From: Thomas Poehnitzsch <thomas.poehnitzsch@informatik.tu-chemnitz.de>
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU
Date: Mon, 17 Feb 2003 00:55:07 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030216235507.GN30133@calix.csn.tu-chemnitz.de>
References: <20030214080612.GN14794@sunbeam.de.gnumonks.org> <20030215175841.GL30133@calix.csn.tu-chemnitz.de> <3E4EA833.5050504@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IuJpT0rwbUevm2bB"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter developer mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <3E4EA833.5050504@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--IuJpT0rwbUevm2bB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Patrick,

thanks for enlightening me.

On Sat, Feb 15, 2003 at 09:50:59PM +0100, Patrick McHardy wrote:
=20
> both are set. "|" is logical or. nfs (always?) generates packets bigger=
=20
> than mtu

In my new understanding, this very much depends on the MTU and the size
of the NFS-operation that has to be sent in a single datagram.

> so they are fragmented and have IP_MF set (except last one). If linux=20
> wants to
> know path mtu it sets IP_DF on these, so the fragments may not be _furthe=
r_
> fragmented.

You are right, my understanding of PMTUD with UDP was slightly wrong.
So the problem is not unique to NFS, but can appear in any application
using UDP, with PMTUD enabled? It just needs to send indivisible
datagrams bigger than the smallest MTU on the route.
=20
> that router is broken too. think about a host doing path mtu discovery,=
=20
> the packet
> doesn't fit the interface mtu but nat shrinks the packet so it does fit=
=20
> .. the host gets
> a wrong idea of the pmtu. unfortunately i don't know of a way to fix it=
=20
> except maybe
> to also consider the removed bytes when deciding if a packet needs to be=
=20
> fragmented.

I just skimmed through RFC1631, and have to admit I completely forgot
about NAT changing the packet size. And yes, your idea of considering
the original size if the packet size decreases by NAT seems to be a good
way.=20

If on the other hand the packet size increases a fragmentation
notification may confuse the application. In this case it would probably
be better to do the fragmentation based on the biggest fragment of the
datagram.

> even worse we need to store the fragment sizes of each reassembled=20
> packet. if we consider
> the case not all fragments have DF set and we would want to handle nat=20
> resizing correctly
> besides fragment sizes we also need fragment boundaries and fragment=20
> flags (-> iph->frag_off).

But how to calculate the fragment boundaries after a nat-helper has
shrunken/enlarged the packet? Wouldn't this mean you have to let those
(fragment-)packets without the DF flag pass (fragmented if necessary)
and ask for fragmentation of those with DF set?
But with conntrack you have to choose an all or nothing approach. So how
do you ask for the retransmission of all packets/fragments?

Furthermore the ICMP error message may then contain data changed by NAT
and thus unknown to the application. (But I think somebody (you?) has
mentioned this before.)

To me this looks like a situation that cannot be handled properly
without breaking anything or making some assumptions. :-(

And what about overlapping fragments? The overlapping data might be
be different after NAT.

Are you guys already through all the considerations and hacking it into
iptables?

Ciao!
    Thomas

PS: In my opinion NFS over UDP should only be used in LAN's. When
    refragmentation or packet loss becomes a problem NFS over TCP would
    probably be the better choice.

--=20
The key words "MUST", "MUST NOT", "DO", "DON'T", "REQUIRED", "SHALL",
"SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", "MAY BE"
and "OPTIONAL" in this document do not mean anything.
                                                         -- RFC 3251

--IuJpT0rwbUevm2bB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+UCTbT7fd1jhuy5cRApMLAJ9AnI84lapJI08r8ZNYbhFEAWRjoQCfamQ6
hfUqD8NdpuLUMqGzKQWQWhQ=
=5To7
-----END PGP SIGNATURE-----

--IuJpT0rwbUevm2bB--
