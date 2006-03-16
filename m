From: Alexander Samad <alex@samad.com.au>
Subject: Interesting problem with conntrack and ftp
Date: Fri, 17 Mar 2006 10:55:11 +1100
Message-ID: <20060316235511.GA18440@hufpuf.lan1.hme1.samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I was resently setting up my new firewall usimng openwrt on a linksys.

I got around to setting up my adsl connection and added into my iptables
these commands



$IPT -t filter -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT=20
$IPT -t filter -A FORWARD -o $WANADSL -p tcp --tcp-flags SYN,RST SYN -j TCP=
MSS --clamp-mss-to-pmtu
$IPT -t nat -A POSTROUTING -o $WANADSL -j MASQUERADE

which is what I have normally done.

http traffic worked well, but ftp of large files, timed out, sign of a
mtu problem. It worked when I ftp'ed from the firewall, but not when I
did it from behind the firewall.

When I did some tcpdumps, I noticed that the second connection created
by the client wasn't being clamp'ed.

The way I figure it was that the second connection was related to the
first one, and thus being consumed by the first line in iptables (above)

Once I changed the order of line 1 and 2 every thing worked fine.

Now openwrt uses 2.4.30, and my previous firewall used 2.6 and I believe
it was setup as shown above and it worked fine.

The other difference is that conntrack_ftp is compiled into the kernel.

Is this a know feature/bug ? why has it worked in 2.6 and not in 2.4 or
is the problem in compiled in and as a module

Alex


--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD4DBQFEGfrfkZz88chpJ2MRAhcMAKCZ5cVuW8Upl8ck80HNJ6skGqAvYgCY16AN
lAZpknnGZXSgvgeDEJuCJA==
=wL+5
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
