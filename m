From: Patrascu Eugeniu <epatrascu@go.ro>
Subject: kernel rule insertion question/suggestion
Date: Tue, 06 Jan 2004 12:30:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1073385010.1106.15.camel@sin.nobugconsulting.ro>
Reply-To: epatrascu@go.ro
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bke0sY7CskAuzJCZLKri"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-bke0sY7CskAuzJCZLKri
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

As explained by a list member a while ago, to insert a netfilter rule in
the running kernel the following things happen:
	I. the whole ruleset is being downloaded in userspace
	II. the rules are checked for loops/errors/whatever and the new rule is
added to the chain.
	III. then the whole ruleset is uploaded back into the running kernel.
	IV. the steps above are repeated for each and every rule added.

I was wondering (in case what I wrote above is really true) if there
would be a good ideea to have a userspace rule compiler that can check
for errors in the rules and then just upload them in the kernel, without
using the mecanism described above. this would be useful for compiling
firewall rules on a central machine and after that just deploying them
thru out the network; also, this would be very helpful for people who
have slow machines as firewalls.

PS: I apologize for my writing, but english is not my native language.

--=20
Patrascu Eugeniu <epatrascu@go.ro>

--=-bke0sY7CskAuzJCZLKri
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQA/+o4yV1VUlYp+JSYRAkr3AJ9Yyh4lYjmYDHdE4v/VV7asLkJ0uQCeJuwl
MSQgHlVn8QMR6VO0bzgsnR8=
=jF8m
-----END PGP SIGNATURE-----

--=-bke0sY7CskAuzJCZLKri--
