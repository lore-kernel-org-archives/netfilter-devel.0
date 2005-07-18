From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 3/*] ctnetlink major update
Date: Mon, 18 Jul 2005 08:36:03 -0400
Message-ID: <20050718123603.GA3729@rama>
References: <42D429E0.8060901@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <42D429E0.8060901@eurodev.net>
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


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 12, 2005 at 10:36:48PM +0200, Pablo Neira wrote:
> Sorry, this patch has been gzip'ed since I wasn't sure if it excedees the=
=20
> maximun size allowed that can be sent to the mailling list (bigger than 3=
0K).
=20
it's 40k, and you can send larger emails, they will be administratively
approved by Travis, our listmaster.  Please only send text attachments.

> I didn't generate the incremental diff against the previous version since=
 it=20
> doesn't make too many sense because this update introduces too many chang=
es.

it _always_ makes sense.  Everybody reviewing your patch will otherwise
have to create such a diff before he can reasonably review.

> ip_conntrack_netlink doesn't use ip_conntrack structures anymore, instead=
 we=20
> use nested ctnetlink atributes. This way protect us against furture chang=
es=20
> that could break backward compatibility. And now it's fairly easy
> porting this to nfnetlink.

ACK.

> getting, creation, deletion of expectation isn't implemented yet. I kept =
it=20
> back until my come back, I didn't have enough time to finish it. Anyway,=
=20
> porting the old expectation handling functions to support ctnetlink
> attributes must be an easy job. If someone is interested, I kept those
> old functions here:

I'll be adding them to your recent changes.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC26IyXaXGVTD0i/8RAqIvAKCy96P8UlTyVlp2rnN0u1238ZS6AwCfZA9V
W/aM3k/NIL1rzd5KBfBC+NY=
=qtu+
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
