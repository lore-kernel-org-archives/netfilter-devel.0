From: Harald Welte <laforge@netfilter.org>
Subject: Re: Netfilter Design
Date: Thu, 26 Jun 2003 09:19:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030626071913.GK2645@sunbeam.de.gnumonks.org>
References: <01C33A40.D7C36290.rhagelstrom@atcorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K/4a4vvARjOsFc7F"
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ryan Hagelstrom <rhagelstrom@atcorp.com>
Content-Disposition: inline
In-Reply-To: <01C33A40.D7C36290.rhagelstrom@atcorp.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--K/4a4vvARjOsFc7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2003 at 11:07:45AM -0500, Ryan Hagelstrom wrote:
> I'm curious why Netfilter was designed like it was allowing for the=20
> redirection of IP packets rather than going with a design of a generic=20
> Intermediate driver that allows the capture and injection of any type of=
=20
> packet along with packets that may not have been incoming on the NIC or=
=20
> coming down through the stac?=20

Because netfilter hooks are placed in layer three stacks (e.g. IPv4),
and thus don't receive (or pass on) any other types of packet.  Another
issue is, that if you inject a packet into the network stack, there are
dozens of internal data structures you need to fill in (just look at all
the members of 'struct sk_buff'.  However, how can any userspace process
(I  assume you are talking about such) know of reasonable values for
lots of in-kernel structure pointers?

> It seems the current design works good for what it does, but it seems
> going with an IM design and building netfilter as a offshoot of the IM
> may have been a more generic and a good building block for other
> projects. Take the inability to orgianlly capture ARPs.  That could
> have been entirelly avoided if it wasn't so restrictive.

What is 'IM' ?  And btw, there are netfilter hooks in the ARP code in
recent kernels.

> Also, this isn't the only list like this but why on earth in this day and=
=20
> age do the archives not have a search feature, but rather download and do=
=20
> search yourself. I feel that a lot of the repeat questions and "search th=
e=20
> archives" responses could be eliminated if it was not so much of a pain i=
n=20
> the ass to search the archives.

This is because the distribution installed on our listserver (debian
woody) does ship mailman 2.0.x, which in turn doesn't provide a list
archival software that includes a search function.

I'd rather keep the installation as close as possible to the mainline
woody distribution - this way I don't need to manually build packages in
case of security updates, etc.

[yes, the recent switch to exim4 already introduces custom packages...
 but the increasing amount of spam and the need for html filtering was
 too important]

And yes, I'd also love to have searchable archives on a couple of other
list servers (all woody) that I'm maintaining :(

Until debian sarge becomes stable, you will most likely have to stick to
marc.theaimsgroup.com for searching netfilter lists.

> Ryan Hagelstrom

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--K/4a4vvARjOsFc7F
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++p5xXaXGVTD0i/8RAiYbAJ9EdLd07zmJENcTAYCTXZjMwE4pggCgg9qg
yuO6kWg3gmFK5pOqC9gFclU=
=tFFg
-----END PGP SIGNATURE-----

--K/4a4vvARjOsFc7F--
