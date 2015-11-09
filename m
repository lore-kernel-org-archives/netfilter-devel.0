From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fwd: nft synproxy integration
Date: Mon, 9 Nov 2015 17:35:06 +0000
Message-ID: <20151109173506.GB9715@macbook.localdomain>
References: <20151109163015.GM8098@macbook.localdomain>
 <CAJO99T=4fjPkBTFEYuibGsHe=BfM0KRbhYkP_E_RPa49SUWeHg@mail.gmail.com>
 <CAJO99TkObg-JWwLaEAyAD9Z1xPsKR6YXFqVx2wcqVtAmW92+1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:50047 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751819AbbKIRfL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 12:35:11 -0500
Content-Disposition: inline
In-Reply-To: <CAJO99TkObg-JWwLaEAyAD9Z1xPsKR6YXFqVx2wcqVtAmW92+1A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.11, Bj=F8rnar Ness wrote:
> 2015-11-09 17:30 GMT+01:00 Patrick McHardy <kaber@trash.net>:
> >
>=20
> [ ... ]
>=20
> > Any thoughts about this?
>=20
> Could it be possible to automagically insert an "hiden notrack" for t=
he same
> packets the synproxy target matches when adding it?
>=20
> Ofcorse depends on what this cost really is in terms of performance, =
but I dont
> like the idea of sacrificing performance for a little easier use.
> Atleast not for this
> module, where the whole point of it beeing able to deal with big pps =
numbers

Problem is that the rule would need to apply to exactly the same packet=
s and
its in a different table, its hard to make sure that among updates and =
other
changes to the ruleset. So right now, no. As I mentioned, you could sti=
ll
manually notrack packets.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
