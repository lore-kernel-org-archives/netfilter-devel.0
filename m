From: Harald Welte <laforge@netfilter.org>
Subject: libiptc optimization
Date: Tue, 24 Jun 2003 19:45:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624174530.GZ2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r6fxLKBTHCmC166Z"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--r6fxLKBTHCmC166Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I've recently done some profiling on iptables, and found out that
libiptc is very inefficient when it comes to large rulesets.=20

As an example, loading a ruleset with 10000 rules in 1000 chains=20
using iptables-restore takes:

original 1.2.8 code:=20
	ruleset-1000:	3m55.575s (3m27.310s user / 0m28.270s system)

After looking at the gprof output, it was clear that

>  %   cumulative   self              self     total          =20
> time   seconds   seconds    calls   s/call   s/call  name   =20
> 42.57     66.68    66.68    11999     0.01     0.01  insert_rules
> 22.79    102.38    35.70 83528513     0.00     0.00  add_chain
> 19.74    133.31    30.93 83541508     0.00     0.00  correct_verdict

there are two functions with almost O^2 complexity in libiptc, eating up
42.5% of the total runtime.  =20

the first case (add_chain) has now been eliminated from libiptc.  This
was done in two steps:=20
	1. make the chain cache work with relative offsets rather
	   than memory adresses (libiptc.c 1.39)
	2. add support to incrementally update the chain cache with
	   every operation, rather than rebuilding it from scratch
	   10000 times. (libiptc.c 1.40)

Now the results look like:

modified libiptc with relative offset + correct_cache()
	ruleset-1000:	2m19.566s (1m52.510s user / 0m26.980s system)

Which is a 46% execution speedup for the userspace part, quite
promising.

The problem is with the second function (correct_verdict).  It corrects
the jump destination after a rule has been inserted the ruleset.  There
is no way to eliminate this O^2 complexity while keeping the current
libiptc architecture.  To get rid of this complexity, one would need to
reimplement iptables to use some intermediate data structure (like
linked lists of chains, linked lists of rules) and then compiling the
ruleset only at iptc_commit() time.  This would speed up rule insertion,
since all you need is a simple list_add() for every iptc_append_entry().

However, this is quite a task, and I'm not willing to put too much
effort into this now.

The most important part is:  The new libiptc.c code has not had that
much testing.  It might cause all sorts of strange bugs in the ruleset,
so please use current iptables CVS with extreme care.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--r6fxLKBTHCmC166Z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++I46XaXGVTD0i/8RAnHzAJ99iiLEE4D7nAbBOD/OUzGtf1iqRgCgkdK7
bhw4VICiVNwmzr4P06ZGmKs=
=EOon
-----END PGP SIGNATURE-----

--r6fxLKBTHCmC166Z--
