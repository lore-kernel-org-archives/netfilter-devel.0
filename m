From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Opinion on patch?
Date: Mon, 16 Sep 2002 20:15:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020916201518.Q3810@sunbeam.de.gnumonks.org>
References: <638AA0336D7ED411928700D0B7B0D75B03053C91@aimail.aiinet.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Eh7AbS6M0l/kYwqY"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Eble, Dan" <DanE@aiinet.com>
Content-Disposition: inline
In-Reply-To: <638AA0336D7ED411928700D0B7B0D75B03053C91@aimail.aiinet.com>; from DanE@aiinet.com on Mon, Sep 16, 2002 at 01:22:00PM -0400
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Eh7AbS6M0l/kYwqY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 16, 2002 at 01:22:00PM -0400, Eble, Dan wrote:
> Do you have an opinion on my patch to allow indexing rules in a chain by
> negative numbers?  It has been several days, and so far no one has
> responded--not even with "Oh, that's so stupid... who would ever want tha=
t?"

I've read the mail and did a quick read over the code.  From a technical po=
int
of view it looks fine.  But then, however, I don't really see the necessity
for inclusion of this patch.

=46rom my point of view, it's not really a feature of which I think it is n=
eeded
for most people - and if it really isn't (since no discussion happened and=
=20
I've not seen a single user proposing it's inclusion on the list), I think
we should not include it to prevent featurism/featuritis.

However, as always, this is my personal opinion and I'm open to discussion.

> Dan Eble <dane@aiinet.com>           _____  .

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

--Eh7AbS6M0l/kYwqY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9hh+2XaXGVTD0i/8RAlFhAJ0YSlH4uudAOjr9q64de4uN9RonbQCffJae
LWSxjlRcBlroLq4+lwR3QU4=
=5bQF
-----END PGP SIGNATURE-----

--Eh7AbS6M0l/kYwqY--
