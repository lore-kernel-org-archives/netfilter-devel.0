Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FC513D601
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 17:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730827972; cv=none; b=HWimZJGcYXhTiFIB1crXR9ASS5FivmMy7AcR+CnvGVE0HBasjGido1bjzeiO5om1ImrhR0odMGzuszog30W4zjgAUT4qd7eu0LLlAoFCGOlLQR3tZTluFIaPKKnbRuL+ylcSKXzKIc8NO3XD4Hbo99r5Q7N3CVxMqdkyZPklxSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730827972; c=relaxed/simple;
	bh=1+7tugJs5aVLoRI0NEw3V+svNjadSpA/3lLLsC9FnqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y1W8uZNxU0RDmEYYvrnD7+1lb73Ah0kFx3vd58JHB5yGSbpnrh2yjrZh9vD4Lp6HqRDwueF3tEa/a1qQ1KKRKylqHC+0xrcQ5vLB8xh/aQPvO7ARRjxaxdfuK5xapGpPisgdcmXwI+mhRT/oWhhgaGR1mVieFgMzqhQKM0GoF1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t8NQ7-0002vM-Ps; Tue, 05 Nov 2024 18:32:47 +0100
Date: Tue, 5 Nov 2024 18:32:47 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Nadia Pinaeva <n.m.pinaeva@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <20241105173247.GA10152@breakpoint.cc>
References: <20241030131232.15524-1-fw@strlen.de>
 <CAOiXEcfv9Gi9Xehws0TOM_VrtH4yKQ4G1Xg9_Q+G8bT_pk-2_A@mail.gmail.com>
 <ZypDF4Suic4REwM8@calendula>
 <20241105162346.GA9442@breakpoint.cc>
 <ZypHs3XO4J2QKGJ-@calendula>
 <20241105163308.GA9779@breakpoint.cc>
 <ZypLmxmAb_Hp2HBS@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZypLmxmAb_Hp2HBS@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Thanks, I'd rather convince you this is the way to go, if after
> quickly sketching a patchset you think it is not worth for more
> reasons, we can revisit.

Untested.  I'm not sure about skb_tstamp() usage.
As-is CTA_EVENT_TIMESTAMP in the NEW event would be before
the start time reported as the start time by the timestamp extension.

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -20,6 +20,7 @@ enum nf_ct_ecache_state {
 
 struct nf_conntrack_ecache {
 	unsigned long cache;		/* bitops want long */
+	u64 timestamp;			/* event timestamp, in nanoseconds */
 	u16 ctmask;			/* bitmask of ct events to be delivered */
 	u16 expmask;			/* bitmask of expect events to be delivered */
 	u32 missed;			/* missed events */
@@ -50,6 +51,7 @@ static inline bool nf_ct_ecache_exist(const struct nf_conn *ct)
 /* This structure is passed to event handler */
 struct nf_ct_event {
 	struct nf_conn *ct;
+	u64 timestamp;
 	u32 portid;
 	int report;
 };
@@ -73,7 +75,7 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct);
 int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
 				  u32 portid, int report);
 
-bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp);
+bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, ktime_t tstamp, gfp_t gfp);
 #else
 
 static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct)
@@ -88,7 +90,8 @@ static inline int nf_conntrack_eventmask_report(unsigned int eventmask,
 	return 0;
 }
 
-static inline bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
+static inline bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask,
+					ktime_t tstamp, gfp_t gfp)
 {
 	return false;
 }
@@ -108,6 +111,9 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 	if (e == NULL)
 		return;
 
+	if (READ_ONCE(e->cache) == 0)
+		e->timestamp = ktime_get_real_ns();
+
 	set_bit(event, &e->cache);
 #endif
 }
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -57,6 +57,7 @@ enum ctattr_type {
 	CTA_SYNPROXY,
 	CTA_FILTER,
 	CTA_STATUS_MASK,
+	CTA_EVENT_TIMESTAMP,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1791,6 +1791,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	if ((ecache || net->ct.sysctl_events) &&
 	    !nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
 				  ecache ? ecache->expmask : 0,
+				  ktime_to_ns(skb_get_ktime(skb)),
 				  GFP_ATOMIC)) {
 		nf_conntrack_free(ct);
 		return ERR_PTR(-ENOMEM);
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 69948e1d6974..661d69da6d9a 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -182,6 +182,7 @@ int nf_conntrack_eventmask_report(unsigned int events, struct nf_conn *ct,
 	item.ct = ct;
 	item.portid = e->portid ? e->portid : portid;
 	item.report = report;
+	item.timestamp = e->timestamp;
 
 	/* This is a resent of a destroy event? If so, skip missed */
 	missed = e->portid ? 0 : e->missed;
@@ -297,7 +298,7 @@ void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state)
 	}
 }
 
-bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
+bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, ktime_t tstamp, gfp_t gfp)
 {
 	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_ecache *e;
@@ -326,6 +327,7 @@ bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp
 
 	e = nf_ct_ext_add(ct, NF_CT_EXT_ECACHE, gfp);
 	if (e) {
+		e->timestamp = tstamp;
 		e->ctmask  = ctmask;
 		e->expmask = expmask;
 	}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6a1239433830..e6b908a1cfef 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -717,6 +717,7 @@ static size_t ctnetlink_nlmsg_size(const struct nf_conn *ct)
 #endif
 	       + ctnetlink_proto_size(ct)
 	       + ctnetlink_label_size(ct)
+	       + nla_total_size(sizeof(u64)) /* CTA_EVENT_TIMESTAMP */
 	       ;
 }
 
@@ -1557,6 +1558,7 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 				    .len = NF_CT_LABELS_MAX_SIZE },
 	[CTA_FILTER]		= { .type = NLA_NESTED },
 	[CTA_STATUS_MASK]	= { .type = NLA_U32 },
+	[CTA_EVENT_TIMESTAMP]	= { .type = NLA_U64 },
 };
 
 static int ctnetlink_flush_iterate(struct nf_conn *ct, void *data)
@@ -2304,7 +2306,7 @@ ctnetlink_create_conntrack(struct net *net,
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
 	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
-	nf_ct_ecache_ext_add(ct, 0, 0, GFP_ATOMIC);
+	nf_ct_ecache_ext_add(ct, 0, 0, 0, GFP_ATOMIC);
 	nf_ct_labels_ext_add(ct);
 	nfct_seqadj_ext_add(ct);
 	nfct_synproxy_ext_add(ct);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 67a41cd2baaf..c57d3715287d 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -322,7 +322,7 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 		}
 
 		if (ctmask && !nf_ct_is_confirmed(ct))
-			nf_ct_ecache_ext_add(ct, ctmask, 0, GFP_ATOMIC);
+			nf_ct_ecache_ext_add(ct, ctmask, 0, skb_tstamp(skb), GFP_ATOMIC);
 		break;
 	}
 #endif
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 2be2f7a7b60f..b2563bcf0c17 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -189,7 +189,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 
 	if ((info->ct_events || info->exp_events) &&
 	    !nf_ct_ecache_ext_add(ct, info->ct_events, info->exp_events,
-				  GFP_KERNEL)) {
+				  0, GFP_KERNEL)) {
 		ret = -EINVAL;
 		goto err3;
 	}
