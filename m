From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [nftables PATCH v2] src: Replace TOS support for using DSCP support
Date: Mon, 2 Jun 2014 22:26:27 -0700
Message-ID: <CAHo-OozdVSHnGNcW9MYbYOCCe2MSz2VhDZ8WUD1GXU7ANeZQrw@mail.gmail.com>
References: <1401184815-14002-1-git-send-email-alvaroneay@gmail.com>
	<1401200300-24583-1-git-send-email-alvaroneay@gmail.com>
	<20140601202707.GC19396@macbook.localnet>
	<538C307C.30405@gmail.com>
	<20140602085826.GA17858@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?=C3=81lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:32857 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaFCF02 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 01:26:28 -0400
Received: by mail-qa0-f48.google.com with SMTP id i13so4235460qae.35
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Jun 2014 22:26:28 -0700 (PDT)
In-Reply-To: <20140602085826.GA17858@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 2, 2014 at 1:58 AM, Florian Westphal <fw@strlen.de> wrote:
> =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com> wrote:
>> >>Now, when we add a rule with DSCP, in the code generation step, nf=
tables
>> >>compares 1 bytes but it should compare 6 bits. I think that the pr=
oblem should
>> >>be in the code generation.
>> >
>> >I don't really see how this patch changes this. The kernel operates=
 in units
>> >of bytes. For anything smaller nftables will have to generate appro=
priate
>> >bitwise operations. Please explain in more detail how this patch ch=
anges this.
>> >
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
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I know very little about how nftables is actually implemented.  That sa=
id:

The IPv6 TOS byte is actually half in one byte half in the next, as a
result of which the 6 dscp bits are 4 bits of one byte and 2 bits of
the next.
The IPv6 flowinfo field is similarly a 20 bit field 12 bits into the pa=
cket.
The IPv4 fragment offset is 13 bits in size.

I wonder if for performance reasons the right answer isn't to allow a
fetch N<=3D64 bits from bit offset M (M=3D0..inf) opcode as opposed to
doing the masking by hand (perhaps require (M%8)+N<=3D64 as well).
Perhaps it should also be capable of left shifting the result by K
bits (to deal with fields - like the ipv4 header length field - which
count dwords instead of bytes).
Theoretically with a sufficiently good jit compiler it shouldn't
matter... but I'm assuming that's in the far future.  (??)

I'm not sure if there should be multiple versions of this
(little-endian vs big-endian, bit ordering...) or just the immediately
useful ones (ie. network byte order).

- Maciej
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
