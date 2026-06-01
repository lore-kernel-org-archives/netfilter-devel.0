Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752F833260E
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2026 19:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780342271; cv=none; b=U+48b8N1feLAtQPzp9iYihb36roU5OqG6Q7d/7kRtSfVnogxnD32C30hPaof2Ha1wmlU9aW/L2BwqCP5Y4Gq2slZtMyKj/aa4+F8dsnlfMAPUGPlM3wpRIPpDX9zpNVjBpqOyfycpVqShWj/lXeoHEYe8t5/UOP1iGPgz3GMf+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780342271; c=relaxed/simple;
	bh=eqUuQhtQ0kI9tdLW2gmrMlB9BryvNrXVwY1TBtXEgSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtO89Ktlkv2IAY7Aun1HApkbqr/jZepthsRQ6C1Qom+My+Mm9HzqrmdW1XBCFK1sGCia+wLpqgL3PV/KswSYxdKksjIbZbHX6dW+tTw+Cu8zi74DESlllSMKNOZU5/6Kzh1YB1IA1kmmA+NPujY9Yi1is5rbnajv3+D7AMRA5b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JHw3+6ir; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=PEq+/tIz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=z8LXQIp7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9sY2RdP6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JHw3+6ir";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="PEq+/tIz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z8LXQIp7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9sY2RdP6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9BDD868735;
	Mon,  1 Jun 2026 19:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VPLAln0f/XXdCts3zlCF/8KgiNeBPgEVXTafC2W+rJE=;
	b=JHw3+6irTGEfcTgZzymIbX33YTi4ZrtxQ1JlMEeVOHBvTdirX5xLtxmJWXz81FGQ8UNpP7
	qstp24O0tURzT2+MPg0sJY2g4kAufMq7a30SOplutXYJFNgydr887nouikHH0l/2udlXlr
	JILecPahQZweku20cYr4xZaxwlbWH9U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342263;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VPLAln0f/XXdCts3zlCF/8KgiNeBPgEVXTafC2W+rJE=;
	b=PEq+/tIzaZZi/cEPtarvGEHGQrUH/jY5iAdaA33N2ZmY8ZOhF6dqLr0sf1CIx8onJpdR3O
	HQKeqQHULkxADAAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z8LXQIp7;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9sY2RdP6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780342262; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VPLAln0f/XXdCts3zlCF/8KgiNeBPgEVXTafC2W+rJE=;
	b=z8LXQIp7Q13PuNPa3Fqxx2OO0Svzoqu+Z/6fvfE8U1+3JFJmiZ5RzKWmXQTsN0sYUJ8Zth
	as6cKHawWfITIDrag6dEcI3smazkgnGkiIPVxXSEamA2Uxne7OtaMgfcQYcEXum8MGJiMD
	Jle115Uk2Njca3mkjYMIkSj/iUbXQdw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780342262;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VPLAln0f/XXdCts3zlCF/8KgiNeBPgEVXTafC2W+rJE=;
	b=9sY2RdP6pdjYIQcLpJH5zdtwBg6aFSBDoL3VYabo/fB/59clHE84Vub9dy66IZSfk8gp8C
	xYazQJ/gSn39frDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C15B779A7;
	Mon,  1 Jun 2026 19:31:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yB7lC/bdHWobLwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 01 Jun 2026 19:31:02 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 1/9 nf-next] netfilter: xtables: use DEBUG_NET_WARN_ON_ONCE in packet and control paths
Date: Mon,  1 Jun 2026 21:30:41 +0200
Message-ID: <20260601193049.8131-2-fmancera@suse.de>
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
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9BDD868735
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_FIVE(0.00)[6];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Replace WARN_ON and WARN_ON_ONCE with DEBUG_NET_WARN_ON_ONCE in the
xtables matching and target execution loops. This prevents unnecessary
system panics when panic_on_warn=1 is enabled in production systems.
Also, remove a redundant hook verification macro block in xt_NETMAP.c.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/ipv4/netfilter/ip_tables.c    |  6 +++---
 net/ipv4/netfilter/iptable_nat.c  |  4 +++-
 net/ipv6/netfilter/ip6_tables.c   |  6 +++---
 net/ipv6/netfilter/ip6table_nat.c |  4 +++-
 net/netfilter/x_tables.c          | 12 +++++++++---
 net/netfilter/xt_NETMAP.c         |  4 ----
 net/netfilter/xt_cluster.c        |  4 ++--
 net/netfilter/xt_nat.c            | 30 +++++++++++++++---------------
 net/netfilter/xt_socket.c         |  3 ++-
 9 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index f917a9004a01..99d01b5c7edc 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -254,7 +254,7 @@ ipt_do_table(void *priv,
 	acpar.hotdrop = false;
 	acpar.state   = state;
 
-	WARN_ON(!(table->valid_hooks & (1 << hook)));
+	DEBUG_NET_WARN_ON_ONCE(!(table->valid_hooks & (1 << hook)));
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
 	private = READ_ONCE(table->private); /* Address dependency. */
@@ -279,7 +279,7 @@ ipt_do_table(void *priv,
 		const struct xt_entry_match *ematch;
 		struct xt_counters *counter;
 
-		WARN_ON(!e);
+		DEBUG_NET_WARN_ON_ONCE(!e);
 		if (!ip_packet_match(ip, indev, outdev,
 		    &e->ip, acpar.fragoff)) {
  no_match:
@@ -298,7 +298,7 @@ ipt_do_table(void *priv,
 		ADD_COUNTER(*counter, skb->len, 1);
 
 		t = ipt_get_target_c(e);
-		WARN_ON(!t->u.kernel.target);
+		DEBUG_NET_WARN_ON_ONCE(!t->u.kernel.target);
 
 #if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
 		/* The packet is traced: log it */
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index a0df72554025..bb866f076d4d 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -65,8 +65,10 @@ static int ipt_nat_register_lookups(struct net *net)
 
 	xt_nat_net = net_generic(net, iptable_nat_net_id);
 	table = xt_find_table(net, NFPROTO_IPV4, "nat");
-	if (WARN_ON_ONCE(!table))
+	if (unlikely(!table)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -ENOENT;
+	}
 
 	ops = kmemdup(nf_nat_ipv4_ops, sizeof(nf_nat_ipv4_ops), GFP_KERNEL);
 	if (!ops)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index ecf79d05a51b..3147326786a5 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -275,7 +275,7 @@ ip6t_do_table(void *priv, struct sk_buff *skb,
 	acpar.hotdrop = false;
 	acpar.state   = state;
 
-	WARN_ON(!(table->valid_hooks & (1 << hook)));
+	DEBUG_NET_WARN_ON_ONCE(!(table->valid_hooks & (1 << hook)));
 
 	local_bh_disable();
 	addend = xt_write_recseq_begin();
@@ -301,7 +301,7 @@ ip6t_do_table(void *priv, struct sk_buff *skb,
 		const struct xt_entry_match *ematch;
 		struct xt_counters *counter;
 
-		WARN_ON(!e);
+		DEBUG_NET_WARN_ON_ONCE(!e);
 		acpar.thoff = 0;
 		if (!ip6_packet_match(skb, indev, outdev, &e->ipv6,
 		    &acpar.thoff, &acpar.fragoff, &acpar.hotdrop)) {
@@ -321,7 +321,7 @@ ip6t_do_table(void *priv, struct sk_buff *skb,
 		ADD_COUNTER(*counter, skb->len, 1);
 
 		t = ip6t_get_target_c(e);
-		WARN_ON(!t->u.kernel.target);
+		DEBUG_NET_WARN_ON_ONCE(!t->u.kernel.target);
 
 #if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
 		/* The packet is traced: log it */
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index c2394e2c94b5..03ed7a5803d0 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -66,8 +66,10 @@ static int ip6t_nat_register_lookups(struct net *net)
 	int i, ret;
 
 	table = xt_find_table(net, NFPROTO_IPV6, "nat");
-	if (WARN_ON_ONCE(!table))
+	if (unlikely(!table)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -ENOENT;
+	}
 
 	xt_nat_net = net_generic(net, ip6table_nat_net_id);
 	ops = kmemdup(nf_nat_ipv6_ops, sizeof(nf_nat_ipv6_ops), GFP_KERNEL);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 4e6708c23922..b8b6e03a6116 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -714,8 +714,10 @@ int xt_compat_add_offset(u_int8_t af, unsigned int offset, int delta)
 
 	WARN_ON(!mutex_is_locked(&xt[af].compat_mutex));
 
-	if (WARN_ON(!xp->compat_tab))
+	if (unlikely(!xp->compat_tab)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -ENOMEM;
+	}
 
 	if (xp->cur >= xp->number)
 		return -EINVAL;
@@ -769,8 +771,10 @@ int xt_compat_init_offsets(u8 af, unsigned int number)
 	if (!number || number > (INT_MAX / sizeof(struct compat_delta)))
 		return -EINVAL;
 
-	if (WARN_ON(xt[af].compat_tab))
+	if (unlikely(xt[af].compat_tab)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		return -EINVAL;
+	}
 
 	mem = sizeof(struct compat_delta) * number;
 	if (mem > XT_MAX_TABLE_SIZE)
@@ -1973,8 +1977,10 @@ int xt_register_template(const struct xt_table *table,
 	mutex_lock(&xt[af].mutex);
 
 	list_for_each_entry(t, &xt_templates[af], list) {
-		if (WARN_ON_ONCE(strcmp(table->name, t->name) == 0))
+		if (strcmp(table->name, t->name) == 0) {
+			DEBUG_NET_WARN_ON_ONCE(1);
 			goto out_unlock;
+		}
 	}
 
 	ret = -ENOMEM;
diff --git a/net/netfilter/xt_NETMAP.c b/net/netfilter/xt_NETMAP.c
index cb2ee80d84fa..180d3b2138c3 100644
--- a/net/netfilter/xt_NETMAP.c
+++ b/net/netfilter/xt_NETMAP.c
@@ -74,10 +74,6 @@ netmap_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct nf_nat_ipv4_multi_range_compat *mr = par->targinfo;
 	struct nf_nat_range2 newrange;
 
-	WARN_ON(xt_hooknum(par) != NF_INET_PRE_ROUTING &&
-		xt_hooknum(par) != NF_INET_POST_ROUTING &&
-		xt_hooknum(par) != NF_INET_LOCAL_OUT &&
-		xt_hooknum(par) != NF_INET_LOCAL_IN);
 	ct = nf_ct_get(skb, &ctinfo);
 
 	netmask = ~(mr->range[0].min_ip ^ mr->range[0].max_ip);
diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index 908fd5f2c3c8..c2d4feac1888 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -49,7 +49,7 @@ xt_cluster_hash(const struct nf_conn *ct,
 		hash = xt_cluster_hash_ipv6(nf_ct_orig_ipv6_src(ct), info);
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 
@@ -69,7 +69,7 @@ xt_cluster_is_multicast_addr(const struct sk_buff *skb, u_int8_t family)
 		is_multicast = ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr);
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		break;
 	}
 	return is_multicast;
diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index b4f7bbc3f3ca..1572092c41f0 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -57,9 +57,9 @@ xt_snat_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	WARN_ON(!(ct != NULL &&
-		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
-		  ctinfo == IP_CT_RELATED_REPLY)));
+	DEBUG_NET_WARN_ON_ONCE(!(ct != NULL &&
+				 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
+				  ctinfo == IP_CT_RELATED_REPLY)));
 
 	xt_nat_convert_range(&range, &mr->range[0]);
 	return nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
@@ -74,8 +74,8 @@ xt_dnat_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	WARN_ON(!(ct != NULL &&
-		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
+	DEBUG_NET_WARN_ON_ONCE(!(ct != NULL &&
+				 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
 
 	xt_nat_convert_range(&range, &mr->range[0]);
 	return nf_nat_setup_info(ct, &range, NF_NAT_MANIP_DST);
@@ -90,9 +90,9 @@ xt_snat_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	WARN_ON(!(ct != NULL &&
-		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
-		  ctinfo == IP_CT_RELATED_REPLY)));
+	DEBUG_NET_WARN_ON_ONCE(!(ct != NULL &&
+				 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
+				  ctinfo == IP_CT_RELATED_REPLY)));
 
 	memcpy(&range, range_v1, sizeof(*range_v1));
 	memset(&range.base_proto, 0, sizeof(range.base_proto));
@@ -109,8 +109,8 @@ xt_dnat_target_v1(struct sk_buff *skb, const struct xt_action_param *par)
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	WARN_ON(!(ct != NULL &&
-		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
+	DEBUG_NET_WARN_ON_ONCE(!(ct != NULL &&
+				 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
 
 	memcpy(&range, range_v1, sizeof(*range_v1));
 	memset(&range.base_proto, 0, sizeof(range.base_proto));
@@ -126,9 +126,9 @@ xt_snat_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	WARN_ON(!(ct != NULL &&
-		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
-		  ctinfo == IP_CT_RELATED_REPLY)));
+	DEBUG_NET_WARN_ON_ONCE(!(ct != NULL &&
+				 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
+				  ctinfo == IP_CT_RELATED_REPLY)));
 
 	return nf_nat_setup_info(ct, range, NF_NAT_MANIP_SRC);
 }
@@ -141,8 +141,8 @@ xt_dnat_target_v2(struct sk_buff *skb, const struct xt_action_param *par)
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	WARN_ON(!(ct != NULL &&
-		 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
+	DEBUG_NET_WARN_ON_ONCE(!(ct != NULL &&
+				 (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED)));
 
 	return nf_nat_setup_info(ct, range, NF_NAT_MANIP_DST);
 }
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 811e53bee408..e3f68b0734d1 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -161,7 +161,8 @@ static int socket_mt_enable_defrag(struct net *net, int family)
 		return nf_defrag_ipv6_enable(net);
 #endif
 	}
-	WARN_ONCE(1, "Unknown family %d\n", family);
+	pr_warn_once("xt_socket: Unknown family %d\n", family);
+	DEBUG_NET_WARN_ON_ONCE(1);
 	return 0;
 }
 
-- 
2.54.0

