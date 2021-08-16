Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEF7C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 10:53:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 838FA61C16
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 10:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbhHPKxh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 06:53:37 -0400
Received: from relais-inet.orange.com ([80.12.70.34]:60878 "EHLO
        relais-inet.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235731AbhHPKxh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 06:53:37 -0400
Received: from opfednr03.francetelecom.fr (unknown [xx.xx.xx.67])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by opfednr23.francetelecom.fr (ESMTP service) with ESMTPS id 4Gp9x75nyRz5vn0;
        Mon, 16 Aug 2021 12:52:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.com;
        s=ORANGE001; t=1629111179;
        bh=R8LV36GT5nKe+cVTi/vCStRwuesQJwJ6cAc4lZO8UpI=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=W75vO8MgD+qgC6fAur75TJOdqU2P3Keo7Ul08cpigyoCSE/p9b+FfnPNTN+nFMjNI
         3GKXCTqUYAbg4MbdICR2bcuA2dES2xduhvgbUH0UoD+spUfbB2aiJYc2v2JJTgT0c1
         Wy6+oXMpwWKCYt7Txcm+ZqYbQTukbPv01qUqmJRZMbN45leqzzfvM3HtTrFaU/rvum
         nEvPKAC1ayWo0sJ4uuk2icCIQCkxE77S9ZoquvWAP3GJt7nKr06jnkpQWI4aixeH4v
         lU+Iw4c5Zdu6PDkKg5qzcNUVx46yDs5c/C8f5ndZUju6elfMqQw8UoPXmv8TVrZfpk
         WscXIoVVY5IoA==
Received: from Exchangemail-eme3.itn.ftgroup (unknown [xx.xx.50.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by opfednr03.francetelecom.fr (ESMTP service) with ESMTPS id 4Gp9x74vCVzDq7t;
        Mon, 16 Aug 2021 12:52:59 +0200 (CEST)
Received: from [10.193.4.89] (10.114.50.248) by exchange-eme3.itn.ftgroup
 (10.114.50.14) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 16 Aug
 2021 12:52:59 +0200
Subject: Re: nfnetlink_queue -- why linear lookup ?
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Florian Westphal <fw@strlen.de>, <netfilter-devel@vger.kernel.org>
References: <11790_1628855682_61165D82_11790_25_1_3f865faa-9fd8-40aa-6e49-5d85dd596b5b@orange.com>
 <20210814210103.GG607@breakpoint.cc>
 <14552_1628975094_61182FF6_14552_82_1_d4901cb2-0852-a524-436c-62bf06f95d0e@orange.com>
 <20210814211238.GH607@breakpoint.cc>
 <27263_1629029795_611905A3_27263_246_1_ddbb7a24-d843-9985-5833-c7c8c1aa8d29@orange.com>
 <20210815130716.GA21655@salvia>
 <4942_1629034317_6119174D_4942_150_1_d69d3f05-89f7-63b5-4759-ef1987aca476@orange.com>
 <20210815141204.GA22946@salvia>
 <5337_1629053191_61196107_5337_107_1_13003d18-0f95-f798-db9d-7182114b90c6@orange.com>
 <20210816090555.GA2364@salvia>
From:   <alexandre.ferrieux@orange.com>
Message-ID: <19560_1629111179_611A438B_19560_274_1_0633ee7a-2660-91b4-f1d7-adc727864376@orange.com>
Date:   Mon, 16 Aug 2021 12:53:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816090555.GA2364@salvia>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.114.50.248]
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 8/16/21 11:05 AM, Pablo Neira Ayuso wrote:
> On Sun, Aug 15, 2021 at 08:47:04PM +0200, alexandre.ferrieux@orange.com wrote:
>> 
>> 
>> [...] to maintain the hashtable, we need to bother the "normal" code path
>> with hash_add/del. Not much, but still, some overhead...
> 
> Probably you can collect some numbers to make sure this is not a
> theoretical issue.

'k, will do :)

>> Yes, a full spectrum of batching methods are possible. If we're to minimize
>> the number of bytes crossing the kernel/user boundary though, an array of
>> ids looks like the way to go (4 bytes per packet, assuming uint32 ids).
> 
> Are you proposing a new batching mechanism?

Well, the problem is backwards compatibility. Indeed I'd propose more flexible 
batching via an array of ids instead of a maxid. But the main added value of 
this flexibility is to enable reused-small-integers ids, like file descriptors. 
As long as the maxid API remains in place, this is impossible.

>> That being said, the Doxygen of the userland nfqueue API mentions being
>> DEPRECATED... So what is the recommended replacement ?
> 
> What API are you refering to specifically?


I'm referring to the nfq API documented here:

 
https://www.netfilter.org/projects/libnetfilter_queue/doxygen/html/group__Queue.html

It starts with "Queue handling [DEPRECATED]"...

_________________________________________________________________________________________________________________________

Ce message et ses pieces jointes peuvent contenir des informations confidentielles ou privilegiees et ne doivent donc
pas etre diffuses, exploites ou copies sans autorisation. Si vous avez recu ce message par erreur, veuillez le signaler
a l'expediteur et le detruire ainsi que les pieces jointes. Les messages electroniques etant susceptibles d'alteration,
Orange decline toute responsabilite si ce message a ete altere, deforme ou falsifie. Merci.

This message and its attachments may contain confidential or privileged information that may be protected by law;
they should not be distributed, used or copied without authorisation.
If you have received this email in error, please notify the sender and delete this message and its attachments.
As emails may be altered, Orange is not liable for messages that have been modified, changed or falsified.
Thank you.

