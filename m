From: Martijn Lievaart <m@rtij.nl>
Subject: Re: conntrack and application-triggered port forwarding
Date: Wed, 09 Apr 2003 17:20:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E943A2A.6070602@rtij.nl>
References: <1049846579.16856.157.camel@gt4rvnd11.telogy.design.ti.com> 	<3E94023A.8080701@rtij.nl> <1049892747.23224.30.camel@gt4rvnd11.telogy.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: marian stagarescu <marian@ti.com>
In-Reply-To: <1049892747.23224.30.camel@gt4rvnd11.telogy.design.ti.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

marian stagarescu wrote:

>>The recent match should be able to do this.
>>1. Create a rule that matches the control channel and add the packet to 
>>a recent-table.
>>2. Match on the udp reverse packets. and on the reversed source/dest in 
>>the recent table. If match, accept.
>>
>>Martijn
>>    
>>
>
>hi martijn,
>
>thanks for your input. a couple questions on this recent match patch
>usage here:
>
>for 1 above:
>
>iptables -I FORWARD -o (NET_IFACE) -p tcp --dport 100 -m recent --name
>test --set -j ACCEPT
> 
>will install src (LAN IP) in recent list
>
>2) Not trying to set the accept for reverse:
>
>iptables -I FORWARD -i (NET_IFACE) -p udp --dport 200 -m recent --name
>test --rcheck 
>
>will test against the src ip (NET IP) whereas i need dst ip (LAN IP)
>
>  
>

Mind you, you'll need a more recent (no pun intended) release of 
iptables than the current release, This functionality is not in iptables 
1.2.7a. Look at the homepage for recent 
(http://snowman.net/projects/ipt_recent/) for more information on how to 
use it, there are examples there. Also see my previous post and the 
answer from Stephen Frost (the author of the recent module) (Subject: 
Talking about recent (was: Re: [PATCH] 2.4.x new amanda conntrack + NAT 
support)).

Finally, this kind of questions really belongs on the user-list 
(although in this paprticular instance you where lucky you posted here). 
Please post question about usage of iptables there 
(netfilter@lists.netfilter.org).

HTH,
Martijn Lievaart
