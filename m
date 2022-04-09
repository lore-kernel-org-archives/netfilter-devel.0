Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E1F2C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 10:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbiDIKp0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 06:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240023AbiDIKpY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 06:45:24 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7697420F6B
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 03:43:17 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id u19so4767211ljd.11
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Apr 2022 03:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RJsWm4rxmFgtC+tLf9ZOiAQ3g7I3aWgHwKtAHPsGzSo=;
        b=PC6h58Z/bO5+KBJMhNvwdkITGHn800jVimfOZkXgnjYoH8943cDO2xjE6i7lj4bsFt
         KQmCwn57KtCXas31x1ihyeh5Ga74AOMmjtSmT815ZB/JC2bncPMYQgf1TWC5lrVqCGh+
         XAWOQeTp4RSrAvjiyff3JEbgXxvBYQ567NMsRdAEagBdsb8KzPTczzkw9qjqDn0r2+3G
         Q5Ey3Nlm+nhWlMfpnHQL9CHPRmlViWvWnsgQLYNkKKeOOU44uq2ahng4BTnnYd+GIUz8
         /1eg8/pzM4TbljeubQ3RHZfk10WghoJn5sCl92y9mOyswOL3Th1t6aJszJTXdTzIalx1
         cC5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RJsWm4rxmFgtC+tLf9ZOiAQ3g7I3aWgHwKtAHPsGzSo=;
        b=ve9KxncB9o+lyGdRnrrFbYTxgTzCwqr/awSNIpPOpotzQUHNZqHfnLGFfcRE6mC9wg
         W4YmgBWXRCgy7eeqdtZpyijkfBGR7NtRzGTJDmPBfRtAXlP0DpFFJ1yqyX77jCR+PkwV
         h5ccOT7y5OBa+b19rcf8Rrd5iuytP9HtZxrkvJctQ4NOGLYOreKpnnLh5ufRo2m+kF8q
         6qycmOuJMUlF1ATW088mYpK8SnVYJWMr18HVI3GWlwOFjnibgA2h6znHIuXdK5Sdf7Sh
         M+xykO0DCFN69DQJqoqK8uepIOGmC1vMp180ghS6SYkY9kNSMdiNoLToli0/5E081dpm
         iUnQ==
X-Gm-Message-State: AOAM530kH9AEDqmhlCR9q1IzNzQ42x4J8lIwcwkcVEsxiybTgc6LUg6D
        LOqivysqq7Sk3Bs1KNcJ4mSK8lZkaE8=
X-Google-Smtp-Source: ABdhPJxuWvh/30C8hb3rvXueSaZN1Pi0fuD5quy2VlNkBwv/5AZlo4qvpJtfGO+wQ2ZEe9E2IRMiEg==
X-Received: by 2002:a05:651c:1027:b0:24b:4475:ad9f with SMTP id w7-20020a05651c102700b0024b4475ad9fmr7518851ljm.176.1649500995571;
        Sat, 09 Apr 2022 03:43:15 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id i7-20020ac25d27000000b00450abeb4267sm1665560lfb.140.2022.04.09.03.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Apr 2022 03:43:15 -0700 (PDT)
Message-ID: <f926a231-6224-f6ca-841f-8a56531b33f8@gmail.com>
Date:   Sat, 9 Apr 2022 13:43:13 +0300
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
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <20220409102216.GF19371@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 9.4.2022 13.22, Florian Westphal wrote:
> Topi Miettinen <toiwoton@gmail.com> wrote:
>> Note that the kernel may accept expressions without errors even if it
>> doesn't implement the feature. For example, input chain filters using
>> *meta skuid*, *meta skgid*, *meta cgroup* or *socket cgroupv2*
>> expressions are silently accepted but they don't work yet, except when used
>> with *tproxy* rules, early demultiplexing or BPF programs.
> 
> This is what iptables-extensions(8) says:
> 
> IMPORTANT:  when  being  used in the INPUT chain, the cgroup matcher is currently only of limited functionality, meaning it will only match on packets that are processed for local sockets through early socket demuxing. Therefore, general usage on the INPUT chain is not advised unless the implications
> are well understood.
> 
> For nftables, this is true for all meta types that use skb->sk internally,
> such as skuid, skgid, cgroup, ...
> 
>> Could you please explain this 'early demux' concept? Is this something that
>> can be triggered with NFT rules, kernel configuration etc? I can't find any
>> documentation.
> 
> sysctl.
> net.ipv4.ip_early_demux = 1
> net.ipv4.tcp_early_demux = 1
> net.ipv4.udp_early_demux = 1
> 
> This is a performance optimization, tcp edemux only works for
> sockets in established state, udp demux has restrictions as well.
> 
> So, no guarantee that this will set the socket reliably, hence the
> paragraph in the iptables-extensions manpage.


Thanks. From this blog post I suppose the problem is that NFT rules 
aren't checked after final demux:
https://www.privateinternetaccess.com/blog/linux-networking-stack-from-the-ground-up-part-4-2/

Would it be possible to add such checks in the future?

What about:

Note that the kernel may accept expressions without errors even if it
doesn't implement the feature. For example, input chain filters using
expressions such as *meta skuid*, *meta skgid*, *meta cgroup* or
*socket cgroupv2* are silently accepted but they don't work reliably
yet, except when used with *tproxy* rules, early demultiplexing
(available only for TCP for sockets in established state and UDP demux
has restrictions as well) or BPF programs.

-Topi
