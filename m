Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71EAC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Mar 2022 18:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbiC2SWP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237003AbiC2SWO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Mar 2022 14:22:14 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFA31E3765
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2022 11:20:30 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id m3so31716574lfj.11
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2022 11:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6TbXK5hWVuoqVjLb8HAO3sW7WxoONVqIR+0V9XhkspU=;
        b=gkdoHsehtxE+qJaXIqcwcMgZYTFQVtfDLeyuY9o5wYk7jP51FcZKNznIFlK2aTLL3/
         5u0fyjDXgCAZIfqr6C8TuJTwRSvftLGtC5HXmM0ZxCjfZfVAxK/upfDvuaH4cEA63ErY
         7/YzOVX07hlmdd5o7E1u3cpfyaL3+hsTQVKKdghE3xLXj/fLNY9tA7j7JAv38/4LLbuA
         l74DwGIht5ZR5xnUYV1y90K2mJBty6Jw6qeEuKSraACwfwHCW8wq7asGEyDCkGHtDD4i
         LdnRg9GvtJRw7S5uJ2sP2QEOud64WAw+22JheDLKskvV19KbW7lq9QlIcC/g51ZU8kfj
         u1Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6TbXK5hWVuoqVjLb8HAO3sW7WxoONVqIR+0V9XhkspU=;
        b=8GLtuAk8pfP/3itTiTNg9x3YUrcR4t+6WjchGwWSFKqFk5NJROZSVsy1OtSL0GuSc8
         lhKFYA8D0WhSv+i7ivgwLW3RhsakPjbbioANicJoTQJX34Y+zD31fA61ql1e8ktOhXl0
         Us0aHRq3vu9Z4mPO+JuFmg8xmEGSmyw7rXVw3Hfexle37mTK/kJpXgrUJucyPE309snD
         /sw4wzmuiX3t1YynZ8TevhMf9L2P4zrdSPjOsxNQQufx0ELF/zEQtgJqtTl48VnSLaLP
         P2SgtbpqpcKDfdKgbFsQO/4UZahU6U1DzfvUKaftHhpMlg7B/RVhdiNsSbzmUzIxFb03
         aUpw==
X-Gm-Message-State: AOAM532ETpP/VMqpU11fM+cWv/RZ5whb4cJCticVGs7qxzRYFXRlMSXt
        J/KB+BKMc0/xER2HBCfNyGZPh2FCvCA=
X-Google-Smtp-Source: ABdhPJyjQ2FdBUeinAq3OeknYvFoft7IfeQW3xm6AKRFwCaQmGZLjO4LaeT8hgzoy5/GRo5sghrBDQ==
X-Received: by 2002:a05:6512:4014:b0:44a:2b77:bed6 with SMTP id br20-20020a056512401400b0044a2b77bed6mr3763533lfb.381.1648578028148;
        Tue, 29 Mar 2022 11:20:28 -0700 (PDT)
Received: from [192.168.1.40] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id l26-20020a2e701a000000b002463f024de9sm2137676ljc.110.2022.03.29.11.20.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 11:20:27 -0700 (PDT)
Message-ID: <5b850d67-92c1-9ece-99d2-390e8a5731b3@gmail.com>
Date:   Tue, 29 Mar 2022 21:20:25 +0300
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
 <YkHOuprHwwuXjWrm@salvia>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <YkHOuprHwwuXjWrm@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 28.3.2022 18.05, Pablo Neira Ayuso wrote:
> On Mon, Mar 28, 2022 at 05:08:32PM +0300, Topi Miettinen wrote:
>> On 28.3.2022 0.31, Pablo Neira Ayuso wrote:
>>> On Sat, Mar 26, 2022 at 12:09:26PM +0200, Topi Miettinen wrote:
> [...]
>>>> Another possibility would be to hook into cgroup directory creation logic in
>>>> kernel so that when the cgroup is created, part of the path checks are
>>>> performed or something else which would allow non-existent cgroups to be
>>>> used. Then the NFT syntax would not need changing, but the expressions would
>>>> "just work" even when loaded early.
>>>
>>> Could you use inotify/dnotify/eventfd to track these updates from
>>> userspace and update the nftables sets accordingly? AFAIK, this is
>>> available to cgroupsv2.
>>
>> It's possible, there's for example:
>> https://github.com/mk-fg/systemd-cgroup-nftables-policy-manager
> 
> This one seems to be adding one rule per cgroupv2, it would be better
> to use a map for this purpose for scalability reasons.
> 
>> https://github.com/helsinki-systems/nft_cgroupv2/
> 
> This approach above takes us back to the linear ruleset evaluation
> problem, this is basically looking like iptables, this does not scale up.
> 
>> But I think that with this approach, depending on system load, there could
>> be a vulnerable time window where the rules aren't loaded yet but the
>> process which is supposed to be protected by the rules has already started
>> running. This isn't desirable for firewalls, so I'd like to have a way for
>> loading the firewall rules as early as possible.
> 
> You could define a static ruleset which creates the table, basechain
> and the cgroupv2 verdict map. Then, systemd updates this map with new
> entries to match on cgroupsv2 and apply the corresponding policy for
> this process, and delete it when not needed anymore. You have to
> define one non-basechain for each cgroupv2 policy.

Actually this seems to work:

table inet filter {
         set cg {
                 typeof socket cgroupv2 level 0
         }

         chain y {
                 socket cgroupv2 level 2 @cg accept
		counter drop
         }
}

Simulating systemd adding the cgroup of a service to the set:
# nft add element inet filter cg "system.slice/systemd-resolved.service"

Cgroup ID (inode number of the cgroup) has been successfully added:
# nft list set inet filter cg
         set cg {
                 typeof socket cgroupv2 level 0
                 elements = { 6032 }
         }
# ls -id /sys/fs/cgroup/system.slice/systemd-resolved.service
6032 /sys/fs/cgroup/system.slice/systemd-resolved.service/

-Topi

> To address the vulnerable time window, the static ruleset defines a
> default policy to allow nothing until an explicit policy based on
> cgroupv2 for this process is in place.
> 
> The cgroupv2 support for nftables was designed to be used with maps.

