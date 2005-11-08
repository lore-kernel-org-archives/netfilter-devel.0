From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Roadmap for IPv6 stateful filtering
Date: Tue, 8 Nov 2005 22:58:19 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511082242080.19096@bizon.gios.gov.pl>
References: <4370A4A3.20702@eurodev.net> <200511081502.04272@nienna>
	<20051108141914.GV26843@sunbeam.de.gnumonks.org>
	<20051108.084451.49049943.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-2122588642-1131487099=:19096"
Cc: laforge@netfilter.org, pablo@eurodev.net, gregor@net.in.tum.de,
	netfilter-devel@lists.netfilter.org, hidden@balabit.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20051108.084451.49049943.davem@davemloft.net>
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

---187430788-2122588642-1131487099=:19096
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 8 Nov 2005, David S. Miller wrote:

> Given what I actually do know about the situation I've told Arnaldo
> that we should probably just hold off on nf conntrack until 2.6.16,
> it's not the end of the world.

For most of netfilter _users_ this means that nf_conntrack is going to be=
=20
accessible after 4-5 months (2.6.16.x) and usable after more than half a=20
year (2.6.17.x), with no clear reason. :(

Please note that currently nf_conntrack is one the most expected netfilter=
=20
feature.


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2122588642-1131487099=:19096--
