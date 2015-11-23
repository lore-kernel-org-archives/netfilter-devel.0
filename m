From: Rodrigo Rebello <rprebello@gmail.com>
Subject: Re: [PATCH conntrack-tools] src: fix build with musl libc
Date: Mon, 23 Nov 2015 11:59:04 -0200
Message-ID: <CABLs7GXzpOCuhWJRx8E+2XRX0gjdKVeME1ciSqUy2aSx-NHG1g@mail.gmail.com>
References: <1448254789-30961-1-git-send-email-rprebello@gmail.com>
	<20151123110709.GA5682@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36438 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbbKWN7F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2015 08:59:05 -0500
Received: by oiww189 with SMTP id w189so124869779oiw.3
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 05:59:04 -0800 (PST)
In-Reply-To: <20151123110709.GA5682@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

2015-11-23 9:07 GMT-02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Mon, Nov 23, 2015 at 02:59:49AM -0200, Rodrigo Rebello wrote:
>> The GNU version of 'struct tcphdr' is not exposed by musl libc headers
>> unless _GNU_SOURCE is defined. Without this definition, the build fails
>> with:
>>
>>   rpc.c: In function 'rpc_helper_cb':
>>   rpc.c:351:15: error: 'struct tcphdr' has no member named 'doff'
>>      offset += th->doff * 4;
>>                  ^
>
> You can probably update the code to use the non-GNU version, that
> should work both with musl, libc and any other new version that
> sticks to the standard.
>
> Thanks.

I could change 'doff' to 'th_off' in rpc.c:351, which is the name used
in the BSD version of 'struct tcphdr', but then I'd have to define the
macro __FAVOR_BSD in order to get the code to compile with uClibc (in
contrast to musl, uClibc only exposes the GNU version by default).

So, I don't see any advantages in doing that (changing the member name
+ defining __FAVOR_BSD) instead of simply defining _GNU_SOURCE.
Besides, I've noticed that a similar issue has been solved before by
using the same approach (commit
fe1f2d58add1e56e651c43de8cd60db8123d49bb).

Regards,
Rodrigo
