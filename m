From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables redirect is broken on bridged setup
Date: Sun, 31 Jul 2005 12:42:53 +0200
Message-ID: <20050731104253.GG14874@rama.de.gnumonks.org>
References: <200507291209.37247.vda@ilport.com.ua>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B8ONY/mu/bqBak9m"
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Denis Vlasenko <vda@ilport.com.ua>
Content-Disposition: inline
In-Reply-To: <200507291209.37247.vda@ilport.com.ua>
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


--B8ONY/mu/bqBak9m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[removed a number of unneccessarry CC's from list]

On Fri, Jul 29, 2005 at 12:11:52PM +0300, Denis Vlasenko wrote:
> Linux 2.6.12

Denis, your bug is not getting fixed faster, no matter how often you
will post it at how many places and to how many recipients.  We have
seen it, and we will look at it.=20

bridging and netfilter/iptables is always a very tricky case, and the
code was developed by separate groups who - as it is my impression -
don't fully understand each others codebase too well.  Also, many of the
possible combinations of bridging and netfilter/iptables have apparently
not been tested (or even used by anyone), so I'm not surprised that you
see some unexpected behaviour.

Also, the bridging/ebtables maintainer Bart de Schuymer is currently on
holidays, as I understand.

So please be patient.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--B8ONY/mu/bqBak9m
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC7KssXaXGVTD0i/8RAh98AJ0ZP1lFIoEi40M2ZCead5Ed5O603ACgqfGW
69jY3YnTj/ChYeEwgCgB6bg=
=/1Dh
-----END PGP SIGNATURE-----

--B8ONY/mu/bqBak9m--
