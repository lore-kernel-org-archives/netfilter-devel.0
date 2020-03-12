Return-Path: <SRS0=u4Sz=45=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B6AC2BB1D
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Mar 2020 22:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6DB020716
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Mar 2020 22:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgCLW4w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Mar 2020 18:56:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36206 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgCLW4w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Mar 2020 18:56:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBECB15842957;
        Thu, 12 Mar 2020 15:56:50 -0700 (PDT)
Date:   Thu, 12 Mar 2020 15:56:50 -0700 (PDT)
Message-Id: <20200312.155650.605586477165565395.davem@davemloft.net>
To:     joe@perches.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 2/3 V2] inet: Use fallthrough;
From:   David Miller <davem@davemloft.net>
In-Reply-To: <68a79203af60110b3412155621cfc00381867c94.camel@perches.com>
References: <cover.1584040050.git.joe@perches.com>
        <68a79203af60110b3412155621cfc00381867c94.camel@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 15:56:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 12 Mar 2020 15:50:22 -0700

> Convert the various uses of fallthrough comments to fallthrough;
> 
> Done via script
> Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe@perches.com/
> 
> And by hand:
> 
> net/ipv6/ip6_fib.c has a fallthrough comment outside of an #ifdef block
> that causes gcc to emit a warning if converted in-place.
> 
> So move the new fallthrough; inside the containing #ifdef/#endif too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied to net-next.
