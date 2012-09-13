From: Pablo Neira Ayuso <pablo@gnumonks.org>
Subject: Re: ulogd syslogemu output garbage after kernel update (32 to
 64bit)
Date: Thu, 13 Sep 2012 13:09:55 +0200
Message-ID: <20120913110955.GA3914@1984>
References: <9F69795E29C890408AC2DAF646C89BB379DA5476A8@MAILBOX.arc.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Fiedler Roman <Roman.Fiedler@ait.ac.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48802 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927Ab2IMLKA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:10:00 -0400
Content-Disposition: inline
In-Reply-To: <9F69795E29C890408AC2DAF646C89BB379DA5476A8@MAILBOX.arc.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 13, 2012 at 09:42:24AM +0200, Fiedler Roman wrote:
> > -----Urspr=FCngliche Nachricht-----
> > Von: Fiedler Roman
> > Gesendet: Montag, 10. September 2012 08:37
> > An: netfilter-devel@vger.kernel.org
> > Betreff: ulogd syslogemu output garbage after kernel update (32 to =
64bit)
> >=20
> > Hello list,
> >=20
> > In short: Could 32-bit ulogd run on 64-bit kernel without failing?
>=20
> Has any one an educated guess, if that could work? Are netlink data-s=
tructures machine-arch dependent and hence a 32-bit ulogd cannot proces=
s a 64-bit netlink message?

Netlink is aligned to 32-bits, no matter if arch is 32-bits/64-bits.
So the short answer is yes, it should work.

You'll have to debug this issue further if you want us to help.

Moreover, as Jozsef mentioned, we're targeting to ulogd2. Consider
that ulogd has entered EOL.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
