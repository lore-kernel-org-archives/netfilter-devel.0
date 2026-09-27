Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2E43F12D8;
	Sun, 27 Sep 2026 22:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790548488; cv=none; b=A2x/M0htNOgBef6KiU2saOorukL5YvFM1kA98b2Ti0KdxAqW+zh0kC0tWNPcNgRPi3oxuuyxhtnl/BjEcNeZJC47XNDn5VWKyo6qmygcZfZqyAoGS0tYi20wPnbxU2DbGXt3rxEWUtm+MaBzdEI3amY5QzTwXOAoycxcrpByirY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790548488; c=relaxed/simple;
	bh=0dCRQ0FD7Q2TDhTN8FaeZB0pWvyjZgAcHGG0vQ8tWaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpmvEbdaPv+4PKeHOUBugUKloGZpeVndIBlDpOtZ6X0hs4ARP7BYRcPwNrh6tzuZg9TLzWp0wkF+ySiJKS04sxOMjxEYHJFPfm4TgkV/FsDwQ7WOKFQ5U2mULi5Q/sP/rcBkARMqYxzCrMwbYx/Zh4IRk0qasIBY3+4tc6D6cYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=p2lkk6qp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="p2lkk6qp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790548485;
	bh=lNY/4NxRy6yUxK+T0r9fV3NfU4CmRVhR4JjsB7g6l1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2lkk6qpPX8nshARYiLGZuSAGSgH8LKrtTa9yIVm0jKZCuIEvPHyl1svpO+2l9CCW
	 aLamirgjUq8tVRtr90lo57DGhdAZupU80FXc7ESmhQtXuP8vXQN0iOTniVBPPjQKiR
	 DD3t91X/LgotQtVyJ9CuJpwql4YVtVoYaTU9LLGvta6HeP3GRCvmbjeiDnBvCFPi8V
	 qaEXfZvdH70EV22RnZsntt7uTtMzdImwtHCUov8hUR0k88p/h0b4WJJW4l6+6LHhjZ
	 BoaBA7g7iCtiWwlFmV+ZT2rSQ58yo4/GkkTigcTZHLk+v6h68l0c9isyRT8WBpx+dO
	 uB3Xk+O44DSzw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 11E9060058;
	Mon, 28 Sep 2026 00:34:45 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 04/11] netfilter: fix several typos in comments
Date: Mon, 28 Sep 2026 00:34:29 +0200
Message-ID: <20260927223436.269024-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927223436.269024-1-pablo@netfilter.org>
References: <20260927223436.269024-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hemanth Selam <hemanth.selam@gmail.com>

Fix typos reported by scripts/checkpatch.pl using the misspelling list
in scripts/spelling.txt. Only touches comments, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arp_tables.c                                 | 2 +-
 net/netfilter/ipset/ip_set_core.c                               | 2 +-
 net/netfilter/ipvs/ip_vs_sync.c                                 | 2 +-
 tools/testing/selftests/net/netfilter/conntrack_icmp_related.sh | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index db307fa49f3f..cf747e1e17a3 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -58,7 +58,7 @@ static inline int arp_devaddr_compare(const struct arpt_devaddr_info *ap,
 /*
  * Unfortunately, _b and _mask are not aligned to an int (or long int)
  * Some arches dont care, unrolling the loop is a win on them.
- * For other arches, we only have a 16bit alignement.
+ * For other arches, we only have a 16bit alignment.
  */
 static unsigned long ifname_compare(const char *_a, const char *_b, const char *_mask)
 {
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 0a86a170ba90..4aeb767088cf 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1426,7 +1426,7 @@ static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info,
 		return -IPSET_ERR_EXIST_SETNAME2;
 
 	/* Features must not change.
-	 * Not an artifical restriction anymore, as we must prevent
+	 * Not an artificial restriction anymore, as we must prevent
 	 * possible loops created by swapping in setlist type of sets.
 	 */
 	if (!(from->type->features == to->type->features &&
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 5383aeafb0ae..4dacd5af65db 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1344,7 +1344,7 @@ static void set_mcast_pmtudisc(struct sock *sk, int val)
 }
 
 /*
- *      Specifiy default interface for outgoing multicasts
+ *      Specify default interface for outgoing multicasts
  */
 static int set_mcast_if(struct sock *sk, struct net_device *dev)
 {
diff --git a/tools/testing/selftests/net/netfilter/conntrack_icmp_related.sh b/tools/testing/selftests/net/netfilter/conntrack_icmp_related.sh
index c63d840ead61..f63b7f12b36a 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_icmp_related.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_icmp_related.sh
@@ -171,7 +171,7 @@ table inet filter {
 }
 EOF
 
-# make sure NAT core rewrites adress of icmp error if nat is used according to
+# make sure NAT core rewrites address of icmp error if nat is used according to
 # conntrack nat information (icmp error will be directed at nsrouter1 address,
 # but it needs to be routed to nsclient1 address).
 ip netns exec "$nsrouter1" nft -f - <<EOF
-- 
2.47.3

