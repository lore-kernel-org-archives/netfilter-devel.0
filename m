From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf V2] netfilter: nf_ct_helper: permit cthelpers with
 different names via nfnetlink
Date: Fri, 14 Apr 2017 00:29:14 +0200
Message-ID: <20170413222914.GA5089@salvia>
References: <1490792404-6035-1-git-send-email-zlpnobody@163.com>
 <CAML_gOdMiDPy==pvW5D5MrJZ1UfnpAzK172R4QbehnSkmHZP0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49568 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbdDMW30 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 18:29:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 09E53BA713
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:29:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 460D3DA807
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:29:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2F1FBDA7F7
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:29:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOdMiDPy==pvW5D5MrJZ1UfnpAzK172R4QbehnSkmHZP0w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 30, 2017 at 10:12:00AM +0800, Liping Zhang wrote:
> Hi Pablo,
> 
> 2017-03-29 21:00 GMT+08:00 Liping Zhang <zlpnobody@163.com>:
> > From: Liping Zhang <zlpnobody@gmail.com>
> >
> > cthelpers added via nfnetlink may have the same tuple, i.e. except for
> > the l3proto and l4proto, other fields are all zero. So even with the
> > different names, we will also fail to add them:
> >   # nfct helper add ssdp inet udp
> >   # nfct helper add tftp inet udp
> >   nfct v1.4.3: netlink error: File exists
> >
> > So in order to avoid unpredictable behaviour, we should:
> > 1. cthelpers can be selected by nft ct helper obj or xt_CT target, so
> > report error if duplicated { name, l3proto, l4proto } tuple exist.
> > 2. cthelpers can be selected by nf_ct_tuple_src_mask_cmp when
> > nf_ct_auto_assign_helper is enabled, so also report error if duplicated
> > { l3proto, l4proto, src-port } tuple exist.
> >
> > Also note, if the cthelper is added from userspace, then the src-port will
> > always be zero, it's invalid for nf_ct_auto_assign_helper, so there's no
> > need to check the second point listed above.
> >
> > Fixes: 893e093c786c ("netfilter: nf_ct_helper: bail out on duplicated helpers")
> > Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
> > ---
> >  V2: drop to use __nf_conntrack_helper_find which may cause annoying
> >      rcu warning when debug is enabled, spotted by Pablo.
> 
> I think this patch should be ignored.
> 
> >  net/netfilter/nf_conntrack_helper.c | 26 +++++++++++++++++++++-----
> >  1 file changed, 21 insertions(+), 5 deletions(-)
> [...]
> > +       for (i = 0; i < nf_ct_helper_hsize; i++) {
> > +               hlist_for_each_entry(cur, &nf_ct_helper_hash[i], hnode) {
> > +                       if (!strcmp(cur->name, me->name) &&
> > +                           (cur->tuple.src.l3num == NFPROTO_UNSPEC ||
> > +                            cur->tuple.src.l3num == me->tuple.src.l3num) &&
> > +                           cur->tuple.dst.protonum == me->tuple.dst.protonum) {
> > +                               ret = -EEXIST;
> > +                               goto out;
> > +                       }
> > +               }
> > +       }
> 
> After I have a closer look, inside hlist_for_each_entry_rcu, we use the
> rcu_dereference_raw() to get the pointer, and this will not generate warning:
> 
> #define hlist_for_each_entry_rcu(pos, head, member) \
>     for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
>                          typeof(*(pos)), member);
>    ....
> 
> Then "This is likely going to spot false positives with the RCU
> debugging instrumentation"
> will not happen.

Right, instrumentation will not trigger any problem.

But even if instrumention is not a problem, I just would like to avoid
people sending me "obvious" fixes afterwards, by removing _rcu since
they see this code runs under mutex or how knows what.
