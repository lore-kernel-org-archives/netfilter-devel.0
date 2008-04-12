From: Eric Leblond <eric@inl.fr>
Subject: Re: ULOGD2 PostgresSql errors
Date: Sat, 12 Apr 2008 12:42:18 +0200
Message-ID: <20080412104218.GH20469@bayen.regit.org>
References: <200804111605.39957.anton.vazir@gmail.com> <20080411193312.GE20469@bayen.regit.org> <200804121243.08408.anton.vazir@gmail.com> <20080412094925.GG20469@bayen.regit.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UBnjLfzoMQYIXCvq"
To: Anton <anton.vazir@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:53560 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758350AbYDLKmX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2008 06:42:23 -0400
Content-Disposition: inline
In-Reply-To: <20080412094925.GG20469@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--UBnjLfzoMQYIXCvq
Content-Type: multipart/mixed; boundary="RpqchZ26BWispMcB"
Content-Disposition: inline


--RpqchZ26BWispMcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Saturday, 2008 April 12 at 11:49:25 +0200, Eric Leblond wrote:
> Hello,
>=20
> On Saturday, 2008 April 12 at 12:43:08 +0500, Anton wrote:
> > Erik,
> >=20
> > Seems it fixes ICMP inserts.
>=20
> Ok, fine.
>=20
> > Just for testing I tried MYSQL=20
> > logging too - it works without errors in log file, and=20
> > looks it logs more data than PGSQL.=20
>=20
> Yes, we're working on this issue. It seems PGSQL do not manage to find
> the called SQL function due to type detection problem. This cause PGSQL
> to loose some packets.

The attached patch should fix the ICMP problem and the non-logging
problem. It is ok now on my test system.

Please note that you need to drop functions in the PGSQL schema before
applying the new schema.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--RpqchZ26BWispMcB
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="pgsql-types.diff"
Content-Transfer-Encoding: quoted-printable

diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index b18f4a8..6f1d9f4 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -86,7 +86,7 @@ CREATE TABLE tcp (
   tcp_sport integer default NULL,
   tcp_dport integer default NULL,
   tcp_seq bigint default NULL,
-  tcp_ackseq integer default NULL,
+  tcp_ackseq bigint default NULL,
   tcp_window integer default NULL,
   tcp_urg boolean default NULL,
   tcp_urgp integer  default NULL,
@@ -120,8 +120,8 @@ CREATE TABLE icmp (
   _icmp_id bigint PRIMARY KEY UNIQUE NOT NULL,
   icmp_type smallint default NULL,
   icmp_code smallint default NULL,
-  icmp_echoid smallint default NULL,
-  icmp_echoseq smallint default NULL,
+  icmp_echoid integer default NULL,
+  icmp_echoseq integer default NULL,
   icmp_gateway integer default NULL,
   icmp_fragmtu smallint  default NULL
 ) WITH (OIDS=3DFALSE);
@@ -130,8 +130,8 @@ CREATE TABLE icmpv6 (
   _icmpv6_id bigint PRIMARY KEY UNIQUE NOT NULL,
   icmpv6_type smallint default NULL,
   icmpv6_code smallint default NULL,
-  icmpv6_echoid smallint default NULL,
-  icmpv6_echoseq smallint default NULL,
+  icmpv6_echoid integer default NULL,
+  icmpv6_echoseq integer default NULL,
   icmpv6_csum integer default NULL
 ) WITH (OIDS=3DFALSE);
=20
@@ -294,7 +294,7 @@ DROP TABLE IF EXISTS nufw;
 CREATE TABLE nufw (
   _nufw_id bigint PRIMARY KEY UNIQUE NOT NULL,
   username varchar(30) default NULL,
-  user_id smallint default NULL,
+  user_id integer default NULL,
   client_os varchar(100) default NULL,
   client_app varchar(256) default NULL
 ) WITH (OIDS=3DFALSE);
@@ -389,7 +389,7 @@ CREATE OR REPLACE FUNCTION INSERT_TCP_FULL(
                 IN tcp_sport integer,
                 IN tcp_dport integer,
                 IN tcp_seq bigint,
-                IN tcp_ackseq integer,
+                IN tcp_ackseq bigint,
                 IN tcp_window integer,
                 IN tcp_urg boolean,
                 IN tcp_urgp integer ,
@@ -492,7 +492,7 @@ CREATE OR REPLACE FUNCTION INSERT_PACKET_FULL(
                 IN tcp_sport integer,
                 IN tcp_dport integer,
                 IN tcp_seq bigint,
-                IN tcp_ackseq integer,
+                IN tcp_ackseq bigint,
                 IN tcp_window integer,
                 IN tcp_urg boolean,
                 IN tcp_urgp integer ,

--RpqchZ26BWispMcB--

--UBnjLfzoMQYIXCvq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIAJIKnxA7CdMWjzIRAgilAJwIgyNLujZ1fNzyVpv5CGzGlu7+xACfUGC+
BGK6aqeD9JGUUQYBJMXsIBQ=
=FcHh
-----END PGP SIGNATURE-----

--UBnjLfzoMQYIXCvq--
