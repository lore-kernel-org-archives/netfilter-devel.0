Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28878C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Apr 2022 16:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbiDFQnR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Apr 2022 12:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238566AbiDFQm7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Apr 2022 12:42:59 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71A12D3112
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2022 07:02:42 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id c15so3333745ljr.9
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Apr 2022 07:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zPRNJlwIRkZQxaOZIHl/TKLOdowLXCXaal/as6LhPMc=;
        b=XqS9Gqc6pxEoKBqsU4cD1ZOJBWZAaxkzD2x8mIy9XfxtyO710o2Cd6brWHWMOB/ey3
         +/1Zu4J0LiqeLWvtwVIHio3DEZDVguWFTmJHubO6am560kf51bo3qYCSEULvMt4OwOBE
         1n/1gJNhPiRi3YURomqJd7AYotktKBNK4HGFY1252mFCGw1/xM/TRKqJN4IKUU+dMPD+
         cdkiGTu4//IiPV1V6wrBscpaBra3FbspScb0h3zPIN7UT9mmhrWPvBE7cGSfJkWwK+l7
         UrFl0y3P3D/FNXHn5cv8qwwPCZrn8VHIq5AMRGHYZ2K3dMFWd3ICnircQj9sX3SUAgZL
         Ir6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zPRNJlwIRkZQxaOZIHl/TKLOdowLXCXaal/as6LhPMc=;
        b=YerWUPPAnVEZsOC4Ii81wxvSp+guAgX/AUho3rIeNqIHa7yGsPs/MjZF096nwvzrzU
         FuXgRmtoZR+ascdQcWfmFCu26eMwAhlokhhQcyTiVKx0D4ooRUWWbXKnLQ2bguLNf7Dt
         JDhHJprTHsxI13E3y/Fu5P9oSAC/GFY9B8Sfcei/6cyl9ysc77nVUHysBswHZpvK881Y
         DbeZinZsvLYqjSUJMHo993ii1AdTeusoG+2kzwPVnnDC0aJlIVRYBvm0FMTuTBlTd+zJ
         ejHufZDSCTz1pYeB/YwVM53Bdo7pSvuy/AYoBYrnWh19F8igO/yJr+h9Q0qM4y853jr0
         hxHg==
X-Gm-Message-State: AOAM531BCVYQi55iNFF+G1G6KevTA0xHF1/cAlyWjNFGVdYAyInwdv5a
        hAFiKNDxgYH62T1NgEMFWnkC9h6lzCE=
X-Google-Smtp-Source: ABdhPJx6fEQ6RGquqJAJtHMsMmFVObXtbCw7JKVmyjzE+YiLcM+Bi3XpEtzcukqNrIgx3OmuYNozcA==
X-Received: by 2002:a2e:2ac2:0:b0:24a:fcf1:7f3a with SMTP id q185-20020a2e2ac2000000b0024afcf17f3amr5290206ljq.2.1649253760660;
        Wed, 06 Apr 2022 07:02:40 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id z14-20020a2e7e0e000000b0024ac33571fbsm1583550ljc.62.2022.04.06.07.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 07:02:40 -0700 (PDT)
Message-ID: <598a0640-724a-8277-c314-d54923d7a42b@gmail.com>
Date:   Wed, 6 Apr 2022 17:02:38 +0300
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
 <YkTP40PPDCJSObeH@salvia> <dbbe9ff4-4ec8-b979-9a35-7f79b3fbb9cb@gmail.com>
 <YkzAIUEmsxebKj8l@salvia>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <YkzAIUEmsxebKj8l@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 6.4.2022 1.18, Pablo Neira Ayuso wrote:
> On Thu, Mar 31, 2022 at 06:10:19PM +0300, Topi Miettinen wrote:
>> On 31.3.2022 0.47, Pablo Neira Ayuso wrote:
>>> On Wed, Mar 30, 2022 at 07:37:00PM +0300, Topi Miettinen wrote:
> [...]
>>>> Nice ideas, but the rules can't be loaded before the cgroups are realized at
>>>> early boot:
>>>>
>>>> Mar 30 19:14:45 systemd[1]: Starting nftables...
>>>> Mar 30 19:14:46 nft[1018]: /etc/nftables.conf:305:5-44: Error: cgroupv2 path
>>>> fails: Permission denied
>>>> Mar 30 19:14:46 nft[1018]: "system.slice/systemd-timesyncd.service" : jump
>>>> systemd_timesyncd
>>>> Mar 30 19:14:46 nft[1018]: ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>> Mar 30 19:14:46 systemd[1]: nftables.service: Main process exited,
>>>> code=exited, status=1/FAILURE
>>>> Mar 30 19:14:46 systemd[1]: nftables.service: Failed with result
>>>> 'exit-code'.
>>>> Mar 30 19:14:46 systemd[1]: Failed to start nftables.
>>>
>>> I guess this unit file performs nft -f on cgroupsv2 that do not exist
>>> yet.
>>
>> Yes, that's the case. Being able to do so with for example "cgroupsv2name"
>> would be nice.
> 
> Cgroupsv2 names might be arbitrarily large, correct? ie. PATH_MAX.

I think so, could this be a problem?

-Topi
