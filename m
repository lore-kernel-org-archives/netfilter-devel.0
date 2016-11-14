From: Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH nf-next 1/4] netfilter: nf_conntrack_tuple_common.h:
 fix #include
Date: Mon, 14 Nov 2016 15:01:57 +0100
Message-ID: <1479132117.2430.66.camel@redhat.com>
References: <cover.1478784737.git.dcaratti@redhat.com>
         <76156fa3b39eba2d1d6739a47d40a99920acd802.1478784737.git.dcaratti@redhat.com>
         <20161111100738.GF8342@lakka.kapsi.fi>
         <1478865739.2571.62.camel@redhat.com>
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
Received: from mx1.redhat.com ([209.132.183.28]:53358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751636AbcKNOCP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2016 09:02:15 -0500
In-Reply-To: <1478865739.2571.62.camel@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2016-11-11 at 13:02 +0100, Davide Caratti wrote:
> 
> > Is there a kernel side conflict between uapi and net/netns headers?
> 
> Looks like a circular dependency is here, or nf_conntrack_tuple_common.h
> is including the wrong netfilter.h. From within net/netns/conntrack.h I
> can include only those UAPI files that don't include <linux/netfilter.h>
> (for example, nf_conntrack_tcp.h that uses '2' instead of
> IP_CT_DIR_MAX).

hello Mikko,

I looked at the dependency issue:

current include/linux/netfilter.h needs include/net/net_namespace.h (i.e.
nf_hook() needs struct net), and include/net/net_namespace.h needs
include/net/netns/conntrack.h (i.e. struct net needs struct netns_ct).

That's why it's not possible to do #include <linux/netfilter.h> in
include/net/netns/conntrack.h, and it's not possible in
include/net/netns/conntrack.h to include any linux/netfilter/*.h UAPI
header where #include <linux/netfilter.h> line is present: the
preprocessor will prefer including include/linux/netfilter.h before
include/uapi/linux/netfilter.h, thus generating the dependency error.

One possible fix for the above issue is to modify
include/uapi/nf_conntrack_tuple_common.h in a way that it avoids including
<linux/netfilter.h> when kernel sources are being built, and still exposes
to userspace applications the same contents as commit 1ffad83dffd6
("netfilter: fix include files for compilation"):

<...>
#include <linux/types.h>
#ifndef __KERNEL__
#include <linux/netfilter.h>
#endif
#include <linux/netfilter/nf_conntrack_common.h> /* for IP_CT_IS_REPLY */
<...>

BTW, include/uapi/linux/capi.h apparently does something similar with
linux/kernelcapi.h. With the above change, also the output of 

$ pushd usr/include
$ ../../scripts/headers_compile_test.sh -k | grep FAILED
$ popd

is preserved.

Are you ok if I post a v2 where the above change (and a minor fix: use
_UAPI_NF_CONNTRACK_TUPLE_COMMON_H in place of NF_CONNTRACK_TUPLE_COMMON_H
on the first lines) is done to nf_conntrack_tuple_common.h?

regards,
--
davide

