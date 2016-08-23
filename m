From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v2 2/2] xtables-compat: add rule cache
Date: Tue, 23 Aug 2016 13:58:14 +0200
Message-ID: <20160823115814.GB26961@salvia>
References: <20160822151119.16165-1-pablombg@gmail.com>
 <20160822151119.16165-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38468 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757175AbcHWL61 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 07:58:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B730FB6C7E
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 13:58:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5F2ADA7FC
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 13:58:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74825100A7A
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 13:58:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160822151119.16165-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 05:11:19PM +0200, Pablo M. Bermudo Garay wrote:
> This patch adds a cache of rules within the nft handle. This feature is
> more useful after the new checks of ruleset compatibility, since the
> rule list is loaded twice consecutively.
> 
> Now all the operations causing changes in the ruleset must invalidate
> the cache, a function called flush_rule_cache has been introduced for
> this purpose.
> 
> Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
> ---
>  iptables/nft.c | 35 +++++++++++++++++++++++------------
>  iptables/nft.h |  1 +
>  2 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 8a06283..ad2f232 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -780,8 +780,17 @@ int nft_init(struct nft_handle *h, struct builtin_table *t)
>  	return 0;
>  }
>  
> +static void flush_rule_cache(struct nft_handle *h)
> +{
> +	if (h->rule_cache) {

Mejor así?

        if (!h->rule_cache)
                return

        nftnl_rule_list_free(h->rule_cache);

Cuando más niveles de indentación más complejo se hace un código, más
difícil de leer.

> +		nftnl_rule_list_free(h->rule_cache);
> +		h->rule_cache = NULL;

¿Creo que este h->rule_cache = NULL no hace falta?

> +	}
> +}
> +
>  void nft_fini(struct nft_handle *h)
>  {
> +	flush_rule_cache(h);
>  	mnl_socket_close(h->nl);
>  	free(mnl_nlmsg_batch_head(h->batch));
>  	mnl_nlmsg_batch_stop(h->batch);
> @@ -1121,6 +1130,7 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
>  	if (batch_rule_add(h, type, r) < 0)
>  		nftnl_rule_free(r);
>  
> +	flush_rule_cache(h);

¿Anulamos la cache por cada append()? Creo recordar que este código
también se ejercita desde iptables-compat-restore.

>  	return 1;
>  }
>  
> @@ -1284,6 +1294,9 @@ static struct nftnl_rule_list *nft_rule_list_get(struct nft_handle *h)
>  	struct nftnl_rule_list *list;
>  	int ret;
>  
> +	if (h->rule_cache)
> +		return h->rule_cache;
> +
>  	list = nftnl_rule_list_alloc();
>  	if (list == NULL)
>  		return 0;
> @@ -1297,6 +1310,7 @@ static struct nftnl_rule_list *nft_rule_list_get(struct nft_handle *h)
>  		return NULL;
>  	}
>  
> +	h->rule_cache = list;
>  	return list;
>  }
>  
> @@ -1333,7 +1347,6 @@ next:
>  	}
>  
>  	nftnl_rule_list_iter_destroy(iter);
> -	nftnl_rule_list_free(list);
>  
>  	/* the core expects 1 for success and 0 for error */
>  	return 1;
> @@ -1396,6 +1409,7 @@ next:
>  	}
>  
>  	nftnl_chain_list_iter_destroy(iter);
> +	flush_rule_cache(h);
>  err:
>  	nftnl_chain_list_free(list);

Se hace el flush y se hace el free() ?

>  
> @@ -1829,8 +1843,6 @@ int nft_rule_check(struct nft_handle *h, const char *chain,
>  	if (ret == 0)
>  		errno = ENOENT;
>  
> -	nftnl_rule_list_free(list);

¿Aquí ahora no hay nada?

> -
>  	return ret;
>  }
>  
> @@ -1855,7 +1867,7 @@ int nft_rule_delete(struct nft_handle *h, const char *chain,
>  	} else
>  		errno = ENOENT;
>  
> -	nftnl_rule_list_free(list);
> +	flush_rule_cache(h);
>  
>  	return ret;
>  }
> @@ -1879,6 +1891,7 @@ nft_rule_add(struct nft_handle *h, const char *chain,
>  		return 0;
>  	}
>  
> +	flush_rule_cache(h);
>  	return 1;
>  }
>  
> @@ -1908,7 +1921,7 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
>  			r = nft_rule_find(h, list, chain, table, data,
>  					  rulenum - 1);
>  			if (r != NULL) {
> -				nftnl_rule_list_free(list);
> +				flush_rule_cache(h);
>  				return nft_rule_append(h, chain, table, data,
>  						       0, verbose);
>  			}
> @@ -1920,12 +1933,12 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
>  		handle = nftnl_rule_get_u64(r, NFTNL_RULE_HANDLE);
>  		DEBUGP("adding after rule handle %"PRIu64"\n", handle);
>  
> -		nftnl_rule_list_free(list);
> +		flush_rule_cache(h);
>  	}
>  
>  	return nft_rule_add(h, chain, table, data, handle, verbose);
>  err:
> -	nftnl_rule_list_free(list);
> +	flush_rule_cache(h);
>  	return 0;
>  }
>  
> @@ -1953,7 +1966,7 @@ int nft_rule_delete_num(struct nft_handle *h, const char *chain,
>  	} else
>  		errno = ENOENT;
>  
> -	nftnl_rule_list_free(list);
> +	flush_rule_cache(h);
>  
>  	return ret;
>  }
> @@ -1983,7 +1996,7 @@ int nft_rule_replace(struct nft_handle *h, const char *chain,
>  	} else
>  		errno = ENOENT;
>  
> -	nftnl_rule_list_free(list);
> +	flush_rule_cache(h);
>  
>  	return ret;
>  }
> @@ -2037,8 +2050,6 @@ next:
>  
>  	nftnl_rule_list_iter_destroy(iter);
>  err:
> -	nftnl_rule_list_free(list);
> -

¿Aquí ahora no hay nada?

>  	if (ret == 0)
>  		errno = ENOENT;
>  
> @@ -2266,7 +2277,7 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
>  			       false);
>  
>  error:
> -	nftnl_rule_list_free(list);
> +	flush_rule_cache(h);
>  
>  	return ret;
>  }
> diff --git a/iptables/nft.h b/iptables/nft.h
> index f5449db..4126593 100644
> --- a/iptables/nft.h
> +++ b/iptables/nft.h
> @@ -35,6 +35,7 @@ struct nft_handle {
>  	struct mnl_nlmsg_batch	*batch;
>  	struct nft_family_ops	*ops;
>  	struct builtin_table	*tables;
> +	struct nftnl_rule_list	*rule_cache;
>  	bool			restore;
>  	bool			batch_support;
>  };
> -- 
> 2.9.3
> 
