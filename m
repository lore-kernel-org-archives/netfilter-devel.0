From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: nf_conntrack: Use net_mutex for helper
 unregistration.
Date: Fri, 6 May 2016 13:03:25 +0200
Message-ID: <20160506110325.GA2420@salvia>
References: <1462488637-46877-1-git-send-email-joe@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Joe Stringer <joe@ovn.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462488637-46877-1-git-send-email-joe@ovn.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Joe,

On Thu, May 05, 2016 at 03:50:37PM -0700, Joe Stringer wrote:
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 3b40ec575cd5..6860b19be406 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -449,10 +449,10 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
>  	 */
>  	synchronize_rcu();
>  
> -	rtnl_lock();
> +	mutex_lock(&net_mutex);
>  	for_each_net(net)
>  		__nf_conntrack_helper_unregister(me, net);
> -	rtnl_unlock();
> +	mutex_unlock(&net_mutex);

This simple solution works because we have no .exit callbacks in any
of our helpers. Otherwise, the helper code may be already gone by when
the worker has a chance to run to release the netns.

If so, probably I can append this as comment to this function so we
don't forget. If we ever have .exit callbacks (I don't expect so), we
would need to wait for worker completion.
