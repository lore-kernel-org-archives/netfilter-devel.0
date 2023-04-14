Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA7CDC77B6E
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Apr 2023 03:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjDNDwi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Apr 2023 23:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjDNDwI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2023 23:52:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C6B4EE3
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2023 20:52:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF86B6438E
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2023 03:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CA0C433D2;
        Fri, 14 Apr 2023 03:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681444326;
        bh=VtvrMuRBKYaqK2LwN3GBGyCGO1rHHdIaHcjM0AL3ktg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i3nTo5/63na/hKaI3H7ycPK8PFHXfRgjyg66ae9ePtNG3UE3jx1kHf7uKnByJYoAi
         Bs9pv8LqxsXclmKBppCjBWVNYZL7QCiychnnGNEKMP3Ea1gwcDHsrOjDB8vfbEC6Dq
         w6DIyaDLZ8bMidIm7G+GF50+mB/Yk1AcPYJ5ej0K5qy8u/4MxQD1UkQUhhKr/xCIXd
         9XY4lFgwh7mSqOnlbNBDFDl056Uxv1AIgJqFupghYZfcEdK9kdOhCEy8tYU8F4OOXp
         7PAKQH3AVyVoVpFlheV+DWZv6jPghq76fN0DuGPuhW1a3wtGjO/onx8gkKkA6p7Xp1
         VawTpk07q4wiA==
Date:   Fri, 14 Apr 2023 11:52:02 +0800
From:   Tzung-Bi Shih <tzungbi@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        jiejiang@chromium.org, jasongustaman@chromium.org,
        garrick@chromium.org
Subject: Re: [PATCH] netfilter: conntrack: fix wrong ct->timeout value
Message-ID: <ZDjN4gyv0x1aewgm@google.com>
References: <20230410060935.253503-1-tzungbi@kernel.org>
 <ZDPJ2rHi5fOqu4ga@calendula>
 <ZDPXad/8beRw78yX@calendula>
 <ZDPeGu4eznqw34VJ@google.com>
 <ZDc3AUBoKMUzPfKi@calendula>
 <ZDd1n1IHEu9+HVSS@google.com>
 <ZDfFmMfS406teiUj@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDfFmMfS406teiUj@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 13, 2023 at 11:04:24AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 13, 2023 at 11:23:11AM +0800, Tzung-Bi Shih wrote:
> > nf_ct_expires() got called by userspace program.  And the return
> > value (which means the remaining timeout) will be the parameter for
> > the next ctnetlink_change_timeout().
> 
> Unconfirmed conntrack is owned by the packet that refers to it, it is
> not yet in the hashes. I don't see how concurrent access to the
> timeout might occur.
> 
> Or are you referring to a different scenario that triggers the partial
> state?

I think it isn't a concurrent access.  We observed that userspace program
reads the remaining timeout and sets it back for unconfirmed conntrack.

Conceptually, it looks like:
timeout = nf_ct_expires(...);  (1)
ctnetlink_change_timeout(...timeout);

At (1), `nfct_time_stamp` is wrongly involved in the calculation[4] because
the conntrack is unconfirmed.  The `ct->timeout` is an internal but not a
timestamp.

As a result, ctnetlink_change_timeout() sets the wrong value to `ct->timeout`.

[4]: https://elixir.bootlin.com/linux/v6.3-rc6/source/include/net/netfilter/nf_conntrack.h#L296

> > As you can see in [4], if this happens on an unconfirmed conntrack, the
> > `nfct_time_stamp` would be wrongly invoved in the calculation again.
> > That's why we take care of all `ct->timeout` accesses in v1.

Again, that's why v1 separates all `ct->timeout` accesses.

If the conntrack is confirmed:
- `ct->timeout` is a timestamp.
- `nfct_time_stamp` should be involved when getting/setting `ct->timeout`.

If the conntrack is unconfirmed:
- `ct->timeout` is an interval.
- `nfct_time_stamp` shouldn't be involved.

Only separate `ct->timeout` access in __nf_ct_set_timeout() is obviously
insufficient.  I would suggest either take care of all `ct->timeout`
accesses as v1 or at least change both __nf_ct_set_timeout() and
nf_ct_expires().

In the latter case, it looks fine in our environment.  However, I'm not
sure if any hidden cases we haven't seen.
