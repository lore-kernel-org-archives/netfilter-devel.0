From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next 1/4] netfilter: nf_conntrack_tuple_common.h: fix #include
Date: Thu, 10 Nov 2016 15:46:25 +0100
Message-ID: <76156fa3b39eba2d1d6739a47d40a99920acd802.1478784737.git.dcaratti@redhat.com>
References: <cover.1478784737.git.dcaratti@redhat.com>
Cc: coreteam@netfilter.org, netfilter-devel@vger.kernel.org
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        James Morris <jmorris@namei.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>, mikko.rapeli@iki.fi
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933572AbcKJOq7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 09:46:59 -0500
In-Reply-To: <cover.1478784737.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In commit 1ffad83dffd6 ("netfilter: fix include files for compilation"),
compile-time errors were fixed for userspace programs including UAPI
nf_conntrack_tuple_common.h: this was done by adding a "#include
 <linux/netfilter.h>" line to that header file. This patch replaces
"<linux/netfilter.h>" with "<linux/netfilter/nf_conntrack_common.h>"
in nf_conntrack_tuple_common.h to avoid compile-time errors when trying
to use enum ip_conntrack_dir in include/net/netns/conntrack.h, and still
correctly resolve IP_CT_IS_REPLY.

This accidentally fixes two failures in the output of the script used to
test the above commit [1]:

$ pushd usr/include
$ ../../scripts/headers_compile_test.sh -k | grep FAILED >before.txt
$ sed -i s/netfilter.h/netfilter\/nf_conntrack_common.h/1 \
  linux/netfilter/nf_conntrack_tuple_common.h
$ ../../scripts/headers_compile_test.sh -k | grep FAILED >after.txt
$ diff before.txt after.txt
 24,25d23
 < FAILED: ./linux/netfilter/nf_conntrack_sctp.h
 < FAILED: ./linux/netfilter/nf_conntrack_tuple_common.h
$ popd

[1] https://github.com/mcfrisk/linux/blob/headers_test_v05/scripts/headers_compile_test.sh

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/uapi/linux/netfilter/nf_conntrack_tuple_common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
index a9c3834..941e8ea 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
@@ -2,7 +2,7 @@
 #define _NF_CONNTRACK_TUPLE_COMMON_H
 
 #include <linux/types.h>
-#include <linux/netfilter.h>
+#include <linux/netfilter/nf_conntrack_common.h>
 
 enum ip_conntrack_dir {
 	IP_CT_DIR_ORIGINAL,
-- 
2.7.4

