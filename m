From: Nicolas George <nicolas.george@ens.fr>
Subject: TCPMSS target for IPv6
Date: Thu, 11 Dec 2003 13:26:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031211122649.GA25739@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
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


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I am really missing the TCPMSS target for IPv6. With IPv6, MSS value is
not only a problem with "criminally braindead ISPs", but also with
IPv6-over-IPv4 tunnels: if the fragmentation problem arises in the IPv4
world, an ICMPv4 "fragmentation needed" is sent, but it can not be
converted into an ICMPv6 "too big", so path MTU discovery does not work.

As far as I can see, the code for iptables and ip6tables is really
similar, so it should be quite straightforward to port IPv4 TCPMSS to
IPv6 for someone that already knows the usual kernel network structures
(which is, alas, not my case yet).

Regards,

--=20
  Nicolas George

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.0 (SunOS)

iD8DBQE/2GKIsGPZlzblTJMRAlgPAJ0S2+efJ1cKUdIWE+/nO4Y57AaubgCfWxom
ddXEE5SLsPScJlzGyQhqhFA=
=GR3Q
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
