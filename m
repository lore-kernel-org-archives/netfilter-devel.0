From: Harald Welte <laforge@netfilter.org>
Subject: Re: 12_contrack_nat_dependency.patch
Date: Fri, 28 Mar 2003 13:09:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030328120953.GX25471@sunbeam.de.gnumonks.org>
References: <1048630711.14738.71.camel@tux.rsn.bth.se> <20030327041148.0DA5E2C056@lists.samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yPSgZSQ6mfPWgZ9n"
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <20030327041148.0DA5E2C056@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--yPSgZSQ6mfPWgZ9n
Content-Type: multipart/mixed; boundary="XFI+TFG+M3u0jUjZ"
Content-Disposition: inline


--XFI+TFG+M3u0jUjZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 27, 2003 at 01:24:39PM +1100, Rusty Russell wrote:
> In message <1048630711.14738.71.camel@tux.rsn.bth.se> you write:
> > Hi Rusty,
> >=20
> > I have a question about the 12_contrack_nat_dependency.patch in
> > p-o-m/pending...
> >=20
> > The patch you sent Harald was for 2.5, will a similar patch work for
> > 2.4? I've backported it and it compiles but I can't really test it.
>=20
> Yep, should be fine.  It has a flaw though for UP, in that relying on
> the lock is not sufficient.

I have removed the patch from patch-o-matic now.=20

> Harald and I are arguing it now; I'll tell you the answer when we
> have it.

We should have argued on netfilter-devel.

Anyway, I'll attach the outcome of our little argument here :)

> Rusty.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XFI+TFG+M3u0jUjZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=r
Content-Transfer-Encoding: quoted-printable

=46rom X-Sieve Thu Mar 27 05:15:01 2003
Return-Path:X-Sieve: cmu-sieve 2.0
Return-path: <netfilter-core-admin@lists.netfilter.org>
Received: from mail by coruscant.gnumonks.org with spam-scanned (Exim 3.34 =
#1)
	id 18yOn7-0007Ku-00
	for laforge@gnumonks.org; Thu, 27 Mar 2003 05:15:01 +0100
Received: from netfilter-sponsored-by.noris.net ([62.128.28.62] helo=3Dkash=
yyyk.netfilter.org)
	by coruscant.gnumonks.org with esmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 3.34 #1)
	id 18yOn5-0007Kl-00
	for laforge@gnumonks.org; Thu, 27 Mar 2003 05:15:00 +0100
Received: from kashyyyk ([127.0.0.1])
	by kashyyyk.netfilter.org with esmtp (Exim 3.35 #1 (Debian))
	id 18yOkG-00056u-00
	for <laforge@gnumonks.org>; Thu, 27 Mar 2003 05:12:04 +0100
Received: from dp.samba.org ([66.70.73.150] helo=3Dlists.samba.org)
	by kashyyyk.netfilter.org with esmtp (Exim 3.35 #1 (Debian))
	id 18yOk5-00052G-00; Thu, 27 Mar 2003 05:11:53 +0100
Received: by lists.samba.org (Postfix, from userid 590)
	id 15D292C06E; Thu, 27 Mar 2003 04:11:48 +0000 (GMT)
From: Rusty Russell <rusty@rustcorp.com.au>
To: Harald Welte <laforge@netfilter.org>
Cc: coreteam@netfilter.org
Subject: Re: [netfilter-core] Re: ip_nat_helper: Autoloading of protocol co=
nntrack modules=20
In-reply-to: Your message of "Wed, 26 Mar 2003 08:56:31 BST."
             <20030326075631.GB21953@sunbeam.de.gnumonks.org>=20
Message-Id: <20030327041148.15D292C06E@lists.samba.org>
Sender: netfilter-core-admin@lists.netfilter.org
Errors-To: netfilter-core-admin@lists.netfilter.org
X-BeenThere: netfilter-core@lists.netfilter.org
X-Mailman-Version: 2.0.11
Precedence: bulk
List-Help: <mailto:netfilter-core-request@lists.netfilter.org?subject=3Dhel=
p>
List-Post: <mailto:netfilter-core@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-cor=
e>,
	<mailto:netfilter-core-request@lists.netfilter.org?subject=3Dsubscribe>
List-Id: List for core team members of the netfilter project <netfilter-cor=
e.lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-c=
ore>,
	<mailto:netfilter-core-request@lists.netfilter.org?subject=3Dunsubscribe>
List-Archive: <https://lists.netfilter.org/cgi-bin/mailman/private/netfilte=
r-core/>
Date: Thu, 27 Mar 2003 13:30:37 +1100
Status: RO
X-Status: A
Content-Length: 1042

In message <20030326075631.GB21953@sunbeam.de.gnumonks.org> you write:
> On the other hand, adding the dummy function is just a hack, and I think
> it's way easier to do this wrong [from a module author's perspective],
> than specifying a flag in some structure while registering with the
> core.

I think that it's more explicit than the flag, myself.

> As stated before, is there a way we can 'magically hide' the dummy
> symbol, e.g. create it from some macro?  The only question is, how do we
> automagically create the name of a symbol derived from the filename...

How about:

/* eg. PROVIDES_CONNTRACK(ftp); */
#define PROVIDES_CONNTRACK(name)			\
	int needs_ip_conntrack_##name;			\
	EXPORT_SYMBOL(needs_ip_conntrack_##name)

/*. eg. NEEDS_CONNTRACK(ftp); */
#define NEEDS_CONNTRACK(name)						\
	extern int needs_ip_conntrack_##name;				\
	static int *need_ip_conntrack_##name =3D &needs_ip_conntrack_##name

These would be used at file scope...

Cheers,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.




--XFI+TFG+M3u0jUjZ--

--yPSgZSQ6mfPWgZ9n
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+hDuRXaXGVTD0i/8RAqGDAKCSXMG2p3O3zsHzqtDHK5QJ46nHDQCdGofw
XS/wc2pCFn2HQ62K23isbQE=
=6JtQ
-----END PGP SIGNATURE-----

--yPSgZSQ6mfPWgZ9n--
