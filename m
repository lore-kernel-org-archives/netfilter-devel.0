Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE554A99E
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 14:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="IgUtsusm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=D4VNmF5Gu93NC7baVuo5qQLsY0L34UMUr3aGgG8hZbs=; b=IgUtsusmsuK/TQkKDqIP61oVp3
	emI3JHxye2Wbz8HLZO7E/PNAnClUDvEDwmnyjfXBpuQuKxpSQsLz7KKTU0eYEw6a/qy0Vj3QPI2nD
	nYbF4RK5QNXp46AkOByNG//aPVd2Hn/4A9d0hSq62UfuCl3POohoX4s7ykU/DnVLoeiKy/cDw/G41
	/jBgV6NNKj12288pUUN9p/WISvMZrz82smHpWnEO9bV5D4X6Zj4I8DxU9XjzMiJ8l5+7yHVIMaaPt
	J7qm4bKfZ+fmI65aCUYxF1XlPl86J9mHnQwjPzrdNPFaWBdWnOpa3ztJq8pMAq2tql9Ju7rwJKz6G
	l+aMSysg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rNZqX-000000006Hd-2OdE;
	Wed, 10 Jan 2024 15:46:21 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 1/2] Revert "xshared: Print protocol numbers if --numeric was given"
Date: Wed, 10 Jan 2024 15:46:18 +0100
Message-ID: <20240110144619.32070-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
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
index 5cae62b45cdf4..6d4ae992a5591 100644
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

