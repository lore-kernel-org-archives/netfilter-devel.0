From: Harald Welte <laforge@netfilter.org>
Subject: Re: best place to tap all packets?
Date: Wed, 11 Jun 2003 13:58:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030611115857.GG32593@sunbeam.de.gnumonks.org>
References: <1054830319.1607.3.camel@amit.metricsystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2Z2K0IlrPCVsbNpk"
Cc: Linux-Netfilter-devel Mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Amit Kucheria <akucheria@metricsystems.com>
Content-Disposition: inline
In-Reply-To: <1054830319.1607.3.camel@amit.metricsystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--2Z2K0IlrPCVsbNpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2003 at 09:25:18AM -0700, Amit Kucheria wrote:
> Hi all,=20
>=20
> I wish to capture *all* packets flowing through a Linux system in order
> to act upon it (delay, drop, inject additional packets).=20
>=20
> For incoming packets, I need to simply record some
> accounting/control/state information from the packets and then send them
> on their way up the stack.=20
>=20
> For outgoing packets, I need to queue them and then based on the control
> information that I have gathered, drop them, or release them or inject
> other packets into the outgoing queues.=20

so why don't you use the already existing framework of the 'tc' system
in the linux kernel?  You can implement new queue disciplines, etc.

> 1. Hack Netfilter to capture these packets and QUEUE/steal(STOLEN) them?
>    Then process them in userspace and reinject them if necessary.

This is fine for low bandwidth.  You don't want to do 100MBit with that
mechanism.

> Q. What are the latencies experienced in transferring packets to
> userspace? Are there numbers available?

huge, non-deterministic.  You cannot tell how long it will take until
your userspace process will be scheduled again, since this depends on
what's going on elsewhere on that system.

> 2. Create a custom 'slice' to capture packets:=20
> - For incoming packets this might in net_bh() or maybe a new bottom half
> that is scheduled instead of net_bh from netif_rx(). This new BH will
> then call net_bh after it is done with its processing.=20
> - For outgoing packets this could be one of the ip_*_output() routines
> in ip_output.c that would pass the packet to my code which would then
> pass them to ip_finish_output (or something similar) when the packet
> needs to be sent out.=20

again, why don't use the tc system?

> Does anybody have any comments on this? I am concerned about the
> latencies involved in moving all packets to userspace using netfilter.=20

yes, I agree with this concern.

> Q. Is it possible to queue packets inside the kernel some place using
> netfilter? Maybe my kernel module could then process these packets.

well, you can register a new queue handler with netfilter (ip_queue
ist just _one_ possible queue handler implementation) that queues the
packets in-kernel, and a kernel thread that works over that queue.

> Q. Whats the best way to capture ARP packets?

there are netfilter hooks in the ARP code... dunno whether this is the
best way.  At least it's a clean way.

> Regards,
> Amit

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--2Z2K0IlrPCVsbNpk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+5xmBXaXGVTD0i/8RAsoEAKCT4jY/tEILhnur/eGljKyxd5iPEQCcD4NO
x8bcN8LYFIj5u1uTzXpLYsI=
=luSH
-----END PGP SIGNATURE-----

--2Z2K0IlrPCVsbNpk--
