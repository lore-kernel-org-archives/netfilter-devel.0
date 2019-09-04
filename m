Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F9EC3A5A7
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 09:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63C7F2339E
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 09:16:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="gZs2Sc+i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbfIDJQt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 05:16:49 -0400
Received: from mx1.riseup.net ([198.252.153.129]:60454 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfIDJQs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 05:16:48 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 18DE61B957B;
        Wed,  4 Sep 2019 02:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1567588608; bh=M4grKsi616xLsrb/REFYTyWAvSO/XYboTTk95OjVkVQ=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=gZs2Sc+i9tF+C5vTcFXmZbkLInFZMFR/auy/aY9tzif7aiFeFvlFfUstgh/C/USoJ
         Vu9TWJZlNyWatjh93F0om9g1DPFT9tg0BQDjtl25fmnhxO3X6NZGjvREi20TT/CCY4
         tddHNsDlI9J0q0TIhqgDj9gH/HNXdJDXqom+dim0=
X-Riseup-User-ID: 13C5D292C1D9E4280A7B251E91EE835116345455964F75430C4201D21AEB3706
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 3DB7222336B;
        Wed,  4 Sep 2019 02:16:47 -0700 (PDT)
Subject: Re: [PATCH nf] netfilter: nf_tables: fix possible null-pointer
 dereference in object update
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
References: <20190903213313.1080-1-ffmancera@riseup.net>
 <20190904065813.GG25650@orbyte.nwl.cc>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <af504e11-39dc-92c7-4bd3-194b05448415@riseup.net>
Date:   Wed, 4 Sep 2019 11:17:01 +0200
MIME-Version: 1.0
In-Reply-To: <20190904065813.GG25650@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

I am sending a v2 with an explanation. Thanks!

On 9/4/19 8:58 AM, Phil Sutter wrote:
> Hi Fernando,
> 
> On Tue, Sep 03, 2019 at 11:33:13PM +0200, Fernando Fernandez Mancera wrote:
>> Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object update operation")
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> 
> Your patch looks good but please (always) provide a bit of explanation.
> In this case typical questions to answer in commit message are:
> - Why may obj->ops->update be NULL? For which object type are they not
>   defined?
> - How could one trigger the issue? In other words, why is
>   nft_obj_commit_update() called for the "wrong" object?
> 
> Cheers, Phil
> 
