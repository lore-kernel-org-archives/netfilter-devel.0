From: Harald Welte <laforge@netfilter.org>
Subject: Re: again!!! the 3rd time, why we need find_appopriate_src? rether than just check in_range?
Date: Thu, 4 Dec 2003 17:29:45 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031204115945.GE7680@obroa-skai.de.gnumonks.org>
References: <3FCEBB3C.1000309@deansoft.com.tw>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C94crkcyjafcjHxo"
Cc: netfilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jesse Peng <jesse@deansoft.com.tw>
Content-Disposition: inline
In-Reply-To: <3FCEBB3C.1000309@deansoft.com.tw>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--C94crkcyjafcjHxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 04, 2003 at 12:42:14PM +0800, Jesse Peng wrote:
> According to above, this circumstance only limited at POST_ROUTING hook,=
=20
> then the question is as follow:
>=20
> 1.Since ip_nat_fn is called both during PREROUTING and POSTROUTING hook,=
=20
> then we've sure while a new packet passing PREROUTING, the ip_nat_fn=20
> have called ip_nat_rule_find, then the ip_nat_rule_find graranting that=
=20
> even no rule found the output tuple will be unique(through the=20
> compensation by allocate_null_biding).
> 2.While during POSTROUTE, the input tuple: orig_tuple to=20
> get_unique_tuple is right one the output tuple above mentioned, so it is=
=20
> still unique!!
> 3.Then why can't we just check if the src of the orig_tuple "in range"=20
> the mr. If it is, then all we need to do is to set the=20
> *tuple=3D*orig_tuple, and return 1.

so what about the cases where we have packets originated by the local
machine?  They will appear via ip_nat_local_fn() -> ip_nat_fn() ->
ip_nat_rule_find() attached to LOCAL_OUT only if CONFIG_IP_NF_NAT_LOCAL
is defined.

If not, the packet is actually only seen at POST_ROUTING, and we still
have to make sure the tuple is unique.
> Because this remaining disunderstanding fool me so long and almost
> destroy my life!!

it almost destroys yor life?  Is your employer going to fire you if you
don't understand netfilter code, or what ;) ?

> Your Sincerely

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--C94crkcyjafcjHxo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/zyHHXaXGVTD0i/8RAtaPAJ9Sp/rO9B7IAB9zeVaXc+Egf9TIjwCeJTJR
1tk9h1XqMuwzrGtElPKZr+0=
=34RD
-----END PGP SIGNATURE-----

--C94crkcyjafcjHxo--
