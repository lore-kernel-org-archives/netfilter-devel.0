From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [RFC,ANNOUNCE] conntrack daemon (stateful replication)
Date: Mon, 29 May 2006 08:51:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0605290840590.26521@bizon.gios.gov.pl>
References: <447A1FB7.5080709@netfilter.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-643471983-1148885466=:26521"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <447A1FB7.5080709@netfilter.org>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-643471983-1148885466=:26521
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 29 May 2006, Pablo Neira Ayuso wrote:

> Hi,
Hi,

> I've been working on a pet project during the last months. Part of this s=
tuff=20
> is related with my works in the university.
>
> The project is called `conntrackd' that is the conntrack userspace daemon=
=2E

Great news! Thank you. :)

> The remaining issues are:
> - Security: A dedicated link is required to communicate nodes that confor=
m=20
> the cluster, otherwise third parties could pick up information about the=
=20
> connections processed by the firewall.

AFAIK this can be solved by additional vlan.

> Requirements:
> -------------
>
> - linux kernel >=3D 2.6.16 with [ip|nf]_conntrack_netlink support
> - libnfnetlink from SVN
> - libnetfilter_conntrack from SVN + plus patch inside the doc/ directory.

Current versions of libnfnetlink/libnetfilter_conntrack/conntrack/etc are=
=20
quite old. Are there any plans for releasing new versions based on SVN?

What about TCP window tracking? AFAIR, last time when I checked=20
conntrack_netlink did not handle it at all.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-643471983-1148885466=:26521--
