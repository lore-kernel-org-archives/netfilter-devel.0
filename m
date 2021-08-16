Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4134C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 11:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E9A063214
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Aug 2021 11:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhHPLHc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 07:07:32 -0400
Received: from relais-inet.orange.com ([80.12.66.40]:61940 "EHLO
        relais-inet.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbhHPLHc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 07:07:32 -0400
Received: from opfedar05.francetelecom.fr (unknown [xx.xx.xx.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by opfedar24.francetelecom.fr (ESMTP service) with ESMTPS id 4GpBFJ0NPkz5vYT;
        Mon, 16 Aug 2021 13:07:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.com;
        s=ORANGE001; t=1629112020;
        bh=c66soVEJKCvxmWmwP6nMRyBBptWTQ3f5+Np89URQiM8=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=T045m14UkfOjMnpiXfBNIhAV5dqmx15OlOGbmr9VFk52vn/fYTE1IkjKTflagY4Iw
         SctfAo0qJuyrtzBYuX1mz8Gno8x0RjSXqBWrYIOCzElrXPnkq+o/9bEOtRJnEbq96r
         NDpwqvVXUHJG0NLCEephUQlizq+fVWwYE5uDh++1aCY6iYzHAbepoJ4vJ/w4vg90lp
         x+RQwKrITI+xINOI3fWe8BCRhswVJatHhCM1po++HGVURjS4FhGPB0ejYYGSRBxKCW
         +maPsFo3SXwIgjnOUiprBKa28eXicYdPJZQvM5R1mJhQ258hsHIpw+XN7551QiMYqZ
         8NOa95d9Zabww==
Received: from Exchangemail-eme3.itn.ftgroup (unknown [xx.xx.50.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by opfedar05.francetelecom.fr (ESMTP service) with ESMTPS id 4GpBFH6X4Yz2xC9;
        Mon, 16 Aug 2021 13:06:59 +0200 (CEST)
Received: from [10.193.4.89] (10.114.50.248) by exchange-eme3.itn.ftgroup
 (10.114.50.14) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 16 Aug
 2021 13:06:59 +0200
Subject: Re: nfnetlink_queue -- why linear lookup ?
To:     Florian Westphal <fw@strlen.de>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
References: <20210814210103.GG607@breakpoint.cc>
 <14552_1628975094_61182FF6_14552_82_1_d4901cb2-0852-a524-436c-62bf06f95d0e@orange.com>
 <20210814211238.GH607@breakpoint.cc>
 <27263_1629029795_611905A3_27263_246_1_ddbb7a24-d843-9985-5833-c7c8c1aa8d29@orange.com>
 <20210815130716.GA21655@salvia>
 <4942_1629034317_6119174D_4942_150_1_d69d3f05-89f7-63b5-4759-ef1987aca476@orange.com>
 <20210815141204.GA22946@salvia>
 <5337_1629053191_61196107_5337_107_1_13003d18-0f95-f798-db9d-7182114b90c6@orange.com>
 <20210816090555.GA2364@salvia>
 <19560_1629111179_611A438B_19560_274_1_0633ee7a-2660-91b4-f1d7-adc727864376@orange.com>
 <20210816105641.GM607@breakpoint.cc>
From:   <alexandre.ferrieux@orange.com>
Message-ID: <27307_1629112019_611A46D3_27307_308_1_c0808ecf-b00c-efb9-451e-21854450a3da@orange.com>
Date:   Mon, 16 Aug 2021 13:07:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816105641.GM607@breakpoint.cc>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.114.50.248]
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 8/16/21 12:56 PM, Florian Westphal wrote:
> alexandre.ferrieux@orange.com <alexandre.ferrieux@orange.com> wrote:
>> Well, the problem is backwards compatibility. Indeed I'd propose more
>> flexible batching via an array of ids instead of a maxid. But the main added
>> value of this flexibility is to enable reused-small-integers ids, like file
>> descriptors. As long as the maxid API remains in place, this is impossible.
> 
> You cannot remove the maxid API.

Ok, I'll just propose an id-hashtable patch.
I'm thinking of using "modulo queue_maxlen" instead of a traditional hash 
function (and queue_maxlen as table size) , as this would yield perfect hashing 
for the FIFO case.


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

