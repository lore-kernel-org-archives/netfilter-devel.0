From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 2/2] netfilter: nfnl_cthelper: reject del request if
 helper obj is in use
Date: Fri, 14 Apr 2017 01:16:42 +0200
Message-ID: <20170413231642.GA7338@salvia>
References: <1491726134-23686-1-git-send-email-zlpnobody@163.com>
 <1491726134-23686-3-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55520 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752077AbdDMXRA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:17:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6CD46C1093
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:16:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ABA73DA86B
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:16:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2B9FDA862
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:16:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491726134-23686-3-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 09, 2017 at 04:22:14PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> We can still delete the ct helper even if it is in use, this will cause
> a use-after-free error. In more detail, I mean:
>   # nfct helper add ssdp inet udp
>   # iptables -t raw -A OUTPUT -p udp -j CT --helper ssdp
>   # nfct helper delete ssdp //--> succeed!
> 
> So add reference count to fix this issue, if ct helper is used by
> others, reject the delete request.
> 
> Apply this patch:
>   # nfct helper delete ssdp
>   nfct v1.4.3: netlink error: Device or resource busy
> 
> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
> ---
>  Also note, nft ct helper obj only exists in nf-next tree, so after this
>  patch appeared in nf-next, I will send another patch to fix it.
> 
>  include/net/netfilter/nf_conntrack_helper.h |  2 ++
>  net/netfilter/nf_conntrack_helper.c         |  6 ++++++
>  net/netfilter/nfnetlink_cthelper.c          | 17 +++++++++++------
>  3 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> index 65e1dcf..c7a9ad7 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -9,6 +9,7 @@
>  
>  #ifndef _NF_CONNTRACK_HELPER_H
>  #define _NF_CONNTRACK_HELPER_H
> +#include <linux/refcount.h>
>  #include <net/netfilter/nf_conntrack.h>
>  #include <net/netfilter/nf_conntrack_extend.h>
>  #include <net/netfilter/nf_conntrack_expect.h>
> @@ -26,6 +27,7 @@ struct nf_conntrack_helper {
>  	struct hlist_node hnode;	/* Internal use. */
>  
>  	char name[NF_CT_HELPER_NAME_LEN]; /* name of the module */
> +	refcount_t refcnt;

Should this new refcnt; thing be in the new struct nfnl_cthelper?

I think this refcount is only required by the userspace helper
infrastructure, not existing in-kernel helpers.

I think like that we can skip patch 1/2 in this series.
