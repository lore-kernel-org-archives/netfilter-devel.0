From: Florian Lohoff <flo@rfc822.org>
Subject: REJECT target / need-fragment ?
Date: Mon, 14 Mar 2005 13:57:47 +0100
Message-ID: <20050314125747.GA18233@paradigm.rfc822.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi,
i'd like to reject packets based on their size and send back and
icmp-must-fragment with a configurable size. As i can see no such
possibility is there currently. The REJECT target itself does not
offer this.

Should i add this functionality to REJECT or rather write another
module.

BTW: The ip stack has function like this:

	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
				  htonl(dst_pmtu(&rt->u.dst)));

May i use this from iptables target modules ?

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
                        Heisenberg may have been here.

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCNYpKUaz2rXW+gJcRAi3nAKDcOxclwTfIgBiciW5zQxtnxuZSKgCdGh9K
iF7RVKeIsPpAIB6qeSIUjXM=
=JKlV
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
