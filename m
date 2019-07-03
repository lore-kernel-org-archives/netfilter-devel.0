Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE007C0650E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ACBA2189E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:42:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="d6A9vpWi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfGCMmc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 08:42:32 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37393 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfGCMmc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:42:32 -0400
Received: by mail-wr1-f66.google.com with SMTP id v14so2655382wrr.4
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jul 2019 05:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=73Z6yaJsbbbf40V41AoK++cX14SZrBNYZG3bmClY4Bw=;
        b=d6A9vpWiEVL4F9MfpBZtNmambPX5TD74hHk4/m94ZZJ32OR7y41As3AoBuhMqn5Fvm
         A60sXgnHhItyvcr8+f/b44l0kevZgPqUq1QkZzuMsE+QgE6yvmA3HuVrLc/ptgrIoQHq
         OTweLldz3cbbKaDZ/aXxE+LMdTJNFhA9EQBmc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=73Z6yaJsbbbf40V41AoK++cX14SZrBNYZG3bmClY4Bw=;
        b=dJYOb+JaoUN3qXdSAEfJBPz6W428ynofPsB5+uBI2qt/vStU4vDgfnl7uqvtdRGhBN
         F5opKiHItAFuwvr9vnldr3VBPZ+W1oG2jSpwiCk/3dErJGt9cwWacBahBEsKMVBSY1IC
         REyR5iJtXfle3JqcsfEmyaAkJJwt0bazqWNm8glCmhgQtjeAvRmspukYfpgtc0W6JtxL
         LGPRGdduRbmbZPsRVmi39EEKkaVReN4gqnrzgtm0HCQgHCfgzKWACW1a1AC77t7rMudV
         sIbrn3lKYvVuBe+tN/aDngWgFXMH735iYudnNb2svGozt9ukyH6CJrrmc7ZDZpHDAIFY
         El1Q==
X-Gm-Message-State: APjAAAUO5IH8tMFCOp3AmAG9qGxYE1HVheFrYYFVG1Ij966MxJ2/UiRt
        D7c/Ge8s1eUCZvpQRRC16PGasLVSr6rLlg==
X-Google-Smtp-Source: APXvYqwu+ZNLwsh1hRenpZ4VYj7OEO7jKkoRjzsBqLhzuKo3EkkLagaCVt/csDku21rsxRpSdwFekg==
X-Received: by 2002:adf:de07:: with SMTP id b7mr5117612wrm.318.1562157749989;
        Wed, 03 Jul 2019 05:42:29 -0700 (PDT)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id v4sm2368048wmg.22.2019.07.03.05.42.28
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 05:42:29 -0700 (PDT)
Subject: Re: [PATCH] netfilter: nft_meta: fix bridge port vlan ID selector
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     wenxu@ucloud.cn, bridge@lists.linux-foundation.org
References: <20190703124040.19279-1-pablo@netfilter.org>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <f7763540-dd87-9ba6-3d18-451427eaeb0d@cumulusnetworks.com>
Date:   Wed, 3 Jul 2019 15:42:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190703124040.19279-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 03/07/2019 15:40, Pablo Neira Ayuso wrote:
> Use br_vlan_enabled() and br_vlan_get_pvid() helpers as Nikolay
> suggests.
> 
> Rename NFT_META_BRI_PVID to NFT_META_BRI_IIFPVID before this patch hits
> the 5.3 release cycle, to leave room for matching for the output bridge
> port in the future.
> 
> Reported-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Fixes: da4f10a4265b ("netfilter: nft_meta: add NFT_META_BRI_PVID support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  4 ++--
>  net/netfilter/nft_meta.c                 | 17 ++++++++++-------
>  2 files changed, 12 insertions(+), 9 deletions(-)
> 

Awesome, thanks!
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

