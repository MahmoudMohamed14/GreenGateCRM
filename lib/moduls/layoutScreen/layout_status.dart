abstract class LayoutStates{}
class LayoutInitState extends  LayoutStates{}
class FetchStateSuccess extends  LayoutStates{}

// class ChangeDepartState extends  LayoutStates{}
class AddClientLoadingState extends  LayoutStates{}
 class AddClientErrorState extends  LayoutStates{}
 class AddClientSuccessState extends  LayoutStates{}
 class EmitLayout extends  LayoutStates{}
 class ClientGetLoadingState extends  LayoutStates{}
 class ClientGetErrorState extends  LayoutStates{}
 class ClientGetSuccessState extends  LayoutStates{}
class ClientGetSellerLoadingState extends  LayoutStates{}
class ClientGetSellerErrorState extends  LayoutStates{}
class ClientGetSellerSuccessState extends  LayoutStates{}
 class HiringDropState extends  LayoutStates{}
class ChangeHomeButton extends  LayoutStates{}
class ClientActionLoadingState extends  LayoutStates{}
class ClientActionErrorState extends  LayoutStates{}
class ClientActionSuccessState extends  LayoutStates{}
class SearchState extends  LayoutStates{}
class RegisterSQLSuccessState extends  LayoutStates{}
 class RegisterSQLLoadingState extends  LayoutStates{}
 class ChangePasswordSuccessState extends  LayoutStates{}
class GetSellerDepartLoadingState extends  LayoutStates{}
class GetSellerDepartErrorState extends  LayoutStates{
 String?error;
 GetSellerDepartErrorState({this.error});
}
class GetSellerDepartSuccessState extends  LayoutStates{}
class UpdateUseSuccessState extends  LayoutStates{}
