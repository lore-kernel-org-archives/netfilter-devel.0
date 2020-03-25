Return-Path: <SRS0=4amC=5K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C2EC54FCE
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Mar 2020 00:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7969420719
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Mar 2020 00:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgCYAbC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Mar 2020 20:31:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38504 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgCYAbC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Mar 2020 20:31:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D37D159FC7E9;
        Tue, 24 Mar 2020 17:31:02 -0700 (PDT)
Date:   Tue, 24 Mar 2020 17:31:01 -0700 (PDT)
Message-Id: <20200324.173101.536412706848749917.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200324223220.12119-1-pablo@netfilter.org>
References: <20200324223220.12119-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 17:31:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 24 Mar 2020 23:32:13 +0100

> The following patchset contains Netfilter fixes for net:
> 
> 1) A new selftest for nf_queue, from Florian Westphal. This test
>    covers two recent fixes: 07f8e4d0fddb ("tcp: also NULL skb->dev
>    when copy was needed") and b738a185beaa ("tcp: ensure skb->dev is
>    NULL before leaving TCP stack").
> 
> 2) The fwd action breaks with ifb. For safety in next extensions,
>    make sure the fwd action only runs from ingress until it is extended
>    to be used from a different hook.
> 
> 3) The pipapo set type now reports EEXIST in case of subrange overlaps.
>    Update the rbtree set to validate range overlaps, so far this
>    validation is only done only from userspace. From Stefano Brivio.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
