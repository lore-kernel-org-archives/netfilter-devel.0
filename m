Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EEDC7619A
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Apr 2023 22:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjDLW4G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Apr 2023 18:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjDLW4F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2023 18:56:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5A22FE4B
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Apr 2023 15:56:04 -0700 (PDT)
Date:   Thu, 13 Apr 2023 00:56:01 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tzung-Bi Shih <tzungbi@kernel.org>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        jiejiang@chromium.org, jasongustaman@chromium.org,
        garrick@chromium.org
Subject: Re: [PATCH] netfilter: conntrack: fix wrong ct->timeout value
Message-ID: <ZDc3AUBoKMUzPfKi@calendula>
References: <20230410060935.253503-1-tzungbi@kernel.org>
 <ZDPJ2rHi5fOqu4ga@calendula>
 <ZDPXad/8beRw78yX@calendula>
 <ZDPeGu4eznqw34VJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZDPeGu4eznqw34VJ@google.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 10, 2023 at 05:59:54PM +0800, Tzung-Bi Shih wrote:
> On Mon, Apr 10, 2023 at 11:31:21AM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Apr 10, 2023 at 10:33:32AM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Apr 10, 2023 at 02:09:35PM +0800, Tzung-Bi Shih wrote:
> > > > (struct nf_conn)->timeout is an interval before the conntrack
> > > > confirmed.  After confirmed, it becomes a timestamp[1].
> > > > 
> > > > It is observed that timeout of an unconfirmed conntrack have been
> > > > altered by calling ctnetlink_change_timeout().  As a result,
> > > > `nfct_time_stamp` was wrongly added to `ct->timeout` twice[2].
> > > > 
> > > > Differentiate the 2 cases in all `ct->timeout` accesses.
> > > 
> > > You can just skip refreshing the timeout for unconfirmed conntrack
> > > entries in ctnetlink_change_timeout().
> > 
> > Something like this patch probably?
> 
> Pardon me, I sent a v2[3] before seeing the message.
> 
> [3]: https://lore.kernel.org/netfilter-devel/20230410093454.853575-1-tzungbi@kernel.org/T/#u
> 
> > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > index bfc3aaa2c872..6556f5f30844 100644
> > --- a/net/netfilter/nf_conntrack_netlink.c
> > +++ b/net/netfilter/nf_conntrack_netlink.c
> > @@ -2466,7 +2466,8 @@ static int ctnetlink_new_conntrack(struct sk_buff *skb,
> >  
> >  	err = -EEXIST;
> >  	ct = nf_ct_tuplehash_to_ctrack(h);
> > -	if (!(info->nlh->nlmsg_flags & NLM_F_EXCL)) {
> > +	if (!(info->nlh->nlmsg_flags & NLM_F_EXCL) &&
> > +	    nf_ct_is_confirmed(ct)) {
> >  		err = ctnetlink_change_conntrack(ct, cda);
> >  		if (err == 0) {
> >  			nf_conntrack_eventmask_report((1 << IPCT_REPLY) |
> 
> The patch can't fix the issue we observed.
> 
> Here is the calling stack:
>   ctnetlink_glue_parse
>   [...]
>   __sys_sendto
>   __x64_sys_sendto
>   [...]

I see. So this is from nfqueue path, now I understand better, thanks.

Maybe just do this special handling:

+       if (nf_ct_is_confirmed(ct))
+               WRITE_ONCE(ct->timeout, timeout + nfct_time_stamp);
+       else
+               WRITE_ONCE(ct->timeout, timeout);

for ctnetlink_change_timeout().

Just replace __nf_ct_set_timeout(), by this code above in
nf_conntrack_netlink.c? I think the __nf_ct_set_timeout() helper is
not very useful.

Better not to cripple features, even if this was broken :-).

Thanks.
