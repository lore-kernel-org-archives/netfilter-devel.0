Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DE91E9919
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 04:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792296193; cv=pass; b=q1CStvVQcjuTNKc7469zO/HwpEypO9b2PIakrV2mWfzFhQUtGs2nE7rzIbUpD0MpYP9wqlhLxaWds/KWUUbjKfi+fuyXPGV2lKcEwX3nniOg3w0YmPA/9EmP4EjGc0q1XPCSQp1vqAymVFqs6rKd9WW0HMgHtxKUNuacPjgINhY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792296193; c=relaxed/simple;
	bh=D7jVMih5i2IGULaIUepXNLE6qViZrno0rxqFSNyEca8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XK0uuJegzHBKnhgNQuNj/1svCBcfOexdahZWaGdq3VqM9U2nZcdgUiY2PlNRPPBJ6HoTi/gn5JRhjVk0lnkM/oFiSHyMKTydJQb6foixhRzv4ajfcQlABj6u7TP5l6gh7CvrzaPgIcxBEYctsX6w8d6QVyvIN8vjSybOG4Slmik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uc+RzXKr; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uc+RzXKr"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c3f8d72d7ceso176393966b.3
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 21:03:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792296190; cv=none;
        d=google.com; s=arc-20260327;
        b=cGL1mFDr2rrtN86341/gE9uUew1gN2qOWJFaHdSdPwl1cEXDAco+PaQHvzOqaUpfoL
         zavcWHjcGFF2AlI5ZfDYC42QeMTxv3Icz3ba2lrpwE00UWwxZB5XT/tprVdevzEoDAfu
         4n4pjL29SKX3JjmsCnPB28wusE0GOPGUGSrVaAXJbuM+JRaC6ELyBVl5Jp0Suub686Sz
         YID4qagWWxPchPqca3mceWv5CiDEjQb6D986dED6PaMDTX6oA5mntDXeaz3lzZPZPZGG
         Ww/jaZpLiBui/8dTteZn9GippHAmO8pqn7b7ao0wEnfWx8w8PSI/uI9kCaIojICG3I9A
         ampQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=JZaUiuDlzwP8qKd8Kwtp5kgrtVv+Y+aTOdCbD+bUftI=;
        fh=QyAZVhQoy4RzVy6vHlRXVzvVAHDnFfuQunD7VneW9LA=;
        b=B7xBf52/qYM26N3uFzvnxY1la+595pBCRFeSkkaCZFLTQ4gkBVXg8+PXMVUZLXKZk8
         JR/eWG7src3nlA5+Y2YUpJujpdbtyAjEJ/IavXTjpe+Ofslwld/KopRWsdM1LkJWKYJc
         DH8iElhawTAztz+HlRtqrDW85OFpJ/L6D1uNi2DPfsRuVUp5ZwLTLEiEDG5MpG8iDIMg
         7oLkqrHz+LsZW2DLgDRo2zma24eSNB4lwj1JjrZ4dI2MbcTPcIekA0+X5so4YR6eZFJ/
         h2DScy6YlQYScAEp4Ck5DfJ+cMQBtIPLLfJX/+wnU3yrrvoNx8umnuQbmVHBMHBAOJr1
         V2Pw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792296190; x=1792900990; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JZaUiuDlzwP8qKd8Kwtp5kgrtVv+Y+aTOdCbD+bUftI=;
        b=Uc+RzXKrYuKDfT+EMEt0UGSxZyqBOl4AKj3oszCRGpxBH9fbb2OI8KvFXcWxhh1VCW
         HlD1YSWpdY0bTcxZ+4ttWVoa3YUnkh2XdDAP4RRJx9aL+xGShfxGfOdFUlsoILCjiqQZ
         xSmNH2zSp1+1MR8zWYizNJ/CvCtpAqMg2Wco/RuNcZ1e7irOvKv7CJh7n3bITKbR+b3H
         H/tPrH2viqoTs9q0coQ9piFCAAanymHkrKw2YRiKeSqXDP5Q55jDcO8EXGhhh7y4gXiC
         /2AEBgFIFsrrx0lFoun21rUsXelsrPEUrLP7KNniQKxNqlu3NgHnUx41kohZLTncmUdk
         +QFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792296190; x=1792900990;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JZaUiuDlzwP8qKd8Kwtp5kgrtVv+Y+aTOdCbD+bUftI=;
        b=df7xrEKXkZ7+HmVmy4C3YqwZ3yMiKcKwdtP/kBJJ1WlFvG0ELAbPRTphM7F0b3xHVX
         rSGSEqYArv2/PLmHyGa2Qn1i2S7gddDRQSG2zt7GIhGAY1N1uA2GTAHN8zVbwAZlF9H4
         ErYpbVu3UFGWx3/VnW5hErg33lHjS9+ojWd42vYzag0MIReg9vAFprAd8ozalvkmy+ho
         WjZnQ0yO1lY/Pn8c/16wb1AIBbIVsGMmhlzNBTm7BoGZf+VbV9sLQc+sCWR9/n0J9vWk
         W2UPgSk6OJdkOF1/m0iYG1P4DoWmlZBt5Fmu0dmEnCHoX65ApYRim40xyjaO7k6lzPE+
         /gbg==
X-Gm-Message-State: AFq9FYL7IhDodzSNL/15RaZtVAVCProbFx2PtWOXd0eu9cRuikDOmqVI
	7IdQ5V+Iew1wqycnk7oAuvpy0XyItLvBb3JuldIwW1D9kqstejzhY6yxgLyPZ5VQxynHWhb+Gfg
	EZQLBHJovGwtNPUaxQfugWwQQZtf3h18OBw==
X-Gm-Gg: AYBFou1uoxTiR4Bwa7B/gRVGSJ5t/c1t/Th+l/2cM0hozIVuUfQv3xATZCgC84zD5uq
	eUOwMXxGw6LW1TN0U5OaIAdAd0U3TXH9vdVRc2CiYTCeFJsW1lsapd95xVw1i9N78YZVTMxL7TB
	z/Q1U/GbyainFvRV/7HdubBA4eo/RDrDQrLlrPs67vTBSrGjp8KRvZFZBLW/OiopEiyDIBhInry
	u3+LWw1LeJWDq6sa2SFIxnj9xwDUaoa1v7faARbTgWKtbw0B6dQkSXtuoikvB4TgLC+ATSbN11d
	BYa4KvQacbJ+nVJ8aSxrvmkmKYj1codpdkzZ+HEY3+KUeuA835sRb50=
X-Received: by 2002:a17:906:1012:20b0:c41:b4e4:7958 with SMTP id
 a640c23a62f3a-c41b4e47ad3mr152425966b.0.1792296189675; Sat, 17 Oct 2026
 21:03:09 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 21:03:09 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sat, 17 Oct 2026 21:03:09 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yuen Su <zypulsecore@gmail.com>
Date: Sat, 17 Oct 2026 21:03:09 -0700
X-Gm-Features: AclHuK9Y59IcUKcElFrcoTSYP86TY8kWtFqVngMzQKzr0ZlkXkSSXV9sj9szitE
Message-ID: <CAC9WPdyPZNTHOMmm+C2shvJntRytoD6Zj17Q3MWFmjZQTv5+QA@mail.gmail.com>
Subject: [PATCH conntrack-tools] conntrack: apply the receive buffer size to
 the event socket
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"

CT_EVENT receives notifications on event_sock after socket
consolidation, but --buffer-size still configures and queries the
separate control socket. A larger value therefore leaves the active
event receive buffer unchanged while reporting success. Use event_sock
for the forced setting, fallback setting and effective-size readback.

Add an isolated real-kernel regression that traces all event masks and
two requested sizes. The original fails because the option targets fd 3
while the multicast listener is fd 4; the fix passes all eight cases.
The existing conntrack CLI suite also passes 286 cases. Prepared with AI
assistance and verified against actual netlink syscalls.

Fixes: 5ec684be0854 ("conntrack: consolidate socket open call")
Signed-off-by: Yuen Su <zypulsecore@gmail.com>
---

Validation (outside the commit message):
- Public CI: https://github.com/ZyPulse-zy/packages/actions/runs/39094897174
- Real netlink syscalls: eight event cases / 72 assertions per binary;
  original mainline and 1.4.8 fail the exact wrong-socket assertion.
- Actual Autotools builds and existing upstream CLI suites pass.
  Local current-mainline CLI suite: 286 cases.
- ASan/UBSan tracing passes; LSan is disabled only because ptrace is
  unsupported by LSan. The default-LSan failure log is retained.
- The OpenWrt 1.4.8 backport was refreshed by the actual SDK quilt target;
  official 25.12.0 GCC14.3 AArch64/musl APKs and dependencies build.
  SDK kernel configuration and Module.symvers hashes remain unchanged.
- QEMU could not open NETLINK_NETFILTER (Protocol not supported), so
  target-userland runtime and hardware behavior are not claimed.

 src/conntrack.c                      |   6 +-
 tests/conntrack/test-event-buffer.py | 130 +++++++++++++++++++++++++++
 2 files changed, 133 insertions(+), 3 deletions(-)
 create mode 100644 tests/conntrack/test-event-buffer.py

diff --git a/src/conntrack.c b/src/conntrack.c
index 940469d..977f130 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -3555,17 +3555,17 @@ static int do_command_ct(const char *progname,
struct ct_cmd *cmd,

 			socklen_t socklen = sizeof(socketbuffersize);

-			res = setsockopt(mnl_socket_get_fd(sock->mnl),
+			res = setsockopt(mnl_socket_get_fd(event_sock->mnl),
 					 SOL_SOCKET, SO_RCVBUFFORCE,
 					 &socketbuffersize,
 					 sizeof(socketbuffersize));
 			if (res < 0) {
-				setsockopt(mnl_socket_get_fd(sock->mnl),
+				setsockopt(mnl_socket_get_fd(event_sock->mnl),
 					   SOL_SOCKET, SO_RCVBUF,
 					   &socketbuffersize,
 					   sizeof(socketbuffersize));
 			}
-			getsockopt(mnl_socket_get_fd(sock->mnl), SOL_SOCKET,
+			getsockopt(mnl_socket_get_fd(event_sock->mnl), SOL_SOCKET,
 				   SO_RCVBUF, &socketbuffersize, &socklen);
 			fprintf(stderr, "NOTICE: Netlink socket buffer size "
 					"has been set to %zu bytes.\n",
diff --git a/tests/conntrack/test-event-buffer.py
b/tests/conntrack/test-event-buffer.py
new file mode 100644
index 0000000..4a5adff
--- /dev/null
+++ b/tests/conntrack/test-event-buffer.py
@@ -0,0 +1,130 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-or-later
+"""Check -E --buffer-size on real netlink sockets in an isolated netns.
+
+Requires Python 3, strace and GNU timeout. Run as follows:
+  CONNTRACK_TEST_PARENT_NETNS=$(readlink /proc/self/ns/net) \
+    unshare --user --map-root-user --net python3 test-event-buffer.py
/path/to/conntrack
+No connections are created, removed or modified.
+"""
+
+import argparse
+import json
+import os
+from pathlib import Path
+import re
+import subprocess
+import tempfile
+
+
+def main():
+    parser = argparse.ArgumentParser(description=__doc__)
+    parser.add_argument("conntrack", type=Path)
+    parser.add_argument("--report", type=Path)
+    args = parser.parse_args()
+    binary = args.conntrack.resolve()
+    parent = os.environ.get("CONNTRACK_TEST_PARENT_NETNS")
+    if not parent or parent == os.readlink("/proc/self/ns/net") or
os.geteuid() != 0:
+        raise SystemExit("Run in a new user/network namespace as documented")
+    report = {"passed": False, "checks": 0, "cases": []}
+
+    def check(condition, description):
+        if not condition:
+            raise AssertionError(description)
+        report["checks"] += 1
+
+    try:
+        with tempfile.TemporaryDirectory(prefix="conntrack-event-buffer-")
as temporary:
+            for mask, groups in [(None, 7), ("NEW", 1), ("UPDATE",
2), ("DESTROY", 4)]:
+                for requested in (32768, 1048576):
+                    trace = Path(temporary) / "syscalls.log"
+                    command = [
+                        "strace",
+                        "-f",
+                        "-o",
+                        str(trace),
+                        "-e",
+                        "trace=socket,bind,setsockopt,getsockopt",
+                        "timeout",
+                        "--preserve-status",
+                        "--signal=TERM",
+                        "1",
+                        str(binary),
+                        "-E",
+                        "--buffer-size",
+                        str(requested),
+                    ]
+                    if mask:
+                        command += ["--event-mask", mask]
+                    result = subprocess.run(command,
capture_output=True, text=True, timeout=5)
+                    text = trace.read_text()
+                    case = {
+                        "mask": mask or "ALL",
+                        "requested": requested,
+                        "exit": result.returncode,
+                        "stderr": result.stderr,
+                        "trace": text,
+                    }
+                    report["cases"].append(case)
+                    check(result.returncode == 0, "Event command did
not shut down cleanly")
+                    binds = re.findall(
+                        r"bind\((\d+),
.*nl_groups=(0x[0-9a-f]+|0+)\}, \d+\) = 0", text
+                    )
+                    control = [int(fd) for fd, group in binds if
int(group, 0) == 0]
+                    events = [int(fd) for fd, group in binds if
int(group, 0) == groups]
+                    check(
+                        len(control) == len(events) == 1,
+                        "Expected control and event netlink sockets",
+                    )
+                    event_fd = events[0]
+                    check(event_fd != control[0], "Event listener
must be a separate socket")
+                    writes = re.findall(
+                        r"setsockopt\((\d+), SOL_SOCKET,
SO_RCVBUF(?:FORCE)?, \[(\d+)\].*", text
+                    )
+                    check(
+                        bool(writes) and all(int(fd) == event_fd for
fd, _ in writes),
+                        "--buffer-size changed the query socket
instead of the event listener",
+                    )
+                    check(
+                        all(int(size) == requested for _, size in
writes), "Requested size changed"
+                    )
+                    check(
+                        bool(
+                            re.search(
+                                r"setsockopt\("
+                                + str(event_fd)
+                                + r", SOL_SOCKET, SO_RCVBUF(?:FORCE)?, .* = 0",
+                                text,
+                            )
+                        ),
+                        "No receive-buffer option succeeded on the
event listener",
+                    )
+                    reads = re.findall(r"getsockopt\((\d+),
SOL_SOCKET, SO_RCVBUF, \[(\d+)\]", text)
+                    check(
+                        len(reads) == 1 and int(reads[0][0]) == event_fd,
+                        "Reported buffer size was read from the query socket",
+                    )
+                    actual = int(reads[0][1])
+                    check(actual > 0, "Kernel returned an invalid buffer size")
+                    check(
+                        f"set to {actual} bytes" in result.stderr,
+                        "Notice does not describe the kernel event
socket readback",
+                    )
+                    case.update(
+                        event_fd=event_fd,
+                        control_fd=control[0],
+                        actual=actual,
+                        force_fallback="EPERM" in text,
+                    )
+        report["passed"] = True
+    except BaseException as exc:
+        report["failure"] = str(exc)
+        raise
+    finally:
+        if args.report:
+            args.report.write_text(json.dumps(report, indent=2) + "\n")
+    print(f"PASS: {report['checks']} real-kernel assertions,
{len(report['cases'])} event cases")
+
+
+if __name__ == "__main__":
+    main()
-- 
2.53.0
