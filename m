From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [NETFILTER 08/08]: nf_conntrack: UDPLITE support
Date: Mon, 16 Jul 2007 17:07:24 +0900 (JST)
Message-ID: <200707160807.l6G87PXh007485@toshiba.co.jp>
References: <20070714151200.9829.67499.sendpatchset@localhost.localdomain>
	<200707141654.l6EGs6XG008905@toshiba.co.jp>
	<469956AF.7060807@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net,
	yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469956AF.7060807@trash.net>
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

From: Patrick McHardy <kaber@trash.net>

> >>[NETFILTER]: nf_conntrack: UDPLITE support
> > 
> > 
> > Maybe you predict this question :) Why do you think that new module is
> > needed instead of reusing codes in nf_conntrack_proto_udp.c ?
> 
> 
> I did :) Reusing code for the conntrack helper didn't seem to buy
> much, the only two functions that actually do anything besides
> copying header values are too different to merge (checksumming/
> packet handling). It also needs seperate sysctls, which is
> responsible for another 20%-30% of the code. So it comes down to
> saving two or three completely trivial functions, which is IMO
> not even worth exporting them.
> 
> For the NAT helpers it makes a lot more sense. The port selection
> logic, the in_range check, the manip_pkt function for UDP/TCP
> and the nf_conntrack_netlink functions could all be generalized
> and moved to a common helper helper :) This is the main reason
> why I didn't include a NAT helper yet, I have some unfinished
> work to do all that.

That is nice idea. Thanks for explanation.

-- Yasuyuki Kozakai
