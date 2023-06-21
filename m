Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7C8EB64D7
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 11:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjFULwQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 07:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjFULwP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 07:52:15 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2F710F6
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Jun 2023 04:52:14 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qBwNf-0007yf-Tu; Wed, 21 Jun 2023 13:52:12 +0200
Date:   Wed, 21 Jun 2023 13:52:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jacek Tomasiak <jacek.tomasiak@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        Jacek Tomasiak <jtomasiak@arista.com>
Subject: Re: [iptables PATCH] iptables: Fix setting of ipv6 counters
Message-ID: <ZJLka2LF9pN/jdiK@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jacek Tomasiak <jacek.tomasiak@gmail.com>,
        netfilter-devel@vger.kernel.org,
        Jacek Tomasiak <jtomasiak@arista.com>
References: <20230619104454.1216-1-jacek.tomasiak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619104454.1216-1-jacek.tomasiak@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 19, 2023 at 12:44:54PM +0200, Jacek Tomasiak wrote:
> When setting counters using ip6tables-nft -c X Y the X and Y values were
> not stored.
> 
> This is a fix based on 9baf3bf0e77dab6ca4b167554ec0e57b65d0af01 but
> applied to the nft variant of ipv6 not the legacy.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1647
> Signed-off-by: Jacek Tomasiak <jtomasiak@arista.com>
> Signed-off-by: Jacek Tomasiak <jacek.tomasiak@gmail.com>

Thanks for the patch! It looks like this is a bug in ip6tables-nft since
day 1, at least I see how commit 0391677c1a0b2 ("xtables: add IPv6
support") already has it wrong.

Applied after adding Fixes: tag and folding a change to one of the shell
test cases to cover it.

Thanks, Phil
