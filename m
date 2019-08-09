Return-Path: <SRS0=FL4W=WF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AA6C0650F
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 01:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 871DD2173C
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 01:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405181AbfHIBFa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 21:05:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53964 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHIBFa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 21:05:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87B401425E38A;
        Thu,  8 Aug 2019 18:05:29 -0700 (PDT)
Date:   Thu, 08 Aug 2019 18:05:29 -0700 (PDT)
Message-Id: <20190808.180529.1408453640987288575.davem@davemloft.net>
To:     adobriyan@gmail.com
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: use "nb" for notifier blocks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190805204331.GA25178@avx2>
References: <20190805204331.GA25178@avx2>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 18:05:29 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 5 Aug 2019 23:43:31 +0300

> Use more pleasant looking
> 
> 	struct notifier_block *nb,
> 
> instead of "this".
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Sorry, this is a lot of churn for something that is basically an
opinion of being nicer or less nice.

I actually kind of like "this".
