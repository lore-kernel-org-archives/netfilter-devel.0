From: nishit@elitecore.com
Subject: Re: rmmod ip_conntrack hangs.....
Date: Thu, 11 Oct 2007 00:45:22 +0530 (IST)
Message-ID: <1856.59.95.206.53.1192043722.squirrel@203.88.135.194>
References: <075601c78707$5d19c800$4c01a8c0@elitecore26>	<200704261105.l3QB59NB010836@toshiba.co.jp>
    <08c701c787fc$c874e1c0$4c01a8c0@elitecore26>
    <4630D096.5070706@trash.net>
    <048501c80812$0d372350$4c01a8c0@elitecore.com>
    <4709B274.1090102@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Nishit Shah" <nishit@elitecore.com>,
	"Yasuyuki KOZAKAI" <yasuyuki.kozakai@toshiba.co.jp>,
	"Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:44839 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754802AbXJJTpW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2007 15:45:22 -0400
In-Reply-To: <4709B274.1090102@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,
         I am adding the patch that patrick had submitted.

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_core.h
b/include/linux/netfilter_ipv4/ip_conntrack_core.h
index 907d4f5..e3a6df0 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_core.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_core.h
@@ -45,7 +45,7 @@ static inline int ip_conntrack_confirm(struct sk_buff
**pskb)
         int ret = NF_ACCEPT;

         if (ct) {
-                if (!is_confirmed(ct))
+                if (!is_confirmed(ct) && !is_dying(ct))
                         ret = __ip_conntrack_confirm(pskb);
                 ip_ct_deliver_cached_events(ct);
         }
diff --git a/include/net/netfilter/nf_conntrack_core.h
b/include/net/netfilter/nf_conntrack_core.h
index 7fdc72c..85634e1 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -64,7 +64,7 @@ static inline int nf_conntrack_confirm(struct sk_buff
**pskb)
         int ret = NF_ACCEPT;

         if (ct) {
-                if (!nf_ct_is_confirmed(ct))
+                if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
                         ret = __nf_conntrack_confirm(pskb);
                 nf_ct_deliver_cached_events(ct);
         }
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c
b/net/ipv4/netfilter/ip_conntrack_core.c
index 07ba1dd..23b99ae 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1254,7 +1254,7 @@ get_next_corpse(int (*iter)(struct ip_conntrack *i,
void *data),
         list_for_each_entry(h, &unconfirmed, list) {
                 ct = tuplehash_to_ctrack(h);
                 if (iter(ct, data))
-                        goto found;
+                        set_bit(IPS_DYING_BIT, &ct->status);
         }
         write_unlock_bh(&ip_conntrack_lock);
         return NULL;
diff --git a/net/netfilter/nf_conntrack_core.c
b/net/netfilter/nf_conntrack_core.c
index 32891eb..4fdf484 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1070,7 +1070,7 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void
*data),
         list_for_each_entry(h, &unconfirmed, list) {
                 ct = nf_ct_tuplehash_to_ctrack(h);
                 if (iter(ct, data))
-                        goto found;
+                        set_bit(IPS_DYING_BIT, &ct->status);
         }
         write_unlock_bh(&nf_conntrack_lock);
         return NULL;


It seems to me that some changes are required to apply this patch on
2.6.16. So, i am adding the patch for 2.6.16.


--- linux-2.6.16/include/linux/netfilter_ipv4/ip_conntrack_core.h	Fri Jun 
9 20:17:29 2006
+++
linux-2.6.16SMP-9420-nishit/include/linux/netfilter_ipv4/ip_conntrack_core.h	Wed
May 23 12:11:45 2007
@@ -45,9 +45,13 @@
 	int ret = NF_ACCEPT;

 	if (ct) {
-		if (!is_confirmed(ct))
+		if (!is_confirmed(ct) && !is_dying(ct))
 			ret = __ip_conntrack_confirm(pskb);
 		ip_ct_deliver_cached_events(ct);
 	}
 	return ret;
 }
--- linux-2.6.16/include/net/netfilter/nf_conntrack_core.h	Tue Jan  3
17:08:14 2006
+++ linux-2.6.16-9420-nishit/include/net/netfilter/nf_conntrack_core.h	Mon
Oct  8 17:45:14 2007
@@ -61,7 +61,7 @@
 	int ret = NF_ACCEPT;

 	if (ct) {
-		if (!nf_ct_is_confirmed(ct))
+		if (!nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
 			ret = __nf_conntrack_confirm(pskb);
 		nf_ct_deliver_cached_events(ct);
 	}
--- linux-2.6.16/net/ipv4/netfilter/ip_conntrack_core.c	Fri May  5
23:08:09 2006
+++ linux-2.6.16-9420-nishit/net/ipv4/netfilter/ip_conntrack_core.c	Fri
Jul  6 17:30:40 2007
@@ -1357,11 +1376,18 @@
 		if (h)
 			break;
 	}
-	if (!h)
+	if (!h){
 		h = LIST_FIND_W(&unconfirmed, do_iter,
 				struct ip_conntrack_tuple_hash *, iter, data);
-	if (h)
+		if (h){
+			struct ip_conntrack * ct = tuplehash_to_ctrack(h);
+			if (iter(ct, data))
+				set_bit(IPS_DYING_BIT, &ct->status);
+		}
+		h = NULL;
+	}else{
 		atomic_inc(&tuplehash_to_ctrack(h)->ct_general.use);
+	}
 	write_unlock_bh(&ip_conntrack_lock);

 	return h;
--- linux-2.6.16/net/netfilter/nf_conntrack_core.c	Wed Mar 22 15:37:01 2006
+++ linux-2.6.16-9420-nishit/net/netfilter/nf_conntrack_core.c	Thu Oct 11
01:04:33 2007
@@ -1504,11 +1504,18 @@
 		if (h)
 			break;
  	}
-	if (!h)
+	if (!h){
 		h = LIST_FIND_W(&unconfirmed, do_iter,
 				struct nf_conntrack_tuple_hash *, iter, data);
-	if (h)
+		if (h){
+			struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
+			if (iter(ct, data))
+				set_bit(IPS_DYING_BIT, &ct->status);
+		}
+		h = NULL;
+	}else{
 		atomic_inc(&nf_ct_tuplehash_to_ctrack(h)->ct_general.use);
+	}
 	write_unlock_bh(&nf_conntrack_lock);

 	return h;


Rgds,
Nishit Shah.


> Nishit Shah wrote:
>> Well, it is a long time for this reply.....
>>
>>             Ya it is working fine for me.I tried a lot to regenrate that
>> error in last few months, but no success !!!!
>
>
> Great. Could you send me the patch you're using so I don't have
> to backport it myself?
>

