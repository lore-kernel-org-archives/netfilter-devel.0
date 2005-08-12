From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] message parsing functions for nfqueue
Date: Fri, 12 Aug 2005 14:41:58 +0200
Message-ID: <20050812124158.GH16325@rama.de.gnumonks.org>
References: <1123794106.4980.11.camel@porky>
	<20050811224813.GU5353@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gdTfX7fkYsEEjebm"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>, Vincent Deffontaines <vincent@inl.fr>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Thomas Graf <tgraf@suug.ch>
Content-Disposition: inline
In-Reply-To: <20050811224813.GU5353@rama.de.gnumonks.org>
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


--gdTfX7fkYsEEjebm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[added Thomas Graf to Cc list, please see bottom of this mail]

On Fri, Aug 12, 2005 at 12:48:13AM +0200, Harald Welte wrote:
> On Thu, Aug 11, 2005 at 11:01:46PM +0200, Eric Leblond wrote:
> > Hi,
> >=20
> > This is a patch against libnfnetlink_queue.
>=20
> At the first sight, the patch looks fine to me.  I'll look at it in
> detail over the weekend.
>=20
> Oh. One thing that comes to my mind is "get_{in,out}dev" don't return a
> device [name], but ifindex.  that should be reflected in the names.
>=20
> Also, I think we should implement some common ifindex<->devicename
> mapping/resolval code.  This could be part of libnfnetlink (but be put
> into a separate source code file).
>=20
> IMHO, all required information can be accessed via netlink.  I've once
> written some code for caching the ifindex<->devicename in userspace (it
> receives rtnetlink events of ifup/ifdown messages and keeps the cache in
> sync).  I'll try to locate that code.

Ok, located it (and got permission to put it under GPL).  It's now in
https://svn.netfilter.org/netfilter/trunk/libnfnetlink/src/{rtnl,iftable}.{=
c,h}

I'm not going to have the time to work on this before I'll get back from
my holidays on Aug 26.  So whoever wants to dig into this, feel free to
go ahead.

One problem, though, is how we will integrate that functionality with
the rest of the application.  In order to receive the ifup/ifdown/...
events by rtnetlink, the main application needs to select() on yet
another filedescriptor - and call some rtnl message handling function.

One idea was ot skip the event messages and only poll the kernel every
time the application requests it. Somthing like

iftable_cache_fill(void)
	- read out a list of ifindex<->devicename mappings
iftable_cache_lookup(int ifindex)
	- lookup devname for given ifindex
iftable_lookup(int ifindex)
	- lookup directly, bypassing the cache.

This time the app would have to call iftable_cache_fill() every so
often.  It's not very elegant. =20

In the end, this really belongs into yet-another netlink-related
library.  Something like librtnetlink.  Maybe Thomas can help us if
there is something that we could use.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gdTfX7fkYsEEjebm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC/JkVXaXGVTD0i/8RAiQ5AJoCcz/X5fdyd94K3peoO1rS+QMExQCbB7d3
23x5Zq8UKlA3ng++l12yAN8=
=s1dF
-----END PGP SIGNATURE-----

--gdTfX7fkYsEEjebm--
