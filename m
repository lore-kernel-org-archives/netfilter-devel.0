From: Harald Welte <laforge@netfilter.org>
Subject: Update: [PATCH 2.6] iptables MIRROR target fixes
Date: Fri, 25 Jul 2003 22:52:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725205242.GH3244@sunbeam.de.gnumonks.org>
References: <20030719142648.GS32475@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j+wdmHMkwJXioevW"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20030719142648.GS32475@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--j+wdmHMkwJXioevW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again, Dave!

On Sat, Jul 19, 2003 at 04:26:48PM +0200, Harald Welte wrote:

> This is the first of my 2.6 merge of the recent bugfixes (all tested
> against 2.6.0-test1).  You might need to apply them incrementally
> (didn't test it in a different order).

Unfortunately I introduced a typo during the merge (which in turn
introduced a new bug).

Please incrementially apply the following patch, thanks.


--- linux-2.6.0-test1-nftest5/net/ipv4/netfilter/ipt_MIRROR.c	2003-07-19 16=
:13:56.000000000 +0200
+++ linux-2.6.0-test1-nftest6/net/ipv4/netfilter/ipt_MIRROR.c	2003-07-19 17=
:35:23.000000000 +0200
@@ -173,7 +173,7 @@
 	/* Don't let conntrack code see this packet:
 	 * it will think we are starting a new
 	 * connection! --RR */
-	ip_direct_send(*pskb);
+	ip_direct_send(nskb);
=20
 	return NF_DROP;
 }

[now really off for OLS].

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--j+wdmHMkwJXioevW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/IZiaXaXGVTD0i/8RAsSfAKCwnAi7hjGdnMvFPmxMxxVADPJf2gCbBhQx
nRwizN451JpEO47HmtmD0BM=
=gAIv
-----END PGP SIGNATURE-----

--j+wdmHMkwJXioevW--
