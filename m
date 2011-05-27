From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [netfilter-core] Cannot unload nf_conntrack
Date: Fri, 27 May 2011 13:26:29 +0200
Message-ID: <4DDF8A65.1070900@netfilter.org>
References: <4DC0310F.3070004@bull.net> <4DDF7152.3030405@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040505090309070704090302"
Cc: netfilter-core@lists.netfilter.org
To: Zoltan.Menyhart@bull.net,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43163 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab1E0L0f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 May 2011 07:26:35 -0400
In-Reply-To: <4DDF7152.3030405@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040505090309070704090302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 27/05/11 11:39, Pablo Neira Ayuso wrote:
> On 03/05/11 18:45, Menyhart Zoltan wrote:
>> Hi,
>>
>> I cannot unload nf_conntrack because
>> nf_conntrack_untracked.ct_general.use.counter  == 7.
>>
>> The last_unloaded_module is "nf_conntrack_ipv6".
>>
>> Probably the following has happend:
>>
>> nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
>> struct sk_buff *skb):
>>
>>     ret = l4proto->error(net, skb, dataoff, &ctinfo, pf, hooknum):
>> /* e.g. */    icmpv6_error(struct net *net, struct sk_buff *skb,
>> unsigned int dataoff,
>>                  enum ip_conntrack_info *ctinfo, u_int8_t pf, unsigned
>> int hooknum):
>>             if (type >= 0 && type < sizeof(noct_valid_new) &&
>> noct_valid_new[type]) {
>>                 skb->nfct = &nf_conntrack_untracked.ct_general;
>>                 skb->nfctinfo = IP_CT_NEW;
>>                 nf_conntrack_get(skb->nfct);
>>                 return NF_ACCEPT;
>>         }
>>
>>     ct = resolve_normal_ct(net, skb, dataoff, pf, protonum, l3proto,
>> l4proto, &set_reply, &ctinfo);
>>         skb->nfct = &ct->ct_general;
>>         skb->nfctinfo = *ctinfo;
>>
>> Is it normal for resolve_normal_ct() to overwrite skb->nfct without
>> putting the previous conntrack?
> 
> Indeed, this looks quite suspicious. Let me check this with more attention.

Please, would you give a try to this patch?

Thanks!

--------------040505090309070704090302
Content-Type: text/x-patch;
 name="fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix.patch"

netfilter: nf_conntrack: fix ct refcount leak in l4proto->error()

This patch fixes a refcount leak of ct objects that may occur if
l4proto->error() assigns one conntrack object to one skbuff. In
that case, we have to skip further processing in nf_conntrack_in().

With this patch, we can also fix wrong return values (-NF_ACCEPT)
for special cases in ICMP[v6] that should not bump the invalid/error
statistic counters.

Reported-by: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 7404bde..ab5b27a 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -160,7 +160,7 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	/* Update skb to refer to this connection */
 	skb->nfct = &nf_ct_tuplehash_to_ctrack(h)->ct_general;
 	skb->nfctinfo = *ctinfo;
-	return -NF_ACCEPT;
+	return NF_ACCEPT;
 }
 
 /* Small and modified version of icmp_rcv */
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 1df3c8b..7c05e7e 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -177,7 +177,7 @@ icmpv6_error_message(struct net *net, struct nf_conn *tmpl,
 	/* Update skb to refer to this connection */
 	skb->nfct = &nf_ct_tuplehash_to_ctrack(h)->ct_general;
 	skb->nfctinfo = *ctinfo;
-	return -NF_ACCEPT;
+	return NF_ACCEPT;
 }
 
 static int
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2e1c11f..9421fe4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -922,6 +922,9 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 			ret = -ret;
 			goto out;
 		}
+		/* ICMP[v6] protocol trackers may assign one conntrack. */
+		if (skb->nfct)
+			goto out;
 	}
 
 	ct = resolve_normal_ct(net, tmpl, skb, dataoff, pf, protonum,

--------------040505090309070704090302--
