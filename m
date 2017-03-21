From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 5/5] netfilter: nfnl_cthelper: fix a race when walk
 the nf_ct_helper_hash table
Date: Tue, 21 Mar 2017 11:33:34 +0100
Message-ID: <20170321103334.GD1940@salvia>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
 <1489934162-7415-6-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35806 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752227AbdCUKdo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 06:33:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E8EC6EBAC1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:33:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9AE1DA873
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:33:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D1B0DA795
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:33:38 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489934162-7415-6-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 19, 2017 at 10:36:02PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> The nf_ct_helper_hash table is protected by nf_ct_helper_mutex, while
> nfct_helper operation is protected by nfnl_lock(NFNL_SUBSYS_CTHELPER).
> So it's possible that one CPU is walking the nf_ct_helper_hash for
> cthelper add/get/del, another cpu is doing nf_conntrack_helpers_unregister
> at the same time. This is dangrous, and may cause use after free error.
> 
> Note, delete operation will flush all cthelpers added via nfnetlink, so
> using rcu to do protect is not easy.
> 
> Now introduce a dummy list to record all the cthelpers added via
> nfnetlink, then we can walk the dummy list instead of walking the
> nf_ct_helper_hash. Also, keep nfnl_cthelper_dump_table unchanged, it
> may be invoked without nfnl_lock(NFNL_SUBSYS_CTHELPER) held.
> 
> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
> ---
>  net/netfilter/nfnetlink_cthelper.c | 176 +++++++++++++++++++------------------
>  1 file changed, 89 insertions(+), 87 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
> index fc4733f..47424ec 100644
> --- a/net/netfilter/nfnetlink_cthelper.c
> +++ b/net/netfilter/nfnetlink_cthelper.c
> @@ -32,6 +32,13 @@ MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
>  MODULE_DESCRIPTION("nfnl_cthelper: User-space connection tracking helpers");
>  
> +struct nfnl_cthelper {
> +	struct list_head		list;
> +	struct nf_conntrack_helper	*helper;
> +};
> +
> +static LIST_HEAD(nfnl_cthelper_list);

We need a field possible_net_t so we can store what netns this helper
belongs to, thus in case of flush command, we just remove the helpers
that this netns owns.
