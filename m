From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_ct_helper: permit cthelpers with
 different names via nfnetlink
Date: Wed, 29 Mar 2017 13:50:25 +0200
Message-ID: <20170329115025.GB6697@salvia>
References: <1490447003-18592-1-git-send-email-zlpnobody@163.com>
 <20170329104131.GA6237@salvia>
 <CAML_gOepJknV1Nn8k28twci5S7=V7qOs41Bc4fTZ9UvbJ_Ehhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52342 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755984AbdC2Lui (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 07:50:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A36A9E976C
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 13:50:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92E43DA903
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 13:50:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 683B9DA8FE
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 13:50:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOepJknV1Nn8k28twci5S7=V7qOs41Bc4fTZ9UvbJ_Ehhw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 29, 2017 at 07:05:10PM +0800, Liping Zhang wrote:
> Hi Pablo,
> 
> 2017-03-29 18:41 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> [...]
> > Wait.
> >
> > Just a comestic change, would this look better if we just do:
> >
> >         hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
> >                  if (!strcmp(h->name, name) &&
> >                      (h->tuple.src.l3num != NFPROTO_UNSPEC &&
> >                       h->tuple.src.l3num != l3num)) &&
> 
> I think this check condition here should be:
> (h->tuple.src.l3num == NFPROTO_UNSPEC || h->tuple.src.l3num == l3num)

Yes, I noticed after sending indeed.

> >                      h->tuple.dst.protonum == protonum) {
> >                         ret = -EEXIST;
> >                         goto out;
> >                  }
> >
> >                  /* avoid unpredictable behaviour for auto_assign_helper */
> >                  if (!(me->flags & NF_CT_HELPER_F_USERSPACE)) &&
> >                      nf_ct_tuple_src_mask_cmp(&cur->tuple, &me->tuple, &mask)) {
> >                         ret = -EEXIST;
> >                         goto out;
> >         }
> >
> > __nf_conntrack_helper_find() uses the _rcu variant to iterate over the
> > helper hash table, and we don't need this given we hold the mutex.
> > This is likely going to spot false positives with the RCU debugging
> > instrumentation I think.
> 
> Right, I did not notice this point. I will send V2 later.

Thanks!
