From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Question about IP rerouting at POST_ROUTE_HOOK
Date: Mon, 1 Mar 2004 17:33:04 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403011731030.12756-100000@filer.marasystems.com>
References: <OFAFE494A0.B2169671-ON88256E4A.000CABC4@tais.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Glenn.Swonk@tais.com
In-Reply-To: <OFAFE494A0.B2169671-ON88256E4A.000CABC4@tais.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 29 Feb 2004 Glenn.Swonk@tais.com wrote:

> I am trying to change the destination (IP address) of the packet at this
> point and am having a problem.
> 
> I am able to change the dest IP address but it is sent out with the
> original IP destination's  MAC address.

See ip_route_me_harder usage in iptables (iptable_mangle is a good and
clear example on this)

As you have hooked in to the IP kernel after routing have already taken 
place it is your responsibility to rerout the packet if you make 
modifications which should affect how the packet is routed.

Regards
Henrik
