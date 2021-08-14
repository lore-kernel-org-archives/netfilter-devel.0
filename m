Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02238C4338F
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Aug 2021 21:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C314C604DC
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Aug 2021 21:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhHNVMV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Aug 2021 17:12:21 -0400
Received: from relais-inet.orange.com ([80.12.66.40]:53104 "EHLO
        relais-inet.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhHNVMV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Aug 2021 17:12:21 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Aug 2021 17:12:20 EDT
Received: from opfedar03.francetelecom.fr (unknown [xx.xx.xx.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by opfedar27.francetelecom.fr (ESMTP service) with ESMTPS id 4GnCc63KtBz2xk5;
        Sat, 14 Aug 2021 23:04:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.com;
        s=ORANGE001; t=1628975094;
        bh=BH7XUMGxdpZaGyp74usxIZ6VxzBgL+sO3RdInHLvqEI=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=tc9fJT3Azh4nVlHfXXhPLJCzcv07/foCeIC1F/pl8XblFtyD9IqnBtw3MkTLe4+Di
         9cIA3v7a9SKmx08s4t2ZzwJIfVTi97qUC/6es+TLOTdRzcdFYDNckMINeQnkPiDqXi
         PItFAyHL84L8tHTp73qKFS+92F8n5TQhEUCGL9IHwww3C1iJlL6RVpOgEx3dcl9wJA
         eInOQOsSAw2XL0Irydv39a08yILPUnxA4JTRGnnQo7nBPI0DVGM3Il4iugQ3Zc4qOA
         AW/s0vLEQJg/2392gRuno6GGg5l/zJULV5Bvw0qbVbXHVZs5xt2YRacwyQc9a8NWlC
         EfKuwKLqJ8NDQ==
Received: from Exchangemail-eme3.itn.ftgroup (unknown [xx.xx.50.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by opfedar03.francetelecom.fr (ESMTP service) with ESMTPS id 4GnCc62TnJzCqkZ;
        Sat, 14 Aug 2021 23:04:54 +0200 (CEST)
Received: from [10.193.4.89] (10.114.50.248) by exchange-eme3.itn.ftgroup
 (10.114.50.14) with Microsoft SMTP Server (TLS) id 14.3.498.0; Sat, 14 Aug
 2021 23:04:53 +0200
Subject: Re: nfnetlink_queue -- why linear lookup ?
To:     Florian Westphal <fw@strlen.de>
CC:     <netfilter-devel@vger.kernel.org>
References: <11790_1628855682_61165D82_11790_25_1_3f865faa-9fd8-40aa-6e49-5d85dd596b5b@orange.com>
 <20210814210103.GG607@breakpoint.cc>
From:   <alexandre.ferrieux@orange.com>
Message-ID: <14552_1628975094_61182FF6_14552_82_1_d4901cb2-0852-a524-436c-62bf06f95d0e@orange.com>
Date:   Sat, 14 Aug 2021 23:05:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210814210103.GG607@breakpoint.cc>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.114.50.248]
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 8/14/21 11:01 PM, Florian Westphal wrote:
> alexandre.ferrieux@orange.com <alexandre.ferrieux@orange.com> wrote:
>>   find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
>>   {
>>     ...
>>     list_for_each_entry(i, &queue->queue_list, list) {
>>       if (i->id == id) {
>>         entry = i;
>>         break;
>>       }
>>     }
>>     ...
>>   }
>> 
>> As a result, in a situation of "highly asynchronous" verdicts, i.e. when we
>> want some packets to linger in the queue for some time before reinjection,
>> the mere existence of a large number of such "old packets" may incur a
>> nonnegligible cost to the system.
>> 
>> So I'm wondering: why is the list implemented as a simple linked list
>> instead of an array directly indexed by the id (like file descriptors) ?
> 
> Because when this was implemented "highly asynchronous" was not on the
> radar.  All users of this (that I know of) do in-order verdicts.

So, O(N) instead of O(1) just because "I currently can't imagine N>5" ?

Would a patch to that effect be rejected ?

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

