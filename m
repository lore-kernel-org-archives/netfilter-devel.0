From: Josh Samuelson <josamue1@wsc.edu>
Subject: Re: [PATCH] new match extension `flow'
Date: Sun, 7 Nov 2004 20:52:41 -0600
Message-ID: <20041108025241.GA4850@wsc.edu>
References: <20041028020550.GA10097@wsc.edu> <41829ADC.2090708@eurodev.net>
	<20041031063813.GA29402@wsc.edu> <4184F9AD.9040902@eurodev.net>
	<20041104022039.GA25749@wsc.edu> <418CEB7A.9080505@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <418CEB7A.9080505@eurodev.net>
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

Hi Pablo,

On Sat, Nov 06, 2004 at 04:19:22PM +0100, Pablo Neira wrote:
> Hi Josh,
> please, don't forget that we are still discussing the event API. As this 
> new match goes on top of it, we can hold this patch until the event API 
> is pushed forward. Then we'll go back this point.

Indeed.

> 
> Some comments:
> 
> >diff -Pru linux-2.6.9/include/linux/netfilter_ipv4/ip_cte_flow.h 
> >linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_cte_flow.h
> >--- linux-2.6.9/include/linux/netfilter_ipv4/ip_cte_flow.h	1969-12-31 
> >18:00:00.000000000 -0600
> >+++ linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_cte_flow.h 2004-11-03 
> >19:10:13.000000000 -0600
> > 
> >
> 
> I see two possibilities here:
> 
> a) move ip_cte_flow.[h|c] to ipt_flow.[h|c], matches always fit in a file.
> b) rename ip_cte_flow to ip_conntrack_flow_stats, this could be a module 
> which generates stats about current connections going through the firewall.
> 
> I need to give more spins to this issue.
> 
> Any comments?
> 
> Pablo

In regards to ip_cte_flow.[h|c], I wasn't sure how to handle this module
with respect to the filesystem namespace.  Those files don't provide
any of the match functionality; it just tracks the flows from the CTE
API, exports a few functions, the linked list of flows and provides
"/proc/net/ip_cte_flow" file.  All of which I'm sure you know by the
source, but just to provide some context for those who perhaps haven't
glanced at it.  The main reason I called ip_cte_flow was because it's
built on/requires 'CTE' functionality.  I figure there is the
potential for a lot of modules needing the CTE API and perhaps the need
to separate those files that require it into a differing filesystem
namespace that can't really be classified as a match/target, etc?
If you prefer ip_conntrack_flow_stats, I'm really not partial to
anything.

The ipt_flow.[h|c] file builds on top of the prior module to provide the
match functionality and to track network/mask based flows.  I separated the
two because I can see the need to track the flows via /proc outside of the
iptables match.  I.e. to just have a quick glance at who may be responsible
for a sudden burst of flows.  Or to allow for other match modules
to build on top of it in ways that my simple match module lacks, etc.

Those are my thoughts on why I did things the way I did.  :)

Cheers,
Josh
