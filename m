From: Patrick McHardy <kaber@trash.net>
Subject: Re: new ABI
Date: Wed, 23 Aug 2006 07:01:50 +0200
Message-ID: <44EBE13E.9020605@trash.net>
References: <200608142312.41851.max@nucleus.it>	<20060816121653.GA31235@kriss.csbnet.se>
	<Pine.LNX.4.58.0608220901120.4038@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0608220901120.4038@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> My views on how to communicate is a little bit old-fashioned as I'm
> perfectly satisfied with sockopt. Yes, dusty. And old. Maybe even not cool
> but a hack. But reliable, which cannot absolutely be said about netlink.
> I shudder to think about the situation when a DDoS attack could prevent or
> just delay me to reconfigure a firewall. And please note even if we accept
> delaying it assumes that we are willing to face reimplementing a TCP-alike
> protocol over netlink to guarantee reliable message passing.

I don't think a DoS attack could prevent you from using netlink any
more than it could from setsockopt (netlink is even more efficient due
to less data copied around). Reliability is not hard to achieve on the
userspace->kernel path if you don't mind eating one RTT for each rule
update (which is not very large), just send the update and wait for
an ACK or an error, then handle it. Having more than one message in
flight introduces another problem besides congestion control and
reliable transmission, the resulting ruleset in the kernel might
depend on the order in which messages are received, if messages are
dropped in the middle and are simply retransmitted it will be wrong.
This should probably not be done.

> Yes. And I'd add one more priciple:
> 
> + All parts must be designed to take into account rule- and
>   (match/target) state-replication between firewalls in active-active
>   setups.

Agreed, that would be nice to have (and not very hard).
