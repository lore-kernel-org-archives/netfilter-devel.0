From: Thomas Poehnitzsch <thomas.poehnitzsch@informatik.tu-chemnitz.de>
Subject: Re: Implementation of some options in Iptables
Date: Tue, 11 Feb 2003 22:04:41 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030211210441.GD30133@calix.csn.tu-chemnitz.de>
References: <200302102214.23176.kaiserphilipp@web.de> <20030211114040.GF24861@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Cc: Philipp Kaiser <kaiserphilipp@web.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20030211114040.GF24861@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Feb 11, 2003 at 12:40:40PM +0100, Harald Welte wrote:

> On Mon, Feb 10, 2003 at 10:14:55PM +0100, Philipp Kaiser wrote:

>> In the Iptables-FAQ you said that all remnants of the --check-options ha=
ve=20
>> been removed. Does this mean that it will never be implemented?
=20
well, if you expect a definite answer to the check as it was in ipchains,=
=20
I have to disappoint you. If on the other hand you would be happy with
test results like "matches", "does not match" and "might match" the rule,
you could give my patch [1] a try.

But beware, this patch was the result of my first contact to iptables. It
will probably only work with 1.2.6a and not all matches have been ported
(yet).=20

> Please read the list archives, this has been discussed over and over
> again.

Ok Harald, so how about discussing the feasibility and usefulness of
having this option on the 2nd of March at a nice cup of coffee. ;-)

Ciao!
    Thomas

[1] http://www-user.tu-chemnitz.de/~thpo/iptables_check.patch

--=20
In theory, there is no difference between theory and practice.
In practice, there is.

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+SWVpT7fd1jhuy5cRAkJ/AJ91XZVFfBg4GQ24CrrqT1US1+wvwwCgj0ld
0qWdTd7enfGqQoMT2Rn8rqA=
=JHMB
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
