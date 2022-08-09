Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93695C19F2D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 17:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245242AbiHIRgY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 13:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244833AbiHIRgX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 13:36:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82F721FCCE
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2022 10:36:22 -0700 (PDT)
Date:   Tue, 9 Aug 2022 19:36:17 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
Subject: Re: [PATCH nf] netfilter: nfnetlink: re-enable conntrack expectation
 events
Message-ID: <YvKbEfrY+k/ufmkm@salvia>
References: <20220805144745.6479-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220805144745.6479-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

a few questions, comments.

On Fri, Aug 05, 2022 at 04:47:45PM +0200, Florian Westphal wrote:
> To avoid allocation of the conntrack extension area when possible,
> the default behaviour was changed to only allocate the event extension
> if a userspace program is subscribed to a notification group.
> 
> Problem is that while 'conntrack -E' does enable the event allocation
> behind the scenes, 'conntrack -E expect' does not: no expectation events
> are delivered unless user sets
> "net.netfilter.nf_conntrack_events" back to 1 (always on).
> 
> Fix the autodetection to also consider EXP type group.
> 
> We need to track the 6 event groups (3+3, new/update/destroy for events and
> for expectations each) independently, else we'd disable events again
> if an expectation group becomes empty while there is still an active
> event group.
> 
> Fixes: 2794cdb0b97b ("netfilter: nfnetlink: allow to detect if ctnetlink listeners exist")
> Reported-by: Yi Chen <yiche@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/netns/conntrack.h |  2 +-
>  net/netfilter/nfnetlink.c     | 83 ++++++++++++++++++++++++++++++-----
>  2 files changed, 72 insertions(+), 13 deletions(-)
> 
> diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
> index 0677cd3de034..c396a3862e80 100644
> --- a/include/net/netns/conntrack.h
> +++ b/include/net/netns/conntrack.h
> @@ -95,7 +95,7 @@ struct nf_ip_net {
>  
>  struct netns_ct {
>  #ifdef CONFIG_NF_CONNTRACK_EVENTS
> -	bool ctnetlink_has_listener;
> +	u8 ctnetlink_has_listener;

so now ctnetlink_has_listener is a bitmask, right?

>  	bool ecache_dwork_pending;
>  #endif
>  	u8			sysctl_log_invalid; /* Log invalid packets */
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index c24b1240908f..6c268f1c201a 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -44,6 +44,10 @@ MODULE_DESCRIPTION("Netfilter messages via netlink socket");
>  
>  static unsigned int nfnetlink_pernet_id __read_mostly;
>  
> +#ifdef CONFIG_NF_CONNTRACK_EVENTS
> +static DEFINE_SPINLOCK(nfnl_grp_active_lock);
> +#endif
> +
>  struct nfnl_net {
>  	struct sock *nfnl;
>  };
> @@ -654,6 +658,44 @@ static void nfnetlink_rcv(struct sk_buff *skb)
>  		netlink_rcv_skb(skb, nfnetlink_rcv_msg);
>  }
>  
> +static void nfnetlink_bind_event(struct net *net, unsigned int group)
> +{
> +#ifdef CONFIG_NF_CONNTRACK_EVENTS
> +	int type, group_bit;
> +	u8 v;
> +
> +	/* ctnetlink_has_listener is u8, all NFNLGRP_CONNTRACK_* groups
> +	 * coming from userspace are < 8.

Nit. is ctnetlink_has_listener relevant in the comment? It reads a bit
confusing.

> +	 */
> +	if (group >= 8)

Nit.

enum nfnetlink_groups has __NFNLGRP_MAX, which is 9.

This skips NFNLGRP_NFTRACE which is the last one in the array, not a
big deal since the switch (type) results in return; but better fix
this for the future?

> +		return;
> +
> +	type = nfnl_group2type[group];
> +
> +	switch (type) {
> +	case NFNL_SUBSYS_CTNETLINK:
> +		break;
> +	case NFNL_SUBSYS_CTNETLINK_EXP:
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	group_bit = (1 << group);
> +
> +	spin_lock(&nfnl_grp_active_lock);

suggestion: maybe mutex instead?

> +	v = READ_ONCE(net->ct.ctnetlink_has_listener);
> +	if ((v & group_bit) == 0) {
> +		v |= group_bit;
> +
> +		/* read concurrently without nfnl_grp_active_lock held. */
> +		WRITE_ONCE(net->ct.ctnetlink_has_listener, v);
> +	}
> +
> +	spin_unlock(&nfnl_grp_active_lock);
> +#endif
> +}
> +
>  static int nfnetlink_bind(struct net *net, int group)
>  {
>  	const struct nfnetlink_subsystem *ss;
> @@ -670,28 +712,45 @@ static int nfnetlink_bind(struct net *net, int group)
>  	if (!ss)
>  		request_module_nowait("nfnetlink-subsys-%d", type);
>  
> -#ifdef CONFIG_NF_CONNTRACK_EVENTS
> -	if (type == NFNL_SUBSYS_CTNETLINK) {
> -		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
> -		WRITE_ONCE(net->ct.ctnetlink_has_listener, true);
> -		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
> -	}
> -#endif
> +	nfnetlink_bind_event(net, group);
>  	return 0;
>  }
>  
>  static void nfnetlink_unbind(struct net *net, int group)
>  {
>  #ifdef CONFIG_NF_CONNTRACK_EVENTS
> +	int type, group_bit;
> +
>  	if (group <= NFNLGRP_NONE || group > NFNLGRP_MAX)
>  		return;
>  
> -	if (nfnl_group2type[group] == NFNL_SUBSYS_CTNETLINK) {
> -		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
> -		if (!nfnetlink_has_listeners(net, group))
> -			WRITE_ONCE(net->ct.ctnetlink_has_listener, false);
> -		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
> +	type = nfnl_group2type[group];
> +
> +	switch (type) {
> +	case NFNL_SUBSYS_CTNETLINK:
> +		break;
> +	case NFNL_SUBSYS_CTNETLINK_EXP:
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	/* ctnetlink_has_listener is u8 */
> +	if (group >= 8)

Same here?

> +		return;
> +
> +	group_bit = (1 << group);
> +
> +	spin_lock(&nfnl_grp_active_lock);
> +	if (!nfnetlink_has_listeners(net, group)) {
> +		u8 v = READ_ONCE(net->ct.ctnetlink_has_listener);
> +
> +		v &= ~group_bit;
> +
> +		/* read concurrently without nfnl_grp_active_lock held. */
> +		WRITE_ONCE(net->ct.ctnetlink_has_listener, v);
>  	}
> +	spin_unlock(&nfnl_grp_active_lock);
>  #endif
>  }
>  
> -- 
> 2.35.1
> 
