Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33DFC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Mar 2022 16:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348864AbiC3Qi6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 12:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348863AbiC3Qi5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 12:38:57 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F042B197AD4
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Mar 2022 09:37:09 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id bn33so28449468ljb.6
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Mar 2022 09:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZN5VvBLWA1S0HAVmwPFdQaFG7kxae44ckSjkvLaXFeY=;
        b=q0TmeI3hB/Jnouir1CDYTmviz8MUWO/YfqmzDycNYTozdSb1ckDTLXwAjIqkDNxGSL
         M6VehtItl3s30mgt0nmAdcSent9v4kX2+IhqJC9hnVXwkdswHNVA7mLPVakT/rZHSb4K
         hZ2ONkBHjH9y5IR6IA3Xf3V6cpRFsGloVA0mjo427/IvcFvzzVW6tTGAEJpoth0DiZtp
         +XkGEdOAIw+YaTDBjYE7CPw4Z04/8jdhZOYOxtnSQAlspvHz2KoPpSc4TO+8A2oYJc6P
         T0NFhokAZZbTqxLa81hQT7Qwc+AdCJ31dlTXdkGWlcrt3yK1Ls7LM7o1uiPTovlUZOFi
         ag2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZN5VvBLWA1S0HAVmwPFdQaFG7kxae44ckSjkvLaXFeY=;
        b=Tu9pn9K/d4Ky33OLhsSGfJgtIdBlSRA31bdai9WksUhfkG6kRRDX03FUx4AEB3OyVd
         kfxmMJo+0/qQh9ZIM3zi9A03NSQd33Mmn7hum7dGf6Y8xyaNo4Dy253ilvkqibFgsOyF
         wlwlLdYOCYbSa9H/yq4/qwi8Qc35M+iwQh0rxVaWEfGmwDM+T2JivPLq24peDZrwYgDm
         BUCFRIbAuTl+LCqde/JV4aWASnqo0L4FagK0QD0cdTtcu8dGLBf6faZda2UE6FGC3kQV
         dqWuUTQd8MWx7ZEEHlL460SAeJ3pxRSrys0qkeEIxKCBVMTrqqR2GDRXfbnZH6gDdDyj
         bN6g==
X-Gm-Message-State: AOAM5320T+mVQDYHKfsh/ZAv8IPUzkXFeXfQR7nOSlDaDZt9T1af3CMa
        CZ8N08qL9LT1+g6KPaCtVc4u6LEbo5Q=
X-Google-Smtp-Source: ABdhPJwFaHlYGiW04yywi6pVURk+stauuvO9lkI+lnQXOD34RAKw9LufVouafApp/OaWncfLBAMoaw==
X-Received: by 2002:a2e:818f:0:b0:24a:7c17:7226 with SMTP id e15-20020a2e818f000000b0024a7c177226mr7332512ljg.472.1648658222971;
        Wed, 30 Mar 2022 09:37:02 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id q6-20020a194306000000b0044a6bfae215sm2081132lfa.158.2022.03.30.09.37.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 09:37:02 -0700 (PDT)
Message-ID: <35c20ae1-fc79-9488-8a42-a405424d1e53@gmail.com>
Date:   Wed, 30 Mar 2022 19:37:00 +0300
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
 <YkOF0LyDSqKX6ERe@salvia>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <YkOF0LyDSqKX6ERe@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 30.3.2022 1.25, Pablo Neira Ayuso wrote:
> On Tue, Mar 29, 2022 at 09:20:25PM +0300, Topi Miettinen wrote:
>> On 28.3.2022 18.05, Pablo Neira Ayuso wrote:
>>> On Mon, Mar 28, 2022 at 05:08:32PM +0300, Topi Miettinen wrote:
>>>> On 28.3.2022 0.31, Pablo Neira Ayuso wrote:
>>>>> On Sat, Mar 26, 2022 at 12:09:26PM +0200, Topi Miettinen wrote:
>>> [...]
>>>> But I think that with this approach, depending on system load, there could
>>>> be a vulnerable time window where the rules aren't loaded yet but the
>>>> process which is supposed to be protected by the rules has already started
>>>> running. This isn't desirable for firewalls, so I'd like to have a way for
>>>> loading the firewall rules as early as possible.
>>>
>>> You could define a static ruleset which creates the table, basechain
>>> and the cgroupv2 verdict map. Then, systemd updates this map with new
>>> entries to match on cgroupsv2 and apply the corresponding policy for
>>> this process, and delete it when not needed anymore. You have to
>>> define one non-basechain for each cgroupv2 policy.
>>
>> Actually this seems to work:
>>
>> table inet filter {
>>          set cg {
>>                  typeof socket cgroupv2 level 0
>>          }
>>
>>          chain y {
>>                  socket cgroupv2 level 2 @cg accept
>> 		counter drop
>>          }
>> }
>>
>> Simulating systemd adding the cgroup of a service to the set:
>> # nft add element inet filter cg "system.slice/systemd-resolved.service"
>>
>> Cgroup ID (inode number of the cgroup) has been successfully added:
>> # nft list set inet filter cg
>>          set cg {
>>                  typeof socket cgroupv2 level 0
>>                  elements = { 6032 }
>>          }
>> # ls -id /sys/fs/cgroup/system.slice/systemd-resolved.service
>> 6032 /sys/fs/cgroup/system.slice/systemd-resolved.service/
> 
> You could define a ruleset that describes the policy following the
> cgroupsv2 hierarchy. Something like this:
> 
>   table inet filter {
>          map dict_cgroup_level_1 {
>                  type cgroupsv2 : verdict;
>                  elements = { "system.slice" : jump system_slice }
>          }
> 
>          map dict_cgroup_level_2 {
>                  type cgroupsv2 : verdict;
>                  elements = { "system.slice/systemd-timesyncd.service" : jump systemd_timesyncd }
>          }
> 
>          chain systemd_timesyncd {
>                  # systemd-timesyncd policy
>          }
> 
>          chain system_slice {
>                  socket cgroupv2 level 2 vmap @dict_cgroup_level_2
>                  # policy for system.slice process
>          }
> 
>          chain input {
>                  type filter hook input priority filter; policy drop;
>                  socket cgroupv2 level 1 vmap @dict_cgroup_level_1
>          }
>   }
> 
> The dictionaries per level allows you to mimic the cgroupsv2 tree
> hierarchy
> 
> This allows you to attach a default policy for processes that belong
> to the "system_slice" (at level 1). This might also be useful in case
> that there is a process in the group "system_slice" which does not yet
> have an explicit level 2 policy, so level 1 policy applies in such
> case.
> 
> You might want to apply the level 1 policy before the level 2 policy
> (ie. aggregate policies per level as you move searching for an exact
> cgroup match), or instead you might prefer to search for an exact
> match at level 2, otherwise backtrack to closest matching cgroupsv2
> for this process.

Nice ideas, but the rules can't be loaded before the cgroups are 
realized at early boot:

Mar 30 19:14:45 systemd[1]: Starting nftables...
Mar 30 19:14:46 nft[1018]: /etc/nftables.conf:305:5-44: Error: cgroupv2 
path fails: Permission denied
Mar 30 19:14:46 nft[1018]: 
"system.slice/systemd-timesyncd.service" : jump systemd_timesyncd
Mar 30 19:14:46 nft[1018]: 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Mar 30 19:14:46 systemd[1]: nftables.service: Main process exited, 
code=exited, status=1/FAILURE
Mar 30 19:14:46 systemd[1]: nftables.service: Failed with result 
'exit-code'.
Mar 30 19:14:46 systemd[1]: Failed to start nftables.

> There is also the jump and goto semantics for chains that can be
> combined in this chain tree.
> 
> BTW, what nftables version are you using? My listing does not show
> i-nodes, instead it shows the path.

Debian version: 1.0.2-1. The inode numbers seem to be caused by my 
SELinux policy. Disabling it shows the paths:

         map dict_cgroup_level_2_sys {
                 type cgroupsv2 : verdict
                 elements = { 5132 : jump systemd_timesyncd }
         }

         map dict_cgroup_level_1 {
                 type cgroupsv2 : verdict
                 elements = { "system.slice" : jump system_slice,
                              "user.slice" : jump user_slice }
         }

Above "system.slice/systemd-timesyncd.service" is a number because the 
cgroup ID became stale when I restarted the service. I think the policy 
doesn't work then anymore.

-Topi
