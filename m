From: Harald Welte <laforge@netfilter.org>
Subject: [jasan@x31.com: Netfilter FAQ patch]
Date: Mon, 4 Jun 2007 09:15:12 +0200
Message-ID: <20070604071512.GH6552@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DNUSDXU7R7AVVM8C"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--DNUSDXU7R7AVVM8C
Content-Type: multipart/mixed; boundary="DEueqSqTbz/jWVG1"
Content-Disposition: inline


--DEueqSqTbz/jWVG1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--DEueqSqTbz/jWVG1
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: Received: from ganesha.gnumonks.org ([unix socket])
	by ganesha (Cyrus v2.1.18-IPv6-Debian-2.1.18-1+sarge2) with LMTP;
	Fri, 01 Jun 2007 11:03:59 +0200
X-Sieve: CMU Sieve 2.2
Return-path: <jasan@maildrop.x31.com>
Received: from maildrop.x31.com ([81.102.9.9])
	by ganesha.gnumonks.org with esmtps
	(TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32) (Exim 4.50) id 1Hu338-0006qO-Mu
	for laforge@gnumonks.org; Fri, 01 Jun 2007 11:03:59 +0200
Received: from maildrop.x31.com (localhost.localdomain [127.0.0.1])
	by maildrop.x31.com (8.13.4/8.13.4) with ESMTP id l5193vPA001745
	for <laforge@gnumonks.org>; Fri, 1 Jun 2007 10:03:57 +0100
Received: (from jasan@localhost)
	by maildrop.x31.com (8.13.4/8.13.4/Submit) id l5193v48001743
	for laforge@gnumonks.org; Fri, 1 Jun 2007 11:03:57 +0200
Date: Fri, 1 Jun 2007 11:03:57 +0200
From: Jan SARENIK <jasan@x31.com>
To: Harald Welte <laforge@gnumonks.org>
Subject: Netfilter FAQ patch
Message-ID: <20070601090357.GB32262@maildrop.x31.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Spam-Score: 0.0 (/)


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello Herald,

I'd like to submit a patch changing few IMHO important sections of
the FAQ. I think there are still many old sections which no-one
sould be interested in anymore. It could be useful to just keep
the older revision available and cleanse the current one (I would
gladly do it).

    With nice regards
   Jasan

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="netfilter-faq-patch-20070601-jasan.diff"

--- netfilter-faq.sgml	2007-06-01 10:50:36.000000000 +0200
+++ netfilter-faq-new.sgml	2007-06-01 10:50:15.000000000 +0200
@@ -4,7 +4,7 @@
 
 <title>netfilter/iptables FAQ</title>
 <author>Harald Welte &lt;laforge@gnumonks.org&gt;</author>
-<date>Version $Revision: 1.44 $, $Date: 2003/10/16 08:10:59 $</date>
+<date>Version $Revision: 1.50 $, $Date: 2007/06/01 12:10:59 $</date>
 
 <abstract>
 This document contains the Frequently Asked Questions as encountered on the 
@@ -21,16 +21,14 @@
 
 <sect1>Where can I get netfilter/iptables?
 <p>
-Netfilter and IPtables are integrated in the Linux 2.4.x kernel series.
+Netfilter and IPtables are integrated in the Linux kernel since 2.4.x series.
 Please obtain a recent kernel from <url url="http://www.kernel.org/"> or
 one of its mirrors.
 <p>
-The userspace tool 'iptables' is available at the netfilter homepage on one of the mirrors at
+The userspace tools 'iptables' and 'ip6tables' are available at the netfilter homepage on one of the mirrors at
 <url url="http://www.netfilter.org/">,
-<url url="http://www.iptables.org/">,
-<url url="http://netfilter.samba.org/">,
-<url url="http://netfilter.gnumonks.org/"> or
-<url url="http://netfilter.filewatcher.org/">.
+<url url="http://www.iptables.org/"> or
+<url url="http://netfilter.samba.org/">.
 </sect1>
 
 <sect1>Is there a backport of netfilter to Linux 2.2?
@@ -133,21 +131,15 @@
 an IETF MIDCOM working group has been founded, ... meanwhile, people want to
 use SIP.
 <p>
-The netfilter/iptables team has currently no resources to implement SIP
-conntrack/NAT support, but we're always open for sponsors :)
+Currently there is implementation for tracking SIP which consists of
+modules nf_conntrack_sip and nf_nat_sip.
 </sect1>
 
 <sect1>Does netfilter/iptables support failover/HA?
 <p>
-The answer is a clear 'yes' and 'no'.
-<p>
 If you are thinking about a full failover, while all the state
-information is preserved: <bf>Not really</bf>.  Doing state synchronization
-between multiple nodes is a difficult process.  Harald (of the netfilter core
-team) has published a paper about this, but not yet found any sponsor to fund
-the development.  Meanwhile, you can try to use our 'connection pickup'
-feature, which [after a failover] tries to pick up already established
-connections: <bf>Might be sufficient depending on the requirements</bf>.
+information is preserved, you have to use <bf>conntrack-tools</bf>
+from <url url="http://people.netfilter.org/pablo/conntrack-tools/">.
 <p>If you do NAT and want to preserve your NAT mappings: <bf>No</bf>.
 <p>If you do statless packet filtering: <bf>Yes</bf>
 </sect1>
@@ -290,9 +282,8 @@
 code
 <p>
 So you want to build a completely transparent firewall?  Great idea! 
-As of kernel 2.4.16, you still need to patch your kernel with an extra
-patch to get this running.  You can find it at
-<url url="http://bridge.sourceforge.net/">.
+In current kernel there is no need to patch anything. You can find more at
+<url url="http://linux-net.osdl.org/index.php/Bridge">.
 
 </sect1>
 

--C7zPtVaVf+AK4Oqc--

--DEueqSqTbz/jWVG1--

--DNUSDXU7R7AVVM8C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGY7wAXaXGVTD0i/8RAo+JAKCFZVNSUyHy7zWSNzetA2K37E8I9wCfcgiL
dVBik8rvAcvibkM7kqYliZM=
=T/Ev
-----END PGP SIGNATURE-----

--DNUSDXU7R7AVVM8C--
