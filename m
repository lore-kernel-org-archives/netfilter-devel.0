From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH nf-next 1/4] netfilter: nf_conntrack_tuple_common.h: fix
 #include
Date: Fri, 11 Nov 2016 12:07:38 +0200
Message-ID: <20161111100738.GF8342@lakka.kapsi.fi>
References: <cover.1478784737.git.dcaratti@redhat.com>
 <76156fa3b39eba2d1d6739a47d40a99920acd802.1478784737.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        James Morris <jmorris@namei.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49110 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750776AbcKKKIO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2016 05:08:14 -0500
Content-Disposition: inline
In-Reply-To: <76156fa3b39eba2d1d6739a47d40a99920acd802.1478784737.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, Nov 10, 2016 at 03:46:25PM +0100, Davide Caratti wrote:
> In commit 1ffad83dffd6 ("netfilter: fix include files for compilation"),
> compile-time errors were fixed for userspace programs including UAPI
> nf_conntrack_tuple_common.h: this was done by adding a "#include
>  <linux/netfilter.h>" line to that header file. This patch replaces
> "<linux/netfilter.h>" with "<linux/netfilter/nf_conntrack_common.h>"
> in nf_conntrack_tuple_common.h to avoid compile-time errors when trying
> to use enum ip_conntrack_dir in include/net/netns/conntrack.h, and still
> correctly resolve IP_CT_IS_REPLY.

I assume also with this change it is ok to include both <linux/netfilter.h>
and <linux/netfilter/nf_conntrack_tuple_common.h> userspace but what was the
kernel compile error with include/net/netns/conntrack.h and ip_conntrack_dir?

Is there a kernel side conflict between uapi and net/netns headers?

Could the fix be confined into the kernel side private headers somehow to avoid
changes visible to userspace?

I kind of like the pattern that netfilter uapi headers include
<linux/netfilter.h> and get what they need from there. Maybe maintainers
disagree though.

-Mikko

> This accidentally fixes two failures in the output of the script used to
> test the above commit [1]:
> 
> $ pushd usr/include
> $ ../../scripts/headers_compile_test.sh -k | grep FAILED >before.txt
> $ sed -i s/netfilter.h/netfilter\/nf_conntrack_common.h/1 \
>   linux/netfilter/nf_conntrack_tuple_common.h
> $ ../../scripts/headers_compile_test.sh -k | grep FAILED >after.txt
> $ diff before.txt after.txt
>  24,25d23
>  < FAILED: ./linux/netfilter/nf_conntrack_sctp.h
>  < FAILED: ./linux/netfilter/nf_conntrack_tuple_common.h
> $ popd
> 
> [1] https://github.com/mcfrisk/linux/blob/headers_test_v05/scripts/headers_compile_test.sh
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  include/uapi/linux/netfilter/nf_conntrack_tuple_common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
> index a9c3834..941e8ea 100644
> --- a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
> +++ b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
> @@ -2,7 +2,7 @@
>  #define _NF_CONNTRACK_TUPLE_COMMON_H
>  
>  #include <linux/types.h>
> -#include <linux/netfilter.h>
> +#include <linux/netfilter/nf_conntrack_common.h>
>  
>  enum ip_conntrack_dir {
>  	IP_CT_DIR_ORIGINAL,
> -- 
> 2.7.4
> 
