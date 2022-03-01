Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B76C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Mar 2022 01:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiCABfZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Feb 2022 20:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiCABfY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Feb 2022 20:35:24 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE6F3B024
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Feb 2022 17:34:44 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id bx9-20020a17090af48900b001bc64ee7d3cso833545pjb.4
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Feb 2022 17:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Uj+NEfFWrG4+rJjk8kDr8lZSFl/zdIH/DsAZjQbsB7I=;
        b=THxa43uNJOiOvWx/BDFXUNe2Fj0+R4dWR337okcd7DY2xB5U66NR6GmeEVvhexsqhK
         Sy64zftAWGBdhnlbsFOg3+Tfbvmy2bgm+O2QE1MjY/vKKvhk5oGdyvIPHV9G1oHbIJjM
         GvqrePPJeD1VuyknH/MrnVugBOmx5IV9Wj2xJUe+BJU1WOWn5jFpBEEtuhbZg/4uSkFS
         y2M7HG4vR2Wz8JxBKdouMpDzEWpeFgyyQx3pHEZnDFWaxwC2pfaGPSPi1ED7EDDnQRRu
         Zi9D35wCOC1JKIzXUNlLx4YsPptCD7qQ6WtRBREc+dloo+bD176SkTA43BlDPaFuBop3
         8NvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Uj+NEfFWrG4+rJjk8kDr8lZSFl/zdIH/DsAZjQbsB7I=;
        b=Ksw07Atkg81eGa0D601vP+8qBRf0F6fYhgu+aB05wbNwv4afiVVeovDWKj5WGUAYU2
         czdHFhuRK5ayLs/ePetJlky0DpsugnjVP9ktlfxBKBVp0AI0yf73Qqst1QzVR5uQEMRe
         CDLkecXWaPsdqy9ru8VLWUm0+HRy0UlKRyEDeCQKsXa329Lk8KhYLHLudQ6hvpsNrz9l
         TH5ePJOR88bbYZKu9SC72Rro5pda/bqysJSRc5SymHlf5XDKoufqQjTbiNkSNsL+fZDO
         QGb+HQqoEmvFIzHktRsVo3WIa1s8xtW0dN+Og4uU84LlowMwdwCSzwZfY/Z9rJKh2iL6
         zHyA==
X-Gm-Message-State: AOAM532T9JlegEE4ss2upz9Ny5MaemVhZKbryscyGy2P1urWRH2tjQ2e
        x28E7Ifx0+7M3f9djs5j1e0V2zQBU+s=
X-Google-Smtp-Source: ABdhPJz3C8W3PMPiQD3gGMRIZvWAOP+PXxTBa1iOM1hrvh3FVhy9xMRa+gPfyBtRSmlYNsmxkjQc1A==
X-Received: by 2002:a17:902:e889:b0:14f:c4bc:677b with SMTP id w9-20020a170902e88900b0014fc4bc677bmr23442767plg.68.1646098483579;
        Mon, 28 Feb 2022 17:34:43 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n42-20020a056a000d6a00b004e1a01dcc35sm14632373pfv.150.2022.02.28.17.34.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 17:34:42 -0800 (PST)
Message-ID: <5576e8a3-1d0b-7715-bf45-150648601604@gmail.com>
Date:   Mon, 28 Feb 2022 17:34:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2 nf 1/2] netfilter: nf_queue: fix possible
 use-after-free
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20220301002108.28338-1-fw@strlen.de>
 <20220301002108.28338-2-fw@strlen.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220301002108.28338-2-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 2/28/22 16:21, Florian Westphal wrote:
> Eric Dumazet says:
>    The sock_hold() side seems suspect, because there is no guarantee
>    that sk_refcnt is not already 0.
>
> On failure, we cannot queue the packet and need to indicate an
> error.  The packet will be dropped by the caller.
>
> v2: split skb prefetch hunk into separate change
>
> Fixes: 271b72c7fa82c ("udp: RCU handling for Unicast packets.")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---


SGTM, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>


