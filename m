From: Patrick McHardy <kaber@trash.net>
Subject: Re: icmp packets going over wrong link for Local traffic!!!
Date: Thu, 04 Nov 2004 03:02:13 +0100
Message-ID: <41898DA5.4000700@trash.net>
References: <200410272051.i9RKpPoW018624@webmail2.magma.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Netfilter mailing list <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: dravya <dravya@magma.ca>
In-Reply-To: <200410272051.i9RKpPoW018624@webmail2.magma.ca>
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

dravya wrote:

>Hi all,
>
>I have applied the Masquerade patch suggested by Rusty (and now Herbert) and everything
>works just fine. All packets are masqueraded correctly even when there are multiple
>interfaces.
>
>However, there are icmp dest unreachable messages that still go over the wrong link. i.e.
>source addr of the wrong link. Since it is local traffic, it will not go through the
>masquerading code as the socket would exist ( (*pskb)->sk ) will exist, thereby returning
>with NF_ACCEPT and bypassing the masquerade code. 
>

Please describe your setup in more detail and show some examples
of the packets with wrong address.

Regards
Patrick
