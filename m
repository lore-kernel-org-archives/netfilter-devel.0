Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12463C5B57D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D816621852
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:18:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="JehHPgs6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfGEISx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 04:18:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52910 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfGEISx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 04:18:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so7892818wms.2
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2019 01:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xNaeeNQ+DrT/MDlwiypulX86a/vhe/+Mo0zzZKV7q8c=;
        b=JehHPgs6sR8BLe7UByCaHBk14ZJNP0GNmUXJbLqc1ZTfXPb8PUTWfJ2nZ6RLnGFo1L
         J1k+aGLyEvR5cwemuYJ5jXbTdE/3GDchqRdGac05YNIAXbxIgzJrDjUoZF2bZCIs0LHd
         8UsvftCyyEzzFDGFryG44SKvKD2/6OgSjMYQU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xNaeeNQ+DrT/MDlwiypulX86a/vhe/+Mo0zzZKV7q8c=;
        b=XNOEKVSSDO6FQyLaPZQK7RvfeQ5TrBU8h39VTTDx2kogudusrlJlekNvyBdznbhRFF
         awyF6K0cHxkdNnBWZYI0MinDd3h8rNv/xSD0Q9EOj3TstU1BsFEeCR6TCw2/dOxh8apN
         oF6s47+DNELEjVmhIxtRZOLn9kOdUafrTB3cpN/akgx8TpjojRIE1hMcUN65o6lqosHE
         JzHYNoRb1gaJ17r0bU6O4iGbhtNZGhfuEF8RaVLvIqWLxLeheSIsnFqPcNZY2aAaqkON
         arAxQDXflLetfXlgKNSdJ02SWbejB+cKYLZRn4i3nFurahE9/fCS+vml9q2ca/OaziDv
         FD4g==
X-Gm-Message-State: APjAAAVXxJQa6/dRDICWJhObE8x3q9UpGjGTN7utcXkfjdViEdOm9YEa
        IOSTozJcd5es5x9M7VtoPJhi8g==
X-Google-Smtp-Source: APXvYqwua5wSPZZ5dvFM8Gh/e9hvNksw/eFcfk0k+YX6EbO3Bha7QwvoFSozmIDDGxTTdpCfdOHPZw==
X-Received: by 2002:a7b:c766:: with SMTP id x6mr2302197wmk.40.1562314731102;
        Fri, 05 Jul 2019 01:18:51 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 72sm8076210wrk.22.2019.07.05.01.18.50
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 01:18:50 -0700 (PDT)
Subject: Re: [PATCH 2/7 nf-next] netfilter: nft_meta_bridge: Remove the
 br_private.h header
To:     wenxu@ucloud.cn, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1562224955-3979-1-git-send-email-wenxu@ucloud.cn>
 <1562224955-3979-2-git-send-email-wenxu@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <ccca906e-eb4f-efa0-abc5-664be9d8044b@cumulusnetworks.com>
Date:   Fri, 5 Jul 2019 11:18:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562224955-3979-2-git-send-email-wenxu@ucloud.cn>
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
> Mkae the nft_bridge_meta can't direct access the bridge
> internal API.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/bridge/netfilter/nft_meta_bridge.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 

Nice, thanks!
Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>


