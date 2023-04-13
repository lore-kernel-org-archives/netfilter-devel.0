Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF75C77B6C
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Apr 2023 09:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjDMJFM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Apr 2023 05:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjDMJEo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2023 05:04:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A35CA93FE
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2023 02:04:30 -0700 (PDT)
Date:   Thu, 13 Apr 2023 11:04:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tzung-Bi Shih <tzungbi@kernel.org>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        jiejiang@chromium.org, jasongustaman@chromium.org,
        garrick@chromium.org
Subject: Re: [PATCH] netfilter: conntrack: fix wrong ct->timeout value
Message-ID: <ZDfFmMfS406teiUj@calendula>
References: <20230410060935.253503-1-tzungbi@kernel.org>
 <ZDPJ2rHi5fOqu4ga@calendula>
 <ZDPXad/8beRw78yX@calendula>
 <ZDPeGu4eznqw34VJ@google.com>
 <ZDc3AUBoKMUzPfKi@calendula>
 <ZDd1n1IHEu9+HVSS@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZDd1n1IHEu9+HVSS@google.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 13, 2023 at 11:23:11AM +0800, Tzung-Bi Shih wrote:
> On Thu, Apr 13, 2023 at 12:56:01AM +0200, Pablo Neira Ayuso wrote:
> > Maybe just do this special handling:
> > 
> > +       if (nf_ct_is_confirmed(ct))
> > +               WRITE_ONCE(ct->timeout, timeout + nfct_time_stamp);
> > +       else
> > +               WRITE_ONCE(ct->timeout, timeout);
> > 
> > for ctnetlink_change_timeout().
> > 
> > Just replace __nf_ct_set_timeout(), by this code above in
> > nf_conntrack_netlink.c? I think the __nf_ct_set_timeout() helper is
> > not very useful.
> 
> I don't quite understand the message above.
> 
> Calling path in v6.3-rc6:
> ctnetlink_change_timeout() in net/netfilter/nf_conntrack_netlink.c
> -> __nf_ct_change_timeout() in net/netfilter/nf_conntrack_core.c
> -> __nf_ct_set_timeout() in include/net/netfilter/nf_conntrack_core.h
> 
> To clarify, which one did you mean:
> 
> Option 1: replace the __nf_ct_change_timeout() invocation to the special
>           handling in net/netfilter/nf_conntrack_netlink.c
> Option 2: replace the __nf_ct_set_timeout() invocation to the special
>           handling in net/netfilter/nf_conntrack_core.c
> Option 3: put the special handling in __nf_ct_set_timeout() in
>           include/net/netfilter/nf_conntrack_core.h
> 
> In either case, the fix would be a subset of v1.

Yes, I think this is Option 3:

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 71d1269fe4d4..9c2cd69bbdc6 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -89,7 +89,11 @@ static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
 {
        if (timeout > INT_MAX)
                timeout = INT_MAX;
-       WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
+
+       if (nf_ct_is_confirmed(ct))
+               WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout;
+       else
+               ct->timeout = (u32)timeout;
 }
 
 int __nf_ct_change_timeout(struct nf_conn *ct, u64 cta_timeout);

Note:

                WRITE_ONCE(ct->timeout, (u32)timeout);

is not required, because unconfirmed conntrack object is owned by the
packet (not yet in the hashes).


BTW, not related to this patch, but I would like to understand why
this __nf_ct_set_timeout() function is inline, but that is a different
issue.

> I'm not sure other use cases.  In our environment, we observed an
> inconsistent state by a partial fix of v1. 

Thanks for explaining, extending patch description would be good.

> nf_ct_expires() got called by userspace program.  And the return
> value (which means the remaining timeout) will be the parameter for
> the next ctnetlink_change_timeout().

Unconfirmed conntrack is owned by the packet that refers to it, it is
not yet in the hashes. I don't see how concurrent access to the
timeout might occur.

Or are you referring to a different scenario that triggers the partial
state?

> As you can see in [4], if this happens on an unconfirmed conntrack, the
> `nfct_time_stamp` would be wrongly invoved in the calculation again.
> That's why we take care of all `ct->timeout` accesses in v1.

If you are observing a partial state, that is a different issue and I
think it deserves a separated patch with a description? Probably
including KCSAN splat if this is what you used to catch the partial
state.

Thanks!

> [4]: https://elixir.bootlin.com/linux/v6.3-rc6/source/include/net/netfilter/nf_conntrack.h#L296
