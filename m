Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7468685C5E
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2024 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729609472; cv=none; b=hI9VlknmufVOWR5+LPBvXJEi9sweeARCqxDeO+6vpPF8EJVI3q7zhfMRUv1nqAipAyBgZXC+Rzkk/A3N+oDDIU35L21N4aJfk+qIIevEclGsLhqCL4/u3MGBXGu8Ei0TUQbbgm06/VFsCXZacR98WwUER7477E/PDFWjOnXdo5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729609472; c=relaxed/simple;
	bh=PSUf8Zkr2ftSZYT4Bhwg5iStUYrZu1VSVzebCkzB7WE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NkY4bTjOIXbp15dk8X5bvLYMFLqLZmueU4aE8nJpXS4+m2nF2RT1DkBE9UcsWrahQCbLGbCEOjG1ygmDeDUCM1uvqr2dZxmSgZ2b0D0udgEwQB0dJXIrOmzYY5CeuzjfSCMAYUdxWDiDEMF9+I1iz1JUP143EqcUVUjuakbVAew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qJRr1pE/; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qJRr1pE/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Hq+onEiFsa3Jd2oJYYdrpkRDNHGb1KRW/y0rGgUtz5Y=; b=qJRr1pE/AdpKCbGW3oKYtdBKQu
	NF26sZx3VVXdNto+1x6l1e0yKolZhII+b34YYX7wJDVe9ejOXd7Nif6u010jL8DspPY/LIclBMVRt
	/CLtucmiO2mge+RfdkAez5UAtReNaepwOol5AU4B7QBVUpPHAWEfRjq/tluvWfDfiKuyrzSHvLhXc
	kg0+beiqd+/Esz/deQgCWkOnLNMwaZ/UaGJSxxqeWkusCdaJKkIqH4AO9I/3m34oPLgsqZzI/jSrk
	2I2/KuQY4TgQoH0puWOzXWRWidqdm6tHR7EA/Zd5ho6zsQqVjSqd5AQVzaAz7sY4XJ2tW6zPiBu0H
	A+WnwL0A==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3GQt-000000000i0-2Oic;
	Tue, 22 Oct 2024 17:04:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH] tests: iptables-test: Fix for duplicate supposed-to-fail errors
Date: Tue, 22 Oct 2024 17:04:25 +0200
Message-ID: <20241022150426.14520-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unexpected results for lines which are supposed to fail are reported
twice: Once when fast mode runs them individually to clear the path
before batch-handling all others, a second time when non-fast mode takes
over after fast mode had failed and runs all tests individually again.

Sort this nuisance by running these tests silently in fast mode, knowing
that they will run again if failing anyway.

Fixes: 0e80cfea3762b ("tests: iptables-test: Implement fast test mode")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 77278925d7217..28029ad32bb24 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -47,12 +47,12 @@ STDERR_IS_TTY = sys.stderr.isatty()
     )
 
 
-def print_error(reason, filename=None, lineno=None):
+def print_error(reason, filename=None, lineno=None, log_file=sys.stderr):
     '''
     Prints an error with nice colors, indicating file and line number.
     '''
-    print(filename + ": " + maybe_colored('red', "ERROR", STDERR_IS_TTY) +
-        ": line %d (%s)" % (lineno, reason), file=sys.stderr)
+    print(filename + ": " + maybe_colored('red', "ERROR", log_file.isatty()) +
+        ": line %d (%s)" % (lineno, reason), file=log_file)
 
 
 def delete_rule(iptables, rule, filename, lineno, netns = None):
@@ -69,7 +69,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
     return 0
 
 
-def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
+def run_test(iptables, rule, rule_save, res, filename, lineno, netns, stderr=sys.stderr):
     '''
     Executes an unit test. Returns the output of delete_rule().
 
@@ -93,7 +93,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
     if ret:
         if res != "FAIL":
             reason = "cannot load: " + cmd
-            print_error(reason, filename, lineno)
+            print_error(reason, filename, lineno, stderr)
             return -1
         else:
             # do not report this error
@@ -101,7 +101,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
     else:
         if res == "FAIL":
             reason = "should fail: " + cmd
-            print_error(reason, filename, lineno)
+            print_error(reason, filename, lineno, stderr)
             delete_rule(iptables, rule, filename, lineno, netns)
             return -1
 
@@ -140,7 +140,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
     #
     if proc.returncode == -11:
         reason = command + " segfaults!"
-        print_error(reason, filename, lineno)
+        print_error(reason, filename, lineno, stderr)
         delete_rule(iptables, rule, filename, lineno, netns)
         return -1
 
@@ -150,7 +150,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
     if matching < 0:
         if res == "OK":
             reason = "cannot find: " + iptables + " -I " + rule
-            print_error(reason, filename, lineno)
+            print_error(reason, filename, lineno, stderr)
             delete_rule(iptables, rule, filename, lineno, netns)
             return -1
         else:
@@ -159,7 +159,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
     else:
         if res != "OK":
             reason = "should not match: " + cmd
-            print_error(reason, filename, lineno)
+            print_error(reason, filename, lineno, stderr)
             delete_rule(iptables, rule, filename, lineno, netns)
             return -1
 
@@ -298,7 +298,7 @@ STDERR_IS_TTY = sys.stderr.isatty()
             if res != "OK":
                 rule = chain + " -t " + table + " " + item[0]
                 ret = run_test(iptables, rule, rule_save,
-                               res, filename, lineno + 1, netns)
+                               res, filename, lineno + 1, netns, log_file)
 
                 if ret < 0:
                     return -1
-- 
2.47.0

