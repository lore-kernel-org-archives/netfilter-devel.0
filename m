From: "Jesper Bengtsson" <jesper.bengtsson@axis.com>
Subject: RE: [PATCH] netfilter: xt_tcpudp.c: wrong struct in udp_checkentry
Date: Thu, 30 Aug 2007 08:43:06 +0200
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C66803425F9A@exmail1.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
content-class: urn:content-classes:message
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

Hi Patrick,

Signed-off by: Jesper Bengtsson <jesper.bengtsson_at_axis.com>

Thanks,
Jesper


> -----Original Message-----
> From: Patrick McHardy [mailto:kaber@trash.net]=20
> Sent: den 29 augusti 2007 19:12
> To: Jesper Bengtsson
> Cc: netfilter-devel@lists.netfilter.org
> Subject: Re: [PATCH] netfilter: xt_tcpudp.c: wrong struct in=20
> udp_checkentry
>=20
>=20
> Jesper Bengtsson wrote:
> > I found what looks like a copy-paste error in=20
> udp_checkentry, see patch
> > below.
> > It doesn't seem to have any effect on the x86 architecture=20
> but it does
> > have effect on the Axis CRIS architecture.
>=20
>=20
> Thanks, please send me a Signed-off-by: line so I can apply it.
>=20
>=20
