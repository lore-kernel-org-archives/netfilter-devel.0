From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: fix compilation with !CONFIG_NF_CONNTRACK
Date: Mon, 31 Oct 2016 12:53:42 +0100
Message-ID: <1477914822-17019-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37326 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941261AbcJaLyA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2016 07:54:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9D2B5209907
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 12:53:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F61EDA84A
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 12:53:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40CADDA84A
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 12:53:54 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With no conntrack support, struct nf_conntrack becomes undefined in
linux/skbuff.h.

Wrap around #include <net/netfilter/nf_conntrack.h> in ifdefs as we do
already in other spots in this code.

All errors (new ones prefixed by >>):

   In file included from net/ipv4/netfilter/nf_socket_ipv4.c:19:0:
>> include/net/netfilter/nf_conntrack.h:83:22: error: field 'ct_general' has incomplete type
     struct nf_conntrack ct_general;
                         ^~~~~~~~~~
   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_get':
>> include/net/netfilter/nf_conntrack.h:170:30: error: 'const struct sk_buff' has no member named 'nfct'; did you mean 'next'?
     return (struct nf_conn *)skb->nfct;
                                 ^~
   include/net/netfilter/nf_conntrack.h: In function 'nf_ct_put':
>> include/net/netfilter/nf_conntrack.h:177:2: error: implicit declaration of function 'nf_conntrack_put' [-Werror=implicit-function-declaration]
     nf_conntrack_put(&ct->ct_general);
     ^~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_socket_ipv4.c | 2 ++
 net/ipv6/netfilter/nf_socket_ipv6.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/netfilter/nf_socket_ipv4.c b/net/ipv4/netfilter/nf_socket_ipv4.c
index 5f3741ba4654..a83d558e1aae 100644
--- a/net/ipv4/netfilter/nf_socket_ipv4.c
+++ b/net/ipv4/netfilter/nf_socket_ipv4.c
@@ -16,7 +16,9 @@
 #include <net/sock.h>
 #include <net/inet_sock.h>
 #include <net/netfilter/nf_socket.h>
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack.h>
+#endif
 
 static int
 extract_icmp4_fields(const struct sk_buff *skb, u8 *protocol,
diff --git a/net/ipv6/netfilter/nf_socket_ipv6.c b/net/ipv6/netfilter/nf_socket_ipv6.c
index 95cb0b82ff9a..ebb2bf84232a 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -18,7 +18,9 @@
 #include <net/inet6_hashtables.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/netfilter/nf_socket.h>
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack.h>
+#endif
 
 static int
 extract_icmp6_fields(const struct sk_buff *skb,
-- 
2.1.4

