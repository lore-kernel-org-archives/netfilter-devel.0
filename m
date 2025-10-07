Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D17A146585
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 10:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759834142; cv=none; b=K9QLbNHJWwlx5RAuCTh1vkITKJYEnqfgEA7OmiNtTA7sJARyRFj9mWHgQ6Vw+Z/QnvP8sqFDXL7mc4WwytU+0Xt0g5lzIaoo/oWJxqCae2DUEKysL+DDQztylkefm5D3KIoQ1SNzYVjfvwNo4iTcDO5RfitBLU3WX+byccmFjAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759834142; c=relaxed/simple;
	bh=pvkQBS/6Du++QRRHDA6rcWbgXaCzMV7B44UV2JoVB48=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KT84BvUpkzu2xyYp2c9v+nLlk7NrkLR0+F89NlzYsZ07/DBaAc6+5Nm6RY4aW5Xd6tfxCcTPCTBZaxSV8nUT9BaLvwZtKznXSevB2RPbndXR/uL2K0KJ+NC3rIVGUktkxGmqW1um2NHYXzz3oeJ3s3VHp7vO51ZP1ZJNSIUIEL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C0B6E60116; Tue,  7 Oct 2025 12:48:58 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: py: must use input, not output
Date: Tue,  7 Oct 2025 12:48:49 +0200
Message-ID: <20251007104852.3892-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

synproxy must never be used in output rules, doing so results in kernel
crash due to infinite recursive calls back to nf_hook_slow() for the
emitted reply packet.

Up until recently kernel lacked this validation, and now that the kernel
rejects this the test fails.  Use input to make this pass again.

A new test to ensure we reject synproxy in ouput should be added
in the near future.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/objects.t         |  4 ++--
 tests/py/ip/objects.t.payload | 22 +++++++++++-----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tests/py/ip/objects.t b/tests/py/ip/objects.t
index 4fcde7cc12ea..71d5ffe43275 100644
--- a/tests/py/ip/objects.t
+++ b/tests/py/ip/objects.t
@@ -1,6 +1,6 @@
-:output;type filter hook output priority 0
+:input;type filter hook input priority 0
 
-*ip;test-ip4;output
+*ip;test-ip4;input
 
 # counter
 %cnt1 type counter;ok
diff --git a/tests/py/ip/objects.t.payload b/tests/py/ip/objects.t.payload
index 5252724ceead..3da4b28512b6 100644
--- a/tests/py/ip/objects.t.payload
+++ b/tests/py/ip/objects.t.payload
@@ -1,5 +1,5 @@
 # ip saddr 192.168.1.3 counter name "cnt2"
-ip test-ip4 output 
+ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0301a8c0 ]
   [ objref type 1 name cnt2 ]
@@ -8,14 +8,14 @@ ip test-ip4 output
 __objmap%d test-ip4 43
 __objmap%d test-ip4 0
 	element 0000bb01  : 0 [end]	element 00005000  : 0 [end]	element 00001600  : 0 [end]
-ip test-ip4 output 
+ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d ]
 
 # ip saddr 192.168.1.3 quota name "qt1"
-ip test-ip4 output 
+ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0301a8c0 ]
   [ objref type 2 name qt1 ]
@@ -24,28 +24,28 @@ ip test-ip4 output
 __objmap%d test-ip4 43
 __objmap%d test-ip4 0
 	element 0000bb01  : 0 [end]	element 00005000  : 0 [end]	element 00001600  : 0 [end]
-ip test-ip4 output 
+ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d ]
 
 # ct helper set "cthelp1"
-ip test-ip4 output
+ip test-ip4 input
   [ objref type 3 name cthelp1 ]
 
 # ct helper set tcp dport map {21 : "cthelp1", 2121 : "cthelp1" }
 __objmap%d test-ip4 43
 __objmap%d test-ip4 0
         element 00001500  : 0 [end]     element 00004908  : 0 [end]
-ip test-ip4 output
+ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d ]
 
 # ip saddr 192.168.1.3 limit name "lim1"
-ip test-ip4 output
+ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0301a8c0 ]
   [ objref type 4 name lim1 ]
@@ -54,25 +54,25 @@ ip test-ip4 output
 __objmap%d test-ip4 43 size 3
 __objmap%d test-ip4 0
         element 0000bb01  : 0 [end]     element 00005000  : 0 [end]     element 00001600  : 0 [end]
-ip test-ip4 output
+ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ objref sreg 1 set __objmap%d ]
 
 # ct timeout set "cttime1"
-ip test-ip4 output
+ip test-ip4 input
   [ objref type 7 name cttime1 ]
 
 # ct expectation set "ctexpect1"
-ip test-ip4 output
+ip test-ip4 input
   [ objref type 9 name ctexpect1 ]
 
 # synproxy name tcp dport map {443 : "synproxy1", 80 : "synproxy2"}
 __objmap%d test-ip4 43 size 2
 __objmap%d test-ip4 0
 	element 0000bb01  : 0 [end]	element 00005000  : 0 [end]
-ip test-ip4 output
+ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-- 
2.49.1

