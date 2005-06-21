From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Tue, 21 Jun 2005 23:50:27 +0200
Message-ID: <20050621215027.GP8335@postel.suug.ch>
References: <42A5B144.3090005@tac.ch> <42A625DA.7090807@eurodev.net>
	<42A6AB19.2040106@tac.ch> <42A6E685.3060408@eurodev.net>
	<42AEF774.8060300@tac.ch> <42B67BEC.1090105@tac.ch>
	<20050621003441.GI8335@postel.suug.ch>
	<42B76474.8080209@eurodev.net>
	<20050621111328.GK8335@postel.suug.ch> <42B81D75.8090205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42B81D75.8090205@trash.net>
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

* Patrick McHardy <42B81D75.8090205@trash.net> 2005-06-21 16:00
> Thomas Graf wrote:
> >>If the module gets unloaded, ip_conntrack_untracked refcount isn't 
> >>decreased, it's still 1. So destroy() is never called. In that case it 
> >>should be really easy to trigger on my slow laptop ;->.
> > 
> > How do you explain the BUG() being triggered then?
> 
> Pablo mentioned to me in private mail that he believes the reason
> is packets holding references to ip_conntrack_untracked on module
> removal. I agree, and this patch should fix it. Roberto, could
> you please try it and tell me if it helps?
>
> +	/* wait until all references to ip_conntrack_untracked are dropped */
> +	while (atomic_read(&ip_conntrack_untracked.ct_general.use) > 1)
> +		schedule();

This patch seems fine but it cannot fix the bug. The fact that we
trigger the BUG() implies a serious problem which is that we'd be
calling destroy() on a conntrack entry which was never allocated.
As far as I understood Roberto correctly it happens once he's
unloading the conntrack modules which means that up to that point
we still have > 1 references on that entry. So I think we have
two problems:

 a) We might be calling destroy() on dummy conntrack entries
    such as ip_conntrack_untracked which causes corruption.
 
 b) There might be conntrack entries in caches while removing
    modules.
