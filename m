Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A10C10F13
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 18:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F6CA2146F
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 18:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfDKSZ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 14:25:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33026 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbfDKSZ6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 14:25:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A283714D06D78;
        Thu, 11 Apr 2019 11:25:57 -0700 (PDT)
Date:   Thu, 11 Apr 2019 11:25:55 -0700 (PDT)
Message-Id: <20190411.112555.531336975963358091.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: bridge: remove broute hook
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190411143642.1087-1-fw@strlen.de>
References: <20190411143642.1087-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Apr 2019 11:25:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Thu, 11 Apr 2019 16:36:38 +0200

> This series removes the 'broute' hook by promoting ebtables' broute table
> to a normal ebtables table (invoked via normal PREROUTING netfilter hook).
> 
> The downside is that nf_hook_slow() needs to be duplicated in br_input.c
> (see patch 3).
> 
> However, I think its worth the price as this allows to remove the
> br_should_route_hook.
> 
> There are quite some changes in bridge specific code, if you prefer
> I can re-submit this for net-next instead of nf-next.
> 
> Main motivation is to provide 'ebtables -t broute' functionality via
> nftables later on, this can then be done without touching the bridge
> or netfilter core infrastructure again.

Acked-by: David S. Miller <davem@davemloft.net>
