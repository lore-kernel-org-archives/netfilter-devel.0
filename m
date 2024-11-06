Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123241FCC44
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896749; cv=none; b=R1IYC4Ahw+QXhN/XRwILWmMh9xLb8r3TaMIq+WRZt2VZnQpLs9K84eF7CxG8XGq/RVmtn3ZePidVZrIoSdIuC2WEfOvmeWheT2sXEbP5iCNgOe57NZPQiUu+0ote2ktFbw95OPV2tABL5ZziAcRAKXFptcgrzrRjlg7khl+XS5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896749; c=relaxed/simple;
	bh=is2QXXB8aB/l+UjKXDVPwNFrDxyA9O6Un2tVgQn+jF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ik7UbeYjfCyBEbhRzUOW/4L5GuWmW7KCs6rKXzQA6JcvAXdwj7npj9DL9nXqvmnVkY5nUTC6dYzrWc6YICYoa6WBU4II+/FkhAaROr9T17oL+bD7+U4IGptn0BkHy+Eb4ugvLvKGTv3qet7IDVgtjbBgF4lhL308jCmR36wE46A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t8fJP-0002Uw-Ps; Wed, 06 Nov 2024 13:39:03 +0100
Date: Wed, 6 Nov 2024 13:39:03 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Nadia Pinaeva <n.m.pinaeva@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: collect start time as
 early as possible
Message-ID: <20241106123903.GA6941@breakpoint.cc>
References: <20241105162346.GA9442@breakpoint.cc>
 <ZypHs3XO4J2QKGJ-@calendula>
 <20241105163308.GA9779@breakpoint.cc>
 <ZypLmxmAb_Hp2HBS@calendula>
 <20241105173247.GA10152@breakpoint.cc>
 <ZyqoReoNkhz_fo3p@calendula>
 <20241106082644.GA474@breakpoint.cc>
 <Zyspid81oTuwYtcQ@calendula>
 <20241106083438.GA1738@breakpoint.cc>
 <ZysyaqYhMEOzdWFm@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZysyaqYhMEOzdWFm@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Nov 06, 2024 at 09:34:38AM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Can you clarify?  Do you mean skb_tstamp() vs ktime_get_real_ns()
> > > > or tstamp sampling in general?
> > > 
> > > I am referring to ktime_get_real_ns(), I remember to have measured
> > > 25%-30% performance drop when this is used, but I have not refreshed
> > > those numbers for long time.
> > >
> > > As for skb_tstamp(), I have to dig in the cost of it.
> > 
> > Its not about the cost, its about the sampling method.
> > If skb has the rx timestamp, then the event will reflect the skb
> > creation/rx time, not the "event time".  Did that make sense?
> 
> I think ktime_get_real_ns() needs to be used to get the "event time",
> I am afraid skb_tstamp() is not useful.

What do you make of this?  Still untested.

It reuses the "timestamp" sysctl, so event only gets timestamped
if thats also enabled.

If timestamp is on and ecache is off, there is no overhead since
no eache extension is added to begin with.

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 0c1dac318e02..8e7580e93a74 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -20,6 +20,9 @@ enum nf_ct_ecache_state {
 
 struct nf_conntrack_ecache {
 	unsigned long cache;		/* bitops want long */
+#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
+	u64 timestamp;			/* event timestamp, in nanoseconds */
+#endif
 	u16 ctmask;			/* bitmask of ct events to be delivered */
 	u16 expmask;			/* bitmask of expect events to be delivered */
 	u32 missed;			/* missed events */
@@ -108,6 +111,14 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 	if (e == NULL)
 		return;
 
+#ifdef NF_CONNTRACK_TIMESTAMP
+	/* renew only if this is the first cached event, so that the
+	 * timestamp reflects the first, not the last, generated event.
+	 */
+	if (e->timestamp && READ_ONCE(e->cache) == 0)
+		e->timestamp = ktime_get_real_ns();
+#endif
+
 	set_bit(event, &e->cache);
 #endif
 }
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index c2ac7269acf7..43233af75b9d 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -57,6 +57,7 @@ enum ctattr_type {
 	CTA_SYNPROXY,
 	CTA_FILTER,
 	CTA_STATUS_MASK,
+	CTA_TIMESTAMP_EVENT,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 69948e1d6974..007510d6ed75 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -162,6 +162,14 @@ static int __nf_conntrack_eventmask_report(struct nf_conntrack_ecache *e,
 	return ret;
 }
 
+static void nf_ct_ecache_tstamp_refresh(struct nf_conntrack_ecache *e)
+{
+#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
+	if (e->timestamp)
+		e->timestamp = ktime_get_real_ns();
+#endif
+}
+
 int nf_conntrack_eventmask_report(unsigned int events, struct nf_conn *ct,
 				  u32 portid, int report)
 {
@@ -186,6 +194,8 @@ int nf_conntrack_eventmask_report(unsigned int events, struct nf_conn *ct,
 	/* This is a resent of a destroy event? If so, skip missed */
 	missed = e->portid ? 0 : e->missed;
 
+	nf_ct_ecache_tstamp_refresh(e);
+
 	ret = __nf_conntrack_eventmask_report(e, events, missed, &item);
 	if (unlikely(ret < 0 && (events & (1 << IPCT_DESTROY)))) {
 		/* This is a destroy event that has been triggered by a process,
@@ -297,6 +307,16 @@ void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state)
 	}
 }
 
+static void nf_ct_ecache_tstamp_new(const struct nf_conn *ct, struct nf_conntrack_ecache *e)
+{
+#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
+	if (nf_ct_ext_exist(ct, NF_CT_EXT_TSTAMP))
+		e->timestamp = ktime_get_real_ns();
+	else
+		e->timestamp = 0;
+#endif
+}
+
 bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
 {
 	struct net *net = nf_ct_net(ct);
@@ -326,6 +346,7 @@ bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp
 
 	e = nf_ct_ext_add(ct, NF_CT_EXT_ECACHE, gfp);
 	if (e) {
+		nf_ct_ecache_tstamp_new(ct, e);
 		e->ctmask  = ctmask;
 		e->expmask = expmask;
 	}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 272eec61c931..2baeaaba0769 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -382,6 +382,19 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 #define ctnetlink_dump_secctx(a, b) (0)
 #endif
 
+static int
+ctnetlink_dump_event_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
+{
+#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
+	const struct nf_conntrack_ecache *e = nf_ct_ecache_find(ct);
+
+	if (e && e->timestamp)
+		return nla_put_be64(skb, CTA_TIMESTAMP_EVENT, e->timestamp,
+				   CTA_TIMESTAMP_PAD);
+#endif
+	return 0;
+}
+
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 static inline int ctnetlink_label_size(const struct nf_conn *ct)
 {
@@ -717,6 +730,9 @@ static size_t ctnetlink_nlmsg_size(const struct nf_conn *ct)
 #endif
 	       + ctnetlink_proto_size(ct)
 	       + ctnetlink_label_size(ct)
+#ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
+	       + nla_total_size(sizeof(u64)) /* CTA_TIMESTAMP_EVENT */
+#endif
 	       ;
 }
 
@@ -838,6 +854,10 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	if (ctnetlink_dump_mark(skb, ct, events & (1 << IPCT_MARK)))
 		goto nla_put_failure;
 #endif
+
+	if (ctnetlink_dump_event_timestamp(skb, ct))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	err = nfnetlink_send(skb, net, item->portid, group, item->report,
 			     GFP_ATOMIC);
@@ -1557,6 +1577,7 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 				    .len = NF_CT_LABELS_MAX_SIZE },
 	[CTA_FILTER]		= { .type = NLA_NESTED },
 	[CTA_STATUS_MASK]	= { .type = NLA_U32 },
+	[CTA_TIMESTAMP_EVENT]	= { .type = NLA_REJECT },
 };
 
 static int ctnetlink_flush_iterate(struct nf_conn *ct, void *data)
