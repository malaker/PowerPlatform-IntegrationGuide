export interface CallState {
  active: boolean;
  duration: number;
  onHold: boolean;
  muted: boolean;
}

export interface CustomerInfo {
  name: string;
  phone: string;
  accountId: string;
  tier: string;
}

export interface CaseInfo {
  caseNumber: string;
  issueType: string;
  priority: string;
  status: string;
  orderNumber: string;
}