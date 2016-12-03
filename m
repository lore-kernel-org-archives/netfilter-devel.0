From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/2] netfilter: conntrack: merge udp and udplite
 helpers
Date: Sat, 3 Dec 2016 14:02:10 +0100
Message-ID: <20161203130210.GA26974@breakpoint.cc>
References: <1480704637-14994-2-git-send-email-fw@strlen.de>
 <201612032029.B6DRRW4L%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, kbuild-all@01.org,
        netfilter-devel@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60544 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752609AbcLCNFX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Dec 2016 08:05:23 -0500
Content-Disposition: inline
In-Reply-To: <201612032029.B6DRRW4L%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

kbuild test robot <lkp@intel.com> wrote:
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from include/uapi/linux/stddef.h:1:0,
>                     from include/linux/stddef.h:4,
>                     from include/uapi/linux/posix_types.h:4,
>                     from include/uapi/linux/types.h:13,
>                     from include/linux/types.h:5,
>                     from net/netfilter/nf_conntrack_proto_udp.c:10:
>    net/netfilter/nf_conntrack_proto_udp.c: In function 'udp_get_net_proto':
> >> net/netfilter/nf_conntrack_proto_udp.c:308:15: error: 'CTA_TIMEOUT_UDP_MAX' undeclared (first use in this function)
>      BUILD_BUG_ON(CTA_TIMEOUT_UDP_MAX != CTA_TIMEOUT_UDPLITE_MAX);

Yay for conditional includes :-/

Pablo, I just saw there are still patches from Davide in your queue so I
will not resend this (it will surely conflict).
