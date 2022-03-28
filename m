Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA254C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Mar 2022 17:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242737AbiC1RsY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Mar 2022 13:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244706AbiC1RsW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Mar 2022 13:48:22 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0436516A
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2022 10:46:37 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id d5so26076780lfj.9
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2022 10:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PigYiEHSxkCvShyaKQqFmOdo4hxRA006ff6yQpGrBOQ=;
        b=erJVVU0RdSzRKoI8cGPnGS3PgVnIsjdTN/MtXDYGruCfjvzmHEyDOIGWJJZ92UvkxX
         N5+h53usgmZ6x3NOYxgGRRfBJUp2rqoM/nYstN1RzJ/0WqdlRCRen6t/gTJqd2nYlgHT
         AbltUAeOsuZmbSyBjTqcEfi046n+G5W28D8YfHzrj95QYqx9W9QydFTuRD8viw5iKP5B
         YfDYq+X2TsS708hHDxmVYyXKJhlmRchs5nWj6TqDbMDHIO56FDRJxgvpBVERQld0KEcL
         hO1qTKy8R8ujynsmCiNPdRCCO2nk94N/YzTbG8Jbfn0DDxwIW0FIZgiqLYmAZU910KFp
         Y0Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PigYiEHSxkCvShyaKQqFmOdo4hxRA006ff6yQpGrBOQ=;
        b=sh5cgGyvUDASe8jMurwzhDeXxHN5fHRkOXjAGHI6U6SHpZj1gy3b8xhhTwovboDSLj
         RBj32fM0uDLv6PaDqBmWCgJIQfo8PQAbl+jUQaxeB9VfPTMLQmVXcgygh8Zvam7OpfB+
         8YnlhgFUxmMcCnZ8g4JaV39tAs77G2x0dISh87TrdOzI9UhYoDW3Kjp0lQFzQml83LIn
         9YL7fC+k2AsMIpcVEH003GbW4bFvcDXhcNzuSb0NFfPMAr9ZOWRarqzkK30lZNbLJV4C
         24o2VqYBAwnkId/OJuuBMSK0/hyXLDxBIex0XqaBVldMAEAU+WIXjIWtUUpJKG4ELN6G
         2YNQ==
X-Gm-Message-State: AOAM533QupoOJNsaliuAXe4o6KFuNuhvE8H51oasD6SYLIztBkxBJjvG
        hyHgIBApLGoGWu7WP/111EpAf3pR7lw=
X-Google-Smtp-Source: ABdhPJxCiY6hdG5xJbAdyxmSW942sOMtpbO2h+3DOE98z/wwSIBnMdZ3rFmDA2MvvMTq+pBjO2w6ig==
X-Received: by 2002:ac2:5d70:0:b0:448:5d7b:dcb1 with SMTP id h16-20020ac25d70000000b004485d7bdcb1mr21177889lft.352.1648489593713;
        Mon, 28 Mar 2022 10:46:33 -0700 (PDT)
Received: from [192.168.1.40] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id m13-20020ac2424d000000b0044859fdd0b7sm1692869lfl.301.2022.03.28.10.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Mar 2022 10:46:33 -0700 (PDT)
Message-ID: <3f1e45fc-01dc-a790-a98e-f0161fe6424f@gmail.com>
Date:   Mon, 28 Mar 2022 20:46:31 +0300
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

So something like this:
table inet x {
	map dict {
		type string : verdict;
	}

	chain y {
		socket cgroupv2 level 4 vmap @dict
	}
}
and then systemd would add an entry like { 
"app-local\x2dfirefox\x2desr-01d5fcc2f9114e509e992cdaef3d84c3.scope" : 
accept } to the vmap "dict" when realizing the cgroup?

-Topi

> To address the vulnerable time window, the static ruleset defines a
> default policy to allow nothing until an explicit policy based on
> cgroupv2 for this process is in place.
> 
> The cgroupv2 support for nftables was designed to be used with maps.
