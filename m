Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1109FC7618F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 17:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8BBD2064B
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 17:29:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="m1eWYmL2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388210AbfGPR3h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 13:29:37 -0400
Received: from mx1.riseup.net ([198.252.153.129]:33378 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728124AbfGPR3h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 13:29:37 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id ABF561B946A;
        Tue, 16 Jul 2019 10:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563298176; bh=KSh1hhgw+lrCUaXcvnaxK1tfbTz9ucbZKT9WwDEFJlc=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=m1eWYmL2iRg0WeKtZ+gTpvcCN6wDqPQX3NFVkiyZJ4utYsvngPGpuCQIqRN6Gfs0q
         Tynt3ZPCI2ZPzlbIQbUiHu4y+5JjDu35z42n37nZQOmKxtXt+EuNab7y/N4JrGehYk
         lFMxSfwcWfIDtFMOdd9jhPq8/3HsJxaB2rqssqw8=
X-Riseup-User-ID: 5870AF93039CC240CA69FCDD2650571CEEC540973A8394EEE9F4556266E3BFD4
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 6EE6E220036;
        Tue, 16 Jul 2019 10:29:35 -0700 (PDT)
Date:   Tue, 16 Jul 2019 19:29:28 +0200
In-Reply-To: <20190716164711.GF1628@orbyte.nwl.cc>
References: <20190716115120.21710-1-pablo@netfilter.org> <20190716164711.GF1628@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH nft] evaluate: bogus error when refering to existing non-base chain
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
CC:     netfilter-devel@vger.kernel.org, charles@ccxtechnologies.com
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Message-ID: <63707D89-2251-4B96-BE53-880E12FF0F6A@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

El 16 de julio de 2019 18:47:11 CEST, Phil Sutter <phil@nwl=2Ecc> escribi=
=C3=B3:
>Hi Pablo,
>
>On Tue, Jul 16, 2019 at 01:51:20PM +0200, Pablo Neira Ayuso wrote:
>[=2E=2E=2E]
>> diff --git a/src/evaluate=2Ec b/src/evaluate=2Ec
>> index f95f42e1067a=2E=2Ecd566e856a11 100644
>> --- a/src/evaluate=2Ec
>> +++ b/src/evaluate=2Ec
>> @@ -1984,17 +1984,9 @@ static int stmt_evaluate_verdict(struct
>eval_ctx *ctx, struct stmt *stmt)
>>  	case EXPR_VERDICT:
>>  		if (stmt->expr->verdict !=3D NFT_CONTINUE)
>>  			stmt->flags |=3D STMT_F_TERMINAL;
>> -		if (stmt->expr->chain !=3D NULL) {
>> -			if (expr_evaluate(ctx, &stmt->expr->chain) < 0)
>> -				return -1;
>> -			if ((stmt->expr->chain->etype !=3D EXPR_SYMBOL &&
>> -			    stmt->expr->chain->etype !=3D EXPR_VALUE) ||
>> -			    stmt->expr->chain->symtype !=3D SYMBOL_VALUE) {
>> -				return stmt_error(ctx, stmt,
>> -						  "invalid verdict chain expression %s\n",
>> -						  expr_name(stmt->expr->chain));
>> -			}
>> -		}
>
>According to my logs, this bit was added by Fernando to cover for
>invalid variable values[1]=2E So I fear we can't just drop this check=2E
>
>Cheers, Phil
>
>[1] I didn't check with current sources, but back then the following
>    variable contents were problematic:
>
>    * define foo =3D @set1 (a set named 'set1' must exist)
>    * define foo =3D { 1024 }
>    * define foo =3D *

Yes I am looking to the report and why current version fails when the jump=
 is to a non-base chain because I tested that some months ago=2E

I will catch up with more details in a few hours=2E Sorry for the inconven=
iences=2E
