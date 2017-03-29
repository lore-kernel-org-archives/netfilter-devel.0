From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_ct_helper: permit cthelpers with
 different names via nfnetlink
Date: Wed, 29 Mar 2017 12:41:31 +0200
Message-ID: <20170329104131.GA6237@salvia>
References: <1490447003-18592-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932147AbdC2Klk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 06:41:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 25C7BBA1C4
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:41:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08418DA862
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:41:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C865DA87E
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:41:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490447003-18592-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 25, 2017 at 09:03:23PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> cthelpers added via nfnetlink may have the same tuple, i.e. except for
> the l3proto and l4proto, other fields are all zero. So even with the
> different names, we will also fail to add them:
>   # nfct helper add ssdp inet udp
>   # nfct helper add tftp inet udp
>   nfct v1.4.3: netlink error: File exists
> 
> So in order to avoid unpredictable behaviour, we should:
> 1. cthelpers can be selected by nft ct helper obj or xt_CT target, so
> report error if duplicated { name, l3proto, l4proto } tuple exist.
> 2. cthelpers can be selected by nf_ct_tuple_src_mask_cmp when
> nf_ct_auto_assign_helper is enabled, so also report error if duplicated
> { l3proto, l4proto, src-port } tuple exist.
> 
> Also note, if the cthelper is added from userspace, then the src-port will
> always be zero, it's invalid for nf_ct_auto_assign_helper, so there's no
> need to check the second point listed above.
> 
> Fixes: 893e093c786c ("netfilter: nf_ct_helper: bail out on duplicated helpers")
> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
> ---
>  net/netfilter/nf_conntrack_helper.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 6dc44d9..a28ecfa 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -386,10 +386,20 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
>  	BUG_ON(strlen(me->name) > NF_CT_HELPER_NAME_LEN - 1);
>  
>  	mutex_lock(&nf_ct_helper_mutex);
> -	hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
> -		if (nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple, &mask)) {
> -			ret = -EEXIST;
> -			goto out;
> +	if (__nf_conntrack_helper_find(me->name, me->tuple.src.l3num,
> +				       me->tuple.dst.protonum)) {
> +		ret = -EEXIST;
> +		goto out;
> +	}
> +
> +	/* avoid unpredictable behaviour for auto_assign_helper */
> +	if (!(me->flags & NF_CT_HELPER_F_USERSPACE)) {
> +		hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
> +			if (nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple,
> +						     &mask)) {
> +				ret = -EEXIST;
> +				goto out;
> +			}

Wait.

Just a comestic change, would this look better if we just do:

	hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
                 if (!strcmp(h->name, name) &&
                     (h->tuple.src.l3num != NFPROTO_UNSPEC &&
                      h->tuple.src.l3num != l3num)) &&
                     h->tuple.dst.protonum == protonum) {
                        ret = -EEXIST;
                        goto out;
                 }

                 /* avoid unpredictable behaviour for auto_assign_helper */
                 if (!(me->flags & NF_CT_HELPER_F_USERSPACE)) &&
                     nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple, &mask)) {
                        ret = -EEXIST;
                        goto out;
	}

__nf_conntrack_helper_find() uses the _rcu variant to iterate over the
helper hash table, and we don't need this given we hold the mutex.
This is likely going to spot false positives with the RCU debugging
instrumentation I think.
