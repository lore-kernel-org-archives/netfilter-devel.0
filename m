From: Harald Welte <laforge@gnumonks.org>
Subject: Re: conntrack hash function comparison
Date: Fri, 31 Jan 2003 12:41:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131114145.GS9073@naboo.cybercafe42>
References: <15916.59019.853598.788888@isis.cs3-inc.com> <Pine.LNX.4.33.0301211136020.19820-100000@blackhole.kfki.hu> <15917.31840.767508.76359@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hXth9cGL35Nvpk4x"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15917.31840.767508.76359@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--hXth9cGL35Nvpk4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2003 at 08:59:12AM -0800, Don Cohen wrote:
>  > I don't really like the idea of rehashing if the hash function is
>  > (so) strong.
> At some point it's clearly worth rehashing.  You have to decide what
> that point is.  If the function is so good and successfully resists
> attack then you'll never (or hardly ever) need to rehash, so all you
> pay is a tiny amount of space for code that's never used.
> Whereas, if you're extremely unlucky, or a clever new attack method
> comes along, that small amount of code will help you a whole lot.
> You choose your table size and rehash threshold in order to make the=20
> search time acceptable (max length of bucket) and also the probability
> of rehash very small.=20

not that I totally disagree with rehashing being a good idea... but in
the case you add this 'small piece of code', you also introduce a new
vulnerability: If somebody can provoke the firewall to rehash all the
time ;(

> Right now I simply rely on rehash to fix any such problems (or any
> OTHER problems for that matter) that actually arise.  Since I argue
> you really ought to have that as a backup anyway, I don't mind using
> it to solve this problem.  I do recommend a log entry if you ever have
> to rehash, and frequent rehash would be worth notification if you have
> such a facility.

yup. rehash parameters should be a sysctl, and rehash statistics kept
somewhere in /proc.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--hXth9cGL35Nvpk4x
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+OmD5XaXGVTD0i/8RAv57AJ468x0hGdeseR7JIjzuN8htiYOJYACeIyxF
J0GWHwrW1ASqLKMWQzlFeMo=
=d2l0
-----END PGP SIGNATURE-----

--hXth9cGL35Nvpk4x--
