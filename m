From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf 2/2] netfilter: nfnl_cthelper: reject del request if
 helper obj is in use
Date: Fri, 14 Apr 2017 07:37:50 +0800
Message-ID: <CAML_gOdybRbrQCAY20tmoE1Zkv=S6NOXvTA5nJq0wVL7CQnSjw@mail.gmail.com>
References: <1491726134-23686-1-git-send-email-zlpnobody@163.com>
 <1491726134-23686-3-git-send-email-zlpnobody@163.com> <20170413231642.GA7338@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:36607 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752365AbdDMXhw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:37:52 -0400
Received: by mail-vk0-f54.google.com with SMTP id q78so4220149vke.3
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 16:37:51 -0700 (PDT)
In-Reply-To: <20170413231642.GA7338@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-04-14 7:16 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
>>  #ifndef _NF_CONNTRACK_HELPER_H
>>  #define _NF_CONNTRACK_HELPER_H
>> +#include <linux/refcount.h>
>>  #include <net/netfilter/nf_conntrack.h>
>>  #include <net/netfilter/nf_conntrack_extend.h>
>>  #include <net/netfilter/nf_conntrack_expect.h>
>> @@ -26,6 +27,7 @@ struct nf_conntrack_helper {
>>       struct hlist_node hnode;        /* Internal use. */
>>
>>       char name[NF_CT_HELPER_NAME_LEN]; /* name of the module */
>> +     refcount_t refcnt;
>
> Should this new refcnt; thing be in the new struct nfnl_cthelper?
>
> I think this refcount is only required by the userspace helper
> infrastructure, not existing in-kernel helpers.
>
> I think like that we can skip patch 1/2 in this series.

We must call nf_conntrack_helper_try_module_get to get the helper,
either it is userspace or  in-kernel helpers. Also the caller didn't care
the helpers is userspace or in-kernel, so I think introducing the
nf_conntrack_helper_put is necessary.

Also, this path set is prepared for per-net helper. For in-kernel helpers,
we will still need to  kmemdup the original one. I mean:
      helper = kmemdup(ftp_helper);
      helper->expect_policy = kmemdup(ftp_exp_policy);
      nf_conntrack_helper_register(net, helper);

And similar to nfnetlink_cttimeout, for net_exit, we should:
list_for_each_entry_safe()
    unregister_helper();
    if (refcount_dec_and_test(&cur->refcnt))
        call_rcu(free_xxx);

For nf_conntrack_helper_put, we should:
if (refcount_dec_and_test(&cur->refcnt))
    call_rcu(free_xxx);

So I think put this "refcount_t refcnt" to struct nf_conntrack_helper
is better.
