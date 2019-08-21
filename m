Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88936C3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 11:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 495E022CE3
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 11:14:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="k+4MzqvE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfHULOZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 07:14:25 -0400
Received: from mx1.riseup.net ([198.252.153.129]:56094 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfHULOY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 07:14:24 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 2E68C1A30EB;
        Wed, 21 Aug 2019 04:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1566386064; bh=mtCLGpZsg7Ro4ffgf8sgNekmOrxgaNxd/LpE91Jvu6k=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=k+4MzqvE1iXayc5EL+DMXnDXuOP0wgYNTtFPvbG3exHae8wBzhPp/GRhzYQ+9bCiv
         +ZPdesiJAYwNxnE58IKtJTrSYsoR7fMPA/sUe0Dy/0iex7cqtAZTfZgaQKxj3yKFy4
         n/Nn5nYaNXS2bElAcxIAX611hsLQjwHq9yJ95zac=
X-Riseup-User-ID: 8625ECCA42BCC2402AF6C818C66D06028E49AB958A03ED898AA365F00AA0AD20
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 86C94120995;
        Wed, 21 Aug 2019 04:14:23 -0700 (PDT)
Subject: Re: [PATCH 1/2 nf-next] netfilter: nf_tables: Introduce stateful
 object update operation
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <20190821094420.866-1-ffmancera@riseup.net>
 <20190821100905.GX2588@breakpoint.cc>
 <17f338ec-fe44-3ba7-3115-4b5f16d93ccf@riseup.net>
 <20190821111105.GA13057@breakpoint.cc>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <f0a25ba8-abfc-7c56-1705-95ac4702521e@riseup.net>
Date:   Wed, 21 Aug 2019 13:14:38 +0200
MIME-Version: 1.0
In-Reply-To: <20190821111105.GA13057@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 8/21/19 1:11 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
>> How is that argument going to be used? If 'commit' is false we should
>> just check that values are fine but not update them?
> 
> Yes, thats the idea.
> 
>> Yes, I agree on updating the object in the commit phase. But I am not
>> sure about how I should place it on 'trans'. Any hints? Thanks :-)
> 
> Can you place a pointer to the tb array on the trans object?
> 

I prefer this option. So we can place a pointer to the tb array on the
trans object and also the pointer to the existing object. This way it
should be easy to do ->update in the commit phase.

Thanks!

> Another possibility is to have ->update return a kmalloced blob
> that contains ready-to-use binary data, so depending on the 'bool
> commit' the update hook would expect either tb[] (for validation)
> or a backend-maintained struct with the to-update values.
> 
> In the quota case it would be a struct containing the u64 values.
> 
>> I am also writing some userspace shell tests.
> 
> Thats good, thanks Fernando!
> 
