From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipv4options still broken (posted prev w/ no reply)...
Date: Wed, 31 May 2006 20:39:47 +0200
Message-ID: <447DE2F3.8090104@trash.net>
References: <1149033568.27117@www.broadwayinternet.com>	
	<447CD93F.9070103@trash.net> <20060531045445.GA8333@oknodo.bof.de>	
	<447DA068.1090507@trash.net> <1149097509.6167.9.camel@mbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Cody Tubbs <tubbs@wispdirect.com>
In-Reply-To: <1149097509.6167.9.camel@mbox>
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

Cody Tubbs wrote:
> What about in a bridged firewall situation, you're saying Linux will
> strip these ip options out while forwarding? automatically?  Is this
> something that can be turned on or off?
> 
> but oh wait, I forgot...
> Why does tcpdump show these ip options still attached even when not
> forwarding? :) (latest kernel) heh++

I never said anything about stripping, but you're right that bridging
will happily forward them.

> On the contrary, you simply asked me who still supports these ip options
> and I gave you a minimal list, thus if giving you an answer is annoying,
> this thread must be an act of pissing in the wind. 

Its very simple, just keep things like "101 something", "root of
stupidity" and "heh++" to yourself and you'll make a much better
impression. Until then I choose to ignore you.
