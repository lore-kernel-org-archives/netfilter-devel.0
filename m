From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 09/11] db: add ring buffer for DB query
Date: Sun, 12 May 2013 12:29:29 +0200
Message-ID: <1368354569.22387.48.camel@ice-age.regit.org>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
	 <1368168538-29780-10-git-send-email-eric@regit.org>
	 <20130511192922.GA10791@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-t7XmpplXQ/xOu2TxJGnV"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:38742 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3ELK3h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 May 2013 06:29:37 -0400
In-Reply-To: <20130511192922.GA10791@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-t7XmpplXQ/xOu2TxJGnV
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Le samedi 11 mai 2013 =E0 21:29 +0200, Pablo Neira Ayuso a =E9crit :
> Hi Eric,
>=20
> On Fri, May 10, 2013 at 08:48:56AM +0200, Eric Leblond wrote:
> > This patch adds an optional ring buffer option which modify
> > the way database queries are made. The main thread is only handling
> > kernel message reading and query formatting. The SQL request is made
> > in a separate dedicated thread.
> > The idea is to try to avoid buffer overrun by minimizing the time
> > requested to treat kernel message. Doing synchronous SQL request, as
> > it was made before was causing a delay which could cause some messages
> > to be lost in case of burst from kernel side.
>=20
> Would be feasible to make asynchronous SQL requests instead, so you
> can skip the use of pthread?

That is an excellent question :)

Here's a list of points. From the small to big one.

=46rom a performance point of view, ulogd will still be slow down by the
request time due to the network communication with the db . I think the
effect is really negligible but may have an impact in the case of
distant db.

=46rom a lazy point of view, this would require to update all the database
backends instead of simply updating the db abstraction layer as it is
done with the proposed patch.

Regarding the use of asynchronous request, I've always stop trying using
them after reading the doc. So I've got no practical experience here and
correct someone correct me if I'm wrong. What I've understood is that
there is no "take my query and just do your work" function. Application
has to get the result to the query and free them.

For example, let's have a look at postgresql case. The doc on
asynchronous API is here:
http://www.postgresql.org/docs/6.4/static/libpq-chapter17044.htm

Here's an interesting part of the documentation:
       =20
        PQsendQuery: Submit a query to Postgres without waiting for the
        result(s). TRUE is returned if the query was successfully
        dispatched, FALSE if not (in which case, use PQerrorMessage to
        get more information about the failure).
        After successfully calling PQsendQuery, call PQgetResult one or
        more times to obtain the query results. PQsendQuery may not be
        called again (on the same connection) until PQgetResult has
        returned NULL, indicating that the query is done.

On other interesting point regarding PQgetResult:

        Don't forget to free each result object with PQclear when done
        with it.

So, the modification would involve doing query with PQsendQuery and
repeatedly call the PQgetResult function to get the result and be able
to free it with PQclear.

I think this system does not really fit with ulogd task which consists
in multiple short queries. It is far more adapted for long queries and
for GUI using them as ulogd will continuously be calling PQgetResult to
free result it will not use. So, it is complicated and does not seem
really adapted.

Here's the points that make me consider using thread instead of
asynchronous call.

BR,
--
Eric


--=-t7XmpplXQ/xOu2TxJGnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBRj28JnxA7CdMWjzIRAsGWAJ9ZR4uuP/zRAvqRgRILswdI8jXl7QCfUJ2f
glQY8BZbJqEyUXVz3Vodmao=
=nYsp
-----END PGP SIGNATURE-----

--=-t7XmpplXQ/xOu2TxJGnV--

