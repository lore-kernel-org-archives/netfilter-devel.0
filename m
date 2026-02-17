Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15982D9798;
	Tue, 17 Feb 2026 11:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771328547; cv=none; b=sMXmIiaK2GLJiz9lq54/3O+HGtZcPki8kjRfmYSNQY6YGzf89jzyGoT3qwq+oibIIGols3ZFhetXmI8rOOfY2A4nfAaoa6l1vfyZ7lwd7g5qrUZpZJlprWZsc1+jn8fFiPYgLAFQjtwAb4y75MzyB+mjw4GiIFfgWNfSkyRkJPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771328547; c=relaxed/simple;
	bh=uo2lM7VyapZrLgxYEbjlz4DLcHO8jnWyg4eyd54yHG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SY2+cBhn4TBODDhCPyYKwiiCHEdREm39OR47dEDkiBKOFGCWJtPTnL5SzGevJjboZEpUUYFkmxseg5smIUfXhj0pbRTOi61QKHF9omDBuWNGRVBDV8f2SeXO1jr6cHx+D1zHSdd9zLUAyT9mo+4M0jzicGuWqkv0Zru0fe9vmUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GPUNQH0q; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GPUNQH0q"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6CA2C6017C;
	Tue, 17 Feb 2026 12:42:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1771328536;
	bh=dcWub9tpAYGVBbW1ex6lNeHAp3M7WdhWszUR94DPZqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GPUNQH0qRDoDi9aqALdG37TPbX/wE8yMgtUdjzXY8gGLTYZEYOAgAniKPIUOKg+uM
	 dHgF2ZEIOPRmnAL6IbueNNcCreB4qLJenBYdNx4Bb48wwFeawhvDuvGmGJjrsFOlVT
	 mNdBDZ4r3hFHWgRq5kt5bvGXmtx53X7xrFlPHlLaa2D/Nx4BkPnqpdUMzf3q2ga+3z
	 JIde5aLqI89egJEh0jLWNeNpx+90iGQqHcv3mFAFfTyDOFBtQ2L17o/AJOt2bFpnZ3
	 3ZHW1AszOx/ljYVFfBZHxdk3Xfvxs2xkUI/ISa39iEmu+gjjJIzDr5v/j98OZnrrXe
	 kywLZQZ1TTZFQ==
Date: Tue, 17 Feb 2026 12:42:13 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>, Shigeru Yoshida <syoshida@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Phil Sutter <phil@nwl.cc>,
	syzbot+5a66db916cdde0dbcc1c@syzkaller.appspotmail.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net] net: flow_offload: protect driver_block_list in
 flow_block_cb_setup_simple()
Message-ID: <aZRUFQGKzEdcjNHG@chamomile>
References: <20260208110054.2525262-1-syoshida@redhat.com>
 <aYxw2CpxOKLh1wOz@strlen.de>
 <20260212183447.2d577f5b@kernel.org>
 <aY8LcgPsoYYGEH5s@strlen.de>
 <20260213081749.3b3ede9c@kernel.org>
 <aZHE4r18hkxdITD-@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="x35JXTi1lX0mTsCy"
Content-Disposition: inline
In-Reply-To: <aZHE4r18hkxdITD-@strlen.de>


--x35JXTi1lX0mTsCy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Sun, Feb 15, 2026 at 02:06:42PM +0100, Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 13 Feb 2026 12:30:58 +0100 Florian Westphal wrote:
> > > > > Looking at the *upper layer*, I don't think it expected drivers to use
> > > > > a single global list for this bit something that is scoped to the
> > > > > net_device.  
> > > > 
> > > > Maybe subjective but the fix seems a little off to me.
> > > > Isn't flow_block_cb_setup_simple() just a "simple" implementation 
> > > > for reuse in drivers locking in there doesn't really guarantee much?  
> > > 
> > > Not sure what you mean.  I see the same pattern as netdevsim in all
> > > drivers using this API. 
> > 
> > Grep for flow_block_cb_add(). Not all drivers use
> 
> static int
> mtk_eth_setup_tc_block(struct net_device *dev, struct flow_block_offload *f)
> {
>         struct mtk_mac *mac = netdev_priv(dev);
>         struct mtk_eth *eth = mac->hw;
>         static LIST_HEAD(block_cb_list);
> 	~~~~~~
> I have a question.
> 
> [..]
>         f->driver_block_list = &block_cb_list;
> 
> Now I have many questions!
> 
> How is this supposed to work?

Last time I met people, I asked how is hw offload actually working
with netns (6 years ago?), someone told me: "maybe there is a driver
that supports it...". I have never seen one, but I am very much
outdates on how this has evolved TBH, I might be wrong.

I don't think any driver really supports netns + hardware offload, so
I suggest to restrict it, see attached patch.

It would be better to add a helper function such as int net_setup_tc()
for the myriad of ->ndo_setup_tc() calls in the code, then move this
check in it to consolidate, but I think you want something you can
pass to -stable at this stage?

--x35JXTi1lX0mTsCy
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="restrict-hw-offload-to-init_netns.patch"

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 99ac747b7906..a97838c1c56d 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -692,6 +692,9 @@ struct tc_cls_u32_offload {
 
 static inline bool tc_can_offload(const struct net_device *dev)
 {
+	if (!net_eq(dev_net(dev), &init_net))
+		return false;
+
 	return dev->features & NETIF_F_HW_TC;
 }
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b1966b68c48a..c6d426052765 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1173,6 +1173,9 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 {
 	int err;
 
+	if (!net_eq(dev_net(dev), &init_net))
+		return -EOPNOTSUPP;
+
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
 	down_write(&flowtable->flow_block_lock);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index fd30e205de84..048fa5f356d9 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -233,6 +233,9 @@ bool nft_chain_offload_support(const struct nft_base_chain *basechain)
 			    ops->hooknum != NF_NETDEV_INGRESS)
 				return false;
 
+			if (!net_eq(dev_net(dev), &init_net))
+				return false;
+
 			dev = ops->dev;
 			if (!dev->netdev_ops->ndo_setup_tc &&
 			    !flow_indr_dev_exists())
diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 8c9a0400c862..6daa9f702a59 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -281,7 +281,7 @@ static int cbs_enable_offload(struct net_device *dev, struct cbs_sched_data *q,
 	struct tc_cbs_qopt_offload cbs = { };
 	int err;
 
-	if (!ops->ndo_setup_tc) {
+	if (!tc_can_offload(dev) || !ops->ndo_setup_tc) {
 		NL_SET_ERR_MSG(extack, "Specified device does not support cbs offload");
 		return -EOPNOTSUPP;
 	}
diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index c74d778c32a1..7801e009e025 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -323,7 +323,7 @@ static int etf_enable_offload(struct net_device *dev, struct etf_sched_data *q,
 	struct tc_etf_qopt_offload etf = { };
 	int err;
 
-	if (!ops->ndo_setup_tc) {
+	if (!tc_can_offload(dev) || !ops->ndo_setup_tc) {
 		NL_SET_ERR_MSG(extack, "Specified device does not support ETF offload");
 		return -EOPNOTSUPP;
 	}
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index f3e5ef9a9592..d853f3b60121 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -410,7 +410,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	 * the queue mapping then run ndo_setup_tc otherwise use the
 	 * supplied and verified mapping
 	 */
-	if (qopt->hw) {
+	if (qopt->hw && tc_can_offload(dev)) {
 		err = mqprio_enable_offload(sch, qopt, extack);
 		if (err)
 			return err;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 300d577b3286..7451d74af91f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1522,7 +1522,7 @@ static int taprio_enable_offload(struct net_device *dev,
 	struct tc_taprio_caps caps;
 	int tc, err = 0;
 
-	if (!ops->ndo_setup_tc) {
+	if (!tc_can_offload(dev) || !ops->ndo_setup_tc) {
 		NL_SET_ERR_MSG(extack,
 			       "Device does not support taprio offload");
 		return -EOPNOTSUPP;

--x35JXTi1lX0mTsCy--
