Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E9AC4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 13:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1F6860FC3
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 13:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238136AbhHONdc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Aug 2021 09:33:32 -0400
Received: from relais-inet.orange.com ([80.12.66.40]:65230 "EHLO
        relais-inet.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbhHONdc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Aug 2021 09:33:32 -0400
Received: from opfedar07.francetelecom.fr (unknown [xx.xx.xx.9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by opfedar24.francetelecom.fr (ESMTP service) with ESMTPS id 4GndXF1RH7z5vj0;
        Sun, 15 Aug 2021 15:33:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.com;
        s=ORANGE001; t=1629034381;
        bh=YCXOgFGVRd+sHiFUGNpEre5H6l70FGUQ/Bs4swU7hhc=;
        h=From:Subject:To:Message-ID:Date:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=k/XbovvRyTMJ3QSEKbjRjCqf2ShP3bSysvDE6XONhSuhO1G7q9hB5tjkTKEOhks/5
         1E3+BRaeFOrOzvk83JlqYR5ObaI+ZOG9Rz/qA0JMCwaKFkLR2cdbBn5T7ivhTQLzIN
         5p9EZyiigaeIzli4lEJOsFV582jGMlEwmBHspLeNmlB25WRUI8zdk5enSF9h6Rj4Jk
         FDCpfKFDXU6DsSfuQ2QupYsP1ojC7ztn7DHiuBEbb3yeOetQ8Ou9Jk5Q2MWX1OMLUq
         1RoqIUKXJkQlP/66EFgpKG7Xm0lbjxFQD4CMbnyZRHV+57+W+qU4TRO53o7y9Irkz4
         6yaVbLWMw69Iw==
Received: from Exchangemail-eme3.itn.ftgroup (unknown [xx.xx.50.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by opfedar07.francetelecom.fr (ESMTP service) with ESMTPS id 4GndXF0V4fz5vN9;
        Sun, 15 Aug 2021 15:33:01 +0200 (CEST)
Received: from [10.193.4.89] (10.114.50.248) by exchange-eme3.itn.ftgroup
 (10.114.50.14) with Microsoft SMTP Server (TLS) id 14.3.498.0; Sun, 15 Aug
 2021 15:33:00 +0200
From:   <alexandre.ferrieux@orange.com>
Subject: Re: nfnetlink_queue -- why linear lookup ?
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Florian Westphal <fw@strlen.de>, <netfilter-devel@vger.kernel.org>
References: <11790_1628855682_61165D82_11790_25_1_3f865faa-9fd8-40aa-6e49-5d85dd596b5b@orange.com>
 <20210814210103.GG607@breakpoint.cc>
 <14552_1628975094_61182FF6_14552_82_1_d4901cb2-0852-a524-436c-62bf06f95d0e@orange.com>
 <20210814211238.GH607@breakpoint.cc>
 <27263_1629029795_611905A3_27263_246_1_ddbb7a24-d843-9985-5833-c7c8c1aa8d29@orange.com>
 <20210815130716.GA21655@salvia>
Message-ID: <14398_1629034381_6119178D_14398_442_1_fb5563e8-2952-9187-db11-f40187f8f073@orange.com>
Date:   Sun, 15 Aug 2021 15:33:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210815130716.GA21655@salvia>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.114.50.248]
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

(reset, typo: LIFO->FIFO)

On 8/15/21 3:07 PM, Pablo Neira Ayuso wrote:
> On Sun, Aug 15, 2021 at 02:17:08PM +0200, alexandre.ferrieux@orange.com wrote:
> [...]
>> So, the only way forward would be a separate hashtable on ids.
>
> Using the rhashtable implementation is fine for this, it's mostly
> boilerplate code that is needed to use it and there are plenty of
> examples in the kernel tree if you need a reference.

Thanks, that's indeed pretty simple. I was just worried that people would object 
to adding even the slightest overhead (hash_add/hash_del) to the existing code 
path, that satisfies 99% of uses (FIFO). What do you think ?

>> PS: what is the intended dominant use case for batch verdicts ?
>
> Issuing a batch containing several packets helps to amortize the
> cost of the syscall.

Yes, but that could also be achieved by passing an array of ids. The extra 
constraint of using a (contiguous) range means that there is no outlier. This 
seems to imply that ranges are no help when flows are multiplexed. Or maybe, the 
assumption was that bursts tend to be homogeneous ?


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

