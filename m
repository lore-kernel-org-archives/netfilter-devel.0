From: Alexander Samad <alex@samad.com.au>
Subject: Bug: ip6 REJECT + 2.6
Date: Mon, 26 Apr 2004 18:03:58 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040426080357.GF2574@samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xaMk4Io5JJdpkLEb"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--xaMk4Io5JJdpkLEb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi

There seems to be  a problem with loading ip6t_REJECT (ip6t_REJECT:
Unknown symbol ip6_dst_lookup)

I built with cvs pom-ng and a debian 2.6.5 kernel source

I believe this fixes it

--- /home/alex/src/kernel/debian/linux/net/ipv6/ipv6_syms.c
2004-04-05 19:49:44.000000000 +1000
+++ linux/net/ipv6/ipv6_syms.c  2004-04-26 17:55:38.000000000 +1000
@@ -17,6 +17,7 @@
 EXPORT_SYMBOL(ip6_route_output);
 #ifdef CONFIG_NETFILTER
 EXPORT_SYMBOL(ip6_route_me_harder);
+EXPORT_SYMBOL(ip6_dst_lookup);
 #endif
 EXPORT_SYMBOL(addrconf_lock);
 EXPORT_SYMBOL(ipv6_setsockopt);


Alex

--xaMk4Io5JJdpkLEb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAjMJtkZz88chpJ2MRAlOKAKDGqdP62NC7cQldPrwkZW+1O5N9oACg8R1t
3GIp9FZyBJ+45Y1I14OhgB4=
=qiQG
-----END PGP SIGNATURE-----

--xaMk4Io5JJdpkLEb--
