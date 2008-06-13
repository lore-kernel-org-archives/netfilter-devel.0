From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: [Patch] Re: Line numbering broken since bb34082d
Date: Fri, 13 Jun 2008 12:59:13 +0200
Message-ID: <1213354753.30942.7.camel@henriknordstrom.net>
References: <alpine.LNX.1.10.0806131107340.23098@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-92yqcYB6zLWCscU8Y0In"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:39533 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbYFMK7X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2008 06:59:23 -0400
In-Reply-To: <alpine.LNX.1.10.0806131107340.23098@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-92yqcYB6zLWCscU8Y0In
Content-Type: multipart/mixed; boundary="=-Mzwdp4nZ/mmN01cBlDQG"


--=-Mzwdp4nZ/mmN01cBlDQG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On fre, 2008-06-13 at 11:14 +0200, Jan Engelhardt wrote:

> `iptables -nvL --lin`, starting with bb34082de, gives a wrong count:
>=20
> Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
> num   pkts bytes target     prot opt in     out     source              =20
> destination        =20
> 2        0     0 LOG        all  --  *      *       0.0.0.0/0           =20
> 0.0.0.0/0           LOG flags 0 level 4=20

Sorry about that. Never tested --line-numbers.

I think the best fix is to drop the +1 from print_firewall(). Patch attache=
d.

Regards
Henrik

--=-Mzwdp4nZ/mmN01cBlDQG
Content-Disposition: attachment; filename=linenumbers.patch
Content-Type: text/x-patch; name=linenumbers.patch; charset=utf-8
Content-Transfer-Encoding: base64

SW5kZXg6IGlwdGFibGVzLmMNCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCi0tLSBpcHRhYmxlcy5jCShyZXZpc2lvbiA3
NTQzKQ0KKysrIGlwdGFibGVzLmMJKHdvcmtpbmcgY29weSkNCkBAIC03MzcsNyArNzM3LDcgQEAN
CiAJZmxhZ3MgPSBmdy0+aXAuZmxhZ3M7DQogDQogCWlmIChmb3JtYXQgJiBGTVRfTElORU5VTUJF
UlMpDQotCQlwcmludGYoRk1UKCIlLTR1ICIsICIldSAiKSwgbnVtKzEpOw0KKwkJcHJpbnRmKEZN
VCgiJS00dSAiLCAiJXUgIiksIG51bSk7DQogDQogCWlmICghKGZvcm1hdCAmIEZNVF9OT0NPVU5U
UykpIHsNCiAJCXByaW50X251bShmdy0+Y291bnRlcnMucGNudCwgZm9ybWF0KTsNCkluZGV4OiBp
cDZ0YWJsZXMuYw0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQ0KLS0tIGlwNnRhYmxlcy5jCShyZXZpc2lvbiA3NTQzKQ0K
KysrIGlwNnRhYmxlcy5jCSh3b3JraW5nIGNvcHkpDQpAQCAtNzM3LDcgKzczNyw3IEBADQogCWZs
YWdzID0gZnctPmlwdjYuZmxhZ3M7DQogDQogCWlmIChmb3JtYXQgJiBGTVRfTElORU5VTUJFUlMp
DQotCQlwcmludGYoRk1UKCIlLTR1ICIsICIldSAiKSwgbnVtKzEpOw0KKwkJcHJpbnRmKEZNVCgi
JS00dSAiLCAiJXUgIiksIG51bSk7DQogDQogCWlmICghKGZvcm1hdCAmIEZNVF9OT0NPVU5UUykp
IHsNCiAJCXByaW50X251bShmdy0+Y291bnRlcnMucGNudCwgZm9ybWF0KTsNCg==


--=-Mzwdp4nZ/mmN01cBlDQG--

--=-92yqcYB6zLWCscU8Y0In
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUASFJS+0NPQ5Kbx8daAQLQeQQAqK4Cfk8YATBTNtrLtX3ItByLhEbQVP5D
1/2BTiHHlVRh1RSWNlqOxgAUiYvlVMls/FdpQMVB0Eeglz5KLVszZCqSM0l4ijnQ
t6TeB3rDXA7aBtEqS4LNsqIZ/Ybyrmhwjd+QuPNjrfFQLf3E4AOLPQ4s30kHMW5J
2YdXgIXhtfA=
=sYbk
-----END PGP SIGNATURE-----

--=-92yqcYB6zLWCscU8Y0In--

