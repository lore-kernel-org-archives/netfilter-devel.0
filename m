Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEDA3B7B84
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 11:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777289277; cv=none; b=EulAKj5ixYllRSFcB6F5B67FkOL5WO6gtwWaGqQVWUhFQNFfmmkT73YA/vb8YNwQG9ZmyER820bbg5QVYclxIM3vh3b1vfrrs6s/b4KMEQhmCtX6VLeBknVx4Ygml7kQpTvE4nIkM/GnkfrotfUM8UlYoMuqpXHdGqzAsPS4Ynk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777289277; c=relaxed/simple;
	bh=IVKu9OKrna48UQbVC2i/UrUwGweD62tj2xtMr+WF9uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cglVys7EBE2vrR93Md48W0897b0SeRY2hnvB4ZWy3wclpyXTIpvqcE9AZupq1tr4SieaZLZG6eTG9mlCwwQiRif0j+4qmq91yRj+fpaQgLg74WPm47K2+eZVDmAnSyVf3ucQQw0/SBp2gZPymZaGauIIBY+eNTRP1CSV/QhX0fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 03A6D6A8EA;
	Mon, 27 Apr 2026 11:27:48 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 932C2593B0;
	Mon, 27 Apr 2026 11:27:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uN78IDNI72kaWgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 27 Apr 2026 11:27:47 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 3/3 nf v4] netfilter: xtables: fix L4 header parsing for non-first fragments
Date: Mon, 27 Apr 2026 13:27:20 +0200
Message-ID: <20260427112720.5128-3-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260427112720.5128-1-fmancera@suse.de>
References: <20260427112720.5128-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 03A6D6A8EA
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

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
---
v2: handled ecn, socket and tcpmss matches
v3: extracted socket to its own patch with a generic solution for
nft/xt, added a comment specifying that par->fragoff is fine for
ecn/tcpmss ipv6 as they enforce -p tcp. Keep on mind that osf only
supports ipv4.
v4: handled xt_hashlimit too
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
2.53.0

