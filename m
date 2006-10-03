From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] iptables: ip6table version support and
 libip6t_multiport.fix
Date: Tue, 03 Oct 2006 23:30:18 +0900 (JST)
Message-ID: <200610031430.k93EUJUB026806@toshiba.co.jp>
References: <cd6061db0610011837u5c9419ecld21645cabab37661@mail.gmail.com>
	<200610020446.k924kYkj027138@toshiba.co.jp>
	<200610021747.42658@auguste.remlab.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: ljlane@debian.org, netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: rdenis@simphalempin.com
In-Reply-To: <200610021747.42658@auguste.remlab.net>
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

From: R=E9mi Denis-Courmont <rdenis@simphalempin.com>
Date: Mon, 2 Oct 2006 17:47:42 +0300

> Le lundi 2 octobre 2006 07:46, Yasuyuki KOZAKAI a =E9crit :
> (...)
> > Please use IP6T_MULTI_PORTS so that we can compile with linux 2.4.
> =

> There you go (also resynched with latest SVN), but won't it fail with=
 =

> xt_multiport_v1 anyway (there is no ip6t_multiport_v1 in *any* kernel=
 =

> version to date, AFAIK)?

But they have multiport v0 features. The revision was introduced to kee=
p
compatibility with such features in old kernel and make possible to add=
 new
features to new kernel.

IPv4 multiport match (and policy match, too) would help you. It has
the line

	#include ../../include/netfilter_ipv4/ipt_multiport.h

and definitions for old kernel are included in the header.

-- Yasuyuki Kozakai
