From: Artur Molchanov <arturmolchanov@gmail.com>
Subject: [PATCH] net/bridge: Fix dropping packets that moving through bridge
 interface
Date: Fri, 30 Dec 2016 19:46:36 +0300
Message-ID: <947bdfc8-07f1-f909-2328-85af084de741@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35508 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbcL3Qqg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Dec 2016 11:46:36 -0500
Received: by mail-lf0-f67.google.com with SMTP id x140so20614285lfa.2
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Dec 2016 08:46:35 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Artur Molchanov <artur.molchanov@synesis.ru>

Fixes: c5136b15ea36 ("netfilter: bridge: add and use br_nf_hook_thresh")

Problem:
br_nf_pre_routing_finish() calls itself instead of
br_nf_pre_routing_finish_bridge().
Due to this bug reverse path filter drops packets that moving through
bridge interface.

User impact:
Local docker containers with bridge network can not communicate with
each other.

Signed-off-by: Artur Molchanov <artur.molchanov@synesis.ru>
---
  net/bridge/br_netfilter_hooks.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_netfilter_hooks.c 
b/net/bridge/br_netfilter_hooks.c
index 8ca6a92..95087e6 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -399,7 +399,7 @@ static int br_nf_pre_routing_finish(struct net *net, 
struct sock *sk, struct sk_
                  br_nf_hook_thresh(NF_BR_PRE_ROUTING,
                            net, sk, skb, skb->dev,
                            NULL,
-                          br_nf_pre_routing_finish);
+                          br_nf_pre_routing_finish_bridge);
                  return 0;
              }
              ether_addr_copy(eth_hdr(skb)->h_dest, dev->dev_addr);
-- 
2.8.3
