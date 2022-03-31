Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B092FC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Mar 2022 15:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiCaPMO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 11:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234757AbiCaPMN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 11:12:13 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85912738
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2022 08:10:23 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id h7so42079160lfl.2
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2022 08:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NbAEEjrOvTUQd+DT/jMZiu7rbo0ewCkB/6rW8HrIrmM=;
        b=jZJSQ278oFU4K5PdgCTqxPTfVeRpFvHTFRqfRZAeeXuS84I4M084y3es6KMD48j2yK
         NjxGzmrI9go/FIPel2XO7nQylGQrhP0/dsDcmwCONiVS+e8ACIMp7S1UgfTi9zE0Nk0X
         UJzcPs1vRYx167F0G+d/8a9/MLrF1HT+LjVKr5cgiAW4N8hcWEHwqJwdXYe9kkDu3pdy
         J+6mxtgzwFqnskSNcnPJe6HufO2U/2fJYuXH6XJKPH3X8QwtWU6g1/rOVUlhBPk4bM1U
         ShEjLDRGLhjb892KPAmfSfTCbSu3qm5RJyqdk/bdQLLza1jMm7I6YroaIevXvFzlCBjl
         UxWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NbAEEjrOvTUQd+DT/jMZiu7rbo0ewCkB/6rW8HrIrmM=;
        b=C7QDKa3CCIW7G1pLWUXZU6HOJPM6RYSU0Dp9nt/OaAr7VKEsWocJnNJQYUNFbeRBzJ
         jqkC09QqW0DU5gcDseilqVFspyBl185yQ1Zz20aAEdDAtkc5moOUBvsYHCUfavLf9Hgy
         htWr8KO8Page6Sh/1pXbKWgWfn7uhGwmDh8KwbHlFgUyj+zq51DYikfoyhdp9ooqJmdQ
         G813B7Pcs/5QPyMIfK/jh6pouZF3DGX9OT2MqEvLf8bu8L6aACG3cGHT/CDwMBHh+1uk
         XYJyIZhWVsOYaVcZ+JjDgPG/DYWnG47G6WbGI97Kjp2dsxP0QW3ZfrrRrrwL5qSxbTO4
         5ryQ==
X-Gm-Message-State: AOAM5302l04A88YTmtkw4FverzUdiyqF7YcowpGM2VmGojwSzcc9a3Aa
        SEOHI0ECVlc314WmnD9x0GrDk4Gqkv0=
X-Google-Smtp-Source: ABdhPJyOB2TobU6UB9Uox1p95dxWmz1zBvnH/5SIxI/lbcVgbCyy1ctXNccoMD1QGtDeLnrx15sU9A==
X-Received: by 2002:a05:6512:281f:b0:44a:5aa0:5b88 with SMTP id cf31-20020a056512281f00b0044a5aa05b88mr11163756lfb.444.1648739421385;
        Thu, 31 Mar 2022 08:10:21 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id m24-20020a194358000000b0044a3851f193sm2696918lfj.83.2022.03.31.08.10.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 08:10:20 -0700 (PDT)
Message-ID: <dbbe9ff4-4ec8-b979-9a35-7f79b3fbb9cb@gmail.com>
Date:   Thu, 31 Mar 2022 18:10:19 +0300
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
 <YkOF0LyDSqKX6ERe@salvia> <35c20ae1-fc79-9488-8a42-a405424d1e53@gmail.com>
 <YkTP40PPDCJSObeH@salvia>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <YkTP40PPDCJSObeH@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 31.3.2022 0.47, Pablo Neira Ayuso wrote:
> On Wed, Mar 30, 2022 at 07:37:00PM +0300, Topi Miettinen wrote:
>> On 30.3.2022 1.25, Pablo Neira Ayuso wrote:
>>> On Tue, Mar 29, 2022 at 09:20:25PM +0300, Topi Miettinen wrote:
>>>> On 28.3.2022 18.05, Pablo Neira Ayuso wrote:
>>>>> On Mon, Mar 28, 2022 at 05:08:32PM +0300, Topi Miettinen wrote:
>>>>>> On 28.3.2022 0.31, Pablo Neira Ayuso wrote:
>>>>>>> On Sat, Mar 26, 2022 at 12:09:26PM +0200, Topi Miettinen wrote:
>>>>> [...]
>>>>>> But I think that with this approach, depending on system load, there could
>>>>>> be a vulnerable time window where the rules aren't loaded yet but the
>>>>>> process which is supposed to be protected by the rules has already started
>>>>>> running. This isn't desirable for firewalls, so I'd like to have a way for
>>>>>> loading the firewall rules as early as possible.
>>>>>
>>>>> You could define a static ruleset which creates the table, basechain
>>>>> and the cgroupv2 verdict map. Then, systemd updates this map with new
>>>>> entries to match on cgroupsv2 and apply the corresponding policy for
>>>>> this process, and delete it when not needed anymore. You have to
>>>>> define one non-basechain for each cgroupv2 policy.
>>>>
>>>> Actually this seems to work:
>>>>
>>>> table inet filter {
>>>>           set cg {
>>>>                   typeof socket cgroupv2 level 0
>>>>           }
>>>>
>>>>           chain y {
>>>>                   socket cgroupv2 level 2 @cg accept
>>>> 		counter drop
>>>>           }
>>>> }
>>>>
>>>> Simulating systemd adding the cgroup of a service to the set:
>>>> # nft add element inet filter cg "system.slice/systemd-resolved.service"
>>>>
>>>> Cgroup ID (inode number of the cgroup) has been successfully added:
>>>> # nft list set inet filter cg
>>>>           set cg {
>>>>                   typeof socket cgroupv2 level 0
>>>>                   elements = { 6032 }
>>>>           }
>>>> # ls -id /sys/fs/cgroup/system.slice/systemd-resolved.service
>>>> 6032 /sys/fs/cgroup/system.slice/systemd-resolved.service/
>>>
>>> You could define a ruleset that describes the policy following the
>>> cgroupsv2 hierarchy. Something like this:
>>>
>>>    table inet filter {
>>>           map dict_cgroup_level_1 {
>>>                   type cgroupsv2 : verdict;
>>>                   elements = { "system.slice" : jump system_slice }
>>>           }
>>>
>>>           map dict_cgroup_level_2 {
>>>                   type cgroupsv2 : verdict;
>>>                   elements = { "system.slice/systemd-timesyncd.service" : jump systemd_timesyncd }
>>>           }
>>>
>>>           chain systemd_timesyncd {
>>>                   # systemd-timesyncd policy
>>>           }
>>>
>>>           chain system_slice {
>>>                   socket cgroupv2 level 2 vmap @dict_cgroup_level_2
>>>                   # policy for system.slice process
>>>           }
>>>
>>>           chain input {
>>>                   type filter hook input priority filter; policy drop;
>>>                   socket cgroupv2 level 1 vmap @dict_cgroup_level_1
>>>           }
>>>    }
>>>
>>> The dictionaries per level allows you to mimic the cgroupsv2 tree
>>> hierarchy
>>>
>>> This allows you to attach a default policy for processes that belong
>>> to the "system_slice" (at level 1). This might also be useful in case
>>> that there is a process in the group "system_slice" which does not yet
>>> have an explicit level 2 policy, so level 1 policy applies in such
>>> case.
>>>
>>> You might want to apply the level 1 policy before the level 2 policy
>>> (ie. aggregate policies per level as you move searching for an exact
>>> cgroup match), or instead you might prefer to search for an exact
>>> match at level 2, otherwise backtrack to closest matching cgroupsv2
>>> for this process.
>>
>> Nice ideas, but the rules can't be loaded before the cgroups are realized at
>> early boot:
>>
>> Mar 30 19:14:45 systemd[1]: Starting nftables...
>> Mar 30 19:14:46 nft[1018]: /etc/nftables.conf:305:5-44: Error: cgroupv2 path
>> fails: Permission denied
>> Mar 30 19:14:46 nft[1018]: "system.slice/systemd-timesyncd.service" : jump
>> systemd_timesyncd
>> Mar 30 19:14:46 nft[1018]: ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> Mar 30 19:14:46 systemd[1]: nftables.service: Main process exited,
>> code=exited, status=1/FAILURE
>> Mar 30 19:14:46 systemd[1]: nftables.service: Failed with result
>> 'exit-code'.
>> Mar 30 19:14:46 systemd[1]: Failed to start nftables.
> 
> I guess this unit file performs nft -f on cgroupsv2 that do not exist
> yet.

Yes, that's the case. Being able to do so with for example 
"cgroupsv2name" would be nice.

> Could you just load the base policy with empty dictionaries instead,
> then track and register the cgroups into the ruleset as they are being
> created/removed?

That's possible and I'll probably make a PR for systemd for such a 
feature. But I don't think that's the best solution: if the NFT rules 
are loaded from initrd and systemd is not running (initrd is not built 
by dracut), rules won't work, even top level "system.slice" and 
"user.slice". Then network connectivity in initrd could be a problem. 
Also I don't know if that model would scale to unprivileged user 
services or containers. Userspace daemon feeding kernel information that 
it already knows seems a bit inelegant.

-Topi

>>> There is also the jump and goto semantics for chains that can be
>>> combined in this chain tree.
>>>
>>> BTW, what nftables version are you using? My listing does not show
>>> i-nodes, instead it shows the path.
>>
>> Debian version: 1.0.2-1. The inode numbers seem to be caused by my SELinux
>> policy. Disabling it shows the paths:
>>
>>          map dict_cgroup_level_2_sys {
>>                  type cgroupsv2 : verdict
>>                  elements = { 5132 : jump systemd_timesyncd }
>>          }
>>
>>          map dict_cgroup_level_1 {
>>                  type cgroupsv2 : verdict
>>                  elements = { "system.slice" : jump system_slice,
>>                               "user.slice" : jump user_slice }
>>          }
>>
>> Above "system.slice/systemd-timesyncd.service" is a number because the
>> cgroup ID became stale when I restarted the service. I think the policy
>> doesn't work then anymore.
> 
> Yes, you have to refresh your policy on cgroupsv2 updates.

