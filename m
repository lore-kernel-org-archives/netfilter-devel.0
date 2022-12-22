Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503D3C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Dec 2022 11:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiLVLO0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 06:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiLVLOY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 06:14:24 -0500
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A980B1AA2F
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Dec 2022 03:14:23 -0800 (PST)
Received: by mail-wr1-f43.google.com with SMTP id h10so1293636wrx.3
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Dec 2022 03:14:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7H2X/uv5MlHDmHl+KhGmRGGVqPUiKwSbVaY7a7WKWgQ=;
        b=gf+mkg3AgUGWwbv63foJ2Wlr53Sakv2lrHBPgiBwaCLpc4IxPbc8W93BzR90lx98YR
         A4Llru8EvVJjb4FGjp3efWt469xNWkcud71CsHQrlkyE3Otxwas5tKU/1DLihpqvSWRz
         mgvdAm46vdGG/+3b+Ba0WATrTu0fLZaPkie1jNxZMRo6mpUMlqQvz4rhg707fL2dEj6m
         WIiu76QWRqjrBc63h9AGphx52oDGMve/jXxI4sNjshUiWV7LFs+F5vpqQYOWF6Qr4Htl
         TqSwTXrZgOZXtQwgo+1WBJrCz/Mks/cCP2BJ/+KVHJUa8/ZS1MFVnJytH06DzEGSfz5V
         xiqQ==
X-Gm-Message-State: AFqh2kpZ+X9ZpCsC2XxubHg+LuTG7CJ3zM6Sry3VwzkUkRJHX8GTMXJE
        w4it85qIJpj0DCbzg9UD/j/B/RE+dqQ=
X-Google-Smtp-Source: AMrXdXvwKBolkm/uI5Qs91+ec27XowQjbEiI8nkCVPVeoy2sXloiCGYc3MooMbW+StxF9vunw9sjcQ==
X-Received: by 2002:a5d:4592:0:b0:242:75a8:31b8 with SMTP id p18-20020a5d4592000000b0024275a831b8mr3365702wrq.12.1671707662120;
        Thu, 22 Dec 2022 03:14:22 -0800 (PST)
Received: from ?IPV6:2a0c:5a85:a203:a300:33fe:6815:88b4:c3d8? ([2a0c:5a85:a203:a300:33fe:6815:88b4:c3d8])
        by smtp.gmail.com with ESMTPSA id f1-20020a5d5681000000b002714b3d2348sm294406wrv.25.2022.12.22.03.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 03:14:21 -0800 (PST)
Message-ID: <22fd9796-023f-1aac-e054-5227bc64be3d@netfilter.org>
Date:   Thu, 22 Dec 2022 12:14:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [ANNOUNCE] nftables 1.0.6 release
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
References: <Y6OXLMinA/lCWNsB@salvia>
Content-Language: en-US
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
In-Reply-To: <Y6OXLMinA/lCWNsB@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 12/22/22 00:30, Pablo Neira Ayuso wrote:
> 
> To build the code, libnftnl >= 1.2.4 and libmnl >= 1.0.4 are required:
> 

Hi,

when building nftables 1.0.6 for debian, the build system says that it 
should be fine to use libnftnl 1.2.2, which apparently is the latest 
release that added a new public symbol.

This can be a problem with the debian toolchain, or it can be for real 
that there are no new symbols since 1.2.2 and therefore the build-time 
dependency is on >= 1.2.2

No big deal, but it would be nice to clarify this.
