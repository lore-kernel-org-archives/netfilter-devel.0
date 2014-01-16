From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH v2] ct: fix key and dir requirements
Date: Thu, 16 Jan 2014 23:46:25 +0100
Message-ID: <CAOkSjBgfJgrwD5bD3-PWRKCG6V97eKEcF5V=ZkG3FbdeCj_TLg@mail.gmail.com>
References: <20140115181939.25239.19905.stgit@nfdev.cica.es>
 <20140116180538.GA18501@localhost> <CAOkSjBhOb=Z_-KDfpmRko7Vi-U4QVhYUJwkJ1FbDpLjEVD3teA@mail.gmail.com>
 <20140116212224.GA27510@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:54378 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaAPWqq convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:46:46 -0500
Received: by mail-lb0-f179.google.com with SMTP id l4so815671lbv.38
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2014 14:46:45 -0800 (PST)
In-Reply-To: <20140116212224.GA27510@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16 January 2014 22:22, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> On Thu, Jan 16, 2014 at 09:46:17PM +0100, Arturo Borrero Gonzalez wro=
te:
>> On 16 January 2014 19:05, Pablo Neira Ayuso <pablo@netfilter.org> wr=
ote:
>> >
>> > The kernel will complain if we pass invalid combinations, I don't =
want
>> > to have this early validation code in the library.
>> >
>>
>> The problem is that as far as I've tested, the kernel  unconditional=
ly
>> returns 'dir' [0].
>
> Then I think we have to fix the kernel, it should not dump an
> attribute that we don't need. I can see that nft is currently not
> using the direction at all, so such change should not break anything.
>
>> If we print in XML/JSON the data obtained from the kernel, <dir> is
>> also printed, while it may be totally undesirable (for example, for =
a
>> latter parsing of that XML/JSON meant to be resended to the kernel).
>> I think we need this check, in libnftables or nft.
>>
>> I don't see the point of allowing such a disruptive combination of a=
ttributes.
>
> I agree those combinations don't make sense, but let just the kernel
> bail out when we pass invalid combinations. Otherwise, the library
> makes internal decisions that we simply cannot change as we'll have
> 3rd party userspace application relying on it. And we may want to
> extend the kernel behaviour in some way that may clash with old
> libraries. Really, we have to avoid this, it's just troubles in the
> long run.

OK, good to know. I delete this patch from my local repo.

I'm working in a kernel patch on top of your nftables kernel [0].

regards.

[0] http://git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git/
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
