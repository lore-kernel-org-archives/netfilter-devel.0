From: pawlakus@oswiecim.eu.org
Subject: Re: new chain after egress for statistical purpose
Date: Thu, 3 Mar 2005 13:17:39 +0100 (CET)
Message-ID: <57895.62.87.185.5.1109852259.squirrel@oswiecim.eu.org>
References: <200503022335.09403.pawlakus@oswiecim.eu.org>
	<20050303061402.GG31334@oknodo.bof.de>
	<57712.62.87.185.5.1109845255.squirrel@oswiecim.eu.org>
	<20050303105430.GH31334@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050303105430.GH31334@oknodo.bof.de>
To: "Patrick Schaaf" <bof@bof.de>
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

> Hmmmmm. Couldn't you use a setup as described in
> 	http://ebtables.sourceforge.net/examples.html
> under "Filtering with ebtables on interfaces not enslaved to a bridge".
> And use ebtables POSTROUTING. Do any shaping on br0, and that should
> only see the remaining traffic.

According to ebtables documentation (to be specific:
http://ebtables.sourceforge.net/br_fw_ia/PacketFlow.png
) it is still before egress. Besides that, i have bad
experience with "Do any shaping on br0" because in my
configuration it just don't work, but this is a topic for some
other thread. (look's like in vanillia kernel there is no way
to shape traffic on br0 because egress are on each ethernet
card, so we should shape on ethX - but that statement is based
only on my 1 hour observation on my box acting as a router and
a bridge on 2.6.x - htb classes on br0 was not working. there
is possibility that i was doing something wrong, and that
PacketFlow.png is false)

And even if it is possible, it doesn't make sense to rewrite
already writen matches from iptables to ebtables...
