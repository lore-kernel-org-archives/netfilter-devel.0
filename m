Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F94A21ABAA
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2026 19:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780342301; cv=none; b=JOgBuckvvrsHCT0zKtiJ6/sK9Whlg6rF6pBG1aI7gNFETm1I5fotaH3WT++5aMKGPHlTzhk7KqNXErYaJjcU+pM2ahb54Xsv9lvmXaYoxsSiS2au4aPTf5YU7e1V8c95Hg/tNlmtsGkoJH/rBa/GCgkO2hliMIY+Os3RTJRMKWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780342301; c=relaxed/simple;
	bh=Kyx/KXjicl3pimk7jj0FeX2F/E7Mpw+UlJvFzCsbnNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCYwgCu4pUw2eyogTXIK+HdbFwnxpw4zLg2lLMyeU/WS0DQlzE5HiUg3QtHXNhriyhhSTdJ8LE7w17rww3aDj1+Xm/SM5KrrjQtaXVx8SwvXkP7f5Iskyg1paQTZW1eZ64en31JbnzJnBnFbVwakt7XKwG/doVD9troHChiEflU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=p6l2EHRe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=InSbxSvW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=p6l2EHRe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=InSbxSvW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="p6l2EHRe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="InSbxSvW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="p6l2EHRe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="InSbxSvW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 274EA68739;
	Mon,  1 Jun 2026 19:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342266; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6446h5T4sMlhXnmVoeae6ZMOn6b00Db54NrtLemAKRg=;
	b=p6l2EHReEhBNp4+TAZ4EwTwIKL/yN0KdvyFjKHqPsabLVjybqRDdtPOeuyclMyG90zh6ri
	3AZM/ZoZ5/QRgT5LURe42O/w+ZTFpHQPmVVtMw2hlg5QvU8ftms6oOhrBFAf5rC+iZ0qWR
	vF4zrRZ9ppEPznVEObaISOcmv97VaFA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342266;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6446h5T4sMlhXnmVoeae6ZMOn6b00Db54NrtLemAKRg=;
	b=InSbxSvW1Jy04Rni7yDXZz9B0DOP3alck5BSZaC9S+xtGyHpGRAZtPvHJyv824pkTKC/xm
	Ni3Na1Rm5b7Yq/Dw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342266; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6446h5T4sMlhXnmVoeae6ZMOn6b00Db54NrtLemAKRg=;
	b=p6l2EHReEhBNp4+TAZ4EwTwIKL/yN0KdvyFjKHqPsabLVjybqRDdtPOeuyclMyG90zh6ri
	3AZM/ZoZ5/QRgT5LURe42O/w+ZTFpHQPmVVtMw2hlg5QvU8ftms6oOhrBFAf5rC+iZ0qWR
	vF4zrRZ9ppEPznVEObaISOcmv97VaFA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342266;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6446h5T4sMlhXnmVoeae6ZMOn6b00Db54NrtLemAKRg=;
	b=InSbxSvW1Jy04Rni7yDXZz9B0DOP3alck5BSZaC9S+xtGyHpGRAZtPvHJyv824pkTKC/xm
	Ni3Na1Rm5b7Yq/Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BC97A779A7;
	Mon,  1 Jun 2026 19:31:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WCNKK/ndHWobLwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 01 Jun 2026 19:31:05 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 5/9 nf-next] netfilter: nat: use DEBUG_NET_WARN_ON_ONCE in core and helper paths
Date: Mon,  1 Jun 2026 21:30:45 +0200
Message-ID: <20260601193049.8131-6-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260601193049.8131-1-fmancera@suse.de>
References: <20260601193049.8131-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

Replace WARN_ON and WARN_ON_ONCE with DEBUG_NET_WARN_ON_ONCE across core
NAT setup functions, masquerade, redirect, and helpers. This prevents
unnecessary system panics when panic_on_warn=1 is enabled in production
systems.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/ipv4/netfilter/nf_nat_pptp.c  | 16 +++++++++----
 net/netfilter/nf_nat_core.c       | 39 +++++++++++++++++++++----------
 net/netfilter/nf_nat_masquerade.c |  6 +++--
 net/netfilter/nf_nat_proto.c      | 14 +++++++----
 net/netfilter/nf_nat_redirect.c   |  5 ++--
 5 files changed, 55 insertions(+), 25 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index fab357cc8559..f4f7cf0a5aba 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -53,8 +53,10 @@ static void pptp_nat_expected(struct nf_conn *ct,
 	struct nf_conn_nat *nat;
 
 	nat = nf_ct_nat_ext_add(ct);
-	if (WARN_ON_ONCE(!nat))
+	if (unlikely(!nat)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return;
+	}
 
 	nat_pptp_info = &nat->help.nat_pptp_info;
 	ct_pptp_info = nfct_help_data(master);
@@ -132,8 +134,10 @@ pptp_outbound_pkt(struct sk_buff *skb,
 	__be16 new_callid;
 	unsigned int cid_off;
 
-	if (WARN_ON_ONCE(!nat))
+	if (unlikely(!nat)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return NF_DROP;
+	}
 
 	nat_pptp_info = &nat->help.nat_pptp_info;
 	ct_pptp_info = nfct_help_data(ct);
@@ -204,8 +208,10 @@ pptp_exp_gre(struct nf_conntrack_expect *expect_orig,
 	struct nf_ct_pptp_master *ct_pptp_info;
 	struct nf_nat_pptp *nat_pptp_info;
 
-	if (WARN_ON_ONCE(!nat))
+	if (unlikely(!nat)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return;
+	}
 
 	nat_pptp_info = &nat->help.nat_pptp_info;
 	ct_pptp_info = nfct_help_data(ct);
@@ -241,8 +247,10 @@ pptp_inbound_pkt(struct sk_buff *skb,
 	__be16 new_pcid;
 	unsigned int pcid_off;
 
-	if (WARN_ON_ONCE(!nat))
+	if (unlikely(!nat)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return NF_DROP;
+	}
 
 	nat_pptp_info = &nat->help.nat_pptp_info;
 	new_pcid = nat_pptp_info->pns_call_id;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 74ec224ce0d6..99ff65e89952 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -366,8 +366,10 @@ nf_nat_used_tuple_harder(const struct nf_conntrack_tuple *tuple,
 	if (thash->tuple.dst.dir == IP_CT_DIR_ORIGINAL)
 		goto out;
 
-	if (WARN_ON_ONCE(ct == ignored_conntrack))
+	if (unlikely(ct == ignored_conntrack)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto out;
+	}
 
 	flags = READ_ONCE(ct->status);
 	if (!nf_nat_may_kill(ct, flags))
@@ -773,11 +775,13 @@ nf_nat_setup_info(struct nf_conn *ct,
 	if (nf_ct_is_confirmed(ct))
 		return NF_ACCEPT;
 
-	WARN_ON(maniptype != NF_NAT_MANIP_SRC &&
-		maniptype != NF_NAT_MANIP_DST);
+	if (unlikely(maniptype != NF_NAT_MANIP_SRC && maniptype != NF_NAT_MANIP_DST))
+		DEBUG_NET_WARN_ON_ONCE(1);
 
-	if (WARN_ON(nf_nat_initialized(ct, maniptype)))
+	if (unlikely(nf_nat_initialized(ct, maniptype))) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return NF_DROP;
+	}
 
 	/* What we've got will look like inverse of reply. Normally
 	 * this is what is in the conntrack, except for prior
@@ -955,8 +959,8 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 		break;
 	default:
 		/* ESTABLISHED */
-		WARN_ON(ctinfo != IP_CT_ESTABLISHED &&
-			ctinfo != IP_CT_ESTABLISHED_REPLY);
+		if (unlikely(ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY))
+			DEBUG_NET_WARN_ON_ONCE(1);
 		if (nf_nat_oif_changed(state->hook, ctinfo, nat, state->out))
 			goto oif_changed;
 	}
@@ -1143,8 +1147,10 @@ nfnetlink_parse_nat_setup(struct nf_conn *ct,
 	/* Should not happen, restricted to creating new conntracks
 	 * via ctnetlink.
 	 */
-	if (WARN_ON_ONCE(nf_nat_initialized(ct, manip)))
+	if (unlikely(nf_nat_initialized(ct, manip))) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EEXIST;
+	}
 
 	/* No NAT information has been passed, allocate the null-binding */
 	if (attr == NULL)
@@ -1181,8 +1187,10 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 	struct nf_hook_ops *nat_ops;
 	int i, ret;
 
-	if (WARN_ON_ONCE(pf >= ARRAY_SIZE(nat_net->nat_proto_net)))
+	if (unlikely(pf >= ARRAY_SIZE(nat_net->nat_proto_net))) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
+	}
 
 	nat_proto_net = &nat_net->nat_proto_net[pf];
 
@@ -1193,8 +1201,10 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		}
 	}
 
-	if (WARN_ON_ONCE(i == ops_count))
+	if (unlikely(i == ops_count)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
+	}
 
 	mutex_lock(&nf_nat_proto_mutex);
 	if (!nat_proto_net->nat_hook_ops) {
@@ -1235,7 +1245,8 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 
 	nat_ops = nat_proto_net->nat_hook_ops;
 	priv = nat_ops[hooknum].priv;
-	if (WARN_ON_ONCE(!priv)) {
+	if (unlikely(!priv)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		mutex_unlock(&nf_nat_proto_mutex);
 		return -EOPNOTSUPP;
 	}
@@ -1264,8 +1275,10 @@ void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 	nat_proto_net = &nat_net->nat_proto_net[pf];
 
 	mutex_lock(&nf_nat_proto_mutex);
-	if (WARN_ON(nat_proto_net->users == 0))
+	if (unlikely(nat_proto_net->users == 0)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto unlock;
+	}
 
 	nat_proto_net->users--;
 
@@ -1276,8 +1289,10 @@ void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 			break;
 		}
 	}
-	if (WARN_ON_ONCE(i == ops_count))
+	if (unlikely(i == ops_count)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		goto unlock;
+	}
 	priv = nat_ops[hooknum].priv;
 	nf_hook_entries_delete_raw(&priv->entries, ops);
 
diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 4de6e0a51701..660961ca4e31 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -36,7 +36,8 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 	const struct rtable *rt;
 	__be32 newsrc, nh;
 
-	WARN_ON(hooknum != NF_INET_POST_ROUTING);
+	if (unlikely(hooknum != NF_INET_POST_ROUTING))
+		DEBUG_NET_WARN_ON_ONCE(1);
 
 	ct = nf_ct_get(skb, &ctinfo);
 
@@ -297,7 +298,8 @@ int nf_nat_masquerade_inet_register_notifiers(void)
 	int ret = 0;
 
 	mutex_lock(&masq_mutex);
-	if (WARN_ON_ONCE(masq_refcnt == UINT_MAX)) {
+	if (masq_refcnt == UINT_MAX) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		ret = -EOVERFLOW;
 		goto out_unlock;
 	}
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 07f51fe75fbe..21a525b2490f 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -373,7 +373,7 @@ unsigned int nf_nat_manip_pkt(struct sk_buff *skb, struct nf_conn *ct,
 			return NF_ACCEPT;
 		break;
 	default:
-		WARN_ON_ONCE(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 
@@ -491,7 +491,7 @@ void nf_nat_csum_recalc(struct sk_buff *skb,
 #endif
 	}
 
-	WARN_ON_ONCE(1);
+	DEBUG_NET_WARN_ON_ONCE(1);
 }
 
 int nf_nat_icmp_reply_translation(struct sk_buff *skb,
@@ -509,7 +509,8 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 	struct nf_conntrack_tuple target;
 	unsigned long statusbit;
 
-	WARN_ON(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY);
+	if (unlikely(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY))
+		DEBUG_NET_WARN_ON_ONCE(1);
 
 	if (skb_ensure_writable(skb, hdrlen + sizeof(*inside)))
 		return 0;
@@ -823,7 +824,8 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
 	struct nf_conntrack_tuple target;
 	unsigned long statusbit;
 
-	WARN_ON(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY);
+	if (unlikely(ctinfo != IP_CT_RELATED && ctinfo != IP_CT_RELATED_REPLY))
+		DEBUG_NET_WARN_ON_ONCE(1);
 
 	if (skb_ensure_writable(skb, hdrlen + sizeof(*inside)))
 		return 0;
@@ -1074,8 +1076,10 @@ int nf_nat_inet_register_fn(struct net *net, const struct nf_hook_ops *ops)
 {
 	int ret;
 
-	if (WARN_ON_ONCE(ops->pf != NFPROTO_INET))
+	if (ops->pf != NFPROTO_INET) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
+	}
 
 	ret = nf_nat_register_fn(net, NFPROTO_IPV6, ops, nf_nat_ipv6_ops,
 				 ARRAY_SIZE(nf_nat_ipv6_ops));
diff --git a/net/netfilter/nf_nat_redirect.c b/net/netfilter/nf_nat_redirect.c
index 5b37487d9d11..138a805a36af 100644
--- a/net/netfilter/nf_nat_redirect.c
+++ b/net/netfilter/nf_nat_redirect.c
@@ -52,8 +52,9 @@ nf_nat_redirect_ipv4(struct sk_buff *skb, const struct nf_nat_range2 *range,
 {
 	union nf_inet_addr newdst = {};
 
-	WARN_ON(hooknum != NF_INET_PRE_ROUTING &&
-		hooknum != NF_INET_LOCAL_OUT);
+	if (unlikely(hooknum != NF_INET_PRE_ROUTING &&
+		     hooknum != NF_INET_LOCAL_OUT))
+		DEBUG_NET_WARN_ON_ONCE(1);
 
 	/* Local packets: make them go to loopback */
 	if (hooknum == NF_INET_LOCAL_OUT) {
-- 
2.54.0

