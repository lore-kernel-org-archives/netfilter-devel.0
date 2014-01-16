From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: libnftables set element printing, DATA_CHAIN
Date: Thu, 16 Jan 2014 11:30:26 +0100
Message-ID: <CAOkSjBjD7VBgErC08C387u6Lgetx8m7mtBfe4khpRLWbahsHJA@mail.gmail.com>
References: <20140115225002.GA13700@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:40032 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaAPKar convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:30:47 -0500
Received: by mail-la0-f42.google.com with SMTP id hr13so345560lab.29
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2014 02:30:46 -0800 (PST)
In-Reply-To: <20140115225002.GA13700@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15 January 2014 23:50, Patrick McHardy <kaber@trash.net> wrote:
> [resending because of incorrect list address]
>
> I was looking at some incorrect output in netlink debugging for set e=
lements
> and noticed a few things that seem odd:
>
> First, the regular netlink debugging seems very incomplete, it doesn'=
t
> print verdict types, it prints [end] whether the set contains interva=
ls
> and the set is an interval end or not and its messing up the output.
>

It's true, most of the development went to the JSON/XML formats, not
the default one.

> Next I'm wondering about what DATA_CHAIN is supposed to be. I guess i=
ts
> the chain for a jump or goto verdict, This is even encoded in the
> XML and JSON output. This seems wrong to me, there is no DATA_CHAIN,
> there are JUMP or GOTO verdicts that include a chain. The specific
> verdict is also missing, so its not possible to distinguish these
> two cases.
>

Ok, let's fix that. Do you have a proposal?

This is what I think you want:

* a <data_reg type=3Dvalue> with raw data.
* a <data_reg type=3Dverdict> with a concrete verdict (eg drop accept)
* a <data_reg type=3Djump> with a chain to jump to.
* a <data_reg type=3Dgoto> with a chain to go to.

Or maybe:

* a <data_reg type=3Dvalue> with raw data.
* a <data_reg type=3Dverdict> with a concrete verdict (eg drop accept)
and if verdict =3D=3D jump or goto, then a <chain> with the destination=
=2E

> I could fix up the debugging output, but this looks like someone more
> familiar with the XML and JSON stuff should have a look at this and
> fix all of this consistently before we release it as wire format.

I can handle it.

regards
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
