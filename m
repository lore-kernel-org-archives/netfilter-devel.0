From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 3/3] NETFILTER: New PPTP helper
Date: Sun, 18 Sep 2005 11:14:22 +0200
Message-ID: <20050918091422.GH8413@sunbeam.de.gnumonks.org>
References: <20050915145406.GC17121@rama.de.gnumonks.org>
	<4329F94E.4060107@trash.net>
	<20050916091548.GO5034@sunbeam.de.gnumonks.org>
	<20050916.154556.116608678.davem@davemloft.net>
	<20050916225131.GS8413@sunbeam.de.gnumonks.org>
	<432C443C.5010101@trash.net>
	<20050917183321.GF8413@sunbeam.de.gnumonks.org>
	<432C6910.80905@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ApAmD002LHtYGJ+H"
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <432C6910.80905@trash.net>
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


--ApAmD002LHtYGJ+H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 17, 2005 at 09:05:52PM +0200, Patrick McHardy wrote:
> Harald Welte wrote:
> >On Sat, Sep 17, 2005 at 06:28:44PM +0200, Patrick McHardy wrote:
> >>Anyway, I was just writing a mail including some more suggestions when
> >>Dave applied the patch. I'll go over the patch again later and send
> >>you my remaining suggestions.
> >Ok, in case you're interested in the latest code (confirmed to work in
> >my testcases) including all 8 of your patches, please check my
> >netfilter-2.6.14 tree (loacal "pptp" branch) on people.netfilter.org.
>=20
> I tried cloning it using cogito, but get this error:

Are you sure you're not running an outdated cogito version?  At least
via rsync everything seems to work fine here:

cg-clone rsync://people.netfilter.org/users/laforge/scm/netfilter-2.6.14.gi=
t\#pptp
defaulting to local storage area
receiving file list ... done
pptp

sent 138 bytes  received 150 bytes  192.00 bytes/sec
total size is 41  speedup is 0.14
receiving file list ... done
progress: 7898 objects, 26077547 bytes, 99% done
progress: 7977 objects, 26276658 bytes, 100% done
info/
info/packs
pack/pack-011d837bd60b7e2544fa0f095ae4ca0d61c3c1ea.idx
pack/pack-011d837bd60b7e2544fa0f095ae4ca0d61c3c1ea.pack
pack/pack-be6bf83523a3a82fdff5544390a2dae7788bd0c8.idx
pack/pack-be6bf83523a3a82fdff5544390a2dae7788bd0c8.pack
pack/pack-c24bb5025e835a3d8733931ce7cc440f7bfbaaed.idx
pack/pack-c24bb5025e835a3d8733931ce7cc440f7bfbaaed.pack
pack/pack-c60dc6f7486e34043bd6861d6b2c0d21756dde76.idx
pack/pack-c60dc6f7486e34043bd6861d6b2c0d21756dde76.pack
pack/pack-e3117bbaf6a59cb53c3f6f0d9b17b9433f0e4135.idx
pack/pack-e3117bbaf6a59cb53c3f6f0d9b17b9433f0e4135.pack
pack/pack-eceba3479417b338c2e156b1c6dfd69f3f0eaad1.idx
pack/pack-eceba3479417b338c2e156b1c6dfd69f3f0eaad1.pack

sent 175896 bytes  received 217784838 bytes  232491.45 bytes/sec
total size is 216999773  speedup is 1.00
receiving file list ... done
v2.6.11
v2.6.11-tree
v2.6.12
v2.6.12-rc2
v2.6.12-rc3
v2.6.12-rc4
v2.6.12-rc5
v2.6.12-rc6
v2.6.13
v2.6.13-rc1
v2.6.13-rc2
v2.6.13-rc3
v2.6.13-rc4
v2.6.13-rc5
v2.6.13-rc6
v2.6.13-rc7
v2.6.14-rc1

sent 486 bytes  received 1765 bytes  1500.67 bytes/sec
total size is 697  speedup is 0.31
New branch: 4b2f955c1b41198c0deee48924f3100fa6131b5f
Cloned to netfilter-2.6.14.git#pptp/ (origin
rsync://people.netfilter.org/users/laforge/scm/netfilter-2.6.14.git#pptp
available as branch "origin")

> >I'll wait for your remaining suggestions and only submit to davem after
> >that.
>=20
> Please see my other mail. I hope I'm not too anoying, but I prefer
> to do these minor changes before submission because its often not
> worth the time for sending patches afterwards.

No, you're not annoying at all.  We just need to find a workflow that
creates as little overhead as possible.  (and yes, I wish I'd come up
with your fixes/suggestions myself, but that's apparently not going to
happen).

What about me posting the patches to netfilter-devel first.  Then I'll
wait for 3 days, and then I'll send them to Davem and cc netdev for
final submission?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ApAmD002LHtYGJ+H
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDLS/uXaXGVTD0i/8RAlduAJ0UTKtRXXgr37juhxYlpNwHjwc77gCeOzAJ
cjZP0lRh234uAGPFeCmewbQ=
=Fl0r
-----END PGP SIGNATURE-----

--ApAmD002LHtYGJ+H--
