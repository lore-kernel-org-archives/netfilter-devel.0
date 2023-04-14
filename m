Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C73C77B70
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Apr 2023 08:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjDNIMY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Apr 2023 04:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDNIMW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Apr 2023 04:12:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3FFAF2100
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2023 01:12:18 -0700 (PDT)
Date:   Fri, 14 Apr 2023 10:12:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tzung-Bi Shih <tzungbi@kernel.org>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        jiejiang@chromium.org, jasongustaman@chromium.org,
        garrick@chromium.org
Subject: Re: [PATCH] netfilter: conntrack: fix wrong ct->timeout value
Message-ID: <ZDkK3ktVcBaykTVT@calendula>
References: <20230410060935.253503-1-tzungbi@kernel.org>
 <ZDPJ2rHi5fOqu4ga@calendula>
 <ZDPXad/8beRw78yX@calendula>
 <ZDPeGu4eznqw34VJ@google.com>
 <ZDc3AUBoKMUzPfKi@calendula>
 <ZDd1n1IHEu9+HVSS@google.com>
 <ZDfFmMfS406teiUj@calendula>
 <ZDjN4gyv0x1aewgm@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZDjN4gyv0x1aewgm@google.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 14, 2023 at 11:52:02AM +0800, Tzung-Bi Shih wrote:
> On Thu, Apr 13, 2023 at 11:04:24AM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Apr 13, 2023 at 11:23:11AM +0800, Tzung-Bi Shih wrote:
> > > nf_ct_expires() got called by userspace program.  And the return
> > > value (which means the remaining timeout) will be the parameter for
> > > the next ctnetlink_change_timeout().
> > 
> > Unconfirmed conntrack is owned by the packet that refers to it, it is
> > not yet in the hashes. I don't see how concurrent access to the
> > timeout might occur.
> > 
> > Or are you referring to a different scenario that triggers the partial
> > state?
> 
> I think it isn't a concurrent access.  We observed that userspace program
> reads the remaining timeout and sets it back for unconfirmed conntrack.
> 
> Conceptually, it looks like:
> timeout = nf_ct_expires(...);  (1)
> ctnetlink_change_timeout(...timeout);

How could this possibly happen?

nf_ct_expires() is called from:

- ctnetlink_dump_timeout(), this is netlink dump path, since:

commit 1397af5bfd7d32b0cf2adb70a78c9a9e8f11d912
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Apr 11 13:01:18 2022 +0200

    netfilter: conntrack: remove the percpu dying list

it is not possible to do any listing of unconfirmed, and that is fine.

As I said, nfnetlink_queue operates with an unconfirmed conntrack with
owns exclusively, which is not in the hashes.

- nf_ct_expires() calls from xt and nft matches are irrelevant:

net/netfilter/nft_ct.c:         *dest = jiffies_to_msecs(nf_ct_expires(ct));
net/netfilter/xt_conntrack.c:           unsigned long expires = nf_ct_expires(ct) / HZ;

- there is the garbage collector, but that only works with conntrack
  entries in the hashes:

net/netfilter/nf_conntrack_core.c:                      expires = clamp(nf_ct_expires(tmp), GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);

- there is also /proc interface, but that only works with conntrack
  entries in the hashes:

net/netfilter/nf_conntrack_standalone.c:                seq_printf(s, "%ld ", nf_ct_expires(ct)  / HZ);

> At (1), `nfct_time_stamp` is wrongly involved in the calculation[4] because
> the conntrack is unconfirmed.  The `ct->timeout` is an internal but not a
> timestamp.

I can see there are two possible states for ct->timeout, thanks for
explaining this again.

> As a result, ctnetlink_change_timeout() sets the wrong value to `ct->timeout`.
> 
> [4]: https://elixir.bootlin.com/linux/v6.3-rc6/source/include/net/netfilter/nf_conntrack.h#L296
> 
> > > As you can see in [4], if this happens on an unconfirmed conntrack, the
> > > `nfct_time_stamp` would be wrongly invoved in the calculation again.
> > > That's why we take care of all `ct->timeout` accesses in v1.
> 
> Again, that's why v1 separates all `ct->timeout` accesses.
> 
> If the conntrack is confirmed:
> - `ct->timeout` is a timestamp.
> - `nfct_time_stamp` should be involved when getting/setting `ct->timeout`.
> 
> If the conntrack is unconfirmed:
> - `ct->timeout` is an interval.
> - `nfct_time_stamp` shouldn't be involved.
> 
> Only separate `ct->timeout` access in __nf_ct_set_timeout() is obviously
> insufficient.  I would suggest either take care of all `ct->timeout`
> accesses as v1 or at least change both __nf_ct_set_timeout() and
> nf_ct_expires().

it does not even make sense to use WRITE_ONCE from
__nf_conntrack_confirm(), see:

https://elixir.bootlin.com/linux/latest/source/net/netfilter/nf_conntrack_core.c#L1260

because the unconfirmed conntrack object is owned exclusively by the packet.

> In the latter case, it looks fine in our environment.  However, I'm not
> sure if any hidden cases we haven't seen.

Maybe you have an old kernel?
