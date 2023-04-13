Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F38FC7619A
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Apr 2023 03:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjDMDXR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Apr 2023 23:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDMDXQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2023 23:23:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C613C4C3C
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Apr 2023 20:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63BEA60FCC
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2023 03:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7C8C433EF;
        Thu, 13 Apr 2023 03:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681356194;
        bh=YqALU30krseTCmwko4OhFERtNQSBvwuJfw4yi872AkE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fSi2R+ojzQKqxB9w0jtBarU4w+atTVwc1UzhoK2AtLzwnGvlQCSVkWWMaAmkJYkjK
         2bqpHcfMnKmQ6dn8dRgDK85y+A6dcGnAJ+bmuqSauLcr0CDEXFjf4ofuq2e1qfQf3u
         XsXBB24rxlCJe5dRPLvJyKWWeR8PrVnyZJsrKw1QUW1RmEhTtDaO7Gvu0pS6qPaBKH
         /VbxF9nuDM8TIo4tMthqIz94vs5kclnLzUoXoEKoQS3tIfuas+iUK6Lj5lh0Seniqa
         BEGv0Enaf6XpL2Cmzu5QaESoAjlucIlRPf7QYjhVmbXWbgep4ilwjwbl/l55lecMCx
         Utns2XnVvZ3MA==
Date:   Thu, 13 Apr 2023 11:23:11 +0800
From:   Tzung-Bi Shih <tzungbi@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        jiejiang@chromium.org, jasongustaman@chromium.org,
        garrick@chromium.org
Subject: Re: [PATCH] netfilter: conntrack: fix wrong ct->timeout value
Message-ID: <ZDd1n1IHEu9+HVSS@google.com>
References: <20230410060935.253503-1-tzungbi@kernel.org>
 <ZDPJ2rHi5fOqu4ga@calendula>
 <ZDPXad/8beRw78yX@calendula>
 <ZDPeGu4eznqw34VJ@google.com>
 <ZDc3AUBoKMUzPfKi@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDc3AUBoKMUzPfKi@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 13, 2023 at 12:56:01AM +0200, Pablo Neira Ayuso wrote:
> Maybe just do this special handling:
> 
> +       if (nf_ct_is_confirmed(ct))
> +               WRITE_ONCE(ct->timeout, timeout + nfct_time_stamp);
> +       else
> +               WRITE_ONCE(ct->timeout, timeout);
> 
> for ctnetlink_change_timeout().
> 
> Just replace __nf_ct_set_timeout(), by this code above in
> nf_conntrack_netlink.c? I think the __nf_ct_set_timeout() helper is
> not very useful.

I don't quite understand the message above.

Calling path in v6.3-rc6:
ctnetlink_change_timeout() in net/netfilter/nf_conntrack_netlink.c
-> __nf_ct_change_timeout() in net/netfilter/nf_conntrack_core.c
-> __nf_ct_set_timeout() in include/net/netfilter/nf_conntrack_core.h

To clarify, which one did you mean:

Option 1: replace the __nf_ct_change_timeout() invocation to the special
          handling in net/netfilter/nf_conntrack_netlink.c
Option 2: replace the __nf_ct_set_timeout() invocation to the special
          handling in net/netfilter/nf_conntrack_core.c
Option 3: put the special handling in __nf_ct_set_timeout() in
          include/net/netfilter/nf_conntrack_core.h

In either case, the fix would be a subset of v1.

I'm not sure other use cases.  In our environment, we observed an
inconsistent state by a partial fix of v1.  nf_ct_expires() got called
by userspace program.  And the return value (which means the remaining
timeout) will be the parameter for the next ctnetlink_change_timeout().
As you can see in [4], if this happens on an unconfirmed conntrack, the
`nfct_time_stamp` would be wrongly invoved in the calculation again.
That's why we take care of all `ct->timeout` accesses in v1.

[4]: https://elixir.bootlin.com/linux/v6.3-rc6/source/include/net/netfilter/nf_conntrack.h#L296
