From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 3/5] netfilter: drop const qualifier from struct
 nf_conntrack_expect_policy
Date: Tue, 21 Mar 2017 16:03:21 +0100
Message-ID: <20170321150321.GA20311@salvia>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
 <1489934162-7415-4-git-send-email-zlpnobody@163.com>
 <20170321103404.GE1940@salvia>
 <CAML_gOfKb9NKJVK0mPCNR1sK1Tt=6RWnzsD7WZEyS7_YNY43hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45742 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756711AbdCUPDd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 11:03:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8065174D1E
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 16:03:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 77C50DA8FD
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 16:03:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26927DA91E
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 16:03:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAML_gOfKb9NKJVK0mPCNR1sK1Tt=6RWnzsD7WZEyS7_YNY43hw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 21, 2017 at 11:00:02PM +0800, Liping Zhang wrote:
> Hi Pablo,
> 
> 2017-03-21 18:34 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > On Sun, Mar 19, 2017 at 10:36:00PM +0800, Liping Zhang wrote:
> >> From: Liping Zhang <zlpnobody@gmail.com>
> >>
> >> So we can modify the nf_conntrack_expect_policy directly, the next patch
> >> will need this.
> >
> > I'm missing why you need this.
> 
> Because I want to modify the nf_conntrack_expect_policy directly when
> do update expect policy in nfct_helper.
> 
> I saw you make a cast type to do this:
>   policy = (struct nf_conntrack_expect_policy *) &helper->expect_policy[i];
> (refer to http://patchwork.ozlabs.org/patch/741528/)
> 
> But when I'm working on this, I'm not sure "cast type" is proper or not.
> So I just remove the const qualifier.

I see. I prefer we just cast away the type from the single spot in
nfnl_cthelper.
