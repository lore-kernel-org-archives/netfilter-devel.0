From: Glen Turner <glen.turner@aarnet.edu.au>
Subject: Re: [PATCH] Add TCPCONG target to patch-o-matic
Date: Thu, 12 Oct 2006 10:07:04 +0930
Message-ID: <452D8E30.5010909@aarnet.edu.au>
References: <45235EDC.4080709@aarnet.edu.au>
	<4524118B.4020903@netfilter.org>	<4524BBB2.2000109@aarnet.edu.au>
	<452A66CA.70603@trash.net>	<452B4512.4070705@aarnet.edu.au>
	<452C81E2.1040206@trash.net> <20061011130413.6d44063f@freekitty>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Hemminger <shemminger@osdl.org>
In-Reply-To: <20061011130413.6d44063f@freekitty>
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

Stephen Hemminger wrote:
> I don't like iptables interacting back with the socket state.

Sounds like a no to me :-)

Patrick, what's the easiest way to maintain this out of Netfilter?
As a patch to patch-o-matic or as a direct patch to iptables and
the kernel?

[ For those following this from the archive at some time in the
   future, I'll put the patch at
   <http://www.aarnet.edu.au/~gdt/patch/tcpcong/> ]

> The only congestion control that makes sense to be application specific
> is the TCP-LP stuff. The others are just duking it out, to see which
> one should be the default.

I'd expect to see more application-specific and link-specific
algorithms in the future.  In the long run you might need more
pseudo-algorithms (eg: "default-lossy-link" to select the kernel's
default algorithm for wireless links).

> I want to put the congestion choice in the route metrics as an option,
> just haven't got around to doing it that way. The only advantage do
> doing it in IP tables is that you can make rules by port etc.

I think it's more complex than that to get a nice behaviour:
   socket, which gets its default from
   route, which gets its default from
   interface, which get its default from
   the global sysctl.
I'm not sure how much of this behaviour can be implemented from
user space.

Thanks for your response,
Glen

-- 
  Glen Turner         Tel: (08) 8303 3936 or +61 8 8303 3936
  Australia's Academic & Research Network  www.aarnet.edu.au
