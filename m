From: Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH nf-next 1/4] netfilter: nf_conntrack_tuple_common.h:
 fix #include
Date: Fri, 11 Nov 2016 13:02:19 +0100
Message-ID: <1478865739.2571.62.camel@redhat.com>
References: <cover.1478784737.git.dcaratti@redhat.com>
         <76156fa3b39eba2d1d6739a47d40a99920acd802.1478784737.git.dcaratti@redhat.com>
         <20161111100738.GF8342@lakka.kapsi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        James Morris <jmorris@namei.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48360 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754492AbcKKMC1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2016 07:02:27 -0500
In-Reply-To: <20161111100738.GF8342@lakka.kapsi.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2016-11-11 at 12:07 +0200, Mikko Rapeli wrote:
> I assume also with this change it is ok to include both
> <linux/netfilter.h>
> and <linux/netfilter/nf_conntrack_tuple_common.h> userspace but what was
> the
> kernel compile error with include/net/netns/conntrack.h and
> ip_conntrack_dir?

hi Mikko, thank you for looking at this!

The problem is in patch 3/4 as I added #include
<linux/netfilter/nf_conntrack_sctp.h>  in include/net/netns/conntrack.h,
but I saw similar things also with DCCP.

<...>
  CC      kernel/sysctl_binary.o
In file included from ./include/linux/netfilter.h:14:0,
                 from ./include/uapi/linux/netfilter/nf_conntrack_tuple_common.h:5,
                 from ./include/uapi/linux/netfilter/nf_conntrack_sctp.h:5,
                 from ./include/linux/netfilter/nf_conntrack_sctp.h:5,
                 from ./include/net/netns/conntrack.h:13,
                 from ./include/net/net_namespace.h:25,
                 from ./include/linux/init_task.h:15,
                 from init/init_task.c:1:
./include/linux/netdevice.h:1859:2: error: unknown type name ‘possible_net_t’
  possible_net_t   nd_net;
  ^	
(possile_net_t is in net_namespace.h).

> Is there a kernel side conflict between uapi and net/netns headers?

Looks like a circular dependency is here, or nf_conntrack_tuple_common.h
is including the wrong netfilter.h. From within net/netns/conntrack.h I
can include only those UAPI files that don't include <linux/netfilter.h>
(for example, nf_conntrack_tcp.h that uses '2' instead of IP_CT_DIR_MAX).

Do you have any suggestion?
thank you in advance,
--
davide
