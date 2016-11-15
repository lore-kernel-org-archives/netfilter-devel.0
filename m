From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next v2 1/4] netfilter: nf_conntrack_tuple_common.h: fix #include
Date: Tue, 15 Nov 2016 15:08:24 +0100
Message-ID: <c2ac27f064bb641d331abdacdff4ac5e6df83915.1479217169.git.dcaratti@redhat.com>
References: <cover.1479217169.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Florian Westphal <fw@strlen.de>, mikko.rapeli@iki.fi
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54348 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752236AbcKOOJb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 09:09:31 -0500
In-Reply-To: <cover.1479217169.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To allow usage of enum ip_conntrack_dir in include/net/netns/conntrack.h,
this patch encloses #include <linux/netfilter.h> in a #ifndef __KERNEL__
directive, so that compiler errors caused by unwanted inclusion of
include/linux/netfilter.h are avoided.
In addition, #include <linux/netfilter/nf_conntrack_common.h> line has
been added to resolve correctly CTINFO2DIR macro.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/uapi/linux/netfilter/nf_conntrack_tuple_common.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
index a9c3834..526b424 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
@@ -2,7 +2,10 @@
 #define _NF_CONNTRACK_TUPLE_COMMON_H
 
 #include <linux/types.h>
+#ifndef __KERNEL__
 #include <linux/netfilter.h>
+#endif
+#include <linux/netfilter/nf_conntrack_common.h> /* IP_CT_IS_REPLY */
 
 enum ip_conntrack_dir {
 	IP_CT_DIR_ORIGINAL,
-- 
2.7.4

