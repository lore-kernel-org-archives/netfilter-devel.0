From: vecna@s0ftpj.org
Subject: Re: possible target SBALANCE ?
Date: Wed, 30 Apr 2003 13:59:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030430115918.GF7343@dns2.italway.it>
References: <200304192142.h3JLg1S03466@fokkensr.vertis.nl> <20030428091332.GB29390@dns2.italway.it> <20030428134713.GA12364@oknodo.bof.de> <20030428150727.GA10325@dns2.italway.it> <20030429144837.GE684@naboo.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I3tAPq1Rm2pUxvsp"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030429144837.GE684@naboo.intranet.astaro.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--I3tAPq1Rm2pUxvsp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> __ip_conntrack_find is an inline function and LIST_FIND a macro.  so
> there are not really any function calls involved.
ok, i don't speak about latency caused by continuos jump, but the
complexity of the algorithm is O(N) with N =3Dnumber of connection,
with merge sort this should became O(Log(N)), and simple when is=20
added to the list you needed to follow incremental order for the key to
search (the hash)

> this is not new.  However:
> - you cannot have outgoing connections from your individual nodes, since
>   you cannot make sure that the reply packets will end up in the correct
>   hash bucket
> - you cannot deal with complex protocols like FTP,IRC,H.323,SIP,PPTP,...
> - your load balancing is static and depends on the equal distribution of
>   (source) IP addresses
I've felt the necessity to balance a large size of traffic, and all
the other solutions (proposed in LVS) involves connection tracking (and=20
LVS have the "bug" o "limitation" to follow session computing hash=20
with source ip and destination port only, not with between couple for=20
trace also the replies, and this could not be fine for split traffic for
IDS, because most needed for trace connection to read also the replis)

but if this is not ad interesting feature for netfilter (is a firewall :)
could be better if I ask on LVS mailing list ?=20

bye,
vecna

--I3tAPq1Rm2pUxvsp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+r7qWqso6AcJ1LUsRAloyAJ0TIzm3z80C2h8O1Vc2bifQmIwLJQCeKMTl
AiiHkazUXSNmc7NM2lmb9+A=
=jByv
-----END PGP SIGNATURE-----

--I3tAPq1Rm2pUxvsp--
