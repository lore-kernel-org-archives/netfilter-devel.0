From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: linux 2.6.10: ip_conntrack table overflowing
Date: Tue, 04 Jan 2005 14:31:47 +0100
Message-ID: <1104845507.4725.31.camel@nienna.balabit>
References: <20050104124034.GA28010@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050104124034.GA28010@roonstrasse.net>
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

2005-01-04, k keltez=E9ssel 13.40-kor Max Kellermann ezt =EDrta:
> yesterday, we upgraded four servers from 2.6.9 to 2.6.10. 12 hours
> later (last night), all of them stopped responding; the conntrack
> tables were full:
>=20
> Jan  3 21:03:31 cfapro01 kernel: ip_conntrack: table full, dropping
> packet.
>=20
> We rebooted, and now there are more than 30000 connections in
> /proc/net/ip_conntrack, but netstat only shows 400; example:
>=20
> tcp      6 421183 ESTABLISHED src=3DXXremoteXX dst=3DYYlocalYY
> sport=3D29800 dport=3D80 src=3DYYlocalYY dst=3DXXremoteXX sport=3D80
> dport=3D29800 [ASSURED] mark=3D0 use=3D1

  Seems to be the problem already reported and fixed by Martin. Take a
look at

https://lists.netfilter.org/pipermail/netfilter-devel/2004-December/01790=
8.html

for the detailed description and the patch fixing the bug.

--=20
 Regards,
  Krisztian Kovacs
