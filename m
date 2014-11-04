From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH v2] src: add redirect support
Date: Tue, 4 Nov 2014 14:56:58 +0100
Message-ID: <CAOkSjBhSysvcL_wOwJK=aPaAeGKt02=i0mmX=zQ5xW-PRDxgXg@mail.gmail.com>
References: <20141016104056.8678.71075.stgit@nfdev.cica.es>
 <20141030162520.GA2074@salvia> <CAOkSjBibjQa7A-WEw0NbhmRnKNsDgWxgGVe7EP9V8S600uKMGg@mail.gmail.com>
 <20141104133712.GA9190@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36268 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaKDN5T convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:57:19 -0500
Received: by mail-lb0-f177.google.com with SMTP id z12so2667614lbi.22
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Nov 2014 05:57:18 -0800 (PST)
In-Reply-To: <20141104133712.GA9190@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4 November 2014 14:37, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
>
> I think this needs to be:
>
> % nft add rule nat prerouting redirect [port] [nat_flags]
>

The port and nat_flags arguments are mutually exclusives. That's why I
used the [port|nat_flags] syntax.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
