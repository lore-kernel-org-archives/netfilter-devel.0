Return-Path: <SRS0=IJRP=TQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA95C04AAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 May 2019 14:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5913420675
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 May 2019 14:42:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="iJ5rJbdN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfEPOmS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 May 2019 10:42:18 -0400
Received: from mx1.riseup.net ([198.252.153.129]:53784 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbfEPOmR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 May 2019 10:42:17 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 19FDA1A482F;
        Thu, 16 May 2019 07:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558017737; bh=+0noP5AkLqosCbOc6p+HzVeoUCZGzgDC4wsZdwFSiS4=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=iJ5rJbdNPi3CqIIDiJ32APjka9lFAGa1E0ITDNczBRv8clOW88YiNA9OyfnGMcq1T
         lXAJZbCnB+uCMH8F1m9Njb5KP0OofzfqvPDUeJGc+MEb/xHxWceRMY0o1HYGS+SsmG
         h9zwqsoRAHzRLaRgT07Mxo4GDlvN9KkQHNOplI30=
X-Riseup-User-ID: 15445029DC09105CFFBB98C9EDF4C1C536AD2FD7B9B1EB63C2B37B053C325570
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 0576C220128;
        Thu, 16 May 2019 07:42:15 -0700 (PDT)
Date:   Thu, 16 May 2019 16:42:08 +0200
In-Reply-To: <20190516143942.tfjxdyi6vj66u3wn@salvia>
References: <20190514211340.913-2-ffmancera@riseup.net> <20190515105850.GA4851@orbyte.nwl.cc> <347917dc-086b-998c-dd2f-b5e4a87b38b1@riseup.net> <20190515111232.lu3ifr72mlhfriqc@salvia> <20190515114617.GB4851@orbyte.nwl.cc> <20190515152132.267ryecqod3xenyj@salvia> <20190515192600.GC4851@orbyte.nwl.cc> <902d698b-a25c-0567-1338-b2d8c0bd91cb@riseup.net> <20190515203149.GD4851@orbyte.nwl.cc> <91e43f5d-c082-48d0-1fa0-fe2d18923dfa@riseup.net> <20190516143942.tfjxdyi6vj66u3wn@salvia>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/2 nft] jump: Allow goto and jump to a variable using nft input files
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Message-ID: <5EFCF7BC-F139-4A15-9675-0A4FAF9A758D@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

El 16 de mayo de 2019 16:39:42 CEST, Pablo Neira Ayuso <pablo@netfilter=2Eo=
rg> escribi=C3=B3:
>On Thu, May 16, 2019 at 01:58:17PM +0200, Fernando Fernandez Mancera
>wrote:
>> Hi!
>>=20
>> On 5/15/19 10:31 PM, Phil Sutter wrote:
>> > Hi,
>> >=20
>> > On Wed, May 15, 2019 at 09:56:11PM +0200, Fernando Fernandez
>Mancera wrote:
>> >> Hi Phil,
>> >>
>> >> On 5/15/19 9:26 PM, Phil Sutter wrote:
>> >>> Hi Pablo,
>> >>>
>> >>> On Wed, May 15, 2019 at 05:21:32PM +0200, Pablo Neira Ayuso
>wrote:
>> >>>> On Wed, May 15, 2019 at 01:46:17PM +0200, Phil Sutter wrote>>
>[=2E=2E=2E]
>> >>>> '@<something>' is currently allowed, as any arbitrary string can
>be
>> >>>> placed in between strings - although in some way this is taking
>us
>> >>>> back to the quote debate that needs to be addressed=2E If we want
>to
>> >>>> disallow something enclosed in quotes then we'll have to apply
>this
>> >>>> function everywhere we allow variables=2E
>> >>>
>> >>> Oh, sorry=2E I put those ticks in there just to quote the value,
>not as
>> >>> part of the value=2E The intention was to point out that something
>like:
>> >>>
>> >>> | define foo =3D @set1
>> >>> | add rule ip t c jump $foo
>> >>>
>> >>> Might pass evaluation stage and since there is a special case for
>things
>> >>> starting with '@' in symbol_expr, the added rule would turn into
>> >>>
>> >>> | add rule ip t c jump set1
>> >>>
>> >>> We could detect this situation by checking expr->symtype=2E
>> >>>
>> >>
>> >> I agree about that=2E We could check if the symbol type is
>SYMBOL_VALUE=2E
>> >> But I am not sure about where should we do it, maybe in the
>parser?
>> >>
>> >>> On the other hand, can we maybe check if given string points to
>an
>> >>> *existing* chain in verdict_type_parse()? Or will that happen
>later
>> >>> anyway?
>> >>>
>> >>
>> >> It happens later, right now if the given string does not point to
>an
>> >> existing chain it returns the usual error for this situation=2E e=2E=
g
>> >=20
>> > I just played around a bit and could provoke some segfaults:
>> >=20
>> > * define foo =3D @set1 (a set named 'set1' must exist)
>> > * define foo =3D { 1024 }
>> > * define foo =3D *
>> >=20
>> > I didn't check how we could avoid those=2E Maybe this is even
>follow-up
>> > work, but we should definitely try to address those eventually=2E
>> >=20
>>=20
>> I have been working on fixing this=2E I propose the following fix=2E
>>=20
>> diff --git a/src/evaluate=2Ec b/src/evaluate=2Ec
>> index 8394037=2E=2Eedab370 100644
>> --- a/src/evaluate=2Ec
>> +++ b/src/evaluate=2Ec
>> @@ -1950,6 +1950,12 @@ static int stmt_evaluate_verdict(struct
>eval_ctx
>> *ctx, struct stmt *stmt)
>>                 if (stmt->expr->chain !=3D NULL) {
>>                         if (expr_evaluate(ctx, &stmt->expr->chain) <
>0)
>>                                 return -1;
>> +                       if (stmt->expr->chain->etype !=3D EXPR_SYMBOL
>||
>> +                           stmt->expr->chain->symtype !=3D
>SYMBOL_VALUE) {
>> +                               BUG("invalid verdict chain expression
>%s\n",
>> +                                   expr_name(stmt->expr->chain));
>
>Instead of BUG(), I'd suggest you do proper error reporting=2E
>

Ok=2E I will send a new patch series=2E Thanks=2E

>> +                               return -1;
>> +                       }
>>                 }
>>                 break;
>>         case EXPR_MAP:
>>=20
>> That works for all the cases that you mentioned above=2E What do you
>think?
>>=20
>> Thanks :-)
>>=20
>> > Cheers, Phil
>> >=20

