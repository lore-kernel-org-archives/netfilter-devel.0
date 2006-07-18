From: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Subject: Writing a match that communicates with userspace
Date: Tue, 18 Jul 2006 17:22:43 -0600
Message-ID: <44BD6D43.7010607@cpsc.ucalgary.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig5CC211C5B0FE0DC0F8F85C1B"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5CC211C5B0FE0DC0F8F85C1B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I'm trying to write a match module for iptables that needs to call out
to a userspace application (using netlink) for additional information
before deciding if it should match a given packet or not.  The delay
before the userspace app. responds could be as much as a second or so;
any longer, and the match should fail.  My questions is, how could I
implement such a system?

What I was considering was to put my match() function into some sort of
interruptible wait state after sending the request to userspace, and
having my netlink socket callback wake up the match function.  However,
I haven't been able to figure out what sort of concurrency exists in
netfilter (If one I block in match(), does that tie up the whole system
until resuming, or are all packets handled in their own threads?), and
the kernel debugging code complains whenever I call msleep() or mdelay()
from within match().  I'm not sure how to implement this approach
safely, or even if it is possible to do so.

My other thought was to store packets in an internal queue and hotdrop
them after sending the request to userspace, and having my netlink
callback pull them out and reinject them where they left off, but have
no idea how do the reinjecting or how to put an upper bound on the time
packets wait in my internal queue.  This design also seems to be quite a
kludge.

I suppose it would be possible for me to shoe-horn my match into a
target, or even move the entire system to userspace and use NFQUEUE, but
that would be even more of a kludge.

Does anyone have any suggestions on how I could design and implement
such a system?  I would be grateful for any advice that you can give.

Thanks,
Rennie deGraaf


--------------enig5CC211C5B0FE0DC0F8F85C1B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (GNU/Linux)

iD8DBQFEvW1OIvU5mZP08HERAk7ZAJsEoUDhwQJ4/qgBqlwkCeHrwf2a3wCcCCv/
RBQ4axZLVAbCwv8IkJcS75o=
=7tLI
-----END PGP SIGNATURE-----

--------------enig5CC211C5B0FE0DC0F8F85C1B--
