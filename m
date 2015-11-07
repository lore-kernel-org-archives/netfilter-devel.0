From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -stable,4.3.y] netfilter: xt_TEE: fix NULL dereference
Date: Sat, 7 Nov 2015 17:39:37 +0100
Message-ID: <20151107163937.GA1356@salvia>
References: <1446813886-5632-1-git-send-email-pablo@netfilter.org>
 <1446813886-5632-2-git-send-email-pablo@netfilter.org>
 <20151106170934.GC24185@kroah.com>
 <20151106172626.GB1357@salvia>
 <1446912242.6006.93.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Greg KH <greg@kroah.com>, netfilter-devel@vger.kernel.org,
	stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45591 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbbKGQcN convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Nov 2015 11:32:13 -0500
Content-Disposition: inline
In-Reply-To: <1446912242.6006.93.camel@decadent.org.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 07, 2015 at 04:04:02PM +0000, Ben Hutchings wrote:
> On Fri, 2015-11-06 at 18:26 +0100, Pablo Neira Ayuso wrote:
> > On Fri, Nov 06, 2015 at 09:09:34AM -0800, Greg KH wrote:
> > > On Fri, Nov 06, 2015 at 01:44:44PM +0100, Pablo Neira Ayuso wrote=
:
> > > > From: Eric Dumazet <edumazet@google.com>
> > > >=20
> > > > [ upstream commit 45efccdbec3cd465c4776ed9ca1d7b1bba1b7e34 ]
> > > >=20
> > >=20
> > > Not a valid commit id :(
> >=20
> > Same thing:
> >=20
> > http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?i=
d=3D
> > 45efccdbec3cd465c4776ed9ca1d7b1bba1b7e34
>=20
> But it's not in mainline yet. =A0You should re-submit to stable once =
it
> is.

Will do and will update my scripts to avoid this race again.

Thanks Ben.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
