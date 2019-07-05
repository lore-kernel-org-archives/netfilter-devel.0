Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB9CDC5B57D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B936218A3
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:28:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="c3IzIeVM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfGEI2d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 04:28:33 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56175 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfGEI2d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 04:28:33 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so7925376wmj.5
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2019 01:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hZ+xm6CrUEywAVzXTfhFxGsIwIJgpN0+1W8s2x/bags=;
        b=c3IzIeVMeule+KQO+Y5hOKFEAcp51mU3jBwWgfNIszd5EwFwOzPrcwrBiO0yh4hMVg
         IR0QIQ96MLJHjrDefnKjJTbRIPIm6dsiiPNS+lfblbTO6vE3CGL2B/FuDwPrpHSF0P1J
         7mbU1JuBtnp1e3PXHrUqqkSabTQ0/5JwR9BZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hZ+xm6CrUEywAVzXTfhFxGsIwIJgpN0+1W8s2x/bags=;
        b=oTFV5C0KEHnRnVV3V/XCJslKg4kdGE5figQxsPWjlnle9vLHN9IVkhhTaDmIAAhKJo
         96lHs7s6NSfB2TqU9NRRHG0NXSWTPn37Kz0iJ7WwKciLTfztCSJcotm/B6iOXb242cqL
         rmXska7efveBc3iYVZUJDxX1cu3lDfvdvegfg4Lv3R2Hd2AdIUvq/5iECgtkFBGhKdwq
         9302TSzeVYMWbzlC1hQ5xCV1yY6HLYjaflrfDtHK9aWjgef02qLRWWndfOcVqwZt2ym4
         KTEeYvuzENiKeMIqLJV0AbySOzTpnpcoxtRrUydCccjjt68JY+Dow6K77xeL4ejmJQ3w
         oYnw==
X-Gm-Message-State: APjAAAUHGLJBgyhuLWmDYrKJiuwVeidkruAVKGlr8Xg4ECg0XGCj9oMX
        1JyN8vtHW2dMJhf/rE1J59+Dvw==
X-Google-Smtp-Source: APXvYqxzDAEN+dnlzeXr4qqgdU+mY/XR5GFfju144HdaPPYRNbmXzcUPePKSquXotxTDowFoKAz+kA==
X-Received: by 2002:a1c:eb0a:: with SMTP id j10mr2429839wmh.1.1562315310906;
        Fri, 05 Jul 2019 01:28:30 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e7sm7594574wmd.0.2019.07.05.01.28.29
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 01:28:30 -0700 (PDT)
Subject: Re: [PATCH 6/7 nf-next] netfilter: nft_meta_bridge: Add
 NFT_META_BRI_IIFVPROTO support
To:     wenxu@ucloud.cn, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1562224955-3979-1-git-send-email-wenxu@ucloud.cn>
 <1562224955-3979-6-git-send-email-wenxu@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <89cf54d6-c36f-d59b-a414-5829aebd4552@cumulusnetworks.com>
Date:   Fri, 5 Jul 2019 11:28:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562224955-3979-6-git-send-email-wenxu@ucloud.cn>
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
> This patch provide a meta to get the bridge vlan proto
> 
> nft add rule bridge firewall zones counter meta br_vlan_proto 0x8100
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/bridge/netfilter/nft_meta_bridge.c   | 12 ++++++++++++
>  2 files changed, 14 insertions(+)
> 


Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

