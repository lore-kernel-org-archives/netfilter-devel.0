From: Peter Stamfest <peter@stamfest.at>
Subject: Re: conntrack matching
Date: Tue, 8 Jun 2004 20:21:51 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406082015390.5747-100000@peter.stamf.pr.at>
References: <Pine.LNX.4.44.0406082001010.27536-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0406082001010.27536-100000@filer.marasystems.com>
ReSent-Message-ID: <Pine.LNX.4.44.0406082028180.5747@peter.stamf.pr.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 8 Jun 2004, Henrik Nordstrom wrote:

> Date: Tue, 8 Jun 2004 20:03:33 +0200 (CEST)
> From: Henrik Nordstrom <hno@marasystems.com>
> To: Matthias Dettling <m-dettling@gmx.de>
> Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
> Subject: Re: conntrack matching
> 
> On Tue, 8 Jun 2004, Matthias Dettling wrote:
> 
> > last week I hadn't much time for answering your mail. But meantime I
> > thought a while about your recommendation to match numbers in network
> > byte order. I think this proposal would be appropriate, if I only would
> > match a single port. But like your patch I also want to match port
> > ranges. And that's the problem.
> 
> Indeed. If you want to match ranges then matching needs to be done in host 
> byte order, not network byte order.

Funny, my table match module I posted a couple of days ago has the same
"problem" - there Network Adresses have to be compared in host byte order
because it deals with ranges of IP adresses. As always, it is just a
matter of what is more appropriate for the task. Comparing adress ranges
only gets "complicated" with IPv6 Adresses - 128bit Architectures
pending...
 
peter
