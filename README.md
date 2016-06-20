# CoreDataVioration
Sample code to reproduce strange behavior of CoreData's `'-com.apple.CoreData.ConcurrencyDebug 1'` option

## Environment
- Xcode 7.3 (7D175)
- Mac OSX 10.11.4

## Step
1. Open CoreDataViolationCrash.xcodeproj with Xcode
1. Edit Scheme > Run > Argument Passed on Launch > 
1. Add "-com.apple.CoreData.ConcurrencyDebug 1"
1. Run with simulator (cmd+R)
1. Press 'button' button on main screen
1. Xcode stop the execution on following line:
```
NSArray* results = [mainContext executeFetchRequest:req error:&error];
```
1. Xcode shows message, "Thread1: EXC_BAD_INSTRUCTION (code=EXCii836_INVOP, subcode=0x0)", and shows following stack trace:
```
CoreData`+[NSManagedObjectContext __Multithreading_Violation_AllThatIsLeftToUsIsHonor__]:
    0x107ba2a10 <+0>: pushq  %rbp
    0x107ba2a11 <+1>: movq   %rsp, %rbp
->  0x107ba2a14 <+4>: ud2    
    0x107ba2a16 <+6>: nopw   %cs:(%rax,%rax)
```

![alt screenshot](https://dl.dropboxusercontent.com/u/6024578/apple_bugreport/coredata_vioration.png)

## Workaround
You can avoid this strange behavior with comment out following line:
```
// req.fetchBatchSize = 20;
```
or
```
// req.predicate = [NSPredicate predicateWithFormat:@"foo = %@", @"wwww"];
```
But I don't know why this workaound works.
