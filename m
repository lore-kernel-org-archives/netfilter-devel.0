From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] User defined udp and tcp conntrack state timeouts
Date: Thu, 19 Sep 2002 20:46:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020919204619.W3810@sunbeam.de.gnumonks.org>
References: <20020919084658.J3810@sunbeam.de.gnumonks.org> <Pine.LNX.4.44L.0209182252170.18297-101000@hunger.screamingdaemon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/knlCKogGKzIgL69"
Cc: Jay Schulist <jschulist@bivio.net>, Patrick Schaaf <bof@bof.de>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jay Schulist <jschlst@linux-sna.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L.0209182252170.18297-101000@hunger.screamingdaemon.com>; from jschlst@linux-sna.org on Wed, Sep 18, 2002 at 10:54:42PM -0700
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/knlCKogGKzIgL69
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2002 at 10:54:42PM -0700, Jay Schulist wrote:
> On Thu, 19 Sep 2002, Harald Welte wrote:
>=20
> > was impossible to have an architecture-independent /etc/sysctl.conf for=
 icmp
> > rate limiting - even user mode linux has a differrent HZ...
> >
> > I'm postponing this patch until the change was made.
> >
>=20
> Here is a new patch which does the conversion from jiffies to seconds for
> the user.

Again, another issue (sorry)...

There are _lots_ of changes between conntrack in 2.4.19 and conntrack in
current 2.4.20-preX (where X > 2) kernels.  Could you please merge your
patch with recent kernel?  If this is not possible, I will ask the=20
2.4.x-patchomatic-maintainers to do this job.

Thanks a lot.

> Thanks for the feedback,
> jay-s.



--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--/knlCKogGKzIgL69
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9iht6XaXGVTD0i/8RAvlMAKCL4RSaIRvYYXTTXnh/epW4OkLKvgCdFKBs
cHtLzKRutnHZKPjMc2j6JH8=
=ZFfs
-----END PGP SIGNATURE-----

--/knlCKogGKzIgL69--
