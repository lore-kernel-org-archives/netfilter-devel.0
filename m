From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft] the -nnn switch
Date: Mon, 22 Sep 2014 12:04:54 +0200
Message-ID: <20140922100454.GN4971@acer.localdomain>
References: <CAOkSjBgOpbJmOXEX=a1kPXqDMs673ZTfB_Qg=q4V5L2JTsg77g@mail.gmail.com>
 <20140919112505.GA1158@acer.localdomain>
 <CAOkSjBisG3f4fm3bw2NfX5MyyCR-n8ud_A3zUAhyJJAaXxBA3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36526 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaIVKE6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:04:58 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBisG3f4fm3bw2NfX5MyyCR-n8ud_A3zUAhyJJAaXxBA3Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 22, 2014 at 11:54:57AM +0200, Arturo Borrero Gonzalez wrote=
:
> On 19 September 2014 13:25, Patrick McHardy <kaber@trash.net> wrote:
> > On Fri, Sep 19, 2014 at 11:49:02AM +0200, Arturo Borrero Gonzalez w=
rote:
> >> Hi,
> >>
> >> the -nnn switch in in nftables is IMO a bit annoying.
> >> We are bounded to use that switch in every serious usage of nft.
> >>
> >> Let me remember the current behaviour:
> >>
> >>  -n -> don't translate IP addresses to names.
> >>  -nn -> also, don't translate gids/uids to names.
> >>  -nnn -> also, don't translate port numbers to names.
> >> default -> translate all numbers to names.
> >>
> >> I propose here that before nftables goes absolutely mainstream we
> >> change the behaviour to the opposite:
> >>
> >> -n -> translate IP addresses to names.
> >> -nn -> translate gids/uids to names.
> >> -nnn -> translate port numbers to names.
> >> default -> show all numerically.
> >>
> >> What do you think?
> >
> > That seems quite counter intuitive. I'd say the default should be n=
ot
> > to cause any network traffic for a regular system (not using LDAP o=
r
> > whatever), which would be -n. So I would be fine with -n being the
> > default and adding an option to also translate hostnames.
>=20
> So, your proposal is to make the current '-n' the default? This is
> what I've understood:
>=20
> =B7 default (no -n given): show IP addresses (no DNS names), show GID
> names, port names
> =B7 -n: show DNS names, show GID names, port names
> =B7 -nn: show DNS names, show GID numbers, port names
> =B7 -nnn: show DNS names, show GID numbers, port numbers
>=20
> That seems pretty counter intuitive to me, actually.
>=20
> Whit that combination of options you can't show all numerically, whic=
h
> I think it should be the default in fact.

No, the -n option keeps its meaning, we default to -n and add an
option to counter it, lets say -N for this example.

No options or -n would be similar, -nn and -nnn would keep its meaning.
-N would counter the default and be like the current behaviour.

Translating local information like user and service names is very usefu=
l
in my opinion and I'd like to keep it the default.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
