From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: NAT on the same ethernet card ?
Date: Fri, 10 Jan 2003 18:55:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030110175537.GG17367@noir.cb.ac.at>
References: <3DEBA04C.7080606@myrealbox.com> <20030110140544.GV1353@sunbeam.de.gnumonks.org> <001801c2b8cd$fa819d00$7901000a@nivel5.cl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nlttjmhgc7EeTk3T"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <001801c2b8cd$fa819d00$7901000a@nivel5.cl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--nlttjmhgc7EeTk3T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 10, 2003 at 02:30:32PM -0300, Miguel Angel Amador Lorca wrote:
> it' is possible that netfilter make NAT or MASQ over  a tcp-packet from the
> one net (10.0.1.0) , and back to the same net (back to the 10.0.1.0 again )
> ?
Yes, by combining DNAT and SNAT. Next time post into -user mailing list, this
one is for development.

> Miguel Angel Amador Lorca    |    mailto:amador@puc.cl
Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505122023

--
   If Bill Gates had a dime for every time a Windows box crashed...
                ...Oh, wait a minute, he already does.

--nlttjmhgc7EeTk3T
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HwkZzogxsPZwLzcRAtECAJ9iSl0KLhwKM3+HXkSDH30xLNxyqQCgmIsO
NtHl8N1bqdq1FtubyV1cGps=
=m8Ys
-----END PGP SIGNATURE-----

--nlttjmhgc7EeTk3T--
