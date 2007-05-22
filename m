From: Phil Dibowitz <phil@ipom.com>
Subject: Re: Developing a user space library for filtering
Date: Tue, 22 May 2007 14:14:04 -0700
Message-ID: <20070522211404.GC24990@ipom.com>
References: <46521CB9.2040309@Sun.COM> <46522166.1090603@gmx.net>
	<465222C0.8050601@Sun.COM>
	<Pine.LNX.4.61.0705220826110.4452@yvahk01.tjqt.qr>
	<20070522064613.GA27619@oknodo.bof.de> <4653578C.3070407@Sun.COM>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Cc: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>,
	netfilter-devel@lists.netfilter.org, Patrick Schaaf <bof@bof.de>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Darren.Reed@Sun.COM
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <4653578C.3070407@Sun.COM>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 22, 2007 at 01:50:20PM -0700, Darren.Reed@Sun.COM wrote:
> Patrick Schaaf wrote:
>=20
> >...
> >Anyway, regarding the original request, I don't think it is sensible to
> >expect from netfilter developers to invent such a library, especially
> >when the scope is desired to be abstracting from netfilter.
> >
>=20
> At this point in time, I was looking for people who might be interested
> in helping design such an API.  In the end, what I'm hoping for is to
> have a common API delivered as part of OpenSolaris as well as both
> FreeBSD and NetBSD.  Given that it's still being drafted, I'm opening
> the door and asking if there is anyone from Linux who's interested in
> participating.  I should point out that I'm not interested in requesting
> anyone here write code that isn't [L]GPL'd.

Actually the netfilter folks wrote an entire infrastructure for just this
purpose.

netfilter is a generic infrastructure for firewall software with a defined
kernel-user API and they're now writing many libraries on top of that.

My software, iptstate, uses libnetfilter-conntrack, which is built upon the
netfilter framework.

All this is not to be confused with iptables, which is simply an implmentat=
ion
of netfilter coincidentally written by the same people who write the netfil=
ter
framework.

Or so I understand it.

> None of those 3 options are what I would call palatable.
>=20
> Imagine if everytime a new glibc was delivered you needed to
> recompile all of your programs, from ls all the way through to the
> X server, or...

Darren, you're correct, this is definitely needed. If IPF and IPtables and
everyone else all used a common core kernel-userspace API, with a standard
library on top of it, that would be awesome.

Netfilter brings a lot of of this to the table, but the people involved in
writing the specs mostly worked on ipchains, and iptables, so they may have
made linux-specific assumptions without realizing it - but it was very much
purposed to be OS-agnostic.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming


--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGU10cN5XoxaHnMrsRAsaOAJ4ofeZf068ha/Rc9OyQbnXmb8KvvACcDxSr
ojwE6Ux2z4w0F9+w7M3NXdc=
=l+eG
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
