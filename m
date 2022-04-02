Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AF2C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Apr 2022 17:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240060AbiDBROO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Apr 2022 13:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347861AbiDBRON (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Apr 2022 13:14:13 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BE265402
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Apr 2022 10:12:21 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gb19so5001878pjb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Apr 2022 10:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6tV6tnyZTuFYgA3d5cC4qg4TVxEnbX+MWJBTjh/KUd0=;
        b=LHEisPr99z7a2Axn3EMX1PYcT/FtYgxopD5GJ0YyYLLvVguM1j1/Bkc2OOuaRxjbc8
         u+foEPJKSmvCDnyYVpzFXHMe+BGNWxIAGq/iJS8bx8JWN/6DTU17MArByOYjXtRERuZT
         UzTPQWcVzzVN6pUebG3lbmFKYtp2NxEv1rDYS4Bc+H+S3AMlVUrZTtIbUScHhrpWoQJq
         NJ3dq27Ht/NnNbciLshXzcgIzAH+Ij2F0ALxv1gbKFF1/UJXYcXAiv/iKc8HC8W83UQc
         XAJW6h82X7xs+kcmbRwd0jT/7ZDSoKCpxDVyaXXphko5S+e0lmC4ouIBb39nyntGXtn9
         +ygQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6tV6tnyZTuFYgA3d5cC4qg4TVxEnbX+MWJBTjh/KUd0=;
        b=zt01xHAq/ZklfgIteeGD0SSc8Wc33Ceyn9SGbylltswa9/h57WBmPbYfUJrWnHAriV
         VBttNVNHdwjMGY62tBSnRNtNiIt1H5NfHQ+qs5q+sdAiLx411XJr/hAbL3AJDdSSR+wc
         DQDEitryUd9nxficzIK4oiI44nQ/+nrRG2Nd6YVxWUlvoVNbng7zmsXLk5PtKho/rNHb
         RtffAmQzf0tLUqRUFo70poiIDDYgeUwTXRJrnDsYBZczcQ51cHteU5Q2YPK+jpShQrwK
         weA4FR5FvBtQ0GV2RzZdQSlwZWD/pDCyrEP4GA14M3uGQ5+eCCcXKRhbRlGzuTYoY4eJ
         ddnA==
X-Gm-Message-State: AOAM531ZquJam4kpllIAKx+lPMl8OEvnWZgUmoJVsMkIj1kynTwyzsB8
        oeRupLlx4hDbvuaLzjCWRiM=
X-Google-Smtp-Source: ABdhPJzOMNyrt2OZWxNwND5x/CQdHnZz8lXHmq48anzC/HeGTjzAVtKYPmNp8pT/8SEgnJEFbshJ0A==
X-Received: by 2002:a17:902:da89:b0:154:5d8e:9d40 with SMTP id j9-20020a170902da8900b001545d8e9d40mr15681801plx.71.1648919540690;
        Sat, 02 Apr 2022 10:12:20 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090adac100b001c67cedd84esm5607928pjx.42.2022.04.02.10.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 10:12:19 -0700 (PDT)
Message-ID: <80f0f13f-d671-20fb-ffe6-5903f653c9ed@gmail.com>
Date:   Sat, 2 Apr 2022 10:12:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: troubles caused by conntrack overlimit in init_netns
Content-Language: en-US
To:     Vasily Averin <vvs@openvz.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, edumazet@google.com
Cc:     netfilter-devel@vger.kernel.org, kernel@openvz.org
References: <de70cc55-6c11-d772-8b08-e8994fd934a0@openvz.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <de70cc55-6c11-d772-8b08-e8994fd934a0@openvz.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 4/2/22 03:33, Vasily Averin wrote:
> Pablo, Florian,
>
> There is an old issue with conntrack limit on multi-netns (read container) nodes.
>
> Any connection to containers hosted on the node creates a conntrack in init_netns.
> If the number of conntrack in init_netns reaches the limit, the whole node becomes
> unavailable.


Can you describe network topology ?


Are you using macvlan, ipvlan, or something else ?


> To avoid it OpenVz had special patches disabled conntracks on init_ns on openvz nodes,
> but this automatically limits the functionality of host's firewall.
>
> This has been our specific pain for many years, however, containers are now
> being used much more widely than before, and the severity of the described problem
> is growing more and more.
>
> Do you know perhaps some alternative solution?
>
> Thank you,
> 	Vasily Averin
