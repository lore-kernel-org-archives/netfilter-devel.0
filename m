From: Stephen Frost <sfrost@snowman.net>
Subject: Re: PSD and recent are _very_ picky about option order: "missing optarg"
Date: Tue, 9 Dec 2003 08:29:19 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031209132919.GU24094@ns.snowman.net>
References: <Pine.LNX.4.44.0312082118580.1981-100000@sparrow>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1PGkbKNF3KNzswH6"
Cc: ML-recent <ipt_recent@snowman.net>,
        ML-netfilter-devel <netfilter-devel@lists.netfilter.org>,
        Markus Hennig <hennig@astaro.de>,
        Dennis Koslowski <koslowski@astaro.de>,
        Jan Rekorajski <baggins@pld.org.pl>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: William Stearns <wstearns@pobox.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0312082118580.1981-100000@sparrow>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--1PGkbKNF3KNzswH6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* William Stearns (wstearns@pobox.com) wrote:
> 	I'm trying to use psd to detect port scans.  Once I find a=20
> scanning IP address, I'd like to save that IP in a recent table called=20
> "mappers".
> 	Here's a simple run, lines wrapped for readability.  The first=20
> fails when psd is loaded first; in the second command I load "recent"=20
> first:

Hi William,

  Quite the list of people you've got there. :)  If memory serves the
  multiple-module argument handling is kind of tricky.  If I can find
  some time I'll see about debugging the problem.  In the meantime I
  don't see any reason it wouldn't work to define another table with a
  conditional jump on psd and have that table add the entry to the
  recent table.  Something like:

  iptables -N mappers
  iptables -A forward -m psd -j mappers
  iptables -A mappers -m recent --set -j DROP

  Or -j RETURN if you want to continue down the forward chain.  Is there
  something I'm missing?

  	Stephen

--1PGkbKNF3KNzswH6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/1c4urzgMPqB3kigRArlSAKCMzoU831LzNjKfL7kyS6wDfYHwrgCgktEM
6A2KS7VwXt56G5VZD/aZOCs=
=VYnb
-----END PGP SIGNATURE-----

--1PGkbKNF3KNzswH6--
