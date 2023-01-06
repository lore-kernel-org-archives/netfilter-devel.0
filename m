Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE6CC3DA7A
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Jan 2023 19:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjAFTed (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 14:34:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235688AbjAFTec (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 14:34:32 -0500
X-Greylist: delayed 711 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 Jan 2023 11:34:30 PST
Received: from smtp-1909.mail.infomaniak.ch (smtp-1909.mail.infomaniak.ch [185.125.25.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B34673E00
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Jan 2023 11:34:30 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NpYSN6SSpzMqSLD;
        Fri,  6 Jan 2023 20:34:28 +0100 (CET)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4NpYSN1rhczMppLZ;
        Fri,  6 Jan 2023 20:34:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1673033668;
        bh=JzxSVtHxsNf7DCh3RJGY5yozWQzU5+fJT9j9a+NBEA0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OPh/vQMVD0ju/pm9Vf/ndqe7dNWVZULAo760kZ1iiqSzGI/IbBdNKyNDoeDNAZK1k
         nLNDtsEUn2k/xuMEnZszNdqkmUvR3JAMR3gxmJZpUC4ySO3Zj0mG1dDFGfmSfBwHw5
         zVftRP9OEkeeBrD12OnjD9jWyqiSnBVS0YPpXuVA=
Message-ID: <5c941be9-ac6a-d259-997e-13fdff09aeb4@digikod.net>
Date:   Fri, 6 Jan 2023 20:34:27 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v8 11/12] samples/landlock: Add network demo
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, artem.kuzin@huawei.com
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-12-konstantin.meskhidze@huawei.com>
 <2ff97355-18ef-e539-b4c1-720cd83daf1d@digikod.net>
 <94a8ef89-b59e-d218-77a1-bf2f9d4096c7@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <94a8ef89-b59e-d218-77a1-bf2f9d4096c7@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 05/01/2023 04:46, Konstantin Meskhidze (A) wrote:
> 
> 
> 11/16/2022 5:25 PM, Mickaël Salaün пишет:

[...]

>>
>>>    		fprintf(stderr,
>>>    			"Hint: You should update the running kernel "
>>>    			"to leverage Landlock features "
>>> @@ -259,16 +342,36 @@ int main(const int argc, char *const argv[], char *const *const envp)
>>>    	access_fs_ro &= ruleset_attr.handled_access_fs;
>>>    	access_fs_rw &= ruleset_attr.handled_access_fs;
>>>
>>> +	/* Removes bind access attribute if not supported by a user. */
>>> +	env_port_name = getenv(ENV_TCP_BIND_NAME);
>>> +	if (!env_port_name) {
>>
>> You can move this logic at the populate_ruleset_net() call site and
>> update this helper to not call getenv() twice for the same variable.
> 
>     But here I exclude ruleset attributes, not rule itself. It will break
>     the logic: creating a ruleset then applying rules.
>     I suggest to leave here as its.

Right, but you can still avoid the duplicate getenv() calls.


>>
>>
>>> +		access_net_tcp &= ~LANDLOCK_ACCESS_NET_BIND_TCP;
>>> +	}
>>> +	/* Removes connect access attribute if not supported by a user. */
>>> +	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
>>> +	if (!env_port_name) {
>>> +		access_net_tcp &= ~LANDLOCK_ACCESS_NET_CONNECT_TCP;
>>> +	}
>>> +	ruleset_attr.handled_access_net &= access_net_tcp;
