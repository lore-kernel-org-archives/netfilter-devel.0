From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 3/3] NETFILTER: New PPTP helper
Date: Sat, 17 Sep 2005 20:33:21 +0200
Message-ID: <20050917183321.GF8413@sunbeam.de.gnumonks.org>
References: <20050915145406.GC17121@rama.de.gnumonks.org>
	<4329F94E.4060107@trash.net>
	<20050916091548.GO5034@sunbeam.de.gnumonks.org>
	<20050916.154556.116608678.davem@davemloft.net>
	<20050916225131.GS8413@sunbeam.de.gnumonks.org>
	<432C443C.5010101@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NTDLp0XeCpa8ZytR"
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <432C443C.5010101@trash.net>
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


--NTDLp0XeCpa8ZytR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 17, 2005 at 06:28:44PM +0200, Patrick McHardy wrote:
> So maybe a heads-up one or two days before submission would help.=20

ok, I'll try that.

> Anyway, I was just writing a mail including some more suggestions when
> Dave applied the patch. I'll go over the patch again later and send
> you my remaining suggestions.

Ok, in case you're interested in the latest code (confirmed to work in
my testcases) including all 8 of your patches, please check my
netfilter-2.6.14 tree (loacal "pptp" branch) on people.netfilter.org.

I'll wait for your remaining suggestions and only submit to davem after
that.

I've noticed that Dave's tree already contains my original pptp patch.
Dave: Do you want me to submit one big incremental patch to your tree,
or rather a patch against current torvalds/linux-2.6.git ?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--NTDLp0XeCpa8ZytR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDLGFxXaXGVTD0i/8RAnLWAJ9EJi9mtPKkhDcU5n5wx6gkyqQurACffd/V
VLmmky1L4jLDUBm/vka/4r8=
=cvG/
-----END PGP SIGNATURE-----

--NTDLp0XeCpa8ZytR--
