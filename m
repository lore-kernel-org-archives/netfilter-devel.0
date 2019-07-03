Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6A0C06513
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 741CF218A4
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:08:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="cKuxib0x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfGCMIJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 08:08:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54689 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfGCMIF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:08:05 -0400
Received: by mail-wm1-f65.google.com with SMTP id g135so1939200wme.4
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jul 2019 05:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J59F3dMhWxbnEie6W6MXq5/LSl0Eehr1s+0JLvyfa3g=;
        b=cKuxib0xGaicYaSYXqj2YMouleMsFhPteEEhc9pVacqBYPsyNB0dXkCX/+isPZ4EIW
         i5Ij4uQqcTrFv+UVuLQzlvAW3F9GdCasq9PL1U8uEpIaO+9OdyPeHJKYcwjky9eUba7N
         aAZ45EQ+NhmViQ5JsTnCE/jrDNLR+W5ltBM0I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J59F3dMhWxbnEie6W6MXq5/LSl0Eehr1s+0JLvyfa3g=;
        b=ELJTshsmgrzUiZQY/eAypZuGYRrShqSdOiFJPNYObnDukVeW6ClUyzISHZUts2zdzB
         nxWJhaHB4fqPtOffxUB38kTJ5N0xr7DVXV7PvRXT73YXN6bKzGdHUvmGkzXj2zJj1QeA
         rSpSyzS18T6xScauGSDK8kCCOiLMc7tSP/obsi2SQZ4xBSkNH9Txb7iOiZnZqAHeGX1I
         6OhKY/RnarR9F7GRhWRrCN6ADigz4Do2lRs67OMQ7WLnofRT7yqaCDR2Lvnj2NkeFOz/
         M75oC5r0Jtcq9AzhIBDTaMlWGfeRYoCcLFbBgl8YJ0qBnTCYh9yTQydAmifyRhI9HZkD
         XdyA==
X-Gm-Message-State: APjAAAUchf7B+5CAOEJ5RiKYus4aOGSr2D5fZ9vaKiMo72uHhXQPIgL3
        ZLI5j5tgFE26VyRkfEf9k6TreQ==
X-Google-Smtp-Source: APXvYqyY/5IU4uKdq9FUXoGJ7wsMiQArBiaK1i5XY7LOZq/P7x84WsZD5LFvXi5DUEu/Q2hNB/EWcQ==
X-Received: by 2002:a1c:3886:: with SMTP id f128mr7745421wma.151.1562155683641;
        Wed, 03 Jul 2019 05:08:03 -0700 (PDT)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id j7sm2920336wru.54.2019.07.03.05.08.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 05:08:03 -0700 (PDT)
Subject: Re: [PATCH 1/2 nf-next v3] netfilter: nft_meta: Add
 NFT_META_BRI_IIFVPROTO support
To:     wenxu@ucloud.cn, pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1561682975-21790-1-git-send-email-wenxu@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <366e228f-7253-e388-4799-f0f9c18d1111@cumulusnetworks.com>
Date:   Wed, 3 Jul 2019 15:08:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1561682975-21790-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 28/06/2019 03:49, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This patch provide a meta to get the bridge vlan proto
> 
> nft add rule bridge firewall zones counter meta br_vlan_proto 0x8100
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/uapi/linux/netfilter/nf_tables.h | 2 ++
>  net/netfilter/nft_meta.c                 | 9 +++++++++
>  2 files changed, 11 insertions(+)
> 

Hi,
When using the internal bridge API outside of the bridge I'd advise you to CC bridge
maintainers as well. This patch is clearly wrong since you cannot access the vlan
fields directly because bridge vlan support might be disabled from the kernel config
as Pablo has noticed as well. In general I'd try to avoid using the internal API directly,
but that is a different matter. Please consult with include/linux/if_bridge.h for exported
functions that are supposed to be visible outside of the bridge, if you need anything else
make sure to add support for it there. The usage of br_opt_get directly for example must
be changed to br_vlan_enabled(). 

Thanks,
 Nik


