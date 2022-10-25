Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3E1C38A2D
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Oct 2022 10:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiJYKRJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 06:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbiJYKQg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 06:16:36 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923A3AE7C;
        Tue, 25 Oct 2022 03:10:34 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id v1so19938769wrt.11;
        Tue, 25 Oct 2022 03:10:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uc9p4pxgaPjOFwwgtFXQO+ezBU9GVgk+go6wbCb+AqY=;
        b=WE1TXhJCvrqQ9Fc1H7HU3LWg8R9Z5vIANXFh+VnJXdeqK/L7TOtQ6zOmiLxCaFP5aB
         kotIioE9VRWyVNLLeEApzFurgNmWdTzlHFxGWkFkRwqE/QztdGduRCIaWePh4XKlsI3U
         bo2ggbSLQVn90ZCHzWQGmlqSqpVWTZ08HZijVqgH2eQs3ejAuBQcCBGDevb1rlROZsXS
         9CBaxiap3UJARpmTUTontd70p9INXQCyvtAb5kZnBUHQr++XEPgy82l5OQggagxH+cAm
         w0lghsWF3/6EAIMtUWTDmdxIs++AErJo/x98BnFNVDtJInBt+GHIY5PXH+Tm6OxIpb8f
         D+vA==
X-Gm-Message-State: ACrzQf24sh4/S9pvXNZDU6mqoOkaLoEHoUnI4e7Pr1Ei4pLiA+zNB8wd
        v4edttFqbQ3TqfyL7QjBPY4UVexI30c=
X-Google-Smtp-Source: AMsMyM4qMrEOgQ5nnxYDzhk1M+HkwrKg0RLxgJJgwJpBhbCk/RK+EQUp0ZBlOlG/vkkVjVnznZnipg==
X-Received: by 2002:a5d:6d8a:0:b0:236:6123:a8a5 with SMTP id l10-20020a5d6d8a000000b002366123a8a5mr10388857wrs.229.1666692632981;
        Tue, 25 Oct 2022 03:10:32 -0700 (PDT)
Received: from [192.168.1.198] ([213.194.139.165])
        by smtp.gmail.com with ESMTPSA id h20-20020a1ccc14000000b003b492753826sm2138877wmb.43.2022.10.25.03.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 03:10:32 -0700 (PDT)
Message-ID: <a9d40594-f05d-f669-3a7b-f2f3924f14c4@netfilter.org>
Date:   Tue, 25 Oct 2022 12:10:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [ANNOUNCE] 17th Netfilter Workshop in Seville, Spain
Content-Language: en-US
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
References: <Yw+F/N3y9vIHnY+3@salvia>
Cc:     netfilter@vger.kernel.org
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
In-Reply-To: <Yw+F/N3y9vIHnY+3@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 8/31/22 18:02, Pablo Neira Ayuso wrote:
> Hi,
> 
> We are pleased to announce a new round in the Netfilter workshop series.
> This year this event will take place from October 20 to October 21, 2022.
> The event will be held at Zevenet [1] facilities in Mairena del Aljarafe,
> Seville, Spain.
> 

Hi there,

let me share my report/summary of what happened during the workshop:

https://ral-arturo.org/2022/10/25/nfws2022.html

regards.
