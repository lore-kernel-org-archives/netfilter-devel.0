From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: A question about reinjecting packets
Date: Thu, 12 Feb 2004 03:04:10 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402120248440.11347-100000@filer.marasystems.com>
References: <20040211155807.GA3146@lain.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Paul Tipper <tipper@wintermute.me.uk>
In-Reply-To: <20040211155807.GA3146@lain.localnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 11 Feb 2004, Paul Tipper wrote:

> I'm working on an implementation of an IPv4 to IPv6 bump in the stack (yes
> I admit it, I'm a student) and while doing this I've gotten stuck at the
> stage of reinjecting packets into the network.  The model I'm working with
> is a little kludgey but in short translates v6 addresses to Class E v4
> addresses so that they can be consistently addressed.

For various compliated reasons I would recommend such transitions to occur
via a virtual network device rather than rewriting the packet within the 
stack. This to ensure correct operation with conntrack etc. But that is 
another story.

> So as far as I can see I've modified everything I need to change to make
> this v4 sk_buff into a v6 one, the problem I then run into is I can find
> no way of getting it successfully out onto the network.

Is there an IPv6 stack enabled on this server?

> I've tried using ip6_xmit() (for which I constructed a struct flowi).

Should work I think, but I am not sure.

ipv6_rcv() is a safer bet I think. Also has the benefit that the IPv6 
packet will be routed and forwarded like normal requiring much less setup, 
and plays better with netfilter conntrack.

Regards
Henrik
