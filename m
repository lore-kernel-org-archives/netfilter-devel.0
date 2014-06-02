From: =?ISO-8859-15?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nftables PATCH v2] src: Replace TOS support for using DSCP support
Date: Mon, 02 Jun 2014 20:57:08 +0200
Message-ID: <538CC904.3080705@gmail.com>
References: <1401184815-14002-1-git-send-email-alvaroneay@gmail.com> <1401200300-24583-1-git-send-email-alvaroneay@gmail.com> <20140601202707.GC19396@macbook.localnet> <538C307C.30405@gmail.com> <20140602085826.GA17858@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44313 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaFDWEP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:04:15 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so9263429wib.17
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jun 2014 15:04:13 -0700 (PDT)
In-Reply-To: <20140602085826.GA17858@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 02/06/14 10:58, Florian Westphal escribi=F3:
> =C1lvaro Neira Ayuso <alvaroneay@gmail.com> wrote:
>>>> Now, when we add a rule with DSCP, in the code generation step, nf=
tables
>>>> compares 1 bytes but it should compare 6 bits. I think that the pr=
oblem should
>>>> be in the code generation.
>>>
>>> I don't really see how this patch changes this. The kernel operates=
 in units
>>> of bytes. For anything smaller nftables will have to generate appro=
priate
>>> bitwise operations. Please explain in more detail how this patch ch=
anges this.
>>>
>>
>> Now, nothing. For that it's stopped. I'm working for doing a patch
>> for operating in the kernel not only with units of bytes like you
>> say. In a couple of days, I'm going to send it to the list.
>
> Are you sure this is the right approach?
>
> It might be better to create appropriate masking instructions in
> userspace, in most cases byte addressing is sufficient.
>
> Something like this (warning: untested, misses 'reverse' mapping to
> remove the implicit bitops when listing rules):
>
> http://git.breakpoint.cc/cgit/fw/nftables.git/commit/?h=3Dpayload_off=
set_04&id=3D76ac27643400111785a8abb21fdd9e4311d9876e
>

I have explained very bad. I'm working in a patch like you but I have=20
done a different solution. I have done my solution in the evaluation. I=
=20
have added a bitwise node in the tree when we evaluate the relational i=
f=20
we have a EXPR_PAYLOAD node in the left and when the size of this left=20
node is not a multiple of BITS_PER_BYTE. And I have used the function=20
mpz_prefixmask for doing the masks. The problem come when I have added =
a=20
rule like:

nft add rule ip filter input ip frag-off !=3D 0

The mask that we need to use for take the 13 bits for frag-off is like =
this:
|00052|N-|00002|	|len |flags| type|
|00008|--|00001|	|len |flags| type|
| 00 00 00 01  |	|      data      |=09
|00008|--|00002|	|len |flags| type|
| 00 00 00 01  |	|      data      |=09
|00008|--|00003|	|len |flags| type|
| 00 00 00 02  |	|      data      |=09
|00012|N-|00004|	|len |flags| type|
|00006|--|00001|	|len |flags| type|
| 1f ff 00 00  |	|      data      |=09

The problem is when I have seen the mask of the bitwise in the kernel, =
I=20
have seen that the mask is 0xff1f. I'm working for trying to fix that. =
I=20
have thought that maybe was a problem that I have tried this rule=20
without my patch and we have the same problem:

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
