From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: current in OUTPUT
Date: Thu, 10 Mar 2005 14:13:34 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0503101412070.3198@tux.rsn.bth.se>
References: <42304342.3050009@evtek.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
To: Juha Heljoranta <juha.heljoranta@evtek.fi>
In-Reply-To: <42304342.3050009@evtek.fi>
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

On Thu, 10 Mar 2005, Juha Heljoranta wrote:

> 'current' macro is not guaranteed to give a task that originated packet
> when OUTPUT chain is been processed, right?

Right, there's some things that isn't sent from process context. Delayed
ACKs (timer context) and icmp replies (softirq context) are two examples.

/Martin
