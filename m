From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] nf_ct_destroy for nf_conntrack_destroy callbacks
Date: Fri, 01 Jun 2007 09:32:34 +0900 (JST)
Message-ID: <200706010032.l510WZTm000963@toshiba.co.jp>
References: <e6af3bc80705310736kd3a8747x6aedf9cedcbaa99e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: mmohsenz@gmail.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <e6af3bc80705310736kd3a8747x6aedf9cedcbaa99e@mail.gmail.com>
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


Hi,

From: "Mohammad Mohsenzadeh" <mmohsenz@gmail.com>
Date: Thu, 31 May 2007 10:36:39 -0400

> Hello,
> I made this patch to allow multiple modules to register for conntrack
> destroy callback. I was wondering what are your thoughts on this.
> Thanks

I have a plan to add it with ct_extend - which allocates extended area in
conntrack. Please see archives. By the way,

> @@ -615,9 +615,7 @@
>  		INIT_LIST_HEAD(&bysource[i]);
>  	}
>  
> -	/* FIXME: Man, this is a hack.  <SIGH> */
> -	NF_CT_ASSERT(rcu_dereference(nf_conntrack_destroyed) == NULL);
> -	rcu_assign_pointer(nf_conntrack_destroyed, nf_nat_cleanup_conntrack);
> +    nf_ct_register_destroy_cb(&nf_nat_cleanup_conntrack);
> 

The coding style is not aligned. Or any your tool mangled white spaces ?
 
>  int
> +nf_ct_register_destroy_cb(void (*destroy)(struct nf_conn *ct))
> +{
> +    struct nf_ct_destroy *entry;
> +    
> +    write_lock_bh (&nf_ct_destroy_lock);
> +    list_for_each_entry (entry, &nf_ct_destroy_head, list) {
> +        if (entry->destroy == destroy) {
> +            write_unlock_bh (&nf_ct_destroy_lock);
> +            return -EINVAL;
> +        }
> +    }
> +    
> +    entry = kmalloc (sizeof (struct nf_ct_destroy), GFP_ATOMIC);
> +    if (!entry) {
> +        write_unlock_bh (&nf_ct_destroy_lock);
> +        return -ENOMEM;
> +    }
> +    
> +    entry->destroy = destroy;
> +    list_add (&entry->list, &nf_ct_destroy_head);
> +    write_unlock_bh (&nf_ct_destroy_lock);
> +    
> +    return 0;
> +}
> +EXPORT_SYMBOL_GPL(nf_ct_register_destroy_cb);

You can replace lock with RCU.

-- Yasuyuki Kozakai
