From: Thomas Poehnitzsch <thomas.poehnitzsch@informatik.tu-chemnitz.de>
Subject: Re: accounting
Date: Thu, 13 Feb 2003 17:46:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030213164648.GI30133@calix.csn.tu-chemnitz.de>
References: <F14LEZF98vvwNeZsjSF0004b9b0@hotmail.com> <17921743084.20030213010212@habitat-b.de> <F14LEZF98vvwNeZsjSF0004b9b0@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fnm8lRGFTVS/3GuM"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <17921743084.20030213010212@habitat-b.de> <F14LEZF98vvwNeZsjSF0004b9b0@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Fnm8lRGFTVS/3GuM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
=20
On Wed, Feb 12, 2003 at 11:27:24PM +0000, Andrej Ricnik wrote:

> I've been searching for a decent Linux IP accounting
> solution (I have a 5GB limit a month and don't want
> to pay a penalty just because the kids are greedy :})
> but couldn't find anything easy to use/decent that would
> allow me to keep track of traffic per IP and/or user
> and stop traffic from that IP/user once their "fair share"
> is used up ...
>=20
> So I was wondering how difficult it would be to intercept
> logging information from userland, and where to find
> info's on how to do it.

as for the logging of traffic, this is really easy. You could use an
iptables rule, as DarKRaveR suggested, or just use snmp
(interfaces.ifTable.ifEntry.ifInOctets*).

But for the assurance of a given limit, you will need a lot more.

On Thu, Feb 13, 2003 at 01:02:12AM +0100, DarKRaveR wrote:

> I kinda face the same problem here, just that I want the whole
> enchilada database backed, and the rules should be generated from a
> database with user information.
> I am working on some c++ progs etc. to make a solution for our
> scenario ... but it's all still earliest work in progress.
>=20
> it's a pitty, I couldn'T find anythign usefull :-( could have save me
> hours of work :-)

Stop working, look here:
https://rnvs.informatik.tu-chemnitz.de/Dynshaper/

It is already up and running, doing everything you can dream of: shaping
to a given limit, dynamic traffic adjustment based on long term traffic
analysis, database backend, IP based class allocation, Web-Frontend,
Database-Backend, ... and it's GPL!

The only disadvantage: it seems there is only a German documentation.

Ciao!
    Thomas

--=20
"vi is my shepard, I shalt not font."

--Fnm8lRGFTVS/3GuM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+S8v4T7fd1jhuy5cRAhsqAKCEipL4xsKLg9BcGXTFEvjemlb86gCfURqB
W3Fkg8QyzxeGG4Y1TGt5ed8=
=O4pw
-----END PGP SIGNATURE-----

--Fnm8lRGFTVS/3GuM--
