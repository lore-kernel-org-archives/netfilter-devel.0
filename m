From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: RE : RE : Apply rules to 1 UDP port but port used as a socket:
 possible?
Date: Wed, 11 Feb 2004 17:58:57 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402111749210.4956-100000@filer.marasystems.com>
References: <D4EF10CCEB2CE742BEEA9838C590B0E8011CB5D4@ftrdmel2.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zze-Proxy GRALL O ext FTRD/SVA/LAN <ograll.ext@rd.francetelecom.com>
In-Reply-To: <D4EF10CCEB2CE742BEEA9838C590B0E8011CB5D4@ftrdmel2.rd.francetelecom.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 11 Feb 2004, zze-Proxy GRALL O ext FTRD/SVA/LAN wrote:

> For the moment I need an UDP socket. After treatment, I want the
> following packets to be NATed. If I inspect these packets thanks to
> QUEUE target(passing to userspace, isn't it?) I don't know what will
> permit to apply NAT rules... I don't understand exactly what you mean ?

You can not let the initial packet be accepted by the local IP stack. 
If you do that then the session will be fully created and future packets 
of the same session will go the smae way.

You MUST intercept the packet before it reaches the local IP stack, or to 
be precise before the packet reaches netfilter nat PREROUTING.

One good way of doing this is to use QUEUE in mangle PREROUTING. The 
mangle PREROUTING hook is called just before nat PREROUTING.

> So your solution is to use libipq after a rule like this:
> 
> iptables -t mangle -A PREROUTING -p udp -s REMOTE_ADDR --sport REMOTE_PORT -d LOCAL_ADDR --dport 1727 -j QUEUE
> 
> Is it what you mean ?
> 
> In this way I can inspect the packet in userspace.

Exacly.

> Do you want to say I do the NAT in the userspace ? 

No. The packet will reenter the kernel once you are done with it in your 
queue handler, and will then enter the nat table and a NAT session will be 
created.

> But if conntrack is already set up, packets won't arrive to mangle PREROUTING, isn't it ?

All packets get to mangle PREROUTING. It is only the nat table that is 
magic.

You will need some rules in mangle to determine that this is the first
packet. Maybe -m state --state NEW may be sufficient for your task but 
keep in mind that this also matches retransmissions until traffic is seen 
in both directions.

Regards
Henrik
