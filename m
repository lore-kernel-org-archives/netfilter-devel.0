From: Alexander Samad <alex@samad.com.au>
Subject: Re: [RFC, PATCH 2/5]: netfilter+ipsec - output hooks
Date: Sun, 21 Mar 2004 08:45:56 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040320214556.GJ29442@samad.com.au>
References: <20040308110331.GA20719@gondor.apana.org.au> <404C874D.4000907@trash.net> <20040308115858.75cdddca.davem@redhat.com> <4059CEEC.7070009@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9uDGw67+9J53IzxX"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <4059CEEC.7070009@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--9uDGw67+9J53IzxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

I don't have a full understanding of the code area we are talking about,
having only had a peruse of it a while back.

But from my reading of this do I understand that packets that enter a
box to be routed (forwarded on) that match a IPSEC transform policy

1) Are seen in  mangle prerouting
2) nat prerouting=20
2) Encrypted
3) mangle Output
4) nat Output

Does this mean they also hit the filter input & output tables aswell or
 just the filter forward table.

I would have thought for the whole process the packet (routed/forward
packet) would only be seen in the prerouting/forward/postrouting flow.
Weather or not it is going to be encrypted shouldn't make a difference I
would have thought

On Thu, Mar 18, 2004 at 05:31:40PM +0100, Patrick McHardy wrote:
> This patch adds new output-hooks. Packets with dst->xfrm !=3D NULL
> traverse the POST_ROUTING hook before dst_output is called. The
> transformers mark the packets in the control buffer with a new flag
> IPSKB_XFRM_TRANSFORMED, these packets then traverse the LOCAL_OUT
> hook when they hit ip_output.
>=20
>=20



--9uDGw67+9J53IzxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAXLuUkZz88chpJ2MRApyfAKCPLCUwAnpI/rrtjGNkLdiLb1Y8ygCgkJ8R
axav0TDCIgK/RlL1LYEQ9iQ=
=3YqR
-----END PGP SIGNATURE-----

--9uDGw67+9J53IzxX--
