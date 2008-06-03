From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]  Accounting rework: ct_extend + 64bit counters
Date: Tue, 03 Jun 2008 15:30:35 +0200
Message-ID: <4845477B.8050400@trash.net>
References: <48442cd8.dD0hLVFRFjNruv6o%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40574 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYFCNah (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:30:37 -0400
In-Reply-To: <48442cd8.dD0hLVFRFjNruv6o%ole@ans.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> [NETFILTER] Accounting rework: ct_extend + 64bit counters
> 
> Initially netfilter has had 64bit counters for conntrack-based accounting, but
> it was changed in 2.6.14 to save memory. Unfortunately in-kernel 64bit counters are
> still required, for example for "connbytes" extension. However, 64bit counters
> waste a lot of memory and it was not possible to enable/disable it runtime.
> 
> This patch:
>  - reimplements accounting with respect to the extension infrastructure,
>  - makes one global version of seq_print_acct() instead of two seq_print_counters(),
>  - makes it possible to enable it at boot time (for SYSFS=n),
>  - makes it possible to enable/disable it at runtime by sysctl or sysfs,
>  - extents counters from 32bit to 64bit,
>  - enables accounting code unconditionally (no more CONFIG_NF_CT_ACCT),
>  - keeps accounting disabled by default,
>  - removes buggy IPCT_COUNTER_FILLING event handling.
> 
> If accounting is enabled newly created connections get additional acct extent.
> Old connections are not changed as it is not possible to add a ct_extend area
> to confirmed conntrack. Accounting is performed for all connections with
> acct extent regardless of a current state of net.netfilter.nf_conntrack_acct.
> 
> Patch against 2.6.26-rc4, it would be nice if it can be included
> in 2.6.27.

Thanks for working on this. Some minor comments below:

> Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
> 
> diff -Nur linux-2.6.26-rc4-net/Documentation/kernel-parameters.txt linux-2.6.26-rc4-64bitc/Documentation/kernel-parameters.txt
> --- linux-2.6.26-rc4-net/Documentation/kernel-parameters.txt	2008-05-26 20:08:11.000000000 +0200
> +++ linux-2.6.26-rc4-64bitc/Documentation/kernel-parameters.txt	2008-06-02 18:28:30.000000000 +0200
> @@ -1234,6 +1234,11 @@
>  			This usage is only documented in each driver source
>  			file if at all.
>  
> +	nf_conntrack.acct=
> +			[NETFILTER] Enable connection tracking flow accounting
> +			0 to disable accounting (default)
> +			1 to enable accounting

Changing the default will probably result in surprises.
How about we make a config option (CONFIG_NF_ACCT_COMPAT)
that makes it default to 1 and print a warning that this
option is going to be removed/the default changed. Then
we add a target to manually enable accounting on a per-connection
base and kill off the compat option after a couple of
month.

> diff -Nur linux-2.6.26-rc4-net/include/linux/netfilter/nf_conntrack_common.h linux-2.6.26-rc4-64bitc/include/linux/netfilter/nf_conntrack_common.h
> --- linux-2.6.26-rc4-net/include/linux/netfilter/nf_conntrack_common.h	2008-05-26 20:08:11.000000000 +0200
> +++ linux-2.6.26-rc4-64bitc/include/linux/netfilter/nf_conntrack_common.h	2008-06-02 17:19:05.000000000 +0200
> @@ -122,10 +122,6 @@
>  	IPCT_NATINFO_BIT = 10,
>  	IPCT_NATINFO = (1 << IPCT_NATINFO_BIT),
>  
> -	/* Counter highest bit has been set */
> -	IPCT_COUNTER_FILLING_BIT = 11,
> -	IPCT_COUNTER_FILLING = (1 << IPCT_COUNTER_FILLING_BIT),
> -


This is exposed to userspace and needs to stay to avoid breaking
compilation.

> +unsigned int
> +seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir)
> +{
> +	struct nf_conn_acct *acct;
> +
> +	acct = nf_conn_acct_find(ct);
> +	if (!acct)
> +		return 0;
> +
> +	return seq_printf(s, "packets=%llu bytes=%llu ",
> +			  acct->packets[dir],
> +			  acct->bytes[dir]);

Will probably cause warnings on 64bit.

