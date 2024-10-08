import { NativeModules } from 'react-native';

const FeWebview = NativeModules.FeWebview


export function multiply(a: number, b: number): Promise<number> {
  return FeWebview.multiply(a, b);
}
