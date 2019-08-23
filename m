Return-Path: <SRS0=Ar4o=WT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8920CC3A5A2
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Aug 2019 18:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DB9F20850
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Aug 2019 18:28:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="IeeLlEVS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404692AbfHWS2f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Aug 2019 14:28:35 -0400
Received: from mx1.riseup.net ([198.252.153.129]:35278 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404001AbfHWS2e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Aug 2019 14:28:34 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 3E7B91A11F6;
        Fri, 23 Aug 2019 11:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1566584914; bh=+io8Je+ioDx5RzhFYe0n6BbbrTZ912K0WKaGX5W1CI8=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=IeeLlEVS0JRg2595l4cdvGrGShXEkH75GpAEd2zioS1s2YrdrYVkIKsc1XJCfVFKn
         KV0R+AaqrYbnFUkM2WOOVFvyKtXS5OWNsHhZRDJWNazKTGhDMSNr8FNf6ePtuCUxpl
         eZuhfjhyY2WNUMiVkJlIgDVu/BN1vO//C196BG1Y=
X-Riseup-User-ID: 1117AA649758779E34BCA3EFACFEBB2AD00B613FC18684C49A185F8444A187BA
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 2EEDF1203F2;
        Fri, 23 Aug 2019 11:28:33 -0700 (PDT)
Subject: Re: [PATCH 1/2 nf-next v2] netfilter: nf_tables: Introduce stateful
 object update operation
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190822164827.1064-1-ffmancera@riseup.net>
 <20190823124142.dsmyr3mkwt3ppz3y@salvia>
 <20190823124250.75apok22fnbdhujd@salvia>
 <fc6fe6d4-1efa-6845-f0ee-4e1f1da61da5@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <20d36122-4d8d-e73f-a5d9-af1642d3a887@riseup.net>
Date:   Fri, 23 Aug 2019 20:28:46 +0200
MIME-Version: 1.0
In-Reply-To: <fc6fe6d4-1efa-6845-f0ee-4e1f1da61da5@riseup.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 8/23/19 8:05 PM, Fernando Fernandez Mancera wrote:
> 
> 
> On 8/23/19 2:42 PM, Pablo Neira Ayuso wrote:
>> On Fri, Aug 23, 2019 at 02:41:42PM +0200, Pablo Neira Ayuso wrote:
>>> On Thu, Aug 22, 2019 at 06:48:26PM +0200, Fernando Fernandez Mancera wrote:
>>>> @@ -1405,10 +1409,16 @@ struct nft_trans_elem {
>>>>  
>>>>  struct nft_trans_obj {
>>>>  	struct nft_object		*obj;
>>>> +	struct nlattr			**tb;
>>>
>>> Instead of annotatint tb[] on the object, you can probably add here:
>>>
>>> union {
>>>         struct quota {
>>>                 uint64_t                consumed;
>>>                 uint64_t                quota;
>>>       } quota;
>>> };
>>>
>>> So the initial update annotates the values in the transaction.
>>>

If we follow that pattern then the indirection would need the
nft_trans_phase enum, the quota struct and also the tb[] as parameters
because in the preparation phase we always need the tb[] array.

Why is that better than annotating tb[] on the object? Sorry, I think
that I am missing something here. Thanks!

>>> I guess you will need two new indirections? Something like
>>> prepare_update() and update().
>>
>> Or you have a single update() and pass enum nft_trans_phase as
>> parameter, so this only needs one single indirection.
>>
> 
> But also we would need to continue passing the 'bool commit' as a
> parameter too right? I will take a look to nft_trans_phase. Thanks! :-)
