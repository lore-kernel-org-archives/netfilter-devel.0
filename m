From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] expectation use a slab instead of kmalloc
Date: Wed, 02 Jun 2004 01:05:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40BD0BD0.7090103@trash.net>
References: <40BB397B.6050300@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40BB397B.6050300@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

Pablo Neira wrote:
> Hi,
> 
> Attached a patch to use a slab for expectations, I think that this could 
> increase a bit the performance in a system which has lots of expectations.

I like it, mainly because it gives usage statistics and leak-checks for
free.

> 
> I also moved the increment of an expectation refcount to 
> ip_conntrack_expect_alloc because we could use ip_conntrack_expect_put 
> to release an expectation which we just allocated in a helper (well, in 
> current helpers I didn't find any case but there are weird protocols 
> outthere so I think that it's not a bad idea).

I also like this better.

> 
> Patrick, if you consider that it's ok, would you be willing to add this 
> to pom-ng? If I'm missing something, please let me know.

I'm going to add it, but please fix the two minor issues noted below
first.

> 
> regards,
> Pablo
> 
> 
> ------------------------------------------------------------------------
> 
> diff -u -r1.1.1.1 ip_conntrack_core.c
> --- a/net/ipv4/netfilter/ip_conntrack_core.c	11 May 2004 13:07:08 -0000	1.1.1.1
> +++ b/net/ipv4/netfilter/ip_conntrack_core.c	30 May 2004 13:08:00 -0000
> @@ -67,6 +67,7 @@
>  static atomic_t ip_conntrack_count = ATOMIC_INIT(0);
>  struct list_head *ip_conntrack_hash;
>  static kmem_cache_t *ip_conntrack_cachep;
> +static kmem_cache_t *ip_conntrack_expect_cachep;
>  struct ip_conntrack ip_conntrack_untracked;
>  
>  extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
> @@ -176,7 +177,7 @@
>  	IP_NF_ASSERT(atomic_read(&exp->use));
>  	IP_NF_ASSERT(!timer_pending(&exp->timeout));
>  
> -	kfree(exp);
> +	kmem_cache_free(ip_conntrack_expect_cachep, exp);
>  }
>  
>  
> @@ -335,7 +336,7 @@
>  			list_del(&ct->master->expected_list);
>  			master = ct->master->expectant;
>  		}
> -		kfree(ct->master);
> +		kmem_cache_free(ip_conntrack_expect_cachep, ct->master);
>  	}
>  	WRITE_UNLOCK(&ip_conntrack_lock);
>  
> @@ -923,16 +924,17 @@
>  ip_conntrack_expect_alloc()
>  {
>  	struct ip_conntrack_expect *new;
> -	
> -	new = (struct ip_conntrack_expect *)
> -		kmalloc(sizeof(struct ip_conntrack_expect), GFP_ATOMIC);
> +
> +	new = kmem_cache_alloc(ip_conntrack_expect_cachep, GFP_ATOMIC);
>  	if (!new) {
>  		DEBUGP("expect_related: OOM allocating expect\n");
>  		return NULL;
>  	}
>  
> +	DEBUGP("new expectation %p allocated\n", new);

^^^ I don't think we need that

>  	/* tuple_cmp compares whole union, we have to initialized cleanly */
>  	memset(new, 0, sizeof(struct ip_conntrack_expect));
> +	atomic_set(&new->use, 1);
>  
>  	return new;
>  }
> @@ -944,7 +946,6 @@
>  	DEBUGP("new expectation %p of conntrack %p\n", new, related_to);
>  	new->expectant = related_to;
>  	new->sibling = NULL;
> -	atomic_set(&new->use, 1);
>  
>  	/* add to expected list for this connection */
>  	list_add(&new->expected_list, &related_to->sibling_list);
> @@ -998,7 +999,8 @@
>  		}
>  
>  		WRITE_UNLOCK(&ip_conntrack_lock);
> -		kfree(expect);
> +		/* This expectation is not inserted so no need to lock */
> +		kmem_cache_free(ip_conntrack_expect_cachep, expect);
>  		return -EEXIST;
>  
>  	} else if (related_to->helper->max_expected && 
> @@ -1017,7 +1019,7 @@
>  				       related_to->helper->name,
>   		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
>   		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
> -			kfree(expect);
> +			kmem_cache_free(ip_conntrack_expect_cachep, expect);
>  			return -EPERM;
>  		}
>  		DEBUGP("ip_conntrack: max number of expected "
> @@ -1058,7 +1060,7 @@
>  		WRITE_UNLOCK(&ip_conntrack_lock);
>  		DEBUGP("expect_related: busy!\n");
>  
> -		kfree(expect);
> +		kmem_cache_free(ip_conntrack_expect_cachep, expect);
>  		return -EBUSY;
>  	}
>  
> @@ -1379,6 +1381,7 @@
>  	}
>  
>  	kmem_cache_destroy(ip_conntrack_cachep);
> +	kmem_cache_destroy(ip_conntrack_expect_cachep);
>  	vfree(ip_conntrack_hash);
>  	nf_unregister_sockopt(&so_getorigdst);
>  }
> @@ -1431,6 +1434,15 @@
>  		printk(KERN_ERR "Unable to create ip_conntrack slab cache\n");
>  		goto err_free_hash;
>  	}
> +
> +        ip_conntrack_expect_cachep = kmem_cache_create("ip_conntrack_expect",
> +                                          sizeof(struct ip_conntrack_expect),
> +					   0, SLAB_HWCACHE_ALIGN, NULL, NULL);
> +        if (!ip_conntrack_expect_cachep) {
> +                printk(KERN_ERR "Unable to create ip_expect slab cache\n");
> +                goto err_free_conntrack_slab;
> +        }

^^^ Indentation is broken (spaces instead of tabs)

> +
>  	/* Don't NEED lock here, but good form anyway. */
>  	WRITE_LOCK(&ip_conntrack_lock);
>  	/* Sew in builtin protocols. */
> @@ -1458,6 +1470,8 @@
>  
>  	return ret;
>  
> +err_free_conntrack_slab:
> +	kmem_cache_destroy(ip_conntrack_cachep);
>  err_free_hash:
>  	vfree(ip_conntrack_hash);
>  err_unreg_sockopt:

Regards
Patrick
