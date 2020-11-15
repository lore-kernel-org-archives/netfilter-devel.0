Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF4BC2D0E4
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Nov 2020 11:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5358423A32
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Nov 2020 11:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgKOLEk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Nov 2020 06:04:40 -0500
Received: from correo.us.es ([193.147.175.20]:43562 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgKOLEj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Nov 2020 06:04:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C355DE34CE
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2020 12:04:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B3BF8DA78A
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2020 12:04:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A8EE5DA73D; Sun, 15 Nov 2020 12:04:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64601DA722;
        Sun, 15 Nov 2020 12:04:33 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 15 Nov 2020 12:04:33 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 473334265A5A;
        Sun, 15 Nov 2020 12:04:33 +0100 (CET)
Date:   Sun, 15 Nov 2020 12:04:32 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Wang Shanker <shankerwangmiao@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nfnl_acct: remove data from struct net
Message-ID: <20201115110432.GA23896@salvia>
References: <2D679487-4F6A-405E-AC4E-B47539F1969A@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2D679487-4F6A-405E-AC4E-B47539F1969A@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Nov 15, 2020 at 01:42:30AM +0800, Wang Shanker wrote:
> This patch removes nfnl_acct_list from struct net, making it possible to
> compile the nfacct module out of tree.

Patch looks good.

The real motivation for this patch that I would place in the patch
description is to reduce the default memory footprint for the netns
structure.

See below a few more comments.

> Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
> ---
>  include/net/net_namespace.h    |  3 ---
>  net/netfilter/nfnetlink_acct.c | 38 ++++++++++++++++++++++++++--------
>  2 files changed, 29 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> index 22bc07f4b043..dc20a47e3828 100644
> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -151,9 +151,6 @@ struct net {
>  #endif
>  	struct sock		*nfnl;
>  	struct sock		*nfnl_stash;
> -#if IS_ENABLED(CONFIG_NETFILTER_NETLINK_ACCT)
> -	struct list_head        nfnl_acct_list;
> -#endif
>  #if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
>  	struct list_head	nfct_timeout_list;
>  #endif
> diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
> index 5bfec829c12f..ae56756fab46 100644
> --- a/net/netfilter/nfnetlink_acct.c
> +++ b/net/netfilter/nfnetlink_acct.c
> @@ -16,6 +16,7 @@
>  #include <linux/errno.h>
>  #include <net/netlink.h>
>  #include <net/sock.h>
> +#include <net/netns/generic.h>
>  
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nfnetlink.h>
> @@ -41,6 +42,17 @@ struct nfacct_filter {
>  	u32 mask;
>  };
>  
> +struct nfnl_acct_net {
> +	struct list_head        nfnl_acct_list;
> +};
> +
> +static unsigned int nfnl_acct_net_id __read_mostly;
> +
> +static inline struct nfnl_acct_net *nfnl_acct_pernet(struct net *net)
> +{
> +	return net_generic(net, nfnl_acct_net_id);
> +}
> +
>  #define NFACCT_F_QUOTA (NFACCT_F_QUOTA_PKTS | NFACCT_F_QUOTA_BYTES)
>  #define NFACCT_OVERQUOTA_BIT	2	/* NFACCT_F_OVERQUOTA */
>  
> @@ -53,6 +65,7 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
>  	char *acct_name;
>  	unsigned int size = 0;
>  	u32 flags = 0;
> +	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
>  
>  	if (!tb[NFACCT_NAME])
>  		return -EINVAL;
> @@ -61,7 +74,7 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
>  	if (strlen(acct_name) == 0)
>  		return -EINVAL;
>  
> -	list_for_each_entry(nfacct, &net->nfnl_acct_list, head) {
> +	list_for_each_entry(nfacct, &nfnl_acct_net->nfnl_acct_list, head) {
>  		if (strncmp(nfacct->name, acct_name, NFACCT_NAME_MAX) != 0)
>  			continue;
>  
> @@ -123,7 +136,7 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
>  			     be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
>  	}
>  	refcount_set(&nfacct->refcnt, 1);
> -	list_add_tail_rcu(&nfacct->head, &net->nfnl_acct_list);
> +	list_add_tail_rcu(&nfacct->head, &nfnl_acct_net->nfnl_acct_list);
>  	return 0;
>  }
>  
> @@ -190,6 +203,7 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  	struct net *net = sock_net(skb->sk);
>  	struct nf_acct *cur, *last;
>  	const struct nfacct_filter *filter = cb->data;
> +	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
>  
>  	if (cb->args[2])
>  		return 0;
> @@ -199,7 +213,7 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  		cb->args[1] = 0;
>  
>  	rcu_read_lock();
> -	list_for_each_entry_rcu(cur, &net->nfnl_acct_list, head) {
> +	list_for_each_entry_rcu(cur, &nfnl_acct_net->nfnl_acct_list, head) {
>  		if (last) {
>  			if (cur != last)
>  				continue;
> @@ -272,6 +286,7 @@ static int nfnl_acct_get(struct net *net, struct sock *nfnl,
>  	int ret = -ENOENT;
>  	struct nf_acct *cur;
>  	char *acct_name;
> +	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
>  
>  	if (nlh->nlmsg_flags & NLM_F_DUMP) {
>  		struct netlink_dump_control c = {
> @@ -288,7 +303,7 @@ static int nfnl_acct_get(struct net *net, struct sock *nfnl,
>  		return -EINVAL;
>  	acct_name = nla_data(tb[NFACCT_NAME]);
>  
> -	list_for_each_entry(cur, &net->nfnl_acct_list, head) {
> +	list_for_each_entry(cur, &nfnl_acct_net->nfnl_acct_list, head) {
>  		struct sk_buff *skb2;
>  
>  		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX)!= 0)
> @@ -345,16 +360,17 @@ static int nfnl_acct_del(struct net *net, struct sock *nfnl,
>  	struct nf_acct *cur, *tmp;
>  	int ret = -ENOENT;
>  	char *acct_name;
> +	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
>  
>  	if (!tb[NFACCT_NAME]) {
> -		list_for_each_entry_safe(cur, tmp, &net->nfnl_acct_list, head)
> +		list_for_each_entry_safe(cur, tmp, &nfnl_acct_net->nfnl_acct_list, head)
>  			nfnl_acct_try_del(cur);
>  
>  		return 0;
>  	}
>  	acct_name = nla_data(tb[NFACCT_NAME]);
>  
> -	list_for_each_entry(cur, &net->nfnl_acct_list, head) {
> +	list_for_each_entry(cur, &nfnl_acct_net->nfnl_acct_list, head) {
>  		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX) != 0)
>  			continue;
>  
> @@ -403,9 +419,10 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_ACCT);
>  struct nf_acct *nfnl_acct_find_get(struct net *net, const char *acct_name)
>  {
>  	struct nf_acct *cur, *acct = NULL;
> +	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
>  
>  	rcu_read_lock();
> -	list_for_each_entry_rcu(cur, &net->nfnl_acct_list, head) {
> +	list_for_each_entry_rcu(cur, &nfnl_acct_net->nfnl_acct_list, head) {
>  		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX)!= 0)
>  			continue;
>  
> @@ -488,7 +505,7 @@ EXPORT_SYMBOL_GPL(nfnl_acct_overquota);
>  
>  static int __net_init nfnl_acct_net_init(struct net *net)
>  {
> -	INIT_LIST_HEAD(&net->nfnl_acct_list);
> +	INIT_LIST_HEAD(&nfnl_acct_pernet(net)->nfnl_acct_list);
>  
>  	return 0;
>  }
> @@ -496,8 +513,9 @@ static int __net_init nfnl_acct_net_init(struct net *net)
>  static void __net_exit nfnl_acct_net_exit(struct net *net)
>  {
>  	struct nf_acct *cur, *tmp;
> +	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);

Please, reverse xmas tree, ie.

	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
 	struct nf_acct *cur, *tmp;

Same thing everywhere else whenever possible.

> -	list_for_each_entry_safe(cur, tmp, &net->nfnl_acct_list, head) {
> +	list_for_each_entry_safe(cur, tmp, &nfnl_acct_net->nfnl_acct_list, head) {
>  		list_del_rcu(&cur->head);
>  
>  		if (refcount_dec_and_test(&cur->refcnt))
> @@ -508,6 +526,8 @@ static void __net_exit nfnl_acct_net_exit(struct net *net)
>  static struct pernet_operations nfnl_acct_ops = {
>          .init   = nfnl_acct_net_init,
>          .exit   = nfnl_acct_net_exit,
> +	.id     = &nfnl_acct_net_id,
> +	.size   = sizeof(struct nfnl_acct_net),
   ^^^^^

identation here is not correct.

>  };
>  
>  static int __init nfnl_acct_init(void)
> -- 
> 2.20.1
> 
> 
