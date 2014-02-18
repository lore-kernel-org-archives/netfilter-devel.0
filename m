From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft RFC PATCH 0/6] events
Date: Tue, 18 Feb 2014 10:20:46 +0100
Message-ID: <CAOkSjBgi5jePNt3F1V0t=iomgNM5iVcan1hdw43kaYcKgCF0pw@mail.gmail.com>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es> <20140218014348.GD12893@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:43032 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbaBRJVH convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:21:07 -0500
Received: by mail-lb0-f170.google.com with SMTP id u14so12253241lbd.29
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Feb 2014 01:21:06 -0800 (PST)
In-Reply-To: <20140218014348.GD12893@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18 February 2014 02:43, Patrick McHardy <kaber@trash.net> wrote:
>>
>> Its quite simple, the syntax is:
>>  % nft event <all|table|chain|rule|set> [xml|json]
>
> So far we're pretty much (except for shortcuts like default "add rule=
")
> following the scheme "nft action object". "event" doesn't fit in this
> scheme, so I'd propose to change this to "monitor". Also I guess obje=
ct
> specification could be optional so "all" wouldn't be needed, but that=
's
> not too important.
>

Ok, so I propose the syntax:

 % nft monitor [table|chain|rule|set] [new|delete] [xml|json]

>> add rule ip6 filter input handle 4
>
> No expressions in the output? Why the set caching then?
>

Well, in this first approach I was unable to achieve that :-(
I needed some feedback (this RFC).

The intention is of course print out all the expressions.

regards.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
