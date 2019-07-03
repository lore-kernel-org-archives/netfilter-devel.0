Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377DFC0650E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 14:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E485921881
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 14:52:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="CxGbbW63"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfGCOwP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 10:52:15 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50389 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCOwP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 10:52:15 -0400
Received: by mail-wm1-f67.google.com with SMTP id n9so2550998wmi.0
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jul 2019 07:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BM5k0kkio2R7Vcb1AP2k6RxRHMZpGAV0eFzOrb5l0VY=;
        b=CxGbbW632YVjM54WJhzdY/VDJPMZY+qNFwBjnmXzA6q5pYuSZPdNDkk9bqDC5qijPd
         IFllT808pft27PzZDzWHtSvheLToF0BNRPE2dcHuTwXGqajpo+B8wiD6hMMjNBfk94Fz
         jc9Lnrjg+F1val7zXWpuHLsC2yo2GWEdiZbFk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BM5k0kkio2R7Vcb1AP2k6RxRHMZpGAV0eFzOrb5l0VY=;
        b=brB8vZWXfHLYBq9ThwuNKG0pSvCqotC2wv+6P4s9ttibb/VpghyQA1EYEz4sJElJDz
         /aH7iGdiaGfBfQz4SGEf4trICp/Nt1K9PzY0NOV6/qvu9CKztpNdQqEW7wMA3ewQw16X
         l+4H+ofgdGmkeiuxVJlIa8l3j51q7AyPGPU8uu31ionIlW92OO4yocXildyCIUlsjsZL
         yE53nmSKlOeb8ltfYeKksw6UZufcs9f7YTgfyp67ES4iUe4HtjRtvBSWG0fYuPBd/7Ox
         zYODCzxr4htZJ5xek2DKWuNhuK0hfFKge84yQsPkCTobuU96+JrU2qUK/ymM9ux1X2MK
         PYGQ==
X-Gm-Message-State: APjAAAUMBMP2/vvyLUkk/cmvV3rv3NZ5TTFwt4nUAGia5yrgNhFu2rFx
        6+A40Hv04GnPC02hL+/LWpppEDzbTQzu0g==
X-Google-Smtp-Source: APXvYqxgvTyefmeP/VQtfNazzq15hGTv2ttyRhceLrqEacViGeoUwQqdDOMFVJ/88nq3k3xG2Zr+GA==
X-Received: by 2002:a1c:7e14:: with SMTP id z20mr8115807wmc.83.1562165533742;
        Wed, 03 Jul 2019 07:52:13 -0700 (PDT)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id t63sm2410203wmt.6.2019.07.03.07.52.12
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 07:52:13 -0700 (PDT)
Subject: Re: [PATCH] netfilter: nft_meta: fix bridge port vlan ID selector
To:     Pablo Neira Ayuso <pablo@netfilter.org>, wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20190703124040.19279-1-pablo@netfilter.org>
 <ecb6d9e8-7923-07ba-8940-c69fc251f4c3@ucloud.cn>
 <20190703141507.mnhzqapu4iaan5d7@salvia>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <3df24a0e-fd51-2dee-8cd3-76daf2ea9de7@cumulusnetworks.com>
Date:   Wed, 3 Jul 2019 17:52:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190703141507.mnhzqapu4iaan5d7@salvia>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 03/07/2019 17:15, Pablo Neira Ayuso wrote:
> Hi,
> 
> I'm planning to revert from nf-next
> 
>         da4f10a4265b netfilter: nft_meta: add NFT_META_BRI_PVID support
> 
> because:
> 
> * Nikolay wants us to use the helpers, however, through the existing
>   approach this creates a dependency between nft_meta and the bridge
>   module. I think I suggested this already, but it seems there is a
>   need for nft_meta_bridge, otherwise nft_meta pulls in the bridge
>   modules as a dependency.
> 
> * NFT_META_BRI_PVID needs to be rename to NFT_META_BRI_IIFPVID.
> 
> * We need new helpers to access this information from rcu path, I'm
>   attaching a patch for such helper for review.
> 
> so we take the time to get this right :-)
> 

Hi,
The plan sounds good to me. I also went over the patch and it looks good.
I think it'd be nice if we can get rid of the br_private.h include and
make nft_meta (or meta_bridge) use linux/if_bridge.h instead. Having
a clear distinction between what is supposed to be exported and what
remains internal would be great. I will help out with that.

Thanks,
 Nik

