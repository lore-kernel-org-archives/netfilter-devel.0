From: Alexander Samad <alex@samad.com.au>
Subject: Q) netfilter IPv6 & NAt
Date: Sat, 7 May 2005 13:08:24 +1000
Message-ID: <20050507030824.GN12091@samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UExESr5xZTMxdOWv"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--UExESr5xZTMxdOWv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi

I remember there was an discussion before about NAT in ip6tables and the
last comment was along the lines that NAt will never be implemented in
netfilter as there is no need for it.

My question is how would you use a linux box as a load balancer for a
cluster of app servers (say apache) if we were only using ipv6, is this
where ROUTE target is used.

Alex

--UExESr5xZTMxdOWv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCfDEokZz88chpJ2MRAltZAJ9gZiYYt0QBD523m+RDF3JKbQtiLwCgjqYR
anM4SqVCVZDoXpXtrXDbm0Y=
=Uf0Y
-----END PGP SIGNATURE-----

--UExESr5xZTMxdOWv--
