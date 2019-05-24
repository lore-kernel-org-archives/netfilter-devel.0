Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 663C8C072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 07:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 115BF20868
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 07:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="LbGUUa8M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388960AbfEXH3W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 03:29:22 -0400
Received: from mx1.riseup.net ([198.252.153.129]:38788 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388847AbfEXH3W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 03:29:22 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id BC69D1A340F;
        Fri, 24 May 2019 00:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558682961; bh=GvOeaky29rHNbDz7BiFUKaceKZ1SmgwFc+O4DnNUREk=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=LbGUUa8M4GdHbjsI5QmNgnH/xqcsVKk2Z+HLao+rI4AP1Uyw1ZfCJSxFU7E01CdEj
         0pijD06NpVMWDLg8avvU+y+mRBqoqite+K3DVQ+Zal0SPZeg3FFuN87fowqVptTe4k
         PmB3/c8qWX7Ymk8gUi4e4VsqBepXdL322j+OopnI=
X-Riseup-User-ID: 1A47FDCB22575E5062AE08888351A64C441639BE3820D73160A02D52155F46D9
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 26928120A83;
        Fri, 24 May 2019 00:29:20 -0700 (PDT)
Subject: Re: [PATCH nft v3 1/2] jump: Introduce chain_expr in jump and goto
 statements
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190516204559.28910-1-ffmancera@riseup.net>
 <20190521092837.vd3egt54lvdhynqi@salvia>
 <1ff8b9ea-ce19-301f-e683-790417a179a7@riseup.net>
 <6570754e-30ab-b24b-4f4d-507a6ac74edf@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <5d9f68a9-a90f-37bf-8ee7-61b7d2ccb324@riseup.net>
Date:   Fri, 24 May 2019 09:29:34 +0200
MIME-Version: 1.0
In-Reply-To: <6570754e-30ab-b24b-4f4d-507a6ac74edf@riseup.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 5/24/19 9:17 AM, Fernando Fernandez Mancera wrote:
> Hi Pablo,
> 
> On 5/21/19 9:38 PM, Fernando Fernandez Mancera wrote:
>> Hi Pablo,
>>
>> On 5/21/19 11:28 AM, Pablo Neira Ayuso wrote:
>>> On Thu, May 16, 2019 at 10:45:58PM +0200, Fernando Fernandez Mancera wrote:
>>>> Now we can introduce expressions as a chain in jump and goto statements. This
>>>> is going to be used to support variables as a chain in the following patches.
>>>
>>> Something is wrong with json:
>>>
>>> json.c: In function ‘verdict_expr_json’:
>>> json.c:683:11: warning: assignment from incompatible pointer type
>>> [-Wincompatible-pointer-types]
>>>      chain = expr->chain;
>>>            ^
>>> parser_json.c: In function ‘json_parse_verdict_expr’:
>>> parser_json.c:1086:8: warning: passing argument 3 of
>>> ‘verdict_expr_alloc’ from incompatible pointer type
>>> [-Wincompatible-pointer-types]
>>>         chain ? xstrdup(chain) : NULL);
>>>         ^~~~~
>>>
>>> Most likely --enable-json missing there.
>>>
>>
>> Sorry, I am going to fix that.
>> [...]
> 
> I am compiling nftables with:
> 
> $ ./configure --enable-json
> $ make
> 
> And I am not getting any error, am I missing something? Thanks! :-)
> 

Fixed, the option is --with-json. Why isn't it "--enable-json" as other
features?
