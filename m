From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [PATCH] make happy cracking message more verbose
Date: Fri, 7 Nov 2003 15:30:12 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0311071431080.4534@dns.toxicfilms.tv>
References: <Pine.LNX.4.51.0311062049040.953@dns.toxicfilms.tv>
 <3FAADD04.7020200@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3FAADD04.7020200@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

> of the offending process after receiving these messages
> for 8 days.
I have had the same here :) That's why i tried to debug it.

> It turned out to be an unrelated bug, located
> in skb_copy_expand.
Hmm, is there a fix ? I would like to test it, and see if
it still happens on my box.

> If any we should print the name of the process producing
> the packets, or "kernel" if they are produced out of process
> context.
That is of course better than what I was trying. Anyway
I am glad that this area is being looked at.

> Still I don't see the point in iptables trying
> to perform IDS actions, in my opinion a counter should
> be incremented and nothing should be printed at all.
Seems reasonable.

> Patrick
Maciej
