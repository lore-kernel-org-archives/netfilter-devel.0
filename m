From: Tom Eastep <teastep@shorewall.net>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Fri, 16 Nov 2007 16:13:47 -0800
Message-ID: <473E323B.60408@shorewall.net>
References: <473D6C99.1010306@trash.net> <20071116.021254.114985389.davem@davemloft.net> <Pine.LNX.4.64.0711161316060.3340@fbirervta.pbzchgretzou.qr> <20071116.044413.227110480.davem@davemloft.net> <473D91E9.4010809@trash.net> <20071116153541.GA25986@linuxace.com> <473DBB8C.9020709@trash.net> <473E27E9.4080306@treenet.co.nz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2FD45922CE0919F8C63943F4"
Cc: Patrick McHardy <kaber@trash.net>,
	Phil Oester <kernel@linuxace.com>,
	David Miller <davem@davemloft.net>, jengelh@computergmbh.de,
	netfilter-devel@vger.kernel.org
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lists.shorewall.net ([206.124.146.177]:52227 "EHLO
	lists.shorewall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759178AbXKQANu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 19:13:50 -0500
In-Reply-To: <473E27E9.4080306@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2FD45922CE0919F8C63943F4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Amos Jeffries wrote:

>=20
> All right.
> Here is the fairly common shorewall 3.4's default dependencies as taken=

> from /usr/share/shorewall/modules .
> These are not likely to change per-system without a clueful administrat=
or.

A couple of things should be noted about this list.

a) It it includes modules that no longer exist in current kernels since
Shorewall is often run on older kernels.

b) It includes modules that currently aren't used by Shorewall. I've flag=
ged
those below with <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

c) The list includes traffic shaping modules which don't apply to the
current discussion.

As others have written, I think it is important to include the common
helpers since their absence usually messes people up.

>=20
> #
> # Essential Modules
> #
> loadmodule nfnetlink
> loadmodule x_tables
> loadmodule ip_tables
> loadmodule iptable_filter
> loadmodule iptable_mangle
> loadmodule ip_conntrack
> loadmodule nf_conntrack
> loadmodule nf_conntrack_ipv4
> loadmodule iptable_nat
> loadmodule xt_state
> loadmodule xt_tcpudp
> #
> # Other xtables modules
> #
> loadmodule xt_CLASSIFY
> loadmodule xt_connmark
> loadmodule xt_CONNMARK
> loadmodule xt_conntrack
> loadmodule xt_dccp      <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> loadmodule xt_hashlimit <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> loadmodule xt_helper    <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> loadmodule xt_length    <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> loadmodule xt_limit
> loadmodule xt_mac
> loadmodule xt_mark
> loadmodule xt_MARK
> loadmodule xt_NFLOG
> loadmodule xt_NFQUEUE
> loadmodule xt_physdev
> loadmodule xt_pkttype
> loadmodule xt_tcpmss
> #
> # Helpers
> #
> loadmodule ip_conntrack_amanda=20
> loadmodule ip_conntrack_ftp
> loadmodule ip_conntrack_h323
> loadmodule ip_conntrack_irc
> loadmodule ip_conntrack_netbios_ns
> loadmodule ip_conntrack_pptp
> # loadmodule ip_conntrack_sip
> loadmodule ip_conntrack_tftp
> loadmodule ip_nat_amanda
> loadmodule ip_nat_ftp
> loadmodule ip_nat_h323
> loadmodule ip_nat_irc
> loadmodule ip_nat_pptp
> # loadmodule ip_nat_sip
> loadmodule ip_nat_snmp_basic
> loadmodule ip_nat_tftp
> loadmodule ip_set
> loadmodule ip_set_iphash
> loadmodule ip_set_ipmap
> loadmodule ip_set_macipmap
> loadmodule ip_set_portmap
> #
> # 2.6.20+ helpers
> #
> loadmodule nf_conntrack_ftp
> loadmodule nf_conntrack_h323
> loadmodule nf_conntrack_irc
> loadmodule nf_conntrack_netbios_ns
> loadmodule nf_conntrack_netlink
> loadmodule nf_conntrack_pptp
> loadmodule nf_conntrack_proto_gre
> loadmodule nf_conntrack_proto_sctp
> loadmodule nf_conntrack_sip
> loadmodule nf_conntrack_tftp
> loadmodule nf_nat_amanda
> loadmodule nf_nat_ftp
> loadmodule nf_nat_h323
> loadmodule nf_nat_irc
> loadmodule nf_nat
> loadmodule nf_nat_pptp
> loadmodule nf_nat_proto_gre
> loadmodule nf_nat_sip
> loadmodule nf_nat_snmp_basic
> loadmodule nf_nat_tftp
> #
> # Traffic Shaping
> #
> loadmodule sch_sfq
> loadmodule sch_ingress
> loadmodule sch_htb
> loadmodule cls_u32
> #
> # Extensions
> #
> loadmodule ipt_addrtype
> loadmodule ipt_ah         <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> loadmodule ipt_CLASSIFY
> loadmodule ipt_CLUSTERIP  <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> loadmodule ipt_comment
> loadmodule ipt_connmark
> loadmodule ipt_CONNMARK
> loadmodule ipt_conntrack
> loadmodule ipt_dscp       <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> loadmodule ipt_DSCP       <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> loadmodule ipt_ecn
> loadmodule ipt_ECN
> loadmodule ipt_esp        <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> loadmodule ipt_hashlimit
> loadmodule ipt_helper
> loadmodule ipt_ipp2p
> loadmodule ipt_iprange
> loadmodule ipt_length     <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> loadmodule ipt_limit
> loadmodule ipt_LOG
> loadmodule ipt_mac
> loadmodule ipt_mark
> loadmodule ipt_MARK
> loadmodule ipt_MASQUERADE
> loadmodule ipt_multiport
> loadmodule ipt_NETMAP
> loadmodule ipt_NOTRACK    <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> loadmodule ipt_owner
> loadmodule ipt_physdev
> loadmodule ipt_pkttype
> loadmodule ipt_policy
> loadmodule ipt_realm
> loadmodule ipt_recent
> loadmodule ipt_REDIRECT
> loadmodule ipt_REJECT
> loadmodule ipt_SAME
> loadmodule ipt_sctp       <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> loadmodule ipt_set
> loadmodule ipt_state
> loadmodule ipt_tcpmss
> loadmodule ipt_TCPMSS
> loadmodule ipt_tos
> loadmodule ipt_TOS
> loadmodule ipt_ttl        <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> loadmodule ipt_TTL        <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> loadmodule ipt_ULOG
>=20

-Tom
--=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key


--------------enig2FD45922CE0919F8C63943F4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHPjI8O/MAbZfjDLIRAtKjAKCB8jDQyO24KAFyrGYS0P7fBxo7CQCff9Dw
NrHdedOUr4Rgp63tl4bdpdo=
=abIe
-----END PGP SIGNATURE-----

--------------enig2FD45922CE0919F8C63943F4--
