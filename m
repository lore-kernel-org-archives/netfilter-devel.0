Return-Path: <SRS0=D3ak=AT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B8EC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jul 2020 19:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A65C206E2
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jul 2020 19:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGHTm7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jul 2020 15:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHTm7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jul 2020 15:42:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D43C061A0B;
        Wed,  8 Jul 2020 12:42:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC6751276B451;
        Wed,  8 Jul 2020 12:42:58 -0700 (PDT)
Date:   Wed, 08 Jul 2020 12:42:58 -0700 (PDT)
Message-Id: <20200708.124258.1985476741139989732.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH 00/12] Netfilter/IPVS updates for net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708174609.1343-1-pablo@netfilter.org>
References: <20200708174609.1343-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 12:42:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed,  8 Jul 2020 19:45:57 +0200

> The following patchset contains Netfilter updates for net-next:
> 
> 1) Support for rejecting packets from the prerouting chain, from
>    Laura Garcia Liebana.
> 
> 2) Remove useless assignment in pipapo, from Stefano Brivio.
> 
> 3) On demand hook registration in IPVS, from Julian Anastasov.
> 
> 4) Expire IPVS connection from process context to not overload
>    timers, also from Julian.
> 
> 5) Fallback to conntrack TCP tracker to handle connection reuse
>    in IPVS, from Julian Anastasov.
> 
> 6) Several patches to support for chain bindings.
> 
> 7) Expose enum nft_chain_flags through UAPI.
> 
> 8) Reject unsupported chain flags from the netlink control plane.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thanks Pablo.
