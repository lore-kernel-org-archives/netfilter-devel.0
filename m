From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [PATCH] [connlimit] Revert 44bd4de9
Date: Mon, 14 Feb 2011 10:30:21 -0500
Message-ID: <4D594A8D.5040600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: stefanb@linux.vnet.ibm.com
To: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:57792 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab1BNPaz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:30:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have to revert the early loop termination in connlimit since it 
generates problems when an iptables statement does not use -m state 
--state NEW before the connlimit match extension.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
  net/netfilter/xt_connlimit.c |   13 +++----------
  1 file changed, 3 insertions(+), 10 deletions(-)

Index: nf-next-2.6/net/netfilter/xt_connlimit.c
===================================================================
--- nf-next-2.6.orig/net/netfilter/xt_connlimit.c
+++ nf-next-2.6/net/netfilter/xt_connlimit.c
@@ -97,8 +97,7 @@ static int count_them(struct net *net,
                const struct nf_conntrack_tuple *tuple,
                const union nf_inet_addr *addr,
                const union nf_inet_addr *mask,
-              u_int8_t family,
-              unsigned int threshold)
+              u_int8_t family)
  {
      const struct nf_conntrack_tuple_hash *found;
      struct xt_connlimit_conn *conn;
@@ -152,14 +151,9 @@ static int count_them(struct net *net,
              continue;
          }

-        if (same_source_net(addr, mask, &conn->tuple.src.u3, family)) {
+        if (same_source_net(addr, mask, &conn->tuple.src.u3, family))
              /* same source network -> be counted! */
              ++matches;
-            if (matches > threshold) {
-                nf_ct_put(found_ct);
-                break;
-            }
-        }
          nf_ct_put(found_ct);
      }

@@ -213,8 +207,7 @@ connlimit_mt(const struct sk_buff *skb,

      spin_lock_bh(&info->data->lock);
      connections = count_them(net, info->data, tuple_ptr, &addr,
- &info->mask, par->family,
-                             info->limit);
+ &info->mask, par->family);
      spin_unlock_bh(&info->data->lock);

      if (connections < 0)
