Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A269C5B57D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD822218BA
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:16:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="WuvrBzJu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfGEIQR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 04:16:17 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53332 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfGEIQR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 04:16:17 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so7889092wmj.3
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2019 01:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4peepLiWhCkWmJMx6sNyd4wCIbHYDrXG09wLZE8Lxtc=;
        b=WuvrBzJuIaPhIsJY2lVj5+75oQzyfNhGBKNHDIEFWqo92/jIr+1VspbpsiPsDzJSQA
         Q1SYdbnJR4rOGf9zfl/Uaz+WEE0tjO2eB6FvPoYbGj/xsNch+8A+Z7gawDLtDz/ShT9B
         8tosHgNaNTU7sGjt7pRvrVdA5DNSXMbGbM4VA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4peepLiWhCkWmJMx6sNyd4wCIbHYDrXG09wLZE8Lxtc=;
        b=Qjmz4JroqJjkL+uI0nSDL1HBPHb0fRXkAax66oCP7JYveneddiNWpXTOPJvJ7z07PT
         I9DWuHNmFsPA4djJDLclQxzIbUpA+EkugiKE4kt7ZE5yAcY/smM0s5osIFcpI/J2oCnP
         wF0CpHB4+FfBDSDPfD/9wRFT1UIGhi+IPvdyQVQMd0sAmgYyvW1PIjEXEFNSxnfennwm
         UwZlRKiqM/IouAAX67F+lW/6FZguXTQpwPi2nmJ1plcInRwtbYX5PPOlOk1PwIElfMR2
         F8mxEHZPUvRx+HgJlgARu0d/7aw0EvY2CxfNHhAChzkLIO7JPm/H8+CgMBg9V/DYbHVn
         Rhvw==
X-Gm-Message-State: APjAAAXv9GKDXvpcfgF46Ic5cltMjPtXhlvkZSK/8X+758zHU8PdSVOL
        3WL7mk1dOn1K0W6K72gMn/YpWkycL/AvdA==
X-Google-Smtp-Source: APXvYqzZJph7epRe6tGfT1xdpagVt6kzFr4EeMRWBPNDYo0lw2rPWvhCN5tFvTMfnv+KM7IDDWHJLw==
X-Received: by 2002:a1c:c545:: with SMTP id v66mr2259142wmf.51.1562314574850;
        Fri, 05 Jul 2019 01:16:14 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id u1sm6898650wml.14.2019.07.05.01.16.13
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 01:16:14 -0700 (PDT)
Subject: Re: [PATCH 1/7 nf-next] netfilter: separate bridge meta key from
 nft_meta into meta_bridge
To:     wenxu@ucloud.cn, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1562224955-3979-1-git-send-email-wenxu@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <2b5f91c9-c564-ea90-89c9-85443cae4bd7@cumulusnetworks.com>
Date:   Fri, 5 Jul 2019 11:16:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562224955-3979-1-git-send-email-wenxu@ucloud.cn>
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
> Separate bridge meta key from nft_meta to meta_bridge for other key
> support. So there is n dependency between nft_meta and the bridge
> module
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/net/netfilter/nft_meta.h       |  44 ++++++++++++
>  net/bridge/netfilter/Kconfig           |   6 ++
>  net/bridge/netfilter/Makefile          |   1 +
>  net/bridge/netfilter/nft_meta_bridge.c | 127 +++++++++++++++++++++++++++++++++
>  net/netfilter/nf_tables_core.c         |   1 +
>  net/netfilter/nft_meta.c               |  81 ++++++++-------------
>  6 files changed, 207 insertions(+), 53 deletions(-)
>  create mode 100644 include/net/netfilter/nft_meta.h
>  create mode 100644 net/bridge/netfilter/nft_meta_bridge.c
> 

Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>


