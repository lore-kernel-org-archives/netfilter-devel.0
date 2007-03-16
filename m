From: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Subject: Using libnetfilter_queue
Date: Fri, 16 Mar 2007 13:50:22 -0600
Message-ID: <45FAF4FE.5000105@cpsc.ucalgary.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig06A10F17973CAD127F2B0344"
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------enig06A10F17973CAD127F2B0344
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello all,

I am trying to write an application that uses libnetfilter_queue, and
have a few questions about its API.

If I understand correctly from the example program supplied with
libnetfilter_queue, the user is responsible for reading messages from
kernelspace with a recv() call.  At this point, the messages are still
opaque nfnetlink messages, which must be passed to nfq_handle_packet()
for parsing.  This function never returns a parsed message; the caller
only gets access to the message fields inside the callback that was
provided to nfq_create_queue().  The callback is expected to call either
nfq_set_verdict() or nfq_set_verdict_mark() before returning.

My questions follow:
1. How is the caller supposed to correctly read the message from
kernelspace, when the caller doesn't know the message size?  The caller
should know an upper bound on the size of the packet contents being
returned, but doesn't know the size of the metadata fields or the
netlink header.  The only ways that I have found to safely read messages
are to either allocate large buffers that *should* be able to fit
everything (this is the approach taken by the example program -- except
that the buffer that it allocates is too small for large packets) or to
first read a struct nlmsghdr using MSG_PEEK, decode the total message
size, allocate a buffer of appropriate size, and then read the whole
message (this breaks encapulation).  It seems to me that the better way
to do this would be for the libnetfilter_queue API to provide a function
that safely reads packets from kernelspace without exposing
implementation details to the caller.  If the callback architecture is
preserved, this could be done inside nfq_handle_packet().

2. What is the point of the callback?  It seems to me that it would be
much simpler to have nfq_handle_packet() (or better yet, a function that
reads a packet) return a parsed packet to the caller and let it handle
it as it wishes.  The only good reason that I can see for having a
callback is to require that nfq_set_verdict() gets called at some point,
but the callback doesn't actually enforce this.  I don't see what
advantage this architecture has over a simpler socket-like API where
programs can open a connection, read a packet, analyze its contents, set
a verdict, and close the connection all from the same logical block.

If I'm misunderstanding how the libnetfilter_queue API works, please let
me know.

Thanks,
Rennie deGraaf


--------------enig06A10F17973CAD127F2B0344
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFF+vUBIvU5mZP08HERAgVbAKCzN5tk+5E9IWDx8vxvszejiLwgrACeO417
oec8kysaKK9WADekNq9aSmQ=
=Ggh2
-----END PGP SIGNATURE-----

--------------enig06A10F17973CAD127F2B0344--
