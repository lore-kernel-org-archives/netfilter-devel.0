From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 12:44:47 +0200
Message-ID: <20051011104446.GJ4290@rama>
References: <20051010164141.GG5627@rama>
	<20051010.141518.60492651.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X+nYw8KZ/oNxZ8JS"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>, bdschuym@pandora.be
Content-Disposition: inline
In-Reply-To: <20051010.141518.60492651.davem@davemloft.net>
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


--X+nYw8KZ/oNxZ8JS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2005 at 02:15:18PM -0700, David S. Miller wrote:
> From: Harald Welte <laforge@netfilter.org>
> Date: Mon, 10 Oct 2005 18:41:41 +0200
>=20
> > This is my proposed patch for the problem you've described.  Please test
> > and submit.  If it works, I'll also prepare a patch for {arp,ip6}_table=
s.
>=20
> Ebtables needs it too.  "git grep num_possible_cpus" shows all
> of the users in the whole tree, %80 of which are the netfilter
> cases we're fixing here :-)

mh. I'm not very familiar with the ebtables specific changes, and
apparently it differs quite a bit in counter handling.

Anyway, I've tried to come up with a patch that also includes ebtables.

Bart: Could you please comment on it? If you have missed the previous
thread: some systems have smp processor id's "0 2" but no "1", e.g.
num_possible_cpus() is 2 (and we allocate two rulesets), but then we try
to index it with '2', e.g. the non-existing 3rd copy.

Unfortunately I don't have a SMP box during travel, so I can't test
whether it at least still works on 'normal' smp boxes.  So all I can say
is that it looks right, and it compiles with CONFIG_SMP.

Please, could anybody test this on their SMP boxes ASAP?   I won't be
having access to a SMP machine for testing until 2005-10-18, and
presumably we don't want to delay this fix.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--X+nYw8KZ/oNxZ8JS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDS5eeXaXGVTD0i/8RAmMWAJ9QRBXGIfWydb9CnANePDLT1Pq0TwCfS2Zh
tsnb2jLaYaWKjmeL++zzm+4=
=o14E
-----END PGP SIGNATURE-----

--X+nYw8KZ/oNxZ8JS--
