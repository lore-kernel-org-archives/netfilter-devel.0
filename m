From: Eric Leblond <eric@regit.org>
Subject: Re: ulogd's SQLITE3 "buffer" option
Date: Fri, 01 Jan 2016 11:04:25 +0100
Message-ID: <1451642665.5359.17.camel@regit.org>
References: <20151229183831.0ff29890@alex-desktop>
	 <20151230001905.GA1700@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Alex Xu <alex_y_xu@yahoo.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:42640 "EHLO home.regit.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbcAAK2k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jan 2016 05:28:40 -0500
In-Reply-To: <20151230001905.GA1700@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Wed, 2015-12-30 at 01:19 +0100, Pablo Neira Ayuso wrote:
> On Tue, Dec 29, 2015 at 06:38:31PM -0500, Alex Xu wrote:
> > I was attempting to configure sqlite3 output in ulogd and could not
> > determine the function of the "buffer" configuration option.
> >=20
> > $ grep buffer output/sqlite3/ulogd_output_sqlite3.c
> > =A0=A0=A0=A0=A0=A0=A0=A0int buffer_size;
> > =A0=A0=A0=A0=A0=A0=A0=A0int buffer_curr;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0.key =3D "buffer",
> > #define buffer_ce(pi)=A0=A0=A0(pi)->config_kset->ces[2].u.value
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0priv->buffer_curr++=
;
> > =A0=A0=A0=A0=A0=A0=A0=A0/* initialize our buffer size and counter *=
/
> > =A0=A0=A0=A0=A0=A0=A0=A0priv->buffer_size =3D buffer_ce(pi);
> > =A0=A0=A0=A0=A0=A0=A0=A0priv->buffer_curr =3D 0;
> > $ grep -rF buffer_curr .
> > output/sqlite3/ulogd_output_SQLITE3.c:=A0=A0int buffer_curr;
> > output/sqlite3/ulogd_output_SQLITE3.c:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
priv-
> > >buffer_curr++;
> > output/sqlite3/ulogd_output_SQLITE3.c:=A0=A0priv->buffer_curr =3D 0=
;
> >=20
> > Now, it is quite likely that I am missing something, but it would
> > appear that buffer_curr is never actually *read*, only *written*,
> > and it's a basic fact of programming that a variable can have no
> > effect
> > if it is never read from. [citation needed]
> >=20
> > It would appear that the original code in ulogd-1.x employed a
> > 'buffer'
> > which was actually a counter for when to tell sqlite to sync to
> > disk.
> > When the code was rewritten by "Holger" and committed by Pablo
> > Neira
> > Ayuso (8f7bb61), the syncing part was removed but the buffer
> > variable
> > was simply renamed.
> >=20
> > Nobody noticed because one fsync every few seconds is tiny.
> >=20
> > Therefore, I think we should remove the "buffer" option entirely.
> >=20
> > Thoughts? I will send a patch if there are no objections.
>=20
> This may be well a leftover that was introduced by when that large
> rewrite took, please submit a patch that we can review.

Agree on diagnostic, it seems unused in current version of the code.
Waiting for the patch.

Happy new year to all,
--=20
Eric Leblond <eric@regit.org>


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
