From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: IPv6 Parameter problem with no ICMPv6 response ?
Date: Mon, 5 Feb 2018 13:16:44 +0100
Message-ID: <20180205121644.vj4kncjuypjme7yz@salvia>
References: <20180205035826.GA2558@spottygum.com>
 <20180205121608.cxd4l5j5vr2tpe46@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: David McCullough <david.mccullough@accelerated.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33450 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753110AbeBEMQt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Feb 2018 07:16:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8217210560
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Feb 2018 13:16:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 95C78BAC48
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Feb 2018 13:16:47 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180205121608.cxd4l5j5vr2tpe46@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 05, 2018 at 01:16:08PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Feb 05, 2018 at 01:58:26PM +1000, David McCullough wrote:
> > 
> > Hi devel,
> > 
> > I am looking for some feedback on IPv6 behaviour with/without netfilter in
> > the path.  We are in process of some IPv6 certification at a lab.
> > 
> > RFC2460 has a bunch of conditions under which certain ICMPv6 responses
> > should be sent.  This is even commented in the code.
> > 
> > linux/net/ipv6/reassembly.c:255
> >                 /* Check if the fragment is rounded to 8 bytes.
> >                  * Required by the RFC.
> >                  */
> >                 if (end & 0x7) {
> >                         /* RFC2460 says always send parameter problem in
> >                          * this case. -DaveM
> >                          */
> >                         __IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
> >                                         IPSTATS_MIB_INHDRERRORS);
> >                         icmpv6_param_prob(skb, ICMPV6_HDR_FIELD,
> >                                           offsetof(struct ipv6hdr, payload_len));                       
> >                         return -1;
> >                 }
> > 
> > linux/net/ipv6/netfilter/nf_conntrack_reasm.c:259
> >                 /* Check if the fragment is rounded to 8 bytes.
> >                  * Required by the RFC.
> >                  */
> >                 if (end & 0x7) {
> >                         /* RFC2460 says always send parameter problem in
> >                          * this case. -DaveM
> >                          */
> >                         pr_debug("end of fragment not rounded to 8 bytes.\n");
> >                         return -1;      
> >                 }
> > 
> > The behaviour of the non-netfilter code is what the certification is expecting.
> > We are using conntracking though and I can see no way to avoid the above
> > netfilter code from silently dropping the packet and not responding correctly.
> > 
> > We experiemented with the patch below and it provided the appropriate
> > responses but we were not sure this is the best approach.  Happy to send in
> > a proper patch if this looks ok.
> 
> Probably you're refering to this fix?
> 
> commit 83f1999caeb14e15df205e80d210699951733287
> Author: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> Date:   Fri Jan 12 17:36:27 2018 -0700
> 
>     netfilter: ipv6: nf_defrag: Pass on packets to stack per RFC2460

You will also need this follow up amendment on top of it:

commit ea23d5e3bf340e413b8e05c13da233c99c64142b
Author: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date:   Wed Jan 31 04:50:01 2018 -0700

    netfilter: ipv6: nf_defrag: Kill frag queue on RFC2460 failure

