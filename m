From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH v2] src: add redirect support
Date: Tue, 4 Nov 2014 16:04:11 +0100
Message-ID: <CAOkSjBhMU2cw=B69G0=Rf-bC-H8BatAhA_07P=qFUjLYNCE4hg@mail.gmail.com>
References: <20141016104056.8678.71075.stgit@nfdev.cica.es>
 <20141030162520.GA2074@salvia> <CAOkSjBibjQa7A-WEw0NbhmRnKNsDgWxgGVe7EP9V8S600uKMGg@mail.gmail.com>
 <20141104133712.GA9190@salvia> <CAOkSjBhSysvcL_wOwJK=aPaAeGKt02=i0mmX=zQ5xW-PRDxgXg@mail.gmail.com>
 <20141104144455.GB10239@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60400 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaKDPEd convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:04:33 -0500
Received: by mail-lb0-f174.google.com with SMTP id p9so364314lbv.5
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Nov 2014 07:04:32 -0800 (PST)
In-Reply-To: <20141104144455.GB10239@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4 November 2014 15:44, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> On Tue, Nov 04, 2014 at 02:56:58PM +0100, Arturo Borrero Gonzalez wro=
te:
>> On 4 November 2014 14:37, Pablo Neira Ayuso <pablo@netfilter.org> wr=
ote:
>> >
>> > I think this needs to be:
>> >
>> > % nft add rule nat prerouting redirect [port] [nat_flags]
>> >
>>
>> The port and nat_flags arguments are mutually exclusives. That's why=
 I
>> used the [port|nat_flags] syntax.
>
> iptables allows this:
>
> -j REDIRECT --to-ports 8000-8010 --random

Then, should I change the behaviour of the nft redirect parser?
The code in my patch doesn't allow that.

I think it makes no sense: "redirect to this port; no sorry, redirect
to a random one."

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
