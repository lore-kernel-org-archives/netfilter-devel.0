From: Harald Welte <laforge@netfilter.org>
Subject: Re: raw table breaks iptables binary compatibility
Date: Sun, 9 Nov 2003 10:35:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031109093556.GC1005@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0311090204280.25676-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311090204280.25676-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 09, 2003 at 02:12:43AM +0100, Henrik Nordstrom wrote:
> This is a followup to the message I sent on 30 Oct after noticing binary=
=20
> compatibility with older iptables releases was broken after applying=20
> p-o-m/base.
>=20
> Other unrelated events has identified this being due to the raw table
> patch. This patch modifies ipt_entry by adding two more fields and this
> totally breaks binary compatibility with iptables binaries compiled for
> kernels with/without the raw table.
>=20
> linux-2.4.22-log/include/linux/netfilter_ipv4/ip_tables.h=20
> linux-2.4.22-raw/include/linux/netfilter_ipv4/ip_tables.h
> --- linux-2.4.22-log/include/linux/netfilter_ipv4/ip_tables.h   2003-09-1=
7=20
> 17:15:00.000000000 +0200
> +++ linux-2.4.22-raw/include/linux/netfilter_ipv4/ip_tables.h   2003-09-2=
8=20
> 14:19:16.000000000 +0200
> @@ -134,6 +134,12 @@
>         /* Back pointer */
>         unsigned int comefrom;
>=20
> +       /* Name of the chain */
> +       char *chainname;
> +      =20
> +       /* Rule number in the chain. */
> +       u_int32_t rulenum;
> +
>         /* Packet and byte counters. */
>         struct ipt_counters counters;

btw: isn't there a way we can do this without compatibility issues?
Can't we put this information into an additional 'magic' matchinfo
struct?  one that doesn't really match anything, but gets automatically
added (and filled in) for every rule?

I doubt the rule-number tracing will be used in a lot of setups - and
this way we could make it run-time configurable.  Something like a
global iptables parameter (iptables -A INPUT -T .....) where '-T' means
'insert a hidden trace matchinfo for rulenumber and chainname'.

Jozsef, what do you think?

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/rgp8XaXGVTD0i/8RAgtmAJ45UW7v4rV+8K73T6oP5eoDKt8xgwCfT80O
X6ehB0crjLgb+hlDVv3tzik=
=tHpH
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
