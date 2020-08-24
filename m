Return-Path: <SRS0=keFs=CC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF9FC433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Aug 2020 13:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FA43204FD
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Aug 2020 13:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgHXNk1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Aug 2020 09:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727839AbgHXNh5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Aug 2020 09:37:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2513CC061755;
        Mon, 24 Aug 2020 06:37:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4164A128286ED;
        Mon, 24 Aug 2020 06:21:09 -0700 (PDT)
Date:   Mon, 24 Aug 2020 06:37:54 -0700 (PDT)
Message-Id: <20200824.063754.900322133904935888.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH 0/6] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200824113941.25423-1-pablo@netfilter.org>
References: <20200824113941.25423-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 06:21:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 24 Aug 2020 13:39:35 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Don't flag SCTP heartbeat as invalid for re-used connections,
>    from Florian Westphal.
> 
> 2) Bogus overlap report due to rbtree tree rotations, from Stefano Brivio.
> 
> 3) Detect partial overlap with start end point match, also from Stefano.
> 
> 4) Skip netlink dump of NFTA_SET_USERDATA is unset.
> 
> 5) Incorrect nft_list_attributes enumeration definition.
> 
> 6) Missing zeroing before memcpy to destination register, also
>    from Florian.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thank you.
