From: =?ISO-8859-2?Q?Tom=E1=B9_Macek?= <maca02@atlas.cz>
Subject: cannot kmalloc nor vmalloc
Date: Mon, 17 Jan 2005 20:00:55 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0501171957130.8115@maca.fortech.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi, I'm just developing a new "match" (like ipt_limit for example) iptables module under RH FC 2, kernel 2.6.5-1.328.
If I make a request for about 100 kB of memory in the registered match function in my module by means of kmalloc(size, GPF_ATOMIC) and set it via memset() to zero, the computer freezes with kernel panic and debugging output. Maybe it has not enaugh memory. I tried something more and never got more than about 40 kB.

Then I tried to get more memory with the vmalloc() function. But vmalloc() is called with the GPF_KERNEL flag, so I cannot use it in the interrupt = I cannot use it in the match function. The vmalloc gives also the debugging output to the log, but it does not freezes the computer when called from inside the match function.

I also tried to get large chunk of memory outside the match function, just before I register the match - in the __init() of my module, and I was able to get more than 100 MB via vmalloc().

How can I get bigger chunk of memory in the interrupt? I will need more (about 5-10) chunks of 100 kB memory.

Any help will be very appreciated!

Tomas
