# TestPixabay
A small project just to compare MVVM (+ MVI/UI state) and TCA in the context of Clean Architecture.

TCA notes:
* I used Combine. That's just a preference but `eraseToEffect()` in TCA is deprecated :)
* I used `errorMessage: String` instead of `error: Error`. Just to avoid an implementation of Equatable. + There's TaskResult in TCA as an option.