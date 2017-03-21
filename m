From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 2/5] netfilter: nfnl_cthelper: fix incorrect
 helper->expect_class_max
Date: Tue, 21 Mar 2017 15:49:49 +0100
Message-ID: <20170321144949.GA17344@salvia>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
 <1489934162-7415-3-git-send-email-zlpnobody@163.com>
 <20170321102752.GB1940@salvia>
 <CAML_gOcFGgeT3SwWgi8g=apH8hxcW3ytvE98=15qupES3bXG6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39382 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932822AbdCUOtz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 10:49:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BC0F2174D08
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 15:49:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A95EFFB464
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 15:49:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 367AEFB465
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 15:49:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAML_gOcFGgeT3SwWgi8g=apH8hxcW3ytvE98=15qupES3bXG6g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 21, 2017 at 10:35:43PM +0800, Liping Zhang wrote:
> Hi Pablo,
> 
> 2017-03-21 18:27 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> [...]
> >> +     class_max = ntohl(nla_get_be32(tb[NFCTH_POLICY_SET_NUM]));
> >> +     if (class_max == 0)
> >> +             return -EINVAL;
> >
> > I think this patch is just fixing up this case. We should always
> > provide a policy for the expectation.
> 
> No, see comments below.
> 
> >
> >> +     if (class_max > NF_CT_MAX_EXPECT_CLASSES)
> >>               return -EOVERFLOW;
> >>
> >>       expect_policy = kzalloc(sizeof(struct nf_conntrack_expect_policy) *
> >> -                             helper->expect_class_max, GFP_KERNEL);
> >> +                             class_max, GFP_KERNEL);
> >>       if (expect_policy == NULL)
> >>               return -ENOMEM;
> >>
> >> -     for (i=0; i<helper->expect_class_max; i++) {
> >> +     for (i = 0; i < class_max; i++) {
> >>               if (!tb[NFCTH_POLICY_SET+i])
> >>                       goto err;
> >>
> >> @@ -191,6 +191,8 @@ nfnl_cthelper_parse_expect_policy(struct nf_conntrack_helper *helper,
> >>               if (ret < 0)
> >>                       goto err;
> >>       }
> >> +
> >> +     helper->expect_class_max = class_max - 1;
> >
> > Why - 1 ?
> >
> > class_max represents the array size, you can just keep this code the
> > way it is.
> 
> Actually, expect_class_max represents the array size minus 1.
> 
> For sip, expect_class_max is set to SIP_EXPECT_MAX(3). For ftp,
> expect_class_max is set to 0.
> 
> Also there's a "BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);"
> in nf_conntrack_helper_register, so if we supply 4 expect_policys,
> i.e. expect_class_max is 4, BUG_ON will happen.

Right, from the kernel side, all helpers assume that
me->expect_class_max represents the array size - 1.

While cthelper takes this as the array size.

This expect_class_max semantics is counterintuitive to me.

Applied, thanks.

P.S: I'm going to send a new version of:

http://patchwork.ozlabs.org/patch/741528/

that applies on top of this one.
