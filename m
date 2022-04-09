Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1378FC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 13:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbiDINED (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 09:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239112AbiDINEB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 09:04:01 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0292A5490
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 06:01:52 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id k21so19279184lfe.4
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Apr 2022 06:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sPchgaxnfSyXEXR9AVPYGRPwIotpOS2AIb9QbaROQN0=;
        b=iuCCDvI3uvtSHbNStVxgb4gfeWatquG2AjjTi8Nkysbs3rc5n/CwbAq+zymO0z00XT
         GuR3j14fVubKkY6geZH9i6zwXpolq03L/zR44ma+5t+p9iTp2gmrHlD6VW1qoXC3Th/f
         nk5IvPdprcKjacF1prLiXkTnD10oMGYti2yVvogCsLmPnYriukZN/Yt5ocv21dtpD0zI
         ZpNWsocWk8W3WJan93KNWZLRJ+Kazpj+Kh1/xEBGNcapVS28F4XGJ96xddG40oDT0/jv
         vPWT1FRZb/jEw22aaQLq5a17zK/KilYQbwMuyE5e26wHiIP1LKjaON7zwVgvNdJi0D0M
         qq1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sPchgaxnfSyXEXR9AVPYGRPwIotpOS2AIb9QbaROQN0=;
        b=ZD7RXveYShrSVqXXvp1s4GAbz8mXSdMkhglKz85xJvsKMLOQy6h7DPWdizzN7M9cN3
         Fls2170FQsgkkqehwpD5IaxQVFQcJznmDIzDtqq9Rl9hCy4/PpjN/hEs3brTulRPxXE/
         3aCRLqLsXeQOXMdrZTHvR29di5iCN2byC3c7eihvEH3+sRuvNSxDzpchnJqSmOcfX5zr
         jCAKZhYIAyLuQl4TaX7QsRelmNSxezsBUhm9dtY6z9zx4UXpjTzhPIexL0u8dBXGYRXE
         DZ8cAoc3NF0+edYdwI2EQejzUeGTTF9GSmjAlMk8XxWhlW6PIQzxHQah/viq+0XiaLSn
         C4Zw==
X-Gm-Message-State: AOAM531aHaukbTx57AqcsDrEtquBNXXoMBcoy9OgH3TPFcBp150/gw3E
        d7rsTepCBel+NjTK6i1Rdt1eAN5fnrQ=
X-Google-Smtp-Source: ABdhPJxy13o3E7orBcjfOVUClfr1pRRJBr2VcpZj8n4hEwZD7+jQssKcI25D3jXhFAR5mn7g1Y2Nxw==
X-Received: by 2002:a05:6512:3082:b0:44a:6dc3:3 with SMTP id z2-20020a056512308200b0044a6dc30003mr14647458lfd.663.1649509310411;
        Sat, 09 Apr 2022 06:01:50 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id be31-20020a05651c171f00b0024b50f426c3sm438499ljb.17.2022.04.09.06.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Apr 2022 06:01:49 -0700 (PDT)
Message-ID: <430e61df-8126-f18e-0ecd-6c946dd54229@gmail.com>
Date:   Sat, 9 Apr 2022 16:01:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] doc: Document that kernel may accept unimplemented
 expressions
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <20220409094402.22567-1-toiwoton@gmail.com>
 <20220409095152.GA19371@breakpoint.cc>
 <9277ac40-4175-62b3-d777-bdfa9434d187@gmail.com>
 <20220409102216.GF19371@breakpoint.cc>
 <f926a231-6224-f6ca-841f-8a56531b33f8@gmail.com>
 <20220409114240.GG19371@breakpoint.cc>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <20220409114240.GG19371@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 9.4.2022 14.42, Florian Westphal wrote:
> Topi Miettinen <toiwoton@gmail.com> wrote:
>> Would it be possible to add such checks in the future?
> 
> We could add socket skuid, socket skgid, its not hard.

That would be nice. Could the syntax still remain 'meta skuid' even 
though the credentials come from a socket for compatibility?

>> Note that the kernel may accept expressions without errors even if it
>> doesn't implement the feature. For example, input chain filters using
>> expressions such as *meta skuid*, *meta skgid*, *meta cgroup* or
> 
> Those can not be made to work.
> 
>> *socket cgroupv2* are silently accepted but they don't work reliably
> 
> socket should work, at least for tcp and udp.
> The cgroupv2 is buggy.  I sent a patch, feel free to test it.

Once the patch is applied, the warnings in manual page wrt. cgroupv2 
would only apply to old kernels. How about the following:

Note that different kernel versions may accept expressions without 
errors even if they don't implement the feature. For example, input 
chain filters using expressions such as *meta skuid*, *meta skgid*, 
*meta cgroup* or *socket cgroupv2* are silently accepted but they may 
not work reliably or at all.

-Topi
