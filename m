From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: conntrack: merge udp and udplite
 helpers
Date: Tue, 6 Dec 2016 11:39:36 +0100
Message-ID: <20161206103936.GA5172@salvia>
References: <1480704637-14994-2-git-send-email-fw@strlen.de>
 <201612032029.B6DRRW4L%fengguang.wu@intel.com>
 <20161203130210.GA26974@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47046 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752135AbcLFKkd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 05:40:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 46437D1622
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:39:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 377C4DA39E
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:39:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E828DA399
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:39:41 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161203130210.GA26974@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 03, 2016 at 02:02:10PM +0100, Florian Westphal wrote:
> kbuild test robot <lkp@intel.com> wrote:
> > All error/warnings (new ones prefixed by >>):
> > 
> >    In file included from include/uapi/linux/stddef.h:1:0,
> >                     from include/linux/stddef.h:4,
> >                     from include/uapi/linux/posix_types.h:4,
> >                     from include/uapi/linux/types.h:13,
> >                     from include/linux/types.h:5,
> >                     from net/netfilter/nf_conntrack_proto_udp.c:10:
> >    net/netfilter/nf_conntrack_proto_udp.c: In function 'udp_get_net_proto':
> > >> net/netfilter/nf_conntrack_proto_udp.c:308:15: error: 'CTA_TIMEOUT_UDP_MAX' undeclared (first use in this function)
> >      BUILD_BUG_ON(CTA_TIMEOUT_UDP_MAX != CTA_TIMEOUT_UDPLITE_MAX);
> 
> Yay for conditional includes :-/
> 
> Pablo, I just saw there are still patches from Davide in your queue so I
> will not resend this (it will surely conflict).

They are now there. Please rebase and resubmit. Thanks for working on
this merging.
