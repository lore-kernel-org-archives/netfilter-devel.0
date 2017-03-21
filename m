From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 5/5] netfilter: nfnl_cthelper: fix a race when walk
 the nf_ct_helper_hash table
Date: Tue, 21 Mar 2017 16:26:21 +0100
Message-ID: <20170321152621.GA4069@salvia>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
 <1489934162-7415-6-git-send-email-zlpnobody@163.com>
 <20170321103334.GD1940@salvia>
 <CAML_gOcmYsogb0BKRxkYh0MF9kW7KTd-HyvEbsa3uL_YTQOa7g@mail.gmail.com>
 <CAML_gOdeXTEPb2vzjR4LYOif291pto4bF8DjWzndsfh6d1+z+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56576 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757918AbdCUP1w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 11:27:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8A5A518CDCB
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 16:26:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79F6CDA729
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 16:26:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7FDFDA875
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 16:26:20 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAML_gOdeXTEPb2vzjR4LYOif291pto4bF8DjWzndsfh6d1+z+g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 21, 2017 at 11:19:11PM +0800, Liping Zhang wrote:
> Hi Pablo,
> 
> 2017-03-21 22:48 GMT+08:00 Liping Zhang <zlpnobody@gmail.com>:
> > 2017-03-21 18:33 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> >>> +struct nfnl_cthelper {
> >>> +     struct list_head                list;
> >>> +     struct nf_conntrack_helper      *helper;
> >>> +};
> >>> +
> >>> +static LIST_HEAD(nfnl_cthelper_list);
> >>
> >> We need a field possible_net_t so we can store what netns this helper
> >> belongs to, thus in case of flush command, we just remove the helpers
> >> that this netns owns.
> 
> After I have a closer look, I find that we do not support netns for the
> nfct_helper currently. So this possible_net_t field is not necessary for
> the time being.

Oh, I see. This is probably one of the remaining subsystems not having
netns support.

> I have a quick glance look, supporting netns for helper need a lot works
> to do. We need to both change the nfnetlink_cthelper, nf_conntrack_help
> and so on.
> 
> But if you think it's worth to support netns for cthelper, I can
> finish it in my spare time:)

Let's focus on fixing up the existing issues. It would be great if you
can add that later on, once changes in nf.git propagate to
nf-next.git.

BTW, let me also pushed out what I have here into nf.git. I'd
appreciate if you can rebase this 5/5 patch on top of it.

Thanks!
