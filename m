From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: conntrack matching
Date: Tue, 8 Jun 2004 20:03:33 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406082001010.27536-100000@filer.marasystems.com>
References: <40C5F7D4.201@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthias Dettling <m-dettling@gmx.de>
In-Reply-To: <40C5F7D4.201@gmx.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 8 Jun 2004, Matthias Dettling wrote:

> last week I hadn't much time for answering your mail. But meantime I
> thought a while about your recommendation to match numbers in network
> byte order. I think this proposal would be appropriate, if I only would
> match a single port. But like your patch I also want to match port
> ranges. And that's the problem.

Indeed. If you want to match ranges then matching needs to be done in host 
byte order, not network byte order.

Only for exact matches is there a benefit of having the match data in 
network byte order.

Note that I never meant to move the ntohs functions to userspace. What
would be used in userspace is htons to translate the user input to network 
byte order for matching to the packets in the kernel.

Regards
Henrik
