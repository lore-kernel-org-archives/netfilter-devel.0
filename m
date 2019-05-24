Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900CBC072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 07:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49E4420879
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 07:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="gaUexDYe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388974AbfEXHR2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 03:17:28 -0400
Received: from mx1.riseup.net ([198.252.153.129]:35802 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388912AbfEXHR2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 03:17:28 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 675701A0A19;
        Fri, 24 May 2019 00:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558682247; bh=rth6/tqVCSOAjXmqIlWc/AiQh6ZLeJaQz+hbODrhE1o=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=gaUexDYelOKqgrqdTdKuzUTLPZAhzz6fKoNIeoHASJJl8C5E8lo/acvgaXOCEUsO5
         nDFy6UEqZNBHpUTarAHG4RR6ovigP5hdujBHstOIGlGZ8H55g7zQcTDPY9MRGgWcg+
         xGDCfkpwtt6n/ndKPZoM/QghpcjxivkkrlJo/XhE=
X-Riseup-User-ID: 5184852FEE2CDD0CF309F283D5B8E285740616F7EB8912419CB234A6B19CF972
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 665611201FC;
        Fri, 24 May 2019 00:17:26 -0700 (PDT)
Subject: Re: [PATCH nft v3 1/2] jump: Introduce chain_expr in jump and goto
 statements
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190516204559.28910-1-ffmancera@riseup.net>
 <20190521092837.vd3egt54lvdhynqi@salvia>
 <1ff8b9ea-ce19-301f-e683-790417a179a7@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <6570754e-30ab-b24b-4f4d-507a6ac74edf@riseup.net>
Date:   Fri, 24 May 2019 09:17:37 +0200
MIME-Version: 1.0
In-Reply-To: <1ff8b9ea-ce19-301f-e683-790417a179a7@riseup.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On 5/21/19 9:38 PM, Fernando Fernandez Mancera wrote:
> Hi Pablo,
> 
> On 5/21/19 11:28 AM, Pablo Neira Ayuso wrote:
>> On Thu, May 16, 2019 at 10:45:58PM +0200, Fernando Fernandez Mancera wrote:
>>> Now we can introduce expressions as a chain in jump and goto statements. This
>>> is going to be used to support variables as a chain in the following patches.
>>
>> Something is wrong with json:
>>
>> json.c: In function ‘verdict_expr_json’:
>> json.c:683:11: warning: assignment from incompatible pointer type
>> [-Wincompatible-pointer-types]
>>      chain = expr->chain;
>>            ^
>> parser_json.c: In function ‘json_parse_verdict_expr’:
>> parser_json.c:1086:8: warning: passing argument 3 of
>> ‘verdict_expr_alloc’ from incompatible pointer type
>> [-Wincompatible-pointer-types]
>>         chain ? xstrdup(chain) : NULL);
>>         ^~~~~
>>
>> Most likely --enable-json missing there.
>>
> 
> Sorry, I am going to fix that.
> [...]

I am compiling nftables with:

$ ./configure --enable-json
$ make

And I am not getting any error, am I missing something? Thanks! :-)
