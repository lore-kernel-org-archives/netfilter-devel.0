Return-Path: <SRS0=vrwR=B2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F455C433E1
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Aug 2020 23:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4073520772
	for <netfilter-devel@archiver.kernel.org>; Sun, 16 Aug 2020 23:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbgHPXF6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 16 Aug 2020 19:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgHPXF5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Aug 2020 19:05:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C15C061786;
        Sun, 16 Aug 2020 16:05:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8333511E47941;
        Sun, 16 Aug 2020 15:49:11 -0700 (PDT)
Date:   Sun, 16 Aug 2020 16:05:56 -0700 (PDT)
Message-Id: <20200816.160556.1155560188275616517.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH 0/8] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200815103201.1768-1-pablo@netfilter.org>
References: <20200815103201.1768-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Aug 2020 15:49:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 15 Aug 2020 12:31:53 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Endianness issue in IPv4 option support in nft_exthdr,
>    from Stephen Suryaputra.
> 
> 2) Removes the waitcount optimization in nft_compat,
>    from Florian Westphal.
> 
> 3) Remove ipv6 -> nf_defrag_ipv6 module dependency, from
>    Florian Westphal.
> 
> 4) Memleak in chain binding support, also from Florian.
> 
> 5) Simplify nft_flowtable.sh selftest, from Fabian Frederick.
> 
> 6) Optional MTU arguments for selftest nft_flowtable.sh,
>    also from Fabian.
> 
> 7) Remove noise error report when killing process in
>    selftest nft_flowtable.sh, from Fabian Frederick.
> 
> 8) Reject bogus getsockopt option length in ebtables,
>    from Florian Westphal.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
