From: Harald Welte <laforge@gnumonks.org>
Subject: Re: how you use nfnetlink-ctnetlink-0.11.patch
Date: Wed, 23 Oct 2002 17:52:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021023175207.Q2450@sunbeam.de.gnumonks.org>
References: <1034286048.25146.40.camel@tux> <Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu> <20021012141737.X13233@sunbeam.de.gnumonks.org> <1034428150.7595.36.camel@tux> <1034429352.7595.48.camel@tux> <20021012163620.C13233@sunbeam.de.gnumonks.org> <1034436775.7595.96.camel@tux> <1035386196.1736.242.camel@gt4rvnd11.telogy.design.ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9kwpIYUMbI/2cCx"
Cc: jschlst@samba.org,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: marian stagarescu <marian@ti.com>
Content-Disposition: inline
In-Reply-To: <1035386196.1736.242.camel@gt4rvnd11.telogy.design.ti.com>; from marian@ti.com on Wed, Oct 23, 2002 at 11:16:36AM -0400
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--M9kwpIYUMbI/2cCx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 23, 2002 at 11:16:36AM -0400, marian stagarescu wrote:
> can someone give me some input on this patch:=20
> stability and how to use it ?=20
> sometime ago i was looking for a way to flush individual conntrack
> entries. i think this patch may let me access conntrack entries and, for
> example, set their TTL to 0 so that it can be flushed. but i'm not user
> how to use it: does it have a corresponding userland iptables part ?

It has a userspace library, called libctnetlink (see our cvs tree or
http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter/iptables2/libctnetlink/

This library has an example program, called 'ctnltest.c'

> thanks,
> marian

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--M9kwpIYUMbI/2cCx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9tsWmXaXGVTD0i/8RAgKaAJ0bqmcVki2MV1CakRFECBGZBx1+HQCfb8iB
nHVWN3zGt4n1accJBDiFbK0=
=AJ8P
-----END PGP SIGNATURE-----

--M9kwpIYUMbI/2cCx--
