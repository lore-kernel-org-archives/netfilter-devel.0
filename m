From: Eric Leblond <eric@inl.fr>
Subject: Re: limit and negation
Date: Tue, 09 Nov 2004 16:14:42 +0100
Message-ID: <1100013282.4439.1.camel@porky>
References: <1099995187.4318.15.camel@porky>
	<33091.66.11.161.14.1100010503.squirrel@66.11.161.14>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-FijopYn4Kv0ihmTYz66L"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nicolas Bouliane <nib@cookinglinux.org>
In-Reply-To: <33091.66.11.161.14.1100010503.squirrel@66.11.161.14>
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


--=-FijopYn4Kv0ihmTYz66L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-11-09 at 09:28 -0500, Nicolas Bouliane wrote:
> bash-2.05b# iptables -A OUTPUT -m limit --limit ! 1/sec -j LOG
> --log-prefix "over"
> iptables v1.2.11: Unexpected `!' after --limit
> Try `iptables -h' or 'iptables --help' for more information.
> bash-2.05b#

I try this one too, but it should not accept this command as it does
now :
>> iptables -A OUTPUT -m limit ! --limit 1/s -j LOG --log-prefix "over"

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-FijopYn4Kv0ihmTYz66L
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBBkN7hnxA7CdMWjzIRArmTAJ0Xy/lLoNyrrPFDfblVvqlWCQJNHwCffRRb
7k+VQp3T23O5BsDGPfFg6Go=
=0IHo
-----END PGP SIGNATURE-----

--=-FijopYn4Kv0ihmTYz66L--
