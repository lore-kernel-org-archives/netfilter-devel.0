From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Avoid using freed memory in iptables.c
Date: Fri, 29 Jul 2005 15:09:45 +0200
Message-ID: <20050729130945.GF7063@rama.de.gnumonks.org>
References: <20050710150548.GK20465@sunbeam.de.gnumonks.org>
	<42D90485.5050603@ingate.com> <42DBD081.8080408@ingate.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jkO+KyKz7TfD21mV"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
Content-Disposition: inline
In-Reply-To: <42DBD081.8080408@ingate.com>
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


--jkO+KyKz7TfD21mV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 18, 2005 at 05:53:37PM +0200, Marcus Sundberg wrote:
> The call to free_opts() in merge_options() is invalid C. The oldopts
> argument always refers to the memory pointed to by the opts global,
> which may be freed by the call to free_opts(), but oldopts is used
> after the free_opts() call. This patch makes sure we don't use freed
> memory.

thanks, I finally merged your important fix today (and also fixed
ip6tables.c).  I think iptables-1.3.3 should be released any day now.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jkO+KyKz7TfD21mV
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC6iqZXaXGVTD0i/8RApxPAJ96u+kWmwvSWl399gftj6TzI8UI/QCbB4Bz
wzha2/96/fZGB7MnYxDdnzE=
=CfLH
-----END PGP SIGNATURE-----

--jkO+KyKz7TfD21mV--
