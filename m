From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/10][CTNETLINK] Fix race condition on conntrack creation
Date: Fri, 07 Jul 2006 06:45:40 +0200
Message-ID: <44ADE6F4.2090909@trash.net>
References: <44ADC336.1060004@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44ADC336.1060004@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Current conntrack creation path can run into rare race conditions, make
> the creation process atomic.
> 
> As side-effect, this patch simplifies the conntrack core API.
> 
> This patch depends on [PATCH 4/10] and [PATCH 5/10]
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Commenting on this and the next two at once, since they belong together.
First of all, they are ordered incorrectly, the code should compile and
stay working between all patches, otherwise it makes understanding and
testing individual patches harder and people doing bisections will
have unpleasant surprises. This patch uses a function that is only
introduced two patches later and introduces a deadlock by only removing
the lock inside ip_conntrack_hash_insert one patch later. All this looks
like it belongs in a single patch.

> ------------------------------------------------------------------------
> 
> [CTNETLINK] Fix race condition on conntrack creation
> 
> Current conntrack creation path can run into rare race conditions, make
> the creation process atomic.

In patch 5 you refer to timer activation and hash insertion. Why does
helper lookup needs to be done inside the lock?

> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
> ===================================================================
> --- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-07 00:15:14.000000000 +0200
> +++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-07 01:52:14.000000000 +0200
> @@ -1059,13 +1059,12 @@ ctnetlink_create_conntrack(struct nfattr
>  		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
>  #endif
>  
> -	ct->helper = ip_conntrack_helper_find_get(rtuple);
> -
> -	add_timer(&ct->timeout);
> +	/* we do no want any races on hash insertion */
> +	write_lock_bh(&ip_conntrack_lock);
> +	ct->helper = ip_conntrack_helper_find(rtuple);
>  	ip_conntrack_hash_insert(ct);
> -
> -	if (ct->helper)
> -		ip_conntrack_helper_put(ct->helper);
> +	add_timer(&ct->timeout);
> +	write_unlock_bh(&ip_conntrack_lock);
>  
>  	DEBUGP("conntrack with id %u inserted\n", ct->id);
>  	return 0;

I also see another race, the caller of create_conntrack does a lookup
within locks, drops the locks and we reaquire them here. The entire
lookup-insertion needs to be atomic.

>From patch 5:

> --- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_core.c 2006-07-06
23:27:55.000000000 +0200
> +++ net-2.6/net/ipv4/netfilter/ip_conntrack_core.c	2006-07-06
23:28:41.000000000 +0200
> @@ -428,12 +428,12 @@ void ip_conntrack_hash_insert(struct ip_
>  {
> 	unsigned int hash, repl_hash;
>
> +	ASSERT_WRITE_LOCK(&ip_conntrack_lock);
> +	
>  	hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
>  	repl_hash = hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
>
> -	write_lock_bh(&ip_conntrack_lock);
>  	__ip_conntrack_hash_insert(ct, hash, repl_hash);
> -	write_unlock_bh(&ip_conntrack_lock);
>  }

Since we already have the hash values in the caller of create_conntrack
and should hold the locks across the lookup-insertion anyway I think
this obsoletes this entire function.
