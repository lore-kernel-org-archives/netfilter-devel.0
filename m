From: Harald Welte <laforge@netfilter.org>
Subject: Making ip_queue l3 independent
Date: Sat, 23 Aug 2003 23:00:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030823210022.GA6750@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Cc: James Morris <jmorris@intercode.com.au>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: coreteam@netfilter.org
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


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James!

At the netfilter summit [*] the issue of ip_queue being l3 dependent was
raised.  As other layer3 protocols (like ipv6, mpls, the bridging code)
want to queue packets to userspace as well, it is questionable if the
current approach of ip_queue / ip6_queue is the right way to go for the
future.

As of now, every l3 protocol can register a queue handler with the
netfilter core.  I think we should keep this behaviour - so other queue
handlers can attach like they currently do.

But what about turning ip_queue.c into something more general (like
nf_queue.c) that can attach as queue handler with any l3 protocol the
user wants?

Enqueuing the packet inside the kernel, transporting the packet from
kernel to userspace and back is not something related to a specific
layer 3 networking protocol.

AFAICT even the ipq_packet_msg_t could stay the same - so no big
compatibility issues with userspace are to be expected. One might
however consider adding a 'proto' member to indicate from which l3prot
the packet came from.

In any case, if we were to make a change, it should happen before
2.6.0-final is released.

James, what is your take on this?  What do you think?  If you agree, do
you have the time to do the change, or would you be fine if I'd work out
a patch?

[*] I'll try to post a short summary about the netfilter workshop tomorrow

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/R9XmXaXGVTD0i/8RAljRAKCTBzxA281LqJoKzb4YZgTbDW+NFwCePNIk
2nffzZeI4NYUT3HUJ1j+kzM=
=bSHc
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
