Return-Path: <SRS0=UCCN=WL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C41C32753
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Aug 2019 02:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2538F2084F
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Aug 2019 02:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfHOC7V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 22:59:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36248 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbfHOC7U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 22:59:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2CFB914522EFE;
        Wed, 14 Aug 2019 19:59:20 -0700 (PDT)
Date:   Wed, 14 Aug 2019 19:59:17 -0700 (PDT)
Message-Id: <20190814.195917.1229842924375924884.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] Netfilter updates for net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190814214347.4940-1-pablo@netfilter.org>
References: <20190814214347.4940-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Aug 2019 19:59:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 14 Aug 2019 23:43:45 +0200

> The following patchset contains Netfilter updates for net-next.
> This round addresses fallout from previous pull request:
> 
> 1) Remove #warning from ipt_LOG.h and ip6t_LOG.h headers,
>    from Jeremy Sowden.
> 
> 2) Incorrect parens in memcmp() in nft_bitwise, from Nathan Chancellor.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thanks.
