Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE8C3A1E69;
	Fri,  1 May 2026 12:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777638179; cv=none; b=jHfHlCIYdSGcwDFbYFhgw2fR5nIwiKyt8RiZiIWg6/u6nOJ0Uxt5vrb/9dENTO3cspLxn91re59C9ZFvD+yJW0zwDrVjprCnXDGOWyVu7PQB/T3YMFhPqOKCw/pzTEl3Rr8M/OTX+erFhtVaElBAWBZmlresrP9SJI2IX6Zfhkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777638179; c=relaxed/simple;
	bh=tNhHT6Abv/3zT8k+dHNKaWWWmJxFJX3NgbugeEhWMX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKemPZdNHou9TI8ec6ZJjJgXH700zK6Dacokpkf480ZMZKa/Cu/XipCxi53/lbX/PlGD2HGDoylhTXr/3+c7ExmX8MxSV016k4mqVf9c8XHIvdhqdUk/bpFVTIQeXND0y83N7/xfAWh7gX92HOtFuqOKkhjli/PpnfRhjxidaO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Nikf5LU+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Nikf5LU+"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2DCDD60254;
	Fri,  1 May 2026 14:22:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777638175;
	bh=cR6WNktAkRA0KiTvVIoCiQDDxvWm++CwvuGFEmxHJkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nikf5LU+3WYCXSAB6F+leXSn1bUWtgZagWIqXhSAGS4l5RaCUs4OE+aeKE3eEZFnq
	 zxnGVN8qScLZl9j2LF5wndmn3IYe7QIfH43MeTyACxZtvH1gVrBfhKb61hY3vLJruS
	 5vmn6iODCs6iUSOYwtIxoS/b/XcJVFgJIjZJ+Sw2ebZdZnCt6qqzj6CUbZ9zJ1uVRG
	 gonfzB76ifMXv/TbjSfzgazWt8m+2jxk6UAik/jLDc59pOUYHJR8XWOWxhKAhxHNfr
	 r6WIElEuSVH5bYDksJcAhpuzHY/DeLyleakIGI/lxSfrksyd8CBhdQFiwu6l5Hf3BI
	 lJPvVYO1oqsAA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 10/14] netfilter: xtables: fix L4 header parsing for non-first fragments
Date: Fri,  1 May 2026 14:22:33 +0200
Message-ID: <20260501122237.296262-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501122237.296262-1-pablo@netfilter.org>
References: <20260501122237.296262-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Multiple targets and matches relies on L4 header to operate. For
fragmented packets, every fragment carries the transport protocol
identifier, but only the first fragment contains the L4 header.

As the 'raw' table can be configured to run at priority -450 (before
defragmentation at -400), the target/match can be reached before
reassembly. In this case, non-first fragments have their payload
incorrectly parsed as a TCP/UDP header. This would be of course a
misconfiguration scenario. In most of the cases this just lead to a
unreliable behavior for fragmented traffic.

Add a fragment check to ensure target/match only evaluates unfragmented
packets or the first fragment in the stream.

Fixes: 902d6a4c2a4f ("netfilter: nf_defrag: Skip defrag if NOTRACK is set")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TPROXY.c    | 11 +++++++++--
 net/netfilter/xt_ecn.c       |  4 ++++
 net/netfilter/xt_hashlimit.c |  4 +++-
 net/netfilter/xt_osf.c       |  3 +++
 net/netfilter/xt_tcpmss.c    |  4 ++++
 5 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index e4bea1d346cf..5f60e7298a1e 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -86,6 +86,9 @@ tproxy_tg4_v0(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tproxy_target_info *tgi = par->targinfo;
 
+	if (par->fragoff)
+		return NF_DROP;
+
 	return tproxy_tg4(xt_net(par), skb, tgi->laddr, tgi->lport,
 			  tgi->mark_mask, tgi->mark_value);
 }
@@ -95,6 +98,9 @@ tproxy_tg4_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tproxy_target_info_v1 *tgi = par->targinfo;
 
+	if (par->fragoff)
+		return NF_DROP;
+
 	return tproxy_tg4(xt_net(par), skb, tgi->laddr.ip, tgi->lport,
 			  tgi->mark_mask, tgi->mark_value);
 }
@@ -106,6 +112,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 	const struct xt_tproxy_target_info_v1 *tgi = par->targinfo;
+	unsigned short fragoff = 0;
 	struct udphdr _hdr, *hp;
 	struct sock *sk;
 	const struct in6_addr *laddr;
@@ -113,8 +120,8 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	int thoff = 0;
 	int tproto;
 
-	tproto = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
-	if (tproto < 0)
+	tproto = ipv6_find_hdr(skb, &thoff, -1, &fragoff, NULL);
+	if (tproto < 0 || fragoff)
 		return NF_DROP;
 
 	hp = skb_header_pointer(skb, thoff, sizeof(_hdr), &_hdr);
diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
index b96e8203ac54..a8503f5d26bf 100644
--- a/net/netfilter/xt_ecn.c
+++ b/net/netfilter/xt_ecn.c
@@ -30,6 +30,10 @@ static bool match_tcp(const struct sk_buff *skb, struct xt_action_param *par)
 	struct tcphdr _tcph;
 	const struct tcphdr *th;
 
+	/* this is fine for IPv6 as ecn_mt_check6() enforces -p tcp */
+	if (par->fragoff)
+		return false;
+
 	/* In practice, TCP match does this, so can't fail.  But let's
 	 * be good citizens.
 	 */
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 3bd127bfc114..2704b4b60d1e 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -658,6 +658,8 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 		if (!(hinfo->cfg.mode &
 		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
 			return 0;
+		if (ntohs(ip_hdr(skb)->frag_off) & IP_OFFSET)
+			return -1;
 		nexthdr = ip_hdr(skb)->protocol;
 		break;
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
@@ -681,7 +683,7 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 			return 0;
 		nexthdr = ipv6_hdr(skb)->nexthdr;
 		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr, &frag_off);
-		if ((int)protoff < 0)
+		if ((int)protoff < 0 || ntohs(frag_off) & IP6_OFFSET)
 			return -1;
 		break;
 	}
diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index dc9485854002..e8807caede68 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -27,6 +27,9 @@
 static bool
 xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
 {
+	if (p->fragoff)
+		return false;
+
 	return nf_osf_match(skb, xt_family(p), xt_hooknum(p), xt_in(p),
 			    xt_out(p), p->matchinfo, xt_net(p), nf_osf_fingers);
 }
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 0d32d4841cb3..b9da8269161d 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -32,6 +32,10 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	u8 _opt[15 * 4 - sizeof(_tcph)];
 	unsigned int i, optlen;
 
+	/* this is fine for IPv6 as xt_tcpmss enforces -p tcp */
+	if (par->fragoff)
+		return false;
+
 	/* If we don't have the whole header, drop packet. */
 	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
 	if (th == NULL)
-- 
2.47.3

