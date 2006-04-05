From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 0/3]  [RFC] fixed duration connection
Date: Wed, 05 Apr 2006 16:41:49 +0200
Message-ID: <1144248110.4406.8.camel@localhost.localdomain>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-z+cxtSaKs4hUQbgDfuxE"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	NuFW devel <nufw-devel@nongnu.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4433CCBF.6060103@trash.net>
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


--=-z+cxtSaKs4hUQbgDfuxE
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Le mercredi 05 avril 2006 =E0 15:57 +0200, Patrick McHardy a =E9crit :
> Eric Leblond wrote:
> > Hi,
> >=20
> > While working on NuFW development branch, we have had to
> > implement policy just as :
> >       * connection to server is authorised from 08h to 18h and
> >         connection must be switched off at 18h.
> > For this reason, we've worked on a simple kernel level implementation.
> > This is done via a second "struct timer" that is added in connection
> > structure. Activation of the timer, is for now done via userspace by
> > using libnetfilter_conntrack or by using new option -T of the conntrack
> > tool.
>=20
> If I understand you correctly, a fixed timeout is just a timeout that
> isn't refreshed, right?

Yes, exactly.=20

>  Why can't we just use the regular timers etc.
> and add a flag that it should not be touched by ip_ct_refresh? This
> would also eliminate the need for any ctnetlink changes since the
> timeout value can already be specified.

This was my first attempt and this may be the good one. In fact I switch
to a second timer because we may have a fixed timeout that exceeds the
protocol timeout. Thus, connection may be removed far too long after
what's needed. For example, we could have an UDP connection with fixed
timeout of a couple day which is more than protool timeout.
In fact, this approach can introduces an overload of conntrack but the
second timer approach may cost more in term of timer handling.

BR,
--
Eric Leblond <eric@inl.fr>
NuFW : http://www.nufw.org




--=-z+cxtSaKs4hUQbgDfuxE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBEM9ctnxA7CdMWjzIRAikLAJ9JgSIt66Q5K1VC5cjPyPmH7zewkACffTeT
7oBylQjWEWzYRrHfTZRy1Iw=
=P6kL
-----END PGP SIGNATURE-----

--=-z+cxtSaKs4hUQbgDfuxE--
