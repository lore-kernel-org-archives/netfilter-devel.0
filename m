From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Fri, 30 May 2003 21:43:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030530194342.GJ29312@sunbeam.de.gnumonks.org>
References: <200305290113.58552.prez@srealm.net.au> <20030529083953.GB2461@sunbeam.de.gnumonks.org> <525377312.20030530134441@netfids.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tT3UgwmDxwvOMqfu"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Geffrey Velasquez <g_netfilter@netfids.com>
Content-Disposition: inline
In-Reply-To: <525377312.20030530134441@netfids.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tT3UgwmDxwvOMqfu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2003 at 01:44:41PM +0200, Geffrey Velasquez wrote:
> Hi Harald according with this email... It is not recomendable to use
> Kernel 2.4.20. But RH Linux 9.0 comes with this kernel version, it
> means that I should not use this kernel too? or maybe RH had fix this
> problem?

according to my information (I've been talking with davem before rh9 was
released), they already have the fix in the kernel.

In any doubt, just install the srpm and look through the patches...

> Regards,
> Geffrey

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tT3UgwmDxwvOMqfu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+17RuXaXGVTD0i/8RAqDPAKCDP7U0sblc8JOOqYjw1GZLUs0VvgCeNgvG
9OptYq2wbFsIkZJx4MBPmc4=
=nGtw
-----END PGP SIGNATURE-----

--tT3UgwmDxwvOMqfu--
