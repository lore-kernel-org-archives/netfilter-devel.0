From: Cody Tubbs <tubbs@wispdirect.com>
Subject: Re: ipv4options still broken (posted prev w/ no reply)...
Date: Wed, 31 May 2006 10:45:09 -0700
Message-ID: <1149097509.6167.9.camel@mbox>
References: <1149033568.27117@www.broadwayinternet.com>
	<447CD93F.9070103@trash.net> <20060531045445.GA8333@oknodo.bof.de>
	<447DA068.1090507@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <447DA068.1090507@trash.net>
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

What about in a bridged firewall situation, you're saying Linux will
strip these ip options out while forwarding? automatically?  Is this
something that can be turned on or off?

but oh wait, I forgot...
Why does tcpdump show these ip options still attached even when not
forwarding? :) (latest kernel) heh++

On the contrary, you simply asked me who still supports these ip options
and I gave you a minimal list, thus if giving you an answer is annoying,
this thread must be an act of pissing in the wind. 

-Cody Tubbs


On Wed, 2006-05-31 at 15:55 +0200, Patrick McHardy wrote:
> Patrick Schaaf wrote:
> > On Wed, May 31, 2006 at 01:46:07AM +0200, Patrick McHardy wrote:
> > 
> > Patrick, at the risk of annoying you some more: the attitude you showed
> > in this thread, is very annoying in itself. While your work on netfilter
> > is really deeply appreciated, slight-of-hand security evaluations like
> > you showed here, are not.
> > 
> > Maybe you just need to get some more sleep. I hope so.
> 
> I don't like beeing lectured. Linux drops all source route
> options anyway, so this entire discussion is absolutely
> pointless.
> 
