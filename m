From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 2/2] netfilter: nfnl_cthelper: reject del request if
 helper obj is in use
Date: Fri, 14 Apr 2017 01:42:04 +0200
Message-ID: <20170413234204.GA9226@salvia>
References: <1491726134-23686-1-git-send-email-zlpnobody@163.com>
 <1491726134-23686-3-git-send-email-zlpnobody@163.com>
 <20170413231642.GA7338@salvia>
 <CAML_gOdybRbrQCAY20tmoE1Zkv=S6NOXvTA5nJq0wVL7CQnSjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58310 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752792AbdDMXmN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:42:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 021C6C1247
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:42:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3FF64DA865
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:42:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70908DA86B
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:42:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOdybRbrQCAY20tmoE1Zkv=S6NOXvTA5nJq0wVL7CQnSjw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 14, 2017 at 07:37:50AM +0800, Liping Zhang wrote:
> Hi Pablo,
> 
> 2017-04-14 7:16 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> [...]
> >>  #ifndef _NF_CONNTRACK_HELPER_H
> >>  #define _NF_CONNTRACK_HELPER_H
> >> +#include <linux/refcount.h>
> >>  #include <net/netfilter/nf_conntrack.h>
> >>  #include <net/netfilter/nf_conntrack_extend.h>
> >>  #include <net/netfilter/nf_conntrack_expect.h>
> >> @@ -26,6 +27,7 @@ struct nf_conntrack_helper {
> >>       struct hlist_node hnode;        /* Internal use. */
> >>
> >>       char name[NF_CT_HELPER_NAME_LEN]; /* name of the module */
> >> +     refcount_t refcnt;
> >
> > Should this new refcnt; thing be in the new struct nfnl_cthelper?
> >
> > I think this refcount is only required by the userspace helper
> > infrastructure, not existing in-kernel helpers.
> >
> > I think like that we can skip patch 1/2 in this series.
> 
> We must call nf_conntrack_helper_try_module_get to get the helper,
> either it is userspace or  in-kernel helpers. Also the caller didn't care
> the helpers is userspace or in-kernel, so I think introducing the
> nf_conntrack_helper_put is necessary.
> 
> Also, this path set is prepared for per-net helper. For in-kernel helpers,
> we will still need to  kmemdup the original one. I mean:
>       helper = kmemdup(ftp_helper);
>       helper->expect_policy = kmemdup(ftp_exp_policy);
>       nf_conntrack_helper_register(net, helper);
> 
> And similar to nfnetlink_cttimeout, for net_exit, we should:
> list_for_each_entry_safe()
>     unregister_helper();
>     if (refcount_dec_and_test(&cur->refcnt))
>         call_rcu(free_xxx);
> 
> For nf_conntrack_helper_put, we should:
> if (refcount_dec_and_test(&cur->refcnt))
>     call_rcu(free_xxx);
> 
> So I think put this "refcount_t refcnt" to struct nf_conntrack_helper
> is better.

OK, please resubmit target to nf-next. It's too late for patches
already for nf, we're at -rc6 and this problem has been there for a
bit of time. So waiting a bit more to get this fixed should be OK.

Thanks.
