From: Harald Welte <laforge@netfilter.org>
Subject: Re: Race Conditions
Date: Wed, 26 Feb 2003 18:33:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226173329.GK8883@sunbeam.de.gnumonks.org>
References: <20030220053722.24368.qmail@web13104.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdJFN6SSISdF2ksn"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: A K A <gello666@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20030220053722.24368.qmail@web13104.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--sdJFN6SSISdF2ksn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2003 at 09:37:22PM -0800, A K A wrote:
> I have developed a module and in the init_module
> function i register two functions to two hooks
> -NF_IP_LOCAL_IN and NF_IP_POST_ROUTING. In the two
> functions i am acesssing a global data structure. Is
> it possible for me to have race condition while
> accessing the data structure or can I be sure that
> while one function is executing another will not
> because they are both running at the same IRQ level
> which is below the schedular, and hence cannot
> interupt each other. Is this assumption correct.

no, you cannot.  All netfilter code needs to be SMP-safe and you can
have two threads in the same softirq context (netfilter runs in softirq
context).

> regards,
> Asad
=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--sdJFN6SSISdF2ksn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XPppXaXGVTD0i/8RAgj3AKC0Zp/5wWVgDXNy37QN4oCLER+MIACcC8eP
QLVHcBwGl7e0QRRFumoFD5I=
=K99T
-----END PGP SIGNATURE-----

--sdJFN6SSISdF2ksn--
