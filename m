From: marian stagarescu <marian@ti.com>
Subject: Re: conntrack and application-triggered port forwarding
Date: 09 Apr 2003 08:52:27 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049892747.23224.30.camel@gt4rvnd11.telogy.design.ti.com>
References: <1049846579.16856.157.camel@gt4rvnd11.telogy.design.ti.com>
	<3E94023A.8080701@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <3E94023A.8080701@rtij.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> The recent match should be able to do this.
> 1. Create a rule that matches the control channel and add the packet to 
> a recent-table.
> 2. Match on the udp reverse packets. and on the reversed source/dest in 
> the recent table. If match, accept.
> 
> Martijn

hi martijn,

thanks for your input. a couple questions on this recent match patch
usage here:

for 1 above:

iptables -I FORWARD -o (NET_IFACE) -p tcp --dport 100 -m recent --name
test --set -j ACCEPT
 
will install src (LAN IP) in recent list

2) Not trying to set the accept for reverse:

iptables -I FORWARD -i (NET_IFACE) -p udp --dport 200 -m recent --name
test --rcheck 

will test against the src ip (NET IP) whereas i need dst ip (LAN IP)

thanks,
marian
