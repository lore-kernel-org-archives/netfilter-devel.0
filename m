From: Harald Welte <laforge@netfilter.org>
Subject: [erik@hensema.net: RFC: promote netfilter MARK value from IPv6 packets to sit packets]
Date: Sun, 23 Feb 2003 20:31:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030223193144.GC15385@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
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


--Izn7cH1Com+I3R9J
Content-Type: multipart/mixed; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

just in case somebody is interested...

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wzJLGUyc3ArbnUjN
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: X-Sieve: cmu-sieve 2.0
Received: from subscriber by coruscant.gnumonks.org with local (Exim 3.34 #1)
	id 18kmj6-0005y3-00
	for laforge@gnumonks.org; Mon, 17 Feb 2003 15:58:36 +0100
Received: from mail by coruscant.gnumonks.org with spam-scanned (Exim 3.34 #1)
	id 18kmj5-0005xt-00
	for subscriber@mail2news.org; Mon, 17 Feb 2003 15:58:36 +0100
Received: from oss.sgi.com ([128.167.58.27])
	by coruscant.gnumonks.org with esmtp (Exim 3.34 #1)
	id 18kmj5-0005xq-00
	for subscriber@mail2news.org; Mon, 17 Feb 2003 15:58:35 +0100
Received: from oss.sgi.com (localhost [127.0.0.1])
	by oss.sgi.com (8.12.5/8.12.5) with ESMTP id h1HEnc3v013984;
	Mon, 17 Feb 2003 06:49:38 -0800
Received: with ECARTIS (v1.0.0; list netdev); Mon, 17 Feb 2003 06:48:59 -0800 (PST)
Received: from dexter.hensema.net (cc78409-a.hnglo1.ov.home.nl [212.120.97.185])
	by oss.sgi.com (8.12.5/8.12.5) with SMTP id h1HEms3v013665
	for <netdev@oss.sgi.com>; Mon, 17 Feb 2003 06:48:57 -0800
Received: from bender.home.hensema.net (bender.home.hensema.net [192.168.1.252])
	by dexter.hensema.net (8.12.3/8.12.3) with ESMTP id h1HEvSer022086
	for <netdev@oss.sgi.com>; Mon, 17 Feb 2003 15:57:28 +0100
Received: from bender.home.hensema.net (localhost [127.0.0.1])
	by bender.home.hensema.net (8.12.3/8.12.3) with ESMTP id h1HEvRcS003419
	for <netdev@oss.sgi.com>; Mon, 17 Feb 2003 15:57:27 +0100
Received: (from erik@localhost)
	by bender.home.hensema.net (8.12.3/8.12.3/Submit) id h1HEvRgQ003418
	for netdev@oss.sgi.com; Mon, 17 Feb 2003 15:57:27 +0100
Date: Mon, 17 Feb 2003 15:57:27 +0100
From: Erik Hensema <erik@hensema.net>
To: netdev@oss.sgi.com
Subject: RFC: promote netfilter MARK value from IPv6 packets to sit packets
Message-ID: <20030217145727.GA3413@hensema.net>
Reply-To: erik@hensema.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.27i
X-archive-position: 1701
X-ecartis-version: Ecartis v1.0.0
Sender: netdev-bounce@oss.sgi.com
Errors-to: netdev-bounce@oss.sgi.com
X-original-sender: erik@hensema.net
Precedence: bulk
X-list: netdev

Hi,

I'm new to the list, so be gentle with your flames ;-)

On my outgoing connection to the internet I provide QoS using ratelimiting
and prioritizing packets. However, it's a cablemodem and my provider only
speaks IPv4. Over the connections I run multiple IPv6 tunnels, and I want
to provide QoS on these tunnels too.

QoS however can only be provided on the physical outgoing interface. On
that level, I can only see IPv4 packets and therefore it's impossible to
provide QoS on IPv6 for me.

In order to be able to provide QoS on tunneled IPv6 connections, I've
created a simple patch (definately not ready for inclusion in the kernel,
since it surely needs a configuration option) which promotes the netfilter
MARK value from the IPv6 packets to the sit packets.
Now I can mark packets using ip6tables, and on the ipv4 level I can still
differentiate between the priorities. Problem solved, I'm happy ;-)

Below is the patch, created on Linux 2.4.19:


--- net/ipv6/sit.c.orig	Mon Feb 17 15:30:41 2003
+++ net/ipv6/sit.c	Mon Feb 17 15:29:40 2003
@@ -571,6 +571,9 @@
 		}
 		if (skb->sk)
 			skb_set_owner_w(new_skb, skb->sk);
+#ifdef CONFIG_NETFILTER
+		new_skb->nfmark = skb->nfmark;
+#endif
 		dev_kfree_skb(skb);
 		skb = new_skb;
 	}

-- 
Erik Hensema (erik@hensema.net)





--wzJLGUyc3ArbnUjN--

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+WSGgXaXGVTD0i/8RAimCAJ9nBAi5fZ6/xRlFwH4gkiPBQKoGTQCfXLcH
e1hFO+1fdl8/zwCFUfpY2Rk=
=IJeo
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
