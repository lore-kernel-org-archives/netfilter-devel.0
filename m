Return-Path: <SRS0=q8lh=TM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E5CC04A6B
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 23:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DF6F208C0
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 23:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfELXAZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 May 2019 19:00:25 -0400
Received: from a3.inai.de ([88.198.85.195]:42680 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbfELXAY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 May 2019 19:00:24 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id C87E23BB8AA1; Mon, 13 May 2019 01:00:22 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id BD56F3BB8A9E;
        Mon, 13 May 2019 01:00:22 +0200 (CEST)
Date:   Mon, 13 May 2019 01:00:22 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: Undefined reference?
In-Reply-To: <CAFs+hh7TXHELQr7aTQXJrkko-jN=C8Nx=s6ZhxQNDyB+KECTnA@mail.gmail.com>
Message-ID: <nycvar.YFH.7.76.1905130059440.21326@n3.vanv.qr>
References: <CAFs+hh4ghFJqE=b+CXiVL9AguKr1MjZntuDvzYyqmDy5aGJPLw@mail.gmail.com> <20190512085624.gdzbjeb4htdp7z45@breakpoint.cc> <CAFs+hh7TXHELQr7aTQXJrkko-jN=C8Nx=s6ZhxQNDyB+KECTnA@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Sunday 2019-05-12 18:20, Stéphane Veyret wrote:
>Le dim. 12 mai 2019 à 10:56, Florian Westphal <fw@strlen.de> a écrit :
>>
>> > Now, I am trying to modify the nftables userspace tool. I had to set variables:
>> > LIBNFTNL_CFLAGS="-g -O2"
>> > LIBNFTNL_LIBS=$HOME/libnftnl/src/.libs/libnftnl.so ./configure
>> > in order for configure to work, but it worked. But at linking time, I
>> > get the following error for each nftnl_* function:
>> > ld: ./.libs/libnftables.so: undefined reference to `nftnl_trace_free'
>> >
>> > I tried to set the LD_LIBRARY_PATH to /usr/local/lib but it did not
>> > change anything. Do you have an idea of what the problem is?
>>
>> Try
>>
>> LIBNFTNL_LIBS="-L$HOME/libnftnl/src/.libs -lnftnl" ./configure
>
>No luck, same result… :-(

This must be

./configure LIBNFTNL_LIBS="-L$HOME/libnftnl/src/.libs -lnftnl"

like.. since forever.
