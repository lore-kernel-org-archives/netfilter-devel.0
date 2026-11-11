Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794392180;
	b=aWwstem/9jWSh6SSsKJYH2worUxC9AsccHzRiiLgLPo3QrkBjgu1tMhWeA/ZLVFGjyRw
	 K41PDi7rNDkVweNWwewyZe2FiN9Da6UFIZVAJXehK98nUvxvb2S9fjPge7LKygSiwDg5N
	 jr1c6cxlFDf+9KujSN8UhD3OoF+rK9sp5oe51n7wbNTpJDAnZa2OVLDv/YQIswQubyO4k
	 OmZTEFb2FZpMsvutsNxddrvj558i3Tk+Yf66U2mapFErriGELs++X8tAc19wuI7thSglD
	 M7ToXRRfd2y4pQW5bhBtSlcFafvNhVM3kTftoLrpAb6mtuVxey3xkPvDLgixqCmmwqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794392180;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TbD4H8p7Q6K63xQ/qNi89XWaocyCT1N+IPh/sf1Hf2k=;
	b=RcmJagpzjH4iqZj5H+roVaPWT/zWVh+YkCWQVhIYzAWxwwfz+VlU3CRhrs0Z/zgaBmJi
	 wjor3h7tC8FgOXjQV54tiw98HxZeTKAnQ2MgdglrTTK0+DkOE02NCmYpYAODxeS2Ly5hX
	 BhGjrF6W8wuZDmFai8Ue4QrJPGkwJhduaJxxFK/Tkb53sMBNbNeT8ghUfaV8v0oButZ1b
	 6TuA+RDbe4z8NsE4fR+rYHohQ6Htp8R8suudMbJgePtSOo+o3IH2iFLAabyNcBr8ubCc6
	 k6QJJfWa0gZBVS8CfHtvnJDlb3nIH37Gf/e77lELs+/LxnrQrib7CH90CVe/PHG5w7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F07606A324
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 10:16:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1F07606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AD39D6060B; Wed, 11 Nov 2026 11:16:17 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 1/3] tests: hash:net,iface: cover cross-iface narrow-net fallthrough blocking
Date: Wed, 11 Nov 2026 11:16:01 +0100
Message-ID: <20261111101603.22698-1-fw@strlen.de>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend the hash:net,iface test to verify that when multiple nets of
different sizes and different interfaces overlap, the narrowest net
entry governs the lookup outcome regardless of its associated
interface. Specifically:

- A narrower net on eth0 blocks fallthrough to a broader net on eth1,
  so a query for (ip, eth1) must not match the broader eth1 entry.
- A timeout-bearing narrow entry continues to block fallthrough while
  it is still live (i.e. before GC reaps it).
- After the narrow entry on the queried interface is deleted, the
  intermediate /30 entry on another iface still prevents the broader
  /16 eth1 entry from matching.

This intentionally omits the 'has timed out but not reaped' case,
because that fails on the existing implementation, so it is added
later.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Passes on either main or with rhashtable patches.

 tests/hash:net,iface.t | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
index 216f7e8a0253..6566fb407e81 100644
--- a/tests/hash:net,iface.t
+++ b/tests/hash:net,iface.t
@@ -150,6 +150,13 @@
 0 ipset -A test 1.1.1.0/28,eth0 nomatch
 # Add an even larger matching net
 0 ipset -A test 1.1.1.0/26,eth0
+# Add an even larger net for an unrelated interface
+0 ipset -A test 1.1.0.0/16,eth1
+# Add a short-lived net for one interface
+0 ipset -A test 9.9.9.0/24,eth0 timeout 2
+# Note: GC hasn't reaped the former yet when it expires below.
+# Add a permanent, broader net for another.
+0 ipset -A test 9.9.0.0/16,eth1
 # Check non-matching IP
 1 ipset -T test 1.1.1.1,eth0
 # Check matching IP from non-matchin small net
@@ -158,6 +165,11 @@
 1 ipset -T test 1.1.1.4,eth0
 # Check matching IP from even larger net
 0 ipset -T test 1.1.1.16,eth0
+# Check narrower net's entries for other iface block fallthrough to broader/unrelated iface
+# to the broader, unrelated-interface net, matching or not
+1 ipset -T test 1.1.1.1,eth1
+# The short-lived net is still live here, so it still blocks fallthrough
+1 ipset -T test 9.9.9.1,eth1
 # Update non-matching IP to matching one
 0 ipset -! -A test 1.1.1.1,eth0
 # Delete overlapping small net
@@ -176,6 +188,8 @@
 0 ipset -T test 1.1.1.1,eth0
 # Check matching IP
 0 ipset -T test 1.1.1.3,eth0
+# Check live entry on intermediate /30 net blocks fallthrough to broader eth1 net
+1 ipset -T test 1.1.1.1,eth1
 # Delete test set
 0 ipset destroy test
 # Timeout: Check that resizing keeps timeout values
-- 
2.56.0

