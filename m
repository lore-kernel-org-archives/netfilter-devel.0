From: Harald Welte <laforge@netfilter.org>
Subject: New IETF Working Group on NAT (Behave)
Date: Fri, 30 Jul 2004 18:42:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040730164225.GY17067@sunbeam2>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ickEXl+ukcSQ/3E"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--4ickEXl+ukcSQ/3E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

For those of you who are intereested, the IETF has just announced  the
formation of a new Working Group on NAT behaviour / NAT traversal,
http://www.ietf.org/ietf/04aug/behave.txt:

Behavior Engineering for Hindrance Avoidance BOF (behave)

Tuesday, August 3 at 1545-1645
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

CHAIRS: Cullen Jennings <fluffy@cisco.com>
	Jiri Kuthan <jiri@iptel.org>=20


AGENDA:
   (1) Agenda bashing (5 minutes)
   (2) Problem Statement, Scope Overview, and Charter (30 mins)
      See Below
   (3) Behavior Recommendations (15 mins)
      draft-audet-nat-behave-00.txt
   (4) Summary and conclusions (10 minutes)

  Reading List:
      draft-audet-nat-behave
      draft-ford-midcom-p2p
      RFC 3489=20
      draft-jennings-midcom-stun-results

DESCRIPTION:

Given the current near-universal deployment of NATs (Network Address
Translators) in the public Internet, the lack of standards for NAT behavior
has given rise to a crisis. While it is widely acknowledged that NATs create
problems for numerous Internet applications, our inability to understand
precisely what a NAT is or how it behaves leaves us few solutions for
compensating for the presence of NATs.

The behavior of NATs varies dramatically from one implementation to another.
As a result it is very difficult for applications to predict or discover the
behavior of these devices. Predicting and/or discovering the behavior of
NATs is important for designing application protocols and NAT traversal
techniques that work reliably in existing networks. This situation is
especially problematic for end-to-end interactive applications such as
multiuser games and interactive multimedia.

NATs continue to proliferate and have seen an increasing rate of deployment.
IPv6 deployments can eliminate this problem, but there is a significant
interim period in which applications will need to work both in IPv4 NAT
environments and with the IPv6 to IPv4 transition mechanisms (e.g. 6to4).

This working group proposes to generate requirements documents and best
current practices to enable vendors of both traditional NATs and IPv6 to
IPv4 transition mechanisms (e.g. 6to4) to function in as deterministic a
fashion as possible. It will consider what is broken by these devices and
document approaches for characterizing and testing them. The group will also
advise on how to develop applications that discover and reliably function in
environments with NATs and IPv6 to IPv4 transition mechanisms that follow
the best current practices identified by this working group. The group will
consider the security implications (or non-implications) of these devices.

The work will be done with the goal of encouraging eventual migration to
IPv6 and compliance with the UNSAF [RFC 3424] considerations. It will not
encourage the proliferation of NATs.

The behavior that will be considered includes the behavior includes IP
fragmentation and parameters that impact ICMP, UDP, TCP, IGMP, MLD, and
multicast. The proposed WG will coordinate with v6ops, midcom and nsis. The
work is largely limited to examining various approaches that are already in
use today and providing suggestions about which ones are likely to work best
in the internet architecture. Discussion will start from several existing
drafts or RFCs, including:
  draft-jennings-midcom-stun-results
  draft-audet-nat-behave
  RFC 3489
  draft-ford-midcom-p2p


Goals & Milestones

Jan 05 - produce a BCP document that describes the usage of protocols like
STUN for performing black-box testing and characterizing NAT behavior

Mar 05 - produce a BCP that defines behavioral requirements for NATs

May 05 - produce a BCP that discusses protocol design techniques for using
the existing set of NAT traversal approaches

Jun 05 - Any revisions to STUN required by other WG deliverables

MAILING LISTS:
  General Discussion: ietf-behave@list.sipfoundry.org
  To Subscribe: ietf-behave-request@list.sipfoundry.org with subscribe in b=
ody
  Archive: http://list.sipfoundry.org/archive/ietf-behave

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4ickEXl+ukcSQ/3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBCnpxXaXGVTD0i/8RAvTeAKCPkL2BzmNjPONr2sGC3Kc7+jYvvgCeM0hW
k13jytVEW+peh1agw5CiZoA=
=rcA1
-----END PGP SIGNATURE-----

--4ickEXl+ukcSQ/3E--
