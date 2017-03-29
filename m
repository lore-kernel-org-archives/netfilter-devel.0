From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_ct_helper: permit cthelpers with
 different names via nfnetlink
Date: Wed, 29 Mar 2017 19:05:10 +0800
Message-ID: <CAML_gOepJknV1Nn8k28twci5S7=V7qOs41Bc4fTZ9UvbJ_Ehhw@mail.gmail.com>
References: <1490447003-18592-1-git-send-email-zlpnobody@163.com> <20170329104131.GA6237@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:33590 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753895AbdC2LFM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 07:05:12 -0400
Received: by mail-vk0-f45.google.com with SMTP id d188so13037832vka.0
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 04:05:11 -0700 (PDT)
In-Reply-To: <20170329104131.GA6237@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-03-29 18:41 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
> Wait.
>
> Just a comestic change, would this look better if we just do:
>
>         hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
>                  if (!strcmp(h->name, name) &&
>                      (h->tuple.src.l3num != NFPROTO_UNSPEC &&
>                       h->tuple.src.l3num != l3num)) &&

I think this check condition here should be:
(h->tuple.src.l3num == NFPROTO_UNSPEC || h->tuple.src.l3num == l3num)

>                      h->tuple.dst.protonum == protonum) {
>                         ret = -EEXIST;
>                         goto out;
>                  }
>
>                  /* avoid unpredictable behaviour for auto_assign_helper */
>                  if (!(me->flags & NF_CT_HELPER_F_USERSPACE)) &&
>                      nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple, &mask)) {
>                         ret = -EEXIST;
>                         goto out;
>         }
>
> __nf_conntrack_helper_find() uses the _rcu variant to iterate over the
> helper hash table, and we don't need this given we hold the mutex.
> This is likely going to spot false positives with the RCU debugging
> instrumentation I think.

Right, I did not notice this point. I will send V2 later.
