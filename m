Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE8FC5B57D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6F6C218A3
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="Znp8eCVf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfGEIYb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 04:24:31 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55132 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfGEIYb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 04:24:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id p74so4880689wme.4
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2019 01:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=atSD+AC/JhTBLnkkNDGX0tjw7svVlM9Q+yrxINFZ3wE=;
        b=Znp8eCVfVNJmz6gkdBUp/VgIf0BCdgk/0mFrzc+BJQDL6TQpwEHJcUoFduUnZA5W8e
         EEKx/byuJKGWd+vtk+YMDaqSRTnRrkaiIQ/1b05ozsGmH/VrlL4kb29sF/izX776ild0
         tTRZdtJDSjJwgX/a4S2V2h7MWyhd4iGME9dX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=atSD+AC/JhTBLnkkNDGX0tjw7svVlM9Q+yrxINFZ3wE=;
        b=cog8CRKbAl34uu1J4bWmpxxGiymJbDiOhiO1XtF9i61yLBCjnhChW1GoDVVMxN0c2m
         AIe39iTMHSNtpOD2srOg/FZz8UhJb3918MihXC6b4AcMtQJcZAiYmxi9NitwCsjo4++y
         VywfRKchBx4SIAkGZq2tDua4zEwabrguGQKakdKyzQH+Q4fcAKHalo7V69iY8Ki+sPpY
         Twt8c/6e9WOD3s7eDOKeOI91nPzBzyhjVikuwHIWfJOw7SMV14RTsENip+ib6DqzBFwG
         /BPaDqsfvskQi2RLNPBEUxJjvp2bArcNGw6pswBtgn+xRMvLXBLZ7pjpu5CjGdmxGZe4
         bNmA==
X-Gm-Message-State: APjAAAUPV/wHaOQGeMzF0Xmo2fgfjQ+892ADSA1kLUwvFv0W7mdePUm6
        MbfBbN/VHN6cdt1xJ7MqDNmAEQ==
X-Google-Smtp-Source: APXvYqzbq8+MDwq1xh01uJRo7jXovlYNN3YkTIb8S5MJlomGowui0t6ZyYTNNNZviY5NMKIMgpfKww==
X-Received: by 2002:a05:600c:da:: with SMTP id u26mr2161859wmm.108.1562315069015;
        Fri, 05 Jul 2019 01:24:29 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id n125sm11090164wmf.6.2019.07.05.01.24.28
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 01:24:28 -0700 (PDT)
Subject: Re: [PATCH 4/7 nf-next] netfilter: nft_meta_bridge: add
 NFT_META_BRI_IIFPVID support
To:     wenxu@ucloud.cn, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1562224955-3979-1-git-send-email-wenxu@ucloud.cn>
 <1562224955-3979-4-git-send-email-wenxu@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <33319d6b-1666-c083-6297-d618e2ae51f4@cumulusnetworks.com>
Date:   Fri, 5 Jul 2019 11:24:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562224955-3979-4-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 04/07/2019 10:22, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> nft add table bridge firewall
> nft add chain bridge firewall zones { type filter hook prerouting priority - 300 \; }
> nft add rule bridge firewall zones counter ct zone set vlan id map { 100 : 1, 200 : 2 }
> 
> As above set the bridge port with pvid, the received packet don't contain
> the vlan tag which means the packet should belong to vlan 200 through pvid.
> With this pacth user can get the pvid of bridge ports.
> 
> So add the following rule for as the first rule in the chain of zones.
> 
> nft add rule bridge firewall zones counter meta vlan set meta briifpvid
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/bridge/netfilter/nft_meta_bridge.c   | 15 +++++++++++++++
>  2 files changed, 17 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

