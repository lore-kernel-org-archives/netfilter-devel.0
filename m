Return-Path: <SRS0=/8pw=SU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86FAFC10F14
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 19:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EAFA214DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 19:02:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gjZOaVdb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="e7jmsvp5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390055AbfDRTCk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 15:02:40 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49210 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731565AbfDRTCk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 15:02:40 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 77F3361340; Thu, 18 Apr 2019 19:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555614159;
        bh=384nKt5SJgcg9Ozd0VbUSR9LJE5gZV4yWlJZeaAlY1c=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gjZOaVdbb9WNxgFOtkmg3omuzO3FcDY/qCh1pvWpsAz48HPdIsdJ+5ICAcAZGIF2x
         TBmH2xm94BNGyPhLhOOsQKXN2gBX5bwOm97GSnwWQPWBjju0u3YWThrYq8A9lP0vVB
         wR0uCO1hR4m9XSvvKg8H86pVYTXkn5I6FqUU7jRg=
Received: from [10.79.161.32] (blr-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.18.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF3B561340;
        Thu, 18 Apr 2019 19:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555614158;
        bh=384nKt5SJgcg9Ozd0VbUSR9LJE5gZV4yWlJZeaAlY1c=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=e7jmsvp5ByJkRJ+D/U6wLHnbhF8ZS+WeMu2/BTAHg1zKnl1wnPpPj5LGmrnRcrCTe
         tBT1u6c7u4lhWKbjaUPpEn49B0toYItCC7nkwloftR0w7YYuMQIIHiCdQevvIgl5dT
         FzPnraq4h57hwfclRBWlDzwslNIxaTmVKcBPhViw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AF3B561340
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH] netfilter: connlabels: fix spelling mistake "trackling"
 -> "tracking"
To:     Colin King <colin.king@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190418170056.22486-1-colin.king@canonical.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <098887eb-7de9-dc84-ca77-6080620533c5@codeaurora.org>
Date:   Fri, 19 Apr 2019 00:32:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190418170056.22486-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 4/18/2019 10:30 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There is a spelling mistake in the module description. Fix this.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh
> ---
>   net/netfilter/xt_connlabel.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/netfilter/xt_connlabel.c b/net/netfilter/xt_connlabel.c
> index 4fa4efd24353..893374ac3758 100644
> --- a/net/netfilter/xt_connlabel.c
> +++ b/net/netfilter/xt_connlabel.c
> @@ -15,7 +15,7 @@
>   
>   MODULE_LICENSE("GPL");
>   MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
> -MODULE_DESCRIPTION("Xtables: add/match connection trackling labels");
> +MODULE_DESCRIPTION("Xtables: add/match connection tracking labels");
>   MODULE_ALIAS("ipt_connlabel");
>   MODULE_ALIAS("ip6t_connlabel");
>   
