From: Harald Welte <laforge@netfilter.org>
Subject: Re: SNAT and IP ID -> what can be mangled by routers?
Date: Tue, 6 May 2003 22:58:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030506205815.GK14822@sunbeam.de.gnumonks.org>
References: <20030502222622.31281.56108.Mailman@kashyyyk> <16053.26244.510867.656383@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B92bTrfKjyax39gr"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netfil@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <16053.26244.510867.656383@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--B92bTrfKjyax39gr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 04, 2003 at 12:14:12PM -0700, Don Cohen wrote:
>=20
> This question reminds me of something I've been wondering about.
> It seems to me that some parts of an IP packet can be arbitrarily
> changed by the forwarding infrastructure.

yes.

> The TOS field seems like one good example.  When I send a packet to
> my ISP it can (I believe, or at least should be allowed to) change
> the TOS field as it wishes to influence where and when that packet
> is forwarded.  What arrives at the ultimate destination need not bear=20
> any resemblance to what I sent.

indeed. However, the TOS bits have never been used in any larger scope
larger than a particular site, since their interpretation changed three
times over the years...

> The possible danger I see from this is that, after the TOS is altered,
> some router might decide to send me an ICMP reply saying that it could
> not forward this packet. =20

I don't think this would be a valid operation.   Of course you can
configure a packet filter to do so - but I don't think you will find any
valid RFC telling you that this is a valid means of operation for the
TOS bits.  Of course the packet can get a lower priority, probably
dropped by some queuing mechanism - but send an ICMP back ?=20

> This means that when I receive that reply I should NOT expect the TOS
> field in the reply (I mean the one in the ICMP content part containing
> the beginning of the packet as it was received at that router) to be
> the same as the one I sent.

yes.

> Clearly I should expect the TTL to also be different.

sure.

> Perhaps I should also not expect, e.g., the IP ID field to be the
> same?  If I can rely on the ID field to be the same then it becomes
> an expensive proposition to mangle IDs at the firewall since you have
> to be able to UNmangle the ICMP replies, which requires possibly a lot
> of memory.

Interesting issue.  But IMHO you should not make assumptions on the IP
ID field.  The IP ID field has a single purpose: fragment reassembly at
the destination.

> The linux source appears to me to identify icmp packets only by source
> and destination IP addresses and ports (and something else I don't
> quite understand - arrival interface?  Can someone explain this?).

> So if the TOS or ID were mangled on the way to the router sending the
> reply this would have no effect, I believe.  (Any other opinions?)

At least not to the linux (and any other sane) TCP/IP stack.

> The real question:
> Are there any standards that indicate what parts of the ICMP reply the
> recipient can count on to be the same as the packet originally sent?
> If so, which are they and what do they say?

I've re-read the respective RFC's (1122,792,1812,...) and I didn't come
up with a clear answer.  The closest we get is:

"The returned IP header (and user data) MUST be identical to that which
was received, except that the router is not required to undo any
modifications to the IP header that are normally performed in forwarding
that were performed before the error was detected (e.g., decrementing
the TTL, or updating options)."

An IP ID change is certainly nothing 'normally performed in forwarding'.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--B92bTrfKjyax39gr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+uCHnXaXGVTD0i/8RAnwUAJ9TXJ8k6JEwj75/yznLjrPNymErbACdGzUt
3Y47JAHm62tHzoi8UEVZtoI=
=MjkP
-----END PGP SIGNATURE-----

--B92bTrfKjyax39gr--
