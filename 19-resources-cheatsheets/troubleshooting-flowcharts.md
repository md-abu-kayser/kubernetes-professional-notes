# Troubleshooting Flowcharts

- Pod not starting → `kubectl describe pod` → check events.
- Service not reachable → `kubectl get endpoints` → `kubectl describe svc`.
- CrashLoopBackOff → `kubectl logs` → check application.
