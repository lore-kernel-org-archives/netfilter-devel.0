From: Harald Welte <laforge@netfilter.org>
Subject: nf_conntrack (l3 independent conntrack)
Date: Sat, 15 Nov 2003 11:50:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031115105020.GI656@obroa-skai.de.gnumonks.org>
References: <20031113010159.GD835@mea-ext.zmailer.org> <200311131303.WAA28664@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ogUXNSQj4OI1q3LQ"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200311131303.WAA28664@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ogUXNSQj4OI1q3LQ
Content-Type: multipart/mixed; boundary="ZG+WKzXzVby2T9Ro"
Content-Disposition: inline


--ZG+WKzXzVby2T9Ro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2003 at 10:03:21PM +0900, Yasuyuki Kozakai wrote:
> If you want to use ip6_conntrack ASAP, you can find the patch in archives
> of this list(24 Sep. 2003).
>=20
> Or in USAGI kernel, too. http://www.linux-ipv6.org/
>=20
> BTW, this patch works only with Linux 2.6. If you want to use it with
> Linux 2.4, some changes are needed. ex) replace synchronize_net() to
> br_write_{un}lock_bh(), fix the codes related to nf_reinject() in
> ip6_conntrack_reasm.c.

Hi again Yasuyuki.  Sorry for not getting back to you earlier.  I'm just
busy with way too much work and don't really know where to start and
when I'll be ever finished with all that stuff.

Please be assured that I didn't forget about the issue, but I just
didn't find the time to finish the design paper on l3 independent
conntrack.

However, I'll attach the current (icomplete) start of my paper to this
email and also put it in CVS. =20

Maybe this is a start and somebody else will pick it up and express his
idea about how the implementation / organization of data structures can
look like.

> Yasuyuki KOZAKAI

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ZG+WKzXzVby2T9Ro
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="nf_conntrack-whitepaper.txt"
Content-Transfer-Encoding: quoted-printable


Design of a layer 3 independent netfilter connection tracking
(nf_conntrack)

Harald Welte

   $Revision$ - INCOMPLETE

   Copyright =A9 2003 Harald Welte <laforge@netfilter.org>
     _________________________________________________________

   Table of Contents
   1. Rationale
   2. Outline
   3. Implementation

1. Rationale

   The 2.4.x kernel series first introduced stateful packet
   filtering capabilities to Linux: The netfilter ip_conntrack
   module. While in itself modular and extensible, it is a strict
   IPv4 connection tracking implementation. There is a demand for
   stateful packet filtering of IPv6 (and potentially other layer
   3 protocols). In fact, we now even have an IPv6 port of the
   ip_conntrack module.

   However, this kind of port (by means of copying the existing
   IPv4 code and doing some IPv6 specific modifications) has
   proven to introduce a number of maintainance problems - apart
   from being bad programming practice. The netfilter core team
   has quite some experience with the ip_tables / ip6_tables
   port, which was done in a similar way and has become part of
   the 2.4.x kernel series.

   Thus, a layer three independent connection tracking core is
   needed, together with plugins for the IPv4 and IPv6 specific
   part of connection tracking.

   While the author of this paper doesn't have the ability to
   work on this project on his own (due to time constraints with
   other netfilter work like pkt_tables), this paper might give
   an idea about his view on how this layer3-generalization of
   conntrack could be achieved.
     _________________________________________________________

2. Outline

   At a first glance one might think that the differences between
   ipv4 and ipv6 connection tracking are quite small. Both
   protocols work in a similar way, both of them are most
   commonly used with TCP and UDP as layer 4. They just have a
   larger address space. So the overall notion of a connection
   within both protocols is exactly the same.

   However, there are some areas where differences are leading to
   issues with regard to connection tracking:

     * Fragmentation. While ip_conntrack does always defragment
       packets before connection tracking happens (and
       potentially re-fragment beofore the packets leave the
       machine again), IPv6 routers don't regularly perform
       fragmentation on their own.
     * NAT. ip_conntrack provides the foundation for the stateful
       NAT implementation included with iptables. In IPv6, there
       is no need for stateful NAT.
     * Extension Headers. In IPv6, there can be extension headers
       between the IPv6 packet header and the packet payload.
       Parsing of those extension headers is needed, before the
       layer4 header can be accessed by the l4 protocol helpers
       in conntrack (ip_conntrack_proto_{tcp,udp}.c).
     * ICMPv6. Unlike TCP and UDP which are the same between IPv4
       and IPv6, ICMPv6 is quite different to ICMPv4. One example
       is the stateless autoconfiguration / neighbour discovery
       mechanism employing multicast ICMPv6 packets, instead of
       the ARP protocol used with IPv4. Connection tracking
       should not interfere with the autoconfiguration messages
     * Scope of addresses. There are for example link-local
       addresses that can never establish connections via a layer
       3 routing device, because they are not allowed to leave a
       physical network link. It is questionable whether this
       should affect connection tracking or rather be left to the
       administrator to configure in ip6tables.
     * Size of Addresses. ip_conntrack keeps two address tuples
       per connection (every tuple is
       2*(sizeof(l3_addr)+sizeof(l4_addr)), thus adding up to 32
       bytes. In IPv6 the size of a tuple would grow up to at
       least 80 bytes due to the large address size. If a union
       for struct nf_conntrack_tuple was used, every IPv4
       conntrack entry would waste 48 bytes of memory, which is
       not acceptable considering the effect on wasting
       cachelines. Thus, a mechanism must be implemented to have
       differently sizes nf_conntrack structures, allocated from
       different slab caches, allocated from different slab
       caches. The dynamic part could be added to the end of a
       structure, so all l3 independent structure members can be
       transparently accessed by the core.
     _________________________________________________________

3. Implementation

   ip_conntrack needs to be split into two parts:
net/core/netfilter/nf_conntrack_core.c
- init()
        - initialize conntrack hash table and slab cache pools
        - register sockopt for SO_ORIGINAL_DST
        - register sysctl table
- nf_conntrack_in()
        - expect a defragmented packet
        - resolve the layer3 helper function (nf_ct_find_l3prot())
        - reolve_normal_ct()
        - l4prot->packet()
        - call application helper

net/ipv4/netfilter/nf_conntrack_ipv4.c
- init()
        - register with nf_conntrack core. tell it the size of the l4
          specific part of struct nf_conntrack.
        - register with ipv4 netfilter hooks (ip_conntrack_standalone.c
) and
          attach nf_conntrack_in() or a local wrapper function for
          defrag, size checks, ...
- export l4 hash function
- export get_tuple() function

--ZG+WKzXzVby2T9Ro--

--ogUXNSQj4OI1q3LQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/tgTrXaXGVTD0i/8RAuxAAJ4jxDaQGFFMLErWOoJO0gN8P61LZwCgrHQf
ftxRpGMBccUfaMBCnvGblRU=
=B81m
-----END PGP SIGNATURE-----

--ogUXNSQj4OI1q3LQ--
