Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E171C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 18:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA5C561267
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 18:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhHOSrH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Aug 2021 14:47:07 -0400
Received: from relais-inet.orange.com ([80.12.66.39]:50858 "EHLO
        relais-inet.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhHOSrH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Aug 2021 14:47:07 -0400
Received: from opfedar01.francetelecom.fr (unknown [xx.xx.xx.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by opfedar23.francetelecom.fr (ESMTP service) with ESMTPS id 4GnmTz249lzBs9g;
        Sun, 15 Aug 2021 20:46:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.com;
        s=ORANGE001; t=1629053191;
        bh=pFGcREHHsji0IUa6Ig68vtC4d2WtSXHXjUAkN4Fv5Hk=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=jbDbmQDFzIxyOq50sFSkbFZdsHsV4Tww2JNPWpy8YcFeiyXRDk/kqaiVPvhusQ9wk
         /Fva3vyjrsKxYhgO99AIWP6Oeb7gDGHJEfFTuxCoDAdd4Hqm/eVBcoZaTrsZ/cZmBW
         KpYeP2wIZFh/2zmHz9AmyibvFuAbXsO+Itz33s61pkBhz3HJQGuPyuqIJuMxqbJ5pZ
         CKa1DFhE9hrt1a7uwK4KXrGYhleUvTmBHxMOKmWq2vGbpjJdP2e8zP0I+AaIBKJy97
         kJmztkMdJzrasrzvqEUn2NaX8gJC9ZoMloKFvHjzdNzkd5xUyqe6HcXfL78bhInb9R
         BkjvQON7rMsiA==
Received: from Exchangemail-eme3.itn.ftgroup (unknown [xx.xx.50.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by opfedar01.francetelecom.fr (ESMTP service) with ESMTPS id 4GnmTz14dgzBrLQ;
        Sun, 15 Aug 2021 20:46:31 +0200 (CEST)
Received: from [10.193.4.89] (10.114.50.248) by exchange-eme3.itn.ftgroup
 (10.114.50.14) with Microsoft SMTP Server (TLS) id 14.3.498.0; Sun, 15 Aug
 2021 20:46:30 +0200
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
From:   <alexandre.ferrieux@orange.com>
Message-ID: <5337_1629053191_61196107_5337_107_1_13003d18-0f95-f798-db9d-7182114b90c6@orange.com>
Date:   Sun, 15 Aug 2021 20:47:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210815141204.GA22946@salvia>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.114.50.248]
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 8/15/21 4:12 PM, Pablo Neira Ayuso wrote:
> On Sun, Aug 15, 2021 at 03:32:30PM +0200, alexandre.ferrieux@orange.com wrote:
 >>
>> [...] I was just worried that people would >> object to adding even the slightest overhead (hash_add/hash_del) to the
>> existing code path, that satisfies 99% of uses (LIFO). What do you think ?
> 
> It should be possible to maintain both the list and the hashtable,
> AFAICS, the batch callback still needs the queue_list.

Yes, but to maintain the hashtable, we need to bother the "normal" code path 
with hash_add/del. Not much, but still, some overhead...

>> > > PS: what is the intended dominant use case for batch verdicts ?
>> > 
>> > Issuing a batch containing several packets helps to amortize the
>> > cost of the syscall.
>> 
>> Yes, but that could also be achieved by passing an array of ids.
> 
> You mean, one single sendmsg() with several netlink messages, that
> would also work to achieve a similar batching effect.


Yes, a full spectrum of batching methods are possible. If we're to minimize the 
number of bytes crossing the kernel/user boundary though, an array of ids looks 
like the way to go (4 bytes per packet, assuming uint32 ids).

>> The extra constraint of using a (contiguous) range means that there
>> is no outlier.  This seems to imply that ranges are no help when
>> flows are multiplexed. Or maybe, the assumption was that bursts tend
>> to be homogeneous ?
> 
> What is your usecase?


For O(1) lookup:

My primary motivation is for transparent proxies and userland qdiscs. In both 
cases, specific packets must be held for some time and reinjected at a later 
time which is not computed by a simple, fixed delay, but rather triggered by 
some external event.

My secondary motivation is that the netfilter queue is a beautifully 
asynchronous mechanism, and absolutely nothing in its definition limits it to 
the dumb FIFO-of-instantaneous-drop-decisions that seems to dominate sample code.

For the deprecation of id-range-based batching:

It seems that as soon as two different packet streams are muxed in the queue, 
one deserving verdict A and the other verdict B, contiguous id ranges of a given 
verdict may be very small. But I realize I'm 20 years late to complain :)

That being said, the Doxygen of the userland nfqueue API mentions being 
DEPRECATED... So what is the recommended replacement ?

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

