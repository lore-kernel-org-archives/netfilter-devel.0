From: Robert Love <rml@novell.com>
Subject: Re: GFP_ATOMIC vs GFP_KERNEL in netfilter module
Date: Thu, 02 Dec 2004 19:31:49 -0500
Message-ID: <1102033909.6052.24.camel@localhost>
References: <92A26C52-44B7-11D9-A62F-000A957B2B6C@inf.ufrgs.br>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261815AbULCAak@vger.kernel.org>
To: Roberto Jung Drebes <drebes@inf.ufrgs.br>
In-Reply-To: <92A26C52-44B7-11D9-A62F-000A957B2B6C@inf.ufrgs.br>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2004-12-02 at 21:12 -0200, Roberto Jung Drebes wrote:

> If I use GFP_KERNEL with the kmallocs, I get errors like

So don't use GFP_KERNEL; use GFP_ATOMIC.  You cannot sleep in netfilter
hooks, since they are run in interrupt context (when the packet is
received) by the net_rx_action softirq.  You can see this in your stack
trace.

> If I use GFP_ATOMIC, I don't get the error, but I think timers are not 
> being called after the delay. I have a similar code for transmition, 
> which works OK with GFP_KERNEL (delays messages) but with GFP_ATOMIC it 
> does also not delay.

If you have problems with GFP_ATOMIC, the problem is elsewhere and not
in the fact that your allocations are atomic versus not.

First thing, though, check the return value from kmalloc for failure (dp
and tl equal NULL) to ensure that the allocation is even working!

	Robert Love
