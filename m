Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AB55024B
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 22:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WgI2zgWQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aAcBsZI9gtMyvob4mU24aw04qrYGjucOAs3wukhfOjI=; b=WgI2zgWQkVW14Zyqdd4U0KK6GE
	hs4ZCx6McPihEQ+dIXnZuWTdncg9ztqd6oaxswtHmX3WgcHadXQ2IDK4YPFYfzL0aSGyHSt4/eot4
	CvLUCJGOEv8XhIFBRajoXXs1+NY8mHsU02ICqqYeeNQcrOo2LV85SY+D+UAy5v2BJUcYpOsTumKR8
	hNzl+Lu9juegkrI66NX6/8+MOFUHxMo8qBgkn734CP84yPqklbBCa81mVZkbfn7F715jWfHoOcdTv
	pK6n+6qsWbEQ8DOlW4fEfImeV1alY+N4ah1Smht/J+0of8tpt7RmUz3lT/A0LVp2aAMngx/Ldb+c4
	dYYmsNFw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rNhGU-000000005W0-32Md;
	Wed, 10 Jan 2024 23:41:38 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 1/3] Revert "xshared: Print protocol numbers if --numeric was given"
Date: Wed, 10 Jan 2024 23:41:34 +0100
Message-ID: <20240110224136.11211-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240110224136.11211-1-phil@nwl.cc>
References: <20240110224136.11211-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit da8ecc62dd765b15df84c3aa6b83dcb7a81d4ffa.

The patch's original intention is not entirely clear anymore. If it was
to reduce delays involved by calling getprotobynumber() though, commit
b6196c7504d4d ("xshared: Prefer xtables_chain_protos lookup over
getprotoent") avoids those if --numeric flag was given already. Also,
this numeric protocol output did not cover iptables-save which is a more
relevant candidate for such optimizations anyway.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1729
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../shell/testcases/ip6tables/0002-verbose-output_0    | 10 +++++-----
 .../testcases/ipt-restore/0011-noflush-empty-line_0    |  2 +-
 .../shell/testcases/iptables/0002-verbose-output_0     |  4 ++--
 iptables/xshared.c                                     |  6 +++---
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0 b/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
index cc18a94b96986..45fab83026cb6 100755
--- a/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
+++ b/iptables/tests/shell/testcases/ip6tables/0002-verbose-output_0
@@ -33,11 +33,11 @@ EXPECT='Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 
 Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination
-    0     0 ACCEPT     0    --  eth2   eth3    feed:babe::1         feed:babe::2
-    0     0 ACCEPT     0    --  eth2   eth3    feed:babe::4         feed:babe::5
-    0     0            58   --  *      *       ::/0                 ::/0                 ipv6-icmptype 1 code 0
-    0     0            0    --  *      *       ::/0                 ::/0                 dst length:42 rt type:23
-    0     0 LOG        0    --  *      *       ::/0                 ::/0                 frag id:1337 LOG flags 0 level 4
+    0     0 ACCEPT     all  --  eth2   eth3    feed:babe::1         feed:babe::2
+    0     0 ACCEPT     all  --  eth2   eth3    feed:babe::4         feed:babe::5
+    0     0            ipv6-icmp --  *      *       ::/0                 ::/0                 ipv6-icmptype 1 code 0
+    0     0            all  --  *      *       ::/0                 ::/0                 dst length:42 rt type:23
+    0     0 LOG        all  --  *      *       ::/0                 ::/0                 frag id:1337 LOG flags 0 level 4
 
 Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination'
diff --git a/iptables/tests/shell/testcases/ipt-restore/0011-noflush-empty-line_0 b/iptables/tests/shell/testcases/ipt-restore/0011-noflush-empty-line_0
index 1a3af46fc4756..bea1a690bb624 100755
--- a/iptables/tests/shell/testcases/ipt-restore/0011-noflush-empty-line_0
+++ b/iptables/tests/shell/testcases/ipt-restore/0011-noflush-empty-line_0
@@ -12,5 +12,5 @@ EOF
 
 EXPECT='Chain FORWARD (policy ACCEPT)
 target     prot opt source               destination         
-ACCEPT     0    --  0.0.0.0/0            0.0.0.0/0           '
+ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0           '
 diff -u <(echo "$EXPECT") <($XT_MULTI iptables -n -L FORWARD)
diff --git a/iptables/tests/shell/testcases/iptables/0002-verbose-output_0 b/iptables/tests/shell/testcases/iptables/0002-verbose-output_0
index 15c72af309186..5d2af4c8d2ab2 100755
--- a/iptables/tests/shell/testcases/iptables/0002-verbose-output_0
+++ b/iptables/tests/shell/testcases/iptables/0002-verbose-output_0
@@ -21,8 +21,8 @@ EXPECT='Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 
 Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination
-    0     0 ACCEPT     0    --  eth2   eth3    10.0.0.1             10.0.0.2
-    0     0 ACCEPT     0    --  eth2   eth3    10.0.0.4             10.0.0.5
+    0     0 ACCEPT     all  --  eth2   eth3    10.0.0.1             10.0.0.2
+    0     0 ACCEPT     all  --  eth2   eth3    10.0.0.4             10.0.0.5
 
 Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination'
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 43fa929df7676..68f70277388a6 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1080,10 +1080,10 @@ void print_rule_details(unsigned int linenum, const struct xt_counters *ctrs,
 
 	fputc(invflags & XT_INV_PROTO ? '!' : ' ', stdout);
 
-	if (((format & (FMT_NUMERIC | FMT_NOTABLE)) == FMT_NUMERIC) || !pname)
-		printf(FMT("%-4hu ", "%hu "), proto);
-	else
+	if (pname)
 		printf(FMT("%-4s ", "%s "), pname);
+	else
+		printf(FMT("%-4hu ", "%hu "), proto);
 }
 
 void save_rule_details(const char *iniface, const char *outiface,
-- 
2.43.0

