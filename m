From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: ICMP error handling in CLUSTERIP
Date: Mon, 11 Apr 2005 13:59:55 +0200
Message-ID: <1113220795.4330.15.camel@nienna.balabit>
References: <000001c53a8c$d5910290$aa28abc1@Vagabond>
	<20050410205842.GY9155@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Alexander Stieglecker <a.stieglecker@gmx.net>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050410205842.GY9155@sunbeam.de.gnumonks.org>
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


  Hi,

2005-04-10, v keltez=E9ssel 22.58-kor Harald Welte ezt =EDrta:
> On Wed, Apr 06, 2005 at 11:41:39AM +0200, Alexander Stieglecker wrote:
> > /* special case: ICMP error handling. conntrack distinguishes between
> >  * error messages (RELATED) and information requests (see below) */
> > if ((*pskb)->nh.iph->protocol =3D=3D IPPROTO_ICMP
> >     && (ctinfo =3D=3D IP_CT_RELATED=20
> > 	|| ctinfo =3D=3D IP_CT_IS_REPLY+IP_CT_IS_REPLY))
> > 	return IPT_CONTINUE;
> >=20
> > IP_CT_IS_REPLY+IP_CT_IS_REPLY equals six which is greater than IP_CT_=
NUMBER.
> > Shouldn't it be something like IP_CT_IS_RELATED+IP_CT_IS_REPLY?
>=20
> good catch.  Committing to svn now, patch for mainline added to my set
> of pending patches.

  Harald, I'm afraid the fix you committed to svn isn't perfect (does
not compile.) Shouldn't that be IP_CT_RELATED instead of
IP_CT_IS_RELATED?

--=20
 Regards,
  Krisztian Kovacs
