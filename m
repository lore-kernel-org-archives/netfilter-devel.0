From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: accounting rework: ct_extend + 64bit counters
 (v4)
Date: Wed, 09 Jul 2008 19:05:49 +0200
Message-ID: <4874EFED.5080001@trash.net>
References: <48727680.0v5JqC/twBGv06/n%ole@ans.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020807020809080700050800"
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Piotr Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33683 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbYGIRFv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 13:05:51 -0400
In-Reply-To: <48727680.0v5JqC/twBGv06/n%ole@ans.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020807020809080700050800
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Krzysztof Piotr Oledzki wrote:
>>From 187703b8bfc30048c3a973fea6d3b3ce9bcbb49a Mon Sep 17 00:00:00 2001
> From: Krzysztof Piotr Oledzki <ole@ans.pl>
> Date: Mon, 7 Jul 2008 21:49:57 +0200
> Subject: netfilter: accounting rework: ct_extend + 64bit counters (v4)
> 
> Initially netfilter has had 64bit counters for conntrack-based accounting, but
> it was changed in 2.6.14 to save memory. Unfortunately in-kernel 64bit counters are
> still required, for example for "connbytes" extension. However, 64bit counters
> waste a lot of memory and it was not possible to enable/disable it runtime.
> 
> This patch:
>  - reimplements accounting with respect to the extension infrastructure,
>  - makes one global version of seq_print_acct() instead of two seq_print_counters(),
>  - makes it possible to enable it at boot time (for CONFIG_SYSCTL/CONFIG_SYSFS=n),
>  - makes it possible to enable/disable it at runtime by sysctl or sysfs,
>  - extends counters from 32bit to 64bit,
>  - renames ip_conntrack_counter -> nf_conn_counter,
>  - enables accounting code unconditionally (no longer depends on CONFIG_NF_CT_ACCT),
>  - set initial accounting enable state based on CONFIG_NF_CT_ACCT
>  - removes buggy IPCT_COUNTER_FILLING event handling.
> 
> If accounting is enabled newly created connections get additional acct extend.
> Old connections are not changed as it is not possible to add a ct_extend area
> to confirmed conntrack. Accounting is performed for all connections with
> acct extend regardless of a current state of "net.netfilter.nf_conntrack_acct".

Applied with the attached minor cleanups. Thanks Krzysztof!

There is one things I think needs fixing however:

>  			if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) ==
> -						IPCTNL_MSG_CT_GET_CTRZERO)
> -				memset(&ct->counters, 0, sizeof(ct->counters));
> -#endif
> +						IPCTNL_MSG_CT_GET_CTRZERO) {
> +				struct nf_conn_counter *acct;
> +
> +				acct = nf_conn_acct_find(ct);
> +				if (acct)
> +					memset(acct, 0, sizeof(struct nf_conn_counter[IP_CT_DIR_MAX]));

This needs locking.

--------------020807020809080700050800
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index 59bd8b9..7f2fba9 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -64,7 +64,7 @@ static struct nf_ct_ext_type acct_extend __read_mostly = {
 	.id	= NF_CT_EXT_ACCT,
 };
 
-int nf_conntrack_acct_init(void)
+int __init nf_conntrack_acct_init(void)
 {
 	int ret;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8e1bc4e..0e1dfbb 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1176,7 +1176,7 @@ int __init nf_conntrack_init(void)
 
 	ret = nf_conntrack_acct_init();
 	if (ret < 0)
-		goto out_fini_acct;
+		goto out_fini_helper;
 
 	/* For use by REJECT target */
 	rcu_assign_pointer(ip_ct_attach, nf_conntrack_attach);
@@ -1190,7 +1190,7 @@ int __init nf_conntrack_init(void)
 
 	return ret;
 
-out_fini_acct:
+out_fini_helper:
 	nf_conntrack_helper_fini();
 out_fini_expect:
 	nf_conntrack_expect_fini();

--------------020807020809080700050800--
