Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB38C77B62
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Apr 2023 11:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbjDDLCo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Apr 2023 07:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234882AbjDDLC0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Apr 2023 07:02:26 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C9872BB
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Apr 2023 03:59:39 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id z10so19345687pgr.8
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Apr 2023 03:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680605927;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tzj/CoDxDMWPQMZ9HTsMU4TmAOxjsvxRO1XHSURsb88=;
        b=UYUIAA9FGKOFCG1TIvvo54tEeYOESwCxXOCYH29ViF+3oDFxJtXvm/5e3f5QKO546J
         k+U0Hnwj4knAndyTpHC5NKUa2OI9VacY+KpZXGa2a8bishyDBzj9bZCmzTN62kXb06x9
         iuzHlpJoR8SSnzZ1+nOLXS8tlrsIiz1bYVLTVf90sKMf1crUGNNcc0F8fH1wOtV6Aen0
         S1YnVAIYQCfqAZR+CeWBDjwNTgD1kWvSko2kdScAR/FeHjcc4ncLBplIl66CjF21norP
         qMx9CrjQw4x48IY0A0JOG3sTJ19IW7sPnoTt6gOgFmHiJl3IzB0v61ap9WaZQkzUJxi1
         hnrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680605927;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Tzj/CoDxDMWPQMZ9HTsMU4TmAOxjsvxRO1XHSURsb88=;
        b=z123cKKcRMyk+A3PoODhxk8GvRTQXKLTdi+Couc3JYcZe9mxrIE2KDJYPNDYimOCGe
         3Qa3g3H9NLeMYUsQtHYNP9wNzUXDnHTAnvixRwjYzzpf+t9b0sYNYf4gwY0p4GBSJu8n
         4GQ4kTDzW0/4U6shxSXm3L1fSx35RoPoK+CCg449NOyR0hrEbwFQ+TjfU3ZBBw6vOhLL
         EJPZqCHEYbcmUWWnHqJbvzd3wxM18wChJmzPU5d6P1ajjd5ViSxQBM5kJD8ssMmurfrD
         JZfDxeVl5YDTLUvXs9Y/cuTK/+NpZspSpJk1OMRDlaH/XdO+7FiaA1r+ueQN1fEUPEn6
         82vQ==
X-Gm-Message-State: AAQBX9ffRZrXIRRQAkqTgw6bzNLNe7G3zAaq5NGtjv0bJPO4/ONYxGQz
        7LqW4Bms5P1Epk6Dspw6iMsq2GTO7kbhC66g1H0=
X-Google-Smtp-Source: AKy350bgEyOM7GsQkMtkzOg+qfR+picZjKAIeosWJ50cjmFYQJ+OS2JIHsJCvrz2UjosY1/CUVxI0A==
X-Received: by 2002:a05:6a00:1c94:b0:62d:d85b:fcfc with SMTP id y20-20020a056a001c9400b0062dd85bfcfcmr16039927pfw.8.1680605927033;
        Tue, 04 Apr 2023 03:58:47 -0700 (PDT)
Received: from [10.255.152.78] ([139.177.225.226])
        by smtp.gmail.com with ESMTPSA id a19-20020a62e213000000b0062e0515f020sm5110495pfi.162.2023.04.04.03.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 03:58:46 -0700 (PDT)
Message-ID: <1434c101-fa0d-adf8-edc3-1e820e78aa9e@bytedance.com>
Date:   Tue, 4 Apr 2023 18:58:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [External] Re: [PATCH] udp:nat:vxlan tx after nat should recsum
 if vxlan tx offload on
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     dsahern@kernel.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>, ecree@amd.com
References: <20230401023029.967357-1-chenwei.0515@bytedance.com>
 <CAF=yD-Lg_XSnE9frH9UFpJCZLx-gg2KHzVu7KmnigidujCvepQ@mail.gmail.com>
 <fae01ad9-4270-2153-9ba4-cf116c8ed975@gmail.com>
 <25fe50f2-9f1d-ec48-52af-780eb9ba6e09@bytedance.com>
 <aa903bc8-a1d1-3fce-99fa-b0896f149ec1@gmail.com>
From:   Fei Cheng <chenwei.0515@bytedance.com>
In-Reply-To: <aa903bc8-a1d1-3fce-99fa-b0896f149ec1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

test case
1. create vxlan tunnel with tx csum offload on.
2. iptables nat the packet out from vxlan
3. vxlan remote will see the packet udp csum error.

I used to use skb->csum_valid to distinguish the two cases.
If donot add extra skb flags, maybe csum_start can seperate too.




在 2023/4/4 下午6:26, Edward Cree 写道:
> On 04/04/2023 02:48, Fei Cheng wrote:
>> Thank you for remind plain text.
>> Use csum_start to seperate these two cases, maybe a good idea.
>> 1.Disable tx csum
>> skb->ip_summed ==  CHECKSUM_PARTIAL && skb_transport_header == udp
>> 2.Enable tx csum
>> skb->ip_summed ==  CHECKSUM_PARTIAL && skb_transport_header != udp
>>
>> Correct?
> 
> What do you mean by "skb_transport_header == udp"?  That it is a UDP
>   header?  Or that it is at the offset of the UDP header?  The inner
>   L4 packet could be UDP as well.
> And why are you even looking at skb_transport_header when it's
>   csum_start that determines what the hardware will do?
> AFAICT nothing in nf_nat_proto.c looks at skb_transport_header anyway;
>   indeed in nf_nat_icmp_reply_translation() we can call into this code
>   with hdroff ending up pointing way deeper in the packet.
> 
> In any case, after digging deeper into the netfilter code, it looks to
>   me like there's no issue in the first place: netfilter doesn't
>   'recompute' the UDP checksum, it just accumulates delta into it to
>   account for the changes it made to the packet, on the assumption that
>   the existing checksum is correct.
> Which AIUI will do the right thing whether the checksum is
> * a correct checksum for an unencapsulated packet
> * a pseudohdr sum for a CHECKSUM_PARTIAL (unencapsulated) packet
> * a correct (LCO) checksum for an encapsulated packet, whose inner L4
>    checksum may or may not be CHECKSUM_PARTIAL offloaded.
> 
> Do you have a test case that breaks with the current code?
> 
> -ed
