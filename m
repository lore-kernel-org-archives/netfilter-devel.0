From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]  Accounting rework: ct_extend + 64bit counters (ver.
 2)
Date: Fri, 06 Jun 2008 12:52:18 +0200
Message-ID: <484916E2.3090200@trash.net>
References: <48459c0c.4MdiVlMLZBmNAw6M%olel@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <olel@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40527 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYFFKwW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 06:52:22 -0400
In-Reply-To: <48459c0c.4MdiVlMLZBmNAw6M%olel@ans.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Looks pretty good, just one or two minor things below. What would
be nice though is to reduce patch size a bit, two suggestions for
this are:

- move seq_print_acct() changes to seperate cleanup patch
- keep counters as packets/bytes struct to reduce rename
   noise in connlimit
- maybe (hardly worth it) pull out the netlink.h change

Krzysztof Oledzki wrote:
> +int nf_conntrack_acct_init(void)
> +{
> +	int ret;
> +
> +#ifdef CONFIG_NF_CT_ACCT
> +	printk(KERN_ERR "CONFIG_NF_CT_ACCT is deprecated and will be removed soon.\n");
> +#endif

This should point out what people are supposed to do
(use the new runtime option). KERN_WARN or NOTICE
seems more appropriate.

> +
> +	ret = nf_ct_extend_register(&acct_extend);
> +	if (ret < 0) {
> +		printk(KERN_ERR "nf_conntrack_acct: Unable to register extension\n");
> +		return ret;
> +	}
> +
> +#ifdef CONFIG_SYSCTL
> +	acct_sysctl_header = register_sysctl_paths(nf_net_netfilter_sysctl_path, acct_sysctl_table);
> +#endif

Please stay under the 80 character limit. Also should check whether
registration succeeded.

>  struct hlist_head *nf_ct_alloc_hashtable(unsigned int *sizep, int *vmalloced)
> @@ -1165,6 +1174,10 @@ int __init nf_conntrack_init(void)
>  	if (ret < 0)
>  		goto out_fini_expect;
>  
> +	ret = nf_conntrack_acct_init();
> +	if (ret < 0)
> +		goto out_fini_acct;
> +
>  	/* For use by REJECT target */
>  	rcu_assign_pointer(ip_ct_attach, nf_conntrack_attach);
>  	rcu_assign_pointer(nf_ct_destroy, destroy_conntrack);
> @@ -1177,6 +1190,7 @@ int __init nf_conntrack_init(void)
>  
>  	return ret;
>  
> +out_fini_acct:

nf_conntrack_helper_fini(); ?

>  out_fini_expect:
>  	nf_conntrack_expect_fini();
>  out_fini_proto:
