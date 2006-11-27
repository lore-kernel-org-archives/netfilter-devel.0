From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [NETFILTER 02/05]: nf_conntrack: automatic sysctl registation
 for conntrack protocols
Date: Mon, 27 Nov 2006 14:17:20 +0900 (JST)
Message-ID: <200611270517.kAR5HLN4017195@toshiba.co.jp>
References: <20061126144447.4215.87216.sendpatchset@localhost.localdomain>
	<20061126144450.4215.9710.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20061126144450.4215.9710.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 26 Nov 2006 15:44:50 +0100 (MET)

> [NETFILTER]: nf_conntrack: automatic sysctl registation for conntrack protocols
> 
> Add helper functions for sysctl registration with optional instantiating
> of common path elements (like net/netfilter) and use it for support for
> automatic registation of conntrack protocol sysctls.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

The automatic registration is good idea. I expected only nf_ct_register_sysctl().


> +static int nf_ct_l3proto_register_sysctl(struct nf_conntrack_l3proto *l3proto)
> +{
> +	int err = 0;
> +
> +#ifdef CONFIG_SYSCTL
> +	mutex_lock(&nf_ct_proto_sysctl_mutex);
> +	if (l3proto->ctl_table != NULL) {
> +		err = nf_ct_register_sysctl(&l3proto->ctl_table_header,
> +					    l3proto->ctl_table_path,
> +					    l3proto->ctl_table, NULL);
> +	}
> +	mutex_unlock(&nf_ct_proto_sysctl_mutex);
> +#endif
> +	return err;
> +}
> +
> +static void nf_ct_l3proto_unregister_sysctl(struct nf_conntrack_l3proto *l3proto)
> +{
> +#ifdef CONFIG_SYSCTL
> +	mutex_lock(&nf_ct_proto_sysctl_mutex);
> +	if (l3proto->ctl_table != NULL)
> +		nf_ct_unregister_sysctl(&l3proto->ctl_table_header,
> +					l3proto->ctl_table, NULL);
> +	mutex_unlock(&nf_ct_proto_sysctl_mutex);
> +#endif
> +}

How about inline ?

> +

(snip)

>  int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto)
>  {
>  	int ret = 0;
> @@ -139,6 +195,12 @@ int nf_conntrack_l3proto_register(struct
>  		goto out_unlock;
>  	}
>  	nf_ct_l3protos[proto->l3proto] = proto;
> +	write_unlock_bh(&nf_conntrack_lock);
> +
> +	ret = nf_ct_l3proto_register_sysctl(proto);
> +	if (ret < 0)
> +		nf_conntrack_l3proto_unregister(proto);
> +	return ret;

Is this safe ? The neither nf_ct_unregister_sysctl nor nf_unregister_sysctl
doesn't have NULL check for header. nf_conntrack_l4proto_register() has
same issue as well.

>  
>  out_unlock:
>  	write_unlock_bh(&nf_conntrack_lock);
> @@ -165,6 +227,8 @@ int nf_conntrack_l3proto_unregister(stru
>  	nf_ct_l3protos[proto->l3proto] = &nf_conntrack_l3proto_generic;
>  	write_unlock_bh(&nf_conntrack_lock);
>  
> +	nf_ct_l3proto_unregister_sysctl(proto);
> +
>  	/* Somebody could be still looking at the proto in bh. */
>  	synchronize_net();
>  
> @@ -175,6 +239,35 @@ out:
>  	return ret;
>  }
>  

(snip)

> +static struct ctl_table *
> +path_dup(struct ctl_table *path, struct ctl_table *table)
> +{
> +	struct ctl_table *t, *last = NULL, *tmp;
> +
> +	for (t = path; t != NULL; t = t->child) {
> +		tmp = kmemdup(t, 2 * sizeof(*t), GFP_KERNEL);

Why twice space is necessary ?

> +		if (tmp == NULL) {
> +			if (last != NULL)
> +				path_free(path, table);
> +			return NULL;
> +		}
> +
> +		if (last != NULL)
> +			last->child = tmp;
> +		else
> +			path = tmp;
> +		last = tmp;
> +	}
> +
> +	if (last != NULL)
> +		last->child = table;
> +	else
> +		path = table;
> +
> +	return path;
> +}

-- Yasuyuki Kozakai
