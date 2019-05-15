Return-Path: <SRS0=H0Uh=TP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4ED9C04E53
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 19:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90FA620843
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 May 2019 19:56:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="dRjBTcMb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfEOT4A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 May 2019 15:56:00 -0400
Received: from mx1.riseup.net ([198.252.153.129]:57542 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbfEOTz7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 May 2019 15:55:59 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 52CEC1A389E;
        Wed, 15 May 2019 12:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1557950159; bh=Bn1bl+ZhdCftKEWIa8973Z7G7eAw8RsSPHIaWaXthW0=;
        h=Subject:To:References:From:Cc:Date:In-Reply-To:From;
        b=dRjBTcMbg5ZWGKjjtTrVUKb/Zt6x4Hqj7YcBkPVB5GSY9bBdv9uBlW2eYJD0+Ablg
         4m+uIPICc/GumplHKdwlR4plGaJjbCIuhsNhqEkPDxYSsM+d92mVFh3FgpHbWHwnp+
         pLNM+cOVINfdo9N24ZlRs6xBRyQ5G3DO8FQRQ4Ug=
X-Riseup-User-ID: F213906BA82CDE2831D0A38ABE6EB400D53D17D4504EF8341C6F252346A6A39B
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 7E33A2238DD;
        Wed, 15 May 2019 12:55:58 -0700 (PDT)
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
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Message-ID: <902d698b-a25c-0567-1338-b2d8c0bd91cb@riseup.net>
Date:   Wed, 15 May 2019 21:56:11 +0200
MIME-Version: 1.0
In-Reply-To: <20190515192600.GC4851@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On 5/15/19 9:26 PM, Phil Sutter wrote:
> Hi Pablo,
> 
> On Wed, May 15, 2019 at 05:21:32PM +0200, Pablo Neira Ayuso wrote:
>> On Wed, May 15, 2019 at 01:46:17PM +0200, Phil Sutter wrote>> [...]
>> '@<something>' is currently allowed, as any arbitrary string can be
>> placed in between strings - although in some way this is taking us
>> back to the quote debate that needs to be addressed. If we want to
>> disallow something enclosed in quotes then we'll have to apply this
>> function everywhere we allow variables.
> 
> Oh, sorry. I put those ticks in there just to quote the value, not as
> part of the value. The intention was to point out that something like:
> 
> | define foo = @set1
> | add rule ip t c jump $foo
> 
> Might pass evaluation stage and since there is a special case for things
> starting with '@' in symbol_expr, the added rule would turn into
> 
> | add rule ip t c jump set1
> 
> We could detect this situation by checking expr->symtype.
> 

I agree about that. We could check if the symbol type is SYMBOL_VALUE.
But I am not sure about where should we do it, maybe in the parser?

> On the other hand, can we maybe check if given string points to an
> *existing* chain in verdict_type_parse()? Or will that happen later
> anyway?
> 

It happens later, right now if the given string does not point to an
existing chain it returns the usual error for this situation. e.g

define dest = randomchain

table ip foo {
	chain bar {
		jump $dest
	}

	chain ber {
	}
}

test_file.nft:7:3-12: Error: Could not process rule: No such file or
directory
		jump $dest
		^^^^^^^^^^

> Cheers, Phil
> 

Thanks!
