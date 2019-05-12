Return-Path: <SRS0=q8lh=TM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE30BC04A6B
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 16:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E74120C01
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 16:28:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="IxoNFPF0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfELQ2R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 May 2019 12:28:17 -0400
Received: from mx1.riseup.net ([198.252.153.129]:56020 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbfELQ2R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 May 2019 12:28:17 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 93FDE1A1E9F;
        Sun, 12 May 2019 09:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1557678496; bh=ZzFV+/qCAaKugb/qIs97HvyM47GPkEUl+bzDNXBgm8Y=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=IxoNFPF0bMAaCXyB3U3w+1m9M8P5/rDr9iVizYxKE00jX4xBpY0RwDF74ZNUDCPmY
         ajwaf5aNm0SooeHLKNmynRreXTNNc1ReVnk7WzcZ/4c7H/I1zKDTtZT2TrPofZR1fv
         ZYGL/5iAP0W2q4uWawxWLbTl34T6MQfxKibNd5xY=
X-Riseup-User-ID: 8689A22304A23D4B75197D3F80209FC066DE36157EF6ECF6C25E32FE1A9CEEDC
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id D13CE120D15;
        Sun, 12 May 2019 09:28:15 -0700 (PDT)
Subject: Re: Undefined reference?
To:     =?UTF-8?Q?St=c3=a9phane_Veyret?= <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
References: <CAFs+hh4ghFJqE=b+CXiVL9AguKr1MjZntuDvzYyqmDy5aGJPLw@mail.gmail.com>
 <20190512085624.gdzbjeb4htdp7z45@breakpoint.cc>
 <CAFs+hh7TXHELQr7aTQXJrkko-jN=C8Nx=s6ZhxQNDyB+KECTnA@mail.gmail.com>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <5eb8284f-6d22-224d-1f52-011c5bf79a4a@riseup.net>
Date:   Sun, 12 May 2019 18:28:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAFs+hh7TXHELQr7aTQXJrkko-jN=C8Nx=s6ZhxQNDyB+KECTnA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I faced a similar problem a long time ago, I solved it by resetting the
linker cache. Try this.

# rm /etc/ld.so.cache
# ldconfig

On 5/12/19 6:20 PM, Stéphane Veyret wrote:
> Le dim. 12 mai 2019 à 10:56, Florian Westphal <fw@strlen.de> a écrit :
>>
>>> Now, I am trying to modify the nftables userspace tool. I had to set variables:
>>> LIBNFTNL_CFLAGS="-g -O2"
>>> LIBNFTNL_LIBS=$HOME/libnftnl/src/.libs/libnftnl.so ./configure
>>> in order for configure to work, but it worked. But at linking time, I
>>> get the following error for each nftnl_* function:
>>> ld: ./.libs/libnftables.so: undefined reference to `nftnl_trace_free'
>>>
>>> I tried to set the LD_LIBRARY_PATH to /usr/local/lib but it did not
>>> change anything. Do you have an idea of what the problem is?
>>
>> Try
>>
>> LIBNFTNL_LIBS="-L$HOME/libnftnl/src/.libs -lnftnl" ./configure
> 
> No luck, same result… :-(
> 
