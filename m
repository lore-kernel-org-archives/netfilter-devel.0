Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87B0192B70
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 11:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728474512; cv=none; b=fcwS5lTlGsPo622VPwzZOcu6P4EIPn9kLmrhrIqmtpTk3RhtwyR+WKdIeej864CRZQy/Hc36WTGy1OzwoMH0Kp9FEbND5sHsopFRlJXKQDj5Sx3naEVMUZkWvL9zuzqYrlNdOkMIBVvJNNF+XclZFMyKjVIN6lCoCNdN25hge80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728474512; c=relaxed/simple;
	bh=wtElI0F6yzzooS17SBwvlGM0NfjP7ftzg3UCWAsSQAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syP7M3cMlIc/aZm8kZWxUwjxYhRI+FcWgFJnyM1ONnxBkXEWqkvM7IXFiGM6oBNnXewHS3exZODGtHVHgPFz64B96QF+HTp/S3nPGJwzkaEta06b8uo2H7Ya3a7OSQLuua7hFygZpAwAizDr4PVBGw/h9ia+tooiRXP5wVgbhDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=lcSpOdZY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lcSpOdZY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HEPp5XVt1Haj1mCjxu9jUcP/pXgPMNrx6lgEwveTQZo=; b=lcSpOdZYEFpXzQSLPaWLXVp9OB
	3fpaMDYI8z/g1uEylRvCKN0UkUO2lYkznLBTOS7lqXCyUefRO6DvwelvF5LRYGLCQlDHGm/gBFUbs
	/jB9U3UIe9MTBXVMAphPDMp+vLPPwhzhz4BSjwkCE0fT/r/4K7B8FLddZdgnW+wwiypgOCeSbmvwr
	BcOEl3ktLCGoraSiDLRkHm414eC/ySqzu+rqmJC1Gw13yIH29++RAbOViud82TMqe1/5D9gbUwFe6
	16qjUaPCla1aeqDLFgGJ4Y7V4pZsYigvBfa177YkH+xXC8noRHI4SXMV9xCJDdCVomUDEqCm7nrsz
	qt5eey8w==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syVB7-000000008I5-05Xo;
	Wed, 09 Oct 2024 13:48:29 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 8/8] tests: iptables-test: Add nft-compat variant
Date: Wed,  9 Oct 2024 13:48:19 +0200
Message-ID: <20241009114819.15379-9-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241009114819.15379-1-phil@nwl.cc>
References: <20241009114819.15379-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test iptables-nft with forced compat extension restore as third modus
operandi.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/iptables-test.py b/iptables-test.py
index 77278925d7217..53af5e1150cfa 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -570,6 +570,8 @@ STDERR_IS_TTY = sys.stderr.isatty()
                         help='Check for missing tests')
     parser.add_argument('-n', '--nftables', action='store_true',
                         help='Test iptables-over-nftables')
+    parser.add_argument('--compat', action='store_true',
+                        help='Test iptables-over-nftables in forced compat mode')
     parser.add_argument('-N', '--netns', action='store_const',
                         const='____iptables-container-test',
                         help='Test netnamespace path')
@@ -589,8 +591,10 @@ STDERR_IS_TTY = sys.stderr.isatty()
         variants.append("legacy")
     if args.nftables:
         variants.append("nft")
+    if args.compat:
+        variants.append("nft-compat")
     if len(variants) == 0:
-        variants = [ "legacy", "nft" ]
+        variants = [ "legacy", "nft", "nft-compat" ]
 
     if os.getuid() != 0:
         print("You need to be root to run this, sorry", file=sys.stderr)
@@ -609,8 +613,14 @@ STDERR_IS_TTY = sys.stderr.isatty()
     total_passed = 0
     total_tests = 0
     for variant in variants:
+
+        exec_infix = variant
+        if variant == "nft-compat":
+            os.putenv("XTABLES_COMPAT", "2")
+            exec_infix = "nft"
+
         global EXECUTABLE
-        EXECUTABLE = "xtables-" + variant + "-multi"
+        EXECUTABLE = "xtables-" + exec_infix + "-multi"
 
         test_files = 0
         tests = 0
-- 
2.43.0

