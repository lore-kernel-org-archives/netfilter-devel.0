From: Eric Leblond <eric@inl.fr>
Subject: [netfilter 0/5] nf_log refactoring
Date: Fri, 02 Jan 2009 18:04:35 +0100
Message-ID: <1230915875.28326.87.camel@ice-age>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FgrTCbDH4G5mWz3f8pqg"
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:42859 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbZABREo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:04:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-FgrTCbDH4G5mWz3f8pqg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

As discussed during netfilter workshop, I've worked on changing the way
netfilter system logger can be used. This patchset has been tested and
seems to work fine but I'm not yet familiar things like rcu and mistakes
can have been done.=20

Background:
Some Netfilter components are using nf_log_packet() to send information
packet to userspace. This is mainly the case of connection tracking
modules which are using this to log invalid packets. Currently the first
loaded module wins the logger function race (loggers are stored in a
per-protocol array of function pointer).
nfnetlink_log has introduced a minor difference because it has a
unbinding and binding capability. But, this is the only logging module
with this capability and there is a issue here as this is currently not
possible to switch back to another module when nfnetlink_log has been
choosen (unbind operation leads to NONE as existence of other module has
been forgotten).

Patchset description:
The goal of this patchset is to replace the first registered win
strategy with something more flexible and intuitive. It thus modify the
binding strategy by providing a register and a bind operation. A module
has first to register and then it can bind to a given pf family. The
registration phase adds the logger structure to a per-protocol chained
list. The binding is pure nf_log operation and thus it will be possible
to change at will the used logger without direct interaction with
logging modules. The first three patches implements this:
 - netfilter: use a linked list of loggers.
 - netfilter: suppress nf_log_unregister_pf function.
 - netfilter: convert logger modules to new API.
The fourth patch modifies the output of /proc/net/netfilter/nf_log to
also give the list of registered logger for a protocol. And the fith
patch fixes the registration problem by adding support of modification
via sysctl of the logger fonction:
 - netfilter: print the list of register loggers.
 - netfilter: sysctl support of logger choice.

List of patches:
 - netfilter: use a linked list of loggers.
 - netfilter: suppress nf_log_unregister_pf function.
 - netfilter: convert logger modules to new API.
 - netfilter: print the list of register loggers.
 - netfilter: sysctl support of logger choice.

Patchset statistics:=20
 include/linux/sysctl.h         |    1 +
 include/net/netfilter/nf_log.h |   11 ++-
 net/ipv4/netfilter/ipt_LOG.c   |    4 +-
 net/ipv4/netfilter/ipt_ULOG.c  |    4 +-
 net/ipv6/netfilter/ip6t_LOG.c  |    1 +
 net/netfilter/nf_log.c         |  201 ++++++++++++++++++++++++++++++++----=
---
 net/netfilter/nfnetlink_log.c  |   11 ++-
 7 files changed, 189 insertions(+), 44 deletions(-)

BR,=20
--=20
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/


--=-FgrTCbDH4G5mWz3f8pqg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Ceci est une partie de message
 =?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJXkkfnxA7CdMWjzIRAnHlAKCNPXhGTNOX4g2Rgcv5PObh1DB5qgCdHGiH
URT+nfjj465YnsAatKgIxpo=
=VOyd
-----END PGP SIGNATURE-----

--=-FgrTCbDH4G5mWz3f8pqg--

