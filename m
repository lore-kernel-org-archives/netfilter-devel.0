From: Martijn Lievaart <m@rtij.nl>
Subject: Re: conntrack and application-triggered port forwarding
Date: Wed, 09 Apr 2003 13:21:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E94023A.8080701@rtij.nl>
References: <1049846579.16856.157.camel@gt4rvnd11.telogy.design.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: marian stagarescu <marian@ti.com>
In-Reply-To: <1049846579.16856.157.camel@gt4rvnd11.telogy.design.ti.com>
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

>i may be missing something elementary about conntrack & nat & firewall
>so please let me know if the following feature is supported in linux
>because i don't quite see it:
>
>outside the scope of specialized ALGs (e.g. ftp, h323,...) i want 
>to be able to specify that an outbound tcp/udp connection to dstport x
>will require that related traffic be allowed inbound on port y.
>
>that is to say, for a gateway:
>
>NET---| NAT/Conntrack/Firewall |---(private LAN)
>
>_IF_AND_ONLY_IF_ traffic goes from LAN on tcp/dstport X open
>forward chain to allow related udp/dstport Y to go back on LAN.
>(i have a drop policy on forward chain for traffic with input interface
>facing NET).
>
>in this example the tcp traffic will be playing the role of the control
>channel and the udp the data channel but since I know that it operates
>on predefined ports (or port ranges) i don't have to snoop into the
>control channel and get the data channel port.
>
>this will be some "generic" ALG mechanism so that for applications that
>are operating on known ports (or port ranges) i can use it without an
>ALG implementation proper.
>
>I can use static rules that will open udp/dstport Y but forward path
>will be open on this rule (proto/port) regardless of the presence of
>outbound tcp/dstport x traffic. so opening the firewall is not triggered
>by an application.
>
>
>Not being too familiar with the internals and api  of conntrack i
>wonder: is such a task easy (example pointers ?)? 
>  
>

The recent match should be able to do this.
1. Create a rule that matches the control channel and add the packet to 
a recent-table.
2. Match on the udp reverse packets. and on the reversed source/dest in 
the recent table. If match, accept.

Martijn
