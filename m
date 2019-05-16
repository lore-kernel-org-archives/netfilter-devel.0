Return-Path: <SRS0=IJRP=TQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8536DC04AAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 May 2019 11:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5893A20818
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 May 2019 11:58:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="kXM2PeD9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfEPL6I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 May 2019 07:58:08 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39174 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727117AbfEPL6H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 May 2019 07:58:07 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id BF4791A31CF;
        Thu, 16 May 2019 04:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558007886; bh=q9e3kxhyK6Pt6S4r1gH0bI8ZTN9lHn2HREAHOeKwQn4=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=kXM2PeD9n9kjA0Xux5qUpztE1SjDTNHn3u14qhFDlPBNXAI5gHhGEdKPYMTA6ADrj
         vSd7QPEW8aa8tooATouZLvvZxUY7L3Gzos5FrxW6nE4/npHP4LPFIsvRI/qI8DRrfO
         uvB0zTvNpdf5qk9HJGqTGeNOsLuAj9f9kohGrh5k=
X-Riseup-User-ID: 5A018BA58784FE5F039DE3CBEFB8C1D8BFDD9DFCBF004A633D0E44E8A4359128
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id C52F212047E;
        Thu, 16 May 2019 04:58:05 -0700 (PDT)
Subject: Re: [PATCH 2/2 nft] jump: Allow goto and jump to a variable using nft
 input files
To:     Phil Sutter <phil@nwl.cc>
References: <20190514211340.913-1-ffmancera@riseup.net>
 <20190514211340.913-2-ffmancera@riseup.net>
 <20190515105850.GA4851@orbyte.nwl.cc>
 <347917dc-086b-998c-dd2f-b5e4a87b38b1@riseup.net>
 <20190515111232.lu3ifr72mlhfriqc@salvia>
 <20190515114617.GB4851@orbyte.nwl.cc>
 <20190515152132.267ryecqod3xenyj@salvia>
 <20190515192600.GC4851@orbyte.nwl.cc>
 <902d698b-a25c-0567-1338-b2d8c0bd91cb@riseup.net>
 <20190515203149.GD4851@orbyte.nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <91e43f5d-c082-48d0-1fa0-fe2d18923dfa@riseup.net>
Date:   Thu, 16 May 2019 13:58:17 +0200
MIME-Version: 1.0
In-Reply-To: <20190515203149.GD4851@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi!

On 5/15/19 10:31 PM, Phil Sutter wrote:
> Hi,
> 
> On Wed, May 15, 2019 at 09:56:11PM +0200, Fernando Fernandez Mancera wrote:
>> Hi Phil,
>>
>> On 5/15/19 9:26 PM, Phil Sutter wrote:
>>> Hi Pablo,
>>>
>>> On Wed, May 15, 2019 at 05:21:32PM +0200, Pablo Neira Ayuso wrote:
>>>> On Wed, May 15, 2019 at 01:46:17PM +0200, Phil Sutter wrote>> [...]
>>>> '@<something>' is currently allowed, as any arbitrary string can be
>>>> placed in between strings - although in some way this is taking us
>>>> back to the quote debate that needs to be addressed. If we want to
>>>> disallow something enclosed in quotes then we'll have to apply this
>>>> function everywhere we allow variables.
>>>
>>> Oh, sorry. I put those ticks in there just to quote the value, not as
>>> part of the value. The intention was to point out that something like:
>>>
>>> | define foo = @set1
>>> | add rule ip t c jump $foo
>>>
>>> Might pass evaluation stage and since there is a special case for things
>>> starting with '@' in symbol_expr, the added rule would turn into
>>>
>>> | add rule ip t c jump set1
>>>
>>> We could detect this situation by checking expr->symtype.
>>>
>>
>> I agree about that. We could check if the symbol type is SYMBOL_VALUE.
>> But I am not sure about where should we do it, maybe in the parser?
>>
>>> On the other hand, can we maybe check if given string points to an
>>> *existing* chain in verdict_type_parse()? Or will that happen later
>>> anyway?
>>>
>>
>> It happens later, right now if the given string does not point to an
>> existing chain it returns the usual error for this situation. e.g
> 
> I just played around a bit and could provoke some segfaults:
> 
> * define foo = @set1 (a set named 'set1' must exist)
> * define foo = { 1024 }
> * define foo = *
> 
> I didn't check how we could avoid those. Maybe this is even follow-up
> work, but we should definitely try to address those eventually.
> 

I have been working on fixing this. I propose the following fix.

diff --git a/src/evaluate.c b/src/evaluate.c
index 8394037..edab370 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1950,6 +1950,12 @@ static int stmt_evaluate_verdict(struct eval_ctx
*ctx, struct stmt *stmt)
                if (stmt->expr->chain != NULL) {
                        if (expr_evaluate(ctx, &stmt->expr->chain) < 0)
                                return -1;
+                       if (stmt->expr->chain->etype != EXPR_SYMBOL ||
+                           stmt->expr->chain->symtype != SYMBOL_VALUE) {
+                               BUG("invalid verdict chain expression %s\n",
+                                   expr_name(stmt->expr->chain));
+                               return -1;
+                       }
                }
                break;
        case EXPR_MAP:

That works for all the cases that you mentioned above. What do you think?

Thanks :-)

> Cheers, Phil
> 
