Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5817C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Apr 2022 16:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbiDFQju (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Apr 2022 12:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237865AbiDFQjo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Apr 2022 12:39:44 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A93324683
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2022 06:58:03 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id h7so4283159lfl.2
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Apr 2022 06:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SKqLobU5fdjugkB1SH8i0KmWNtgGvyifMU+pElZkY0I=;
        b=RueCV3JRUZw3vNpUHTR+77hMD89uZW92IXoOVJHjH0gvEuvwzKmgZl1JY+B0kgYPg7
         43rSHlq+P9My8CmyaZ/Lvj/j5oCJL9AZzKF/gEhcnyr2AGsINv/xQjUtbkq5uycsZShJ
         5Rc5zcQGsYYlZGEes6skZI8bwQ3mN/wr6AdgqyUzBpYDHeAb4QF0gaAEj/f9i32iY8Zy
         KNvqB/p0D6aYQjAjoHvSzHDLblflYMUpLuJiFo7qFrSPio5JezFp4FicNLZiaujPSyPE
         BVi608SEL+3KO6bqxNgCMucGkQB6/eOjSRqFEZFimeRA+9Q5yeE/e5vb34fHvwXcMGQr
         L5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SKqLobU5fdjugkB1SH8i0KmWNtgGvyifMU+pElZkY0I=;
        b=XQETFGinnFHidewRcPqOJ5XF8qHSsoyGok+Jxuky9nARfbrl425LzU7k98E/A29H4X
         BrEv521L0ivt3WjcK7Fzl+fMqNdfjSrqbDgstoHyFS3YCY1EekQrSsl6TLS9WTB3QFQv
         3rdgiwENvSU15ayuWHwaX9fpLC8vto1xk2PA+LPlxzROL3XfZ7wvjlDMgSuiifofsMei
         WiM+MMWUWYuFJe1AdTu2GfXcHGSrOEYCOdEG5fuLm97tc+BLPCboS3nLDOELd8JsuRiQ
         3dK0LoCyuz11zblNon2L+CjgjQzTkv76yapw43JIQClxgw61Xo51R/T5T/7B/f53/SZ6
         XzPg==
X-Gm-Message-State: AOAM533RPrF6r8uZ4ImBIhrlUBxTGd/ylOHD+eupkVmuOp3Kz6Ooh6Qf
        gpP8mvI1lrZieGCQrdxiEiXqcd7pZn4=
X-Google-Smtp-Source: ABdhPJxCbmwODueJaLh+wcq2BEu866m9hBBpJnn9oEyopu9vSx2eF5xKL2TlXpxZw5fR8Pu8LnxeZQ==
X-Received: by 2002:a05:6512:108b:b0:44a:6dc2:ffeb with SMTP id j11-20020a056512108b00b0044a6dc2ffebmr6211188lfg.184.1649253480064;
        Wed, 06 Apr 2022 06:58:00 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id p27-20020a056512313b00b0044a315f262csm1843786lfd.102.2022.04.06.06.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 06:57:59 -0700 (PDT)
Message-ID: <0f7eaf21-9241-8a42-d2ec-c2b34ff06142@gmail.com>
Date:   Wed, 6 Apr 2022 16:57:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Support for loading firewall rules with cgroup(v2) expressions
 early
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <fabde324-383a-622c-7e69-32c9b2d06191@gmail.com>
 <YkDXwaPwYf8NgKT+@salvia> <418f6461-4504-4707-5ec2-61227af2ad27@gmail.com>
 <YkHOuprHwwuXjWrm@salvia> <5b850d67-92c1-9ece-99d2-390e8a5731b3@gmail.com>
 <YkOF0LyDSqKX6ERe@salvia> <YkPGJRUAuaLKrA0I@salvia>
 <bcb8f1c4-177a-c9a4-4da4-cc594ca91f91@gmail.com>
 <6786df44-49de-3d35-2c16-030e6290d19d@gmail.com> <Yky787OF8/FdnIPr@salvia>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <Yky787OF8/FdnIPr@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 6.4.2022 1.00, Pablo Neira Ayuso wrote:
> On Sun, Apr 03, 2022 at 09:32:11PM +0300, Topi Miettinen wrote:
>> On 2.4.2022 11.12, Topi Miettinen wrote:
>>> On 30.3.2022 5.53, Pablo Neira Ayuso wrote:
>>>> On Wed, Mar 30, 2022 at 12:25:25AM +0200, Pablo Neira Ayuso wrote:
>>>>> On Tue, Mar 29, 2022 at 09:20:25PM +0300, Topi Miettinen wrote:
>>>> [...]
>>>>> You could define a ruleset that describes the policy following the
>>>>> cgroupsv2 hierarchy. Something like this:
>>>>>
>>>>>    table inet filter {
>>>>>           map dict_cgroup_level_1 {
>>>>>                   type cgroupsv2 : verdict;
>>>>>                   elements = { "system.slice" : jump system_slice }
>>>>>           }
>>>>>
>>>>>           map dict_cgroup_level_2 {
>>>>>                   type cgroupsv2 : verdict;
>>>>>                   elements = {
>>>>> "system.slice/systemd-timesyncd.service" : jump
>>>>> systemd_timesyncd }
>>>>>           }
>>>>>
>>>>>           chain systemd_timesyncd {
>>>>>                   # systemd-timesyncd policy
>>>>>           }
>>>>>
>>>>>           chain system_slice {
>>>>>                   socket cgroupv2 level 2 vmap @dict_cgroup_level_2
>>>>>                   # policy for system.slice process
>>>>>           }
>>>>>
>>>>>           chain input {
>>>>>                   type filter hook input priority filter; policy drop;
>>>>
>>>> This example should use the output chain instead:
>>>>
>>>>             chain output {
>>>>                     type filter hook output priority filter; policy drop;
>>>>
>>>>   From the input chain, the packet relies on early demux to have access
>>>> to the socket.
>>>>
>>>> The idea would be to filter out outgoing traffic and rely on conntrack
>>>> for (established) input traffic.
>>>
>>> Is it really so that 'socket cgroupv2' can't be used on input side at
>>> all? At least 'ss' can display the cgroup for listening sockets
>>> correctly, so the cgroup information should be available somewhere:
>>>
>>> $ ss -lt --cgroup
>>> State    Recv-Q   Send-Q       Local Address:Port       Peer
>>> Address:Port   Process
>>> LISTEN   0        4096                  *%lo:ssh                   *:*
>>>       cgroup:/system.slice/ssh.socket
>>
>> Also 'meta skuid' doesn't seem to work in input filters. It would have been
>> simple to use 'meta skuid < 1000' to simulate 'system.slice' vs.
>> 'user.slice' cgroups.
>>
>> If this is intentional, the manual page should make this much clearer.
> 
> It is not yet described in nft(8) unfortunately, but
> iptables-extensions(8) says:
> 
>   IMPORTANT: when being used in the INPUT chain, the cgroup matcher is currently only
>         of limited functionality, meaning it will only match on packets that are processed
>         for local sockets through early socket demuxing. Therefore, general usage on the INPUT
>         chain is not advised unless the implications are well understood.

Something like this would be nice to add to nft(8). The concept of 
'early socket demuxing' isn't very obvious (at least to me). Could the 
user of nft be able to control somehow, like force early demuxing with a 
sysctl?

-Topi

> 
>> There's no warning and the kernel doesn't reject the useless input rules.
>>
>> I think it should be possible to do filtering on input side based on the
>> socket properties (UID, GID, cgroup). Especially with UDP, it should be
>> possible to drop all packets if the listening process is not OK.
> 
> Everything is possible, it's not yet implemented though.
> 
>> My use case is that I need to open ports for Steam games (TCP and UDP ports
>> 27015-27030) but I don't want to make them available for system services or
>> any other apps besides Steam games. SELinux SECMARKs and TE rules for
>> sockets help me here but there are other problems.

