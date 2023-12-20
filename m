Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986983F8CD
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 15:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lmTyfdh7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ued2f0Pb0mlZndb+nx/J1N25Rnqt06LLKVOZ/D1a8Ec=; b=lmTyfdh7D5bk5vyWTZO4LWILEN
	C1zvidmsOjt6kX/6yynV0HmYFrJ3vZQFD+PYiCjF+MC8R2ufVaaRSbV1ZNmAv5RkNjXvM5sxh0rdc
	reNsoy42EqFAE06Rluim1ayNtebzeaQScTrJnIf3RNMyndS7+2aaxF3N7WdGWKdzA+3z/XaX2z1X4
	vgXwkmaMJytzuIdR/u+wIrd2p5QD/Wetv3LX0JYWv3tyQYcn1VB5+G3ySWE93or8YDAMO507YE3eG
	zYUTv4YLAjSJmadPdWFTSJuSuSClSXYgRER/OPu/GbRcUovRXMOyNIiEpajqoe4zECBzEBPA2XaT7
	x0IGav1A==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFyGj-0003ZL-DE
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 16:13:57 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] tests: iptables-test: Use difflib if dumps differ
Date: Wed, 20 Dec 2023 16:13:53 +0100
Message-ID: <20231220151353.25210-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Improve log readability by printing a unified diff of the expected vs.
actual iptables-save output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 6f63cdbeda9af..179e366e02961 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -15,6 +15,7 @@ import sys
 import os
 import subprocess
 import argparse
+from difflib import unified_diff
 
 IPTABLES = "iptables"
 IP6TABLES = "ip6tables"
@@ -367,11 +368,12 @@ STDERR_IS_TTY = sys.stderr.isatty()
 
     out = out.decode('utf-8').rstrip()
     if out.find(out_expect) < 0:
-        msg = ["dumps differ!"]
-        msg.extend(["expect: " + l for l in out_expect.split("\n")])
-        msg.extend(["got: " + l for l in out.split("\n")
-                                if not l[0] in ['*', ':', '#']])
-        print("\n".join(msg), file=log_file)
+        print("dumps differ!", file=log_file)
+        out_clean = [ l for l in out.split("\n")
+                        if not l[0] in ['*', ':', '#']]
+        diff = unified_diff(out_expect.split("\n"), out_clean,
+                            fromfile="expect", tofile="got", lineterm='')
+        print("\n".join(diff), file=log_file)
         return -1
 
     return tests
-- 
2.43.0

