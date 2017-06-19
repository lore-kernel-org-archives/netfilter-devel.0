From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2] netfilter: Remove duplicated rcu_read_lock.
Date: Mon, 19 Jun 2017 20:04:49 +0200
Message-ID: <20170619180449.GA19139@salvia>
References: <20170605152125.24978-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ja@ssi.bg, netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751081AbdFSSE5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2017 14:04:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5FE7E2EFEA4
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 20:04:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4FFE58F48
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 20:04:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61FDE1850F
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 20:04:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170605152125.24978-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 06, 2017 at 12:21:25AM +0900, Taehee Yoo wrote:
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 8a0f218..bb27e99 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -928,7 +928,6 @@ static unsigned int nfqnl_nf_hook_drop(struct net *net)
>  	unsigned int instances = 0;
>  	int i;
>  
> -	rcu_read_lock();
>  	for (i = 0; i < INSTANCE_BUCKETS; i++) {
>  		struct nfqnl_instance *inst;
>  		struct hlist_head *head = &q->instance_table[i];
> @@ -938,7 +937,6 @@ static unsigned int nfqnl_nf_hook_drop(struct net *net)
>  			instances++;
>  		}
>  	}
> -	rcu_read_unlock();
>  
>  	return instances;
>  }

This is called from nfqnl_rcv_dev_event(), are you sure we can get rid
of this rcu read lock ?
