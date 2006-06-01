From: "Jesper Dangaard Brouer" <jdb@comx.dk>
Subject: Concurrency issues with the iptables userspace program andexitcodes
Date: Thu, 1 Jun 2006 11:15:49 +0200
Message-ID: <1149153349.28481.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg=pgp-sha1; boundary="=-ABoKXWISvl9X+nOgBSQJ"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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


--=-ABoKXWISvl9X+nOgBSQJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi

I have experienced some concurrency issues with the iptables
userspace program.  Executing an iptables (write) command while
another (write command) is running causes a failure of the command.
Well, this is the expected semantics of a non-blocking call, but the
issue is how the error situation is reported back.

The iptables command detects the situation and reports:
 "iptables: Resource temporarily unavailable"

With shell exitcode "1".  What annoys me is that the shell exitcode
is "1", which is also used for "normal" errors.  This means that my
code/scripts needs to parse output from stderr to distinguish it from
normal/expected errors.

I propose that the exitcode of "Resource temporarily unavailable"
error is changed to something unique for this situation.

Comments?

--=20
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network developer
  Cand. Scient Datalog / MSc.
  Author of http://adsl-optimizer.dk


--=-ABoKXWISvl9X+nOgBSQJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBEfrBFwuVH+NB3fZkRAiZjAJ9UTLY2cFAXJSPP6M3I0zk9fDNukgCfR/Op
k8aceykj0rzc/cVcS1ffqCw=
=WCSP
-----END PGP SIGNATURE-----

--=-ABoKXWISvl9X+nOgBSQJ--
