From: Harald Welte <laforge@netfilter.org>
Subject: Re: Question about reference count of expectations in 2.6.14 tree
Date: Thu, 11 Aug 2005 15:35:45 +0200
Message-ID: <20050811133545.GI4130@rama.de.gnumonks.org>
References: <200508100111.j7A1Bok9010084@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vdqwC0msT4ilQ2it"
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200508100111.j7A1Bok9010084@toshiba.co.jp>
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


--vdqwC0msT4ilQ2it
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 10, 2005 at 10:11:49AM +0900, Yasuyuki KOZAKAI wrote:
>=20
> # Well, the mail I sent yesterday seems not to reach list, so I resent it.
> # Sorry if you have already received same mail.

clamav has some problems at the listserver, so the list was stuck for
some time :(

> In 2.6.14 tree, ip_conntrack_expect_insert() increments the reference
> count of expectations twice. I understand that once is for timer.
> What is next incrementing for ? expectation list ?

Good question.  To me it looks like a bug introduced when merging
Rusty's conntrack-refcounting patch and the original ctnetlink code.

If nobody objects, I'll remove the second atomic_inc() line from that
function.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--vdqwC0msT4ilQ2it
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC+1QwXaXGVTD0i/8RAiyvAJ4qzkTssNh7CH7+e/CMPprubPQK3wCglr+q
xNj+m9ZoNblLM/Bg2lRSDBU=
=bIjZ
-----END PGP SIGNATURE-----

--vdqwC0msT4ilQ2it--
