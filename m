Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217EAC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Apr 2022 08:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiDBIOc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Apr 2022 04:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiDBIOc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Apr 2022 04:14:32 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BBCEE4E0
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Apr 2022 01:12:40 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id g24so6629557lja.7
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Apr 2022 01:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=md4fNxnGs/J84ZVo/lAw+NynCC1XgKbDo2PRYMFpOss=;
        b=ojRyaAPx2YLMv+u9YaiTNXotaKiugVJf0mioRIjvrdb1yXHY6KZZWUnwuNMDAaYJ+n
         d2bXXI1c90BulIwJH9RXd96ua89LTDbiStCn1HlPzIGGf2zIlyhNXIRsWZBGqXVzg4BB
         8RGh/pO1m2R3A76F0o9i/Qyb95AgenNFLuw+AjhNhRSUFti2iamj72NOiYF6+wkaeupH
         u74OfCtiUdcim5S19K1uFYDS0qExnCwtU5T7jxQqPwupuVN3MKWwpuxyH70tAie+mmZ7
         l0f6UI3PKFVB6p7r8rZ+MIvvMWADEY6TrXvb0B1zWMFaPPKQL5sEPhgtBb7Pzwy/X3S0
         h2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=md4fNxnGs/J84ZVo/lAw+NynCC1XgKbDo2PRYMFpOss=;
        b=mspGpWnF5zdQM0tGg+NFLiBAlZz+GfoJLk8oVnKEUtLyb7eX5B8bK6FM4SO0lHPwUw
         PPuBTvFB//mfxnsh2JG4htamP5V3kZhgF9iFmyX6E4o0yPiS82zAmHWR4vA7UWl820qm
         OLg1WOuF0D0niSbww30a5BP3KIUSCsPi2rtRlDRwvCyQoZqkuvwQl3ED9+p+8B9hKzBX
         FTFzQ2WbjXzLtAtwL+N4zBuRmZT0zq/53TC4jbj0M5WfpKN7fdbaj4f3TLyZK5vsbfLa
         DFpfpKePx9wQ8M/E/TiQ+B+yz/+YLW6wK2X+e/v4XXwNtPCx0GZgC6PYOBrojOMrnSt+
         3gZw==
X-Gm-Message-State: AOAM531/QJz0ff85V2JF+Uro/j3PExS2OfQrHGcZJ1iYdQMujYpPcDiq
        4m+vMMYl1N+9xw1V+RU/nVvVERhwPA8=
X-Google-Smtp-Source: ABdhPJwAvvVxVhyLYFCLtrrY+D060xAGwrAO9Eeh32peCZT5y3ecT7V4Yx1oWcDIld0JI0vgQi7kgw==
X-Received: by 2002:a05:651c:2ca:b0:23e:6a81:9591 with SMTP id f10-20020a05651c02ca00b0023e6a819591mr16003810ljo.54.1648887158687;
        Sat, 02 Apr 2022 01:12:38 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id z7-20020a19e207000000b0044abf0797e5sm457992lfg.15.2022.04.02.01.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 01:12:38 -0700 (PDT)
Message-ID: <bcb8f1c4-177a-c9a4-4da4-cc594ca91f91@gmail.com>
Date:   Sat, 2 Apr 2022 11:12:36 +0300
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
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <YkPGJRUAuaLKrA0I@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 30.3.2022 5.53, Pablo Neira Ayuso wrote:
> On Wed, Mar 30, 2022 at 12:25:25AM +0200, Pablo Neira Ayuso wrote:
>> On Tue, Mar 29, 2022 at 09:20:25PM +0300, Topi Miettinen wrote:
> [...]
>> You could define a ruleset that describes the policy following the
>> cgroupsv2 hierarchy. Something like this:
>>
>>   table inet filter {
>>          map dict_cgroup_level_1 {
>>                  type cgroupsv2 : verdict;
>>                  elements = { "system.slice" : jump system_slice }
>>          }
>>
>>          map dict_cgroup_level_2 {
>>                  type cgroupsv2 : verdict;
>>                  elements = { "system.slice/systemd-timesyncd.service" : jump systemd_timesyncd }
>>          }
>>
>>          chain systemd_timesyncd {
>>                  # systemd-timesyncd policy
>>          }
>>
>>          chain system_slice {
>>                  socket cgroupv2 level 2 vmap @dict_cgroup_level_2
>>                  # policy for system.slice process
>>          }
>>
>>          chain input {
>>                  type filter hook input priority filter; policy drop;
> 
> This example should use the output chain instead:
> 
>            chain output {
>                    type filter hook output priority filter; policy drop;
> 
>  From the input chain, the packet relies on early demux to have access
> to the socket.
> 
> The idea would be to filter out outgoing traffic and rely on conntrack
> for (established) input traffic.

Is it really so that 'socket cgroupv2' can't be used on input side at 
all? At least 'ss' can display the cgroup for listening sockets 
correctly, so the cgroup information should be available somewhere:

$ ss -lt --cgroup
State    Recv-Q   Send-Q       Local Address:Port       Peer 
Address:Port   Process 

LISTEN   0        4096                  *%lo:ssh                   *:* 
      cgroup:/system.slice/ssh.socket

-Topi
