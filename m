Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6CD7C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 12:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A621B610FD
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 12:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237720AbhHOMRL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Aug 2021 08:17:11 -0400
Received: from relais-inet.orange.com ([80.12.66.39]:58590 "EHLO
        relais-inet.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236645AbhHOMRL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Aug 2021 08:17:11 -0400
Received: from opfedar06.francetelecom.fr (unknown [xx.xx.xx.8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by opfedar23.francetelecom.fr (ESMTP service) with ESMTPS id 4Gnbr33KZ7zBsTW;
        Sun, 15 Aug 2021 14:16:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.com;
        s=ORANGE001; t=1629029795;
        bh=xOh4MAnlctM89sGh5eYvxvfSQS8wIk2/CvDa03HFdy8=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=wWZYYRWWIiRm+ElGVIgTP+6tsRMTZpWmye0JP34LamlxDhbfU7Lf0XAd+UPhGGYeD
         +cHKh68emzMmprL1ImCQStsg3BGgMz0VSo7ciu61p4zrd8vVGrF5q/t3v026pwp1ME
         d2/CUZ4RBdz07L5KD8dDF7b8RNlpKBJyoSv6HV8lM4ZaYdEFp4F9m/zf6z+PYTf8oE
         L2OYl7bCoAxzcwlpJsR7CcbPYDkuK9vUO9ohM+Q6NKJpoHYpHJQ/06AV77LDbLEBa+
         iMamuoS1VXeYlGqKPULrgADBhLyEpK2n/8+77JtVvAMNkBUqn04f0wAp7/jqg/nliV
         ZTs+Cg4Hu9wuQ==
Received: from Exchangemail-eme3.itn.ftgroup (unknown [xx.xx.50.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by opfedar06.francetelecom.fr (ESMTP service) with ESMTPS id 4Gnbr32RKlz3wbH;
        Sun, 15 Aug 2021 14:16:35 +0200 (CEST)
Received: from [10.193.4.89] (10.114.50.248) by exchange-eme3.itn.ftgroup
 (10.114.50.14) with Microsoft SMTP Server (TLS) id 14.3.498.0; Sun, 15 Aug
 2021 14:16:34 +0200
Subject: Re: nfnetlink_queue -- why linear lookup ?
To:     Florian Westphal <fw@strlen.de>
CC:     <netfilter-devel@vger.kernel.org>
References: <11790_1628855682_61165D82_11790_25_1_3f865faa-9fd8-40aa-6e49-5d85dd596b5b@orange.com>
 <20210814210103.GG607@breakpoint.cc>
 <14552_1628975094_61182FF6_14552_82_1_d4901cb2-0852-a524-436c-62bf06f95d0e@orange.com>
 <20210814211238.GH607@breakpoint.cc>
From:   <alexandre.ferrieux@orange.com>
Message-ID: <27263_1629029795_611905A3_27263_246_1_ddbb7a24-d843-9985-5833-c7c8c1aa8d29@orange.com>
Date:   Sun, 15 Aug 2021 14:17:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210814211238.GH607@breakpoint.cc>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.114.50.248]
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 8/14/21 11:12 PM, Florian Westphal wrote:
> alexandre.ferrieux@orange.com <alexandre.ferrieux@orange.com> wrote:
>> > Because when this was implemented "highly asynchronous" was not on the
>> > radar.  All users of this (that I know of) do in-order verdicts.
>> 
>> So, O(N) instead of O(1) just because "I currently can't imagine N>5" ?
> 
> Seems so. THis code was written 21 years ago.
> 
>> Would a patch to that effect be rejected ?
> 
> Probably not, depends on the implementation.

Sad: while the (necessarily) async nature of the kernel/user interface naturally 
suggests this change, one specific part of the existing API complicates things: 
batch verdicts !

Indeed, the very notion of an "id range" for batch verdicts, forbids the simple 
approach of reused small integers as array indices.

So, the only way forward would be a separate hashtable on ids. Much less elegant 
+ risk of slight overhead for housekeeping. I stand disappointed :)

PS: what is the intended dominant use case for batch verdicts ?

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

