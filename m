From: Pablo Neira <pablo@eurodev.net>
Subject: Re: check timer active
Date: Sun, 05 Dec 2004 23:29:22 +0100
Message-ID: <41B38BC2.1030506@eurodev.net>
References: <EINSTEINObLLAeSQzWA000068c7@einstein.systemmetrics.com>	<41B376E9.10607@eurodev.net>
	<41B37BE6.1090208@eurodev.net> <41B37E2F.4020007@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030906080509000002080106"
Cc: netfilter-devel@lists.netfilter.org,
	'Henrik Nordstrom' <hno@marasystems.com>,
	'Krisztian Kovacs' <hidden@sch.bme.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41B37E2F.4020007@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------030906080509000002080106
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:

> Pablo Neira wrote:
>
>> still think that you should use that function.
>>
>> Hm, I just realized that the amanda helper is faking counters, I 
>> guess that we need a version of ip_ct_refresh_acct which doesn't the 
>> increase skb counters. I'll send a patch to fix this once I know what 
>> is scheduled with nf_conntrack.
>
>
> Feel free to send it now, I still apply bugfixes to ip_conntrack
> of course :)


arg, stupid me, such problem doesn't exist, if skb is NULL we don't 
increase counters, that's what happens in amanda. Maybe the patch 
attached could clean up the current API, anyway that's not a bugfix 
anymore, so I'll hold it here.

--
Pablo

--------------030906080509000002080106
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

===== include/linux/netfilter_ipv4/ip_conntrack.h 1.24 vs edited =====
--- 1.24/include/linux/netfilter_ipv4/ip_conntrack.h	2004-10-21 06:13:43 +02:00
+++ edited/include/linux/netfilter_ipv4/ip_conntrack.h	2004-12-05 23:18:54 +01:00
@@ -260,11 +260,15 @@
 extern int invert_tuplepr(struct ip_conntrack_tuple *inverse,
 			  const struct ip_conntrack_tuple *orig);
 
-/* Refresh conntrack for this many jiffies */
+/* Refresh conntrack for this many jiffies and increase counters */
 extern void ip_ct_refresh_acct(struct ip_conntrack *ct,
 			       enum ip_conntrack_info ctinfo,
 			       const struct sk_buff *skb,
 			       unsigned long extra_jiffies);
+
+/* Refresh conntrack for this many jiffies */
+extern void ip_ct_refresh(struct ip_conntrack *ct,
+			  unsigned long extra_jiffies);
 
 /* These are for NAT.  Icky. */
 /* Update TCP window tracking data when NAT mangles the packet */
===== net/ipv4/netfilter/ip_conntrack_amanda.c 1.11 vs edited =====
--- 1.11/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-11-06 08:41:23 +01:00
+++ edited/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-12-05 23:17:37 +01:00
@@ -59,7 +59,7 @@
 
 	/* increase the UDP timeout of the master connection as replies from
 	 * Amanda clients to the server can be quite delayed */
-	ip_ct_refresh_acct(ct, ctinfo, NULL, master_timeout * HZ);
+	ip_ct_refresh(ct, master_timeout * HZ);
 
 	/* No data? */
 	dataoff = skb->nh.iph->ihl*4 + sizeof(struct udphdr);
===== net/ipv4/netfilter/ip_conntrack_core.c 1.73 vs edited =====
--- 1.73/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-29 01:35:43 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_core.c	2004-12-05 23:19:31 +01:00
@@ -1089,11 +1089,10 @@
 #endif
 }
 
-/* Refresh conntrack for this many jiffies and do accounting (if skb != NULL) */
-void ip_ct_refresh_acct(struct ip_conntrack *ct, 
-		        enum ip_conntrack_info ctinfo,
-			const struct sk_buff *skb,
-			unsigned long extra_jiffies)
+static inline void __ip_ct_refresh(struct ip_conntrack *ct, 
+				   enum ip_conntrack_info ctinfo,
+				   const struct sk_buff *skb,
+				   unsigned long extra_jiffies)
 {
 	IP_NF_ASSERT(ct->timeout.data == (unsigned long)ct);
 
@@ -1111,6 +1110,23 @@
 		ct_add_counters(ct, ctinfo, skb);
 		WRITE_UNLOCK(&ip_conntrack_lock);
 	}
+}
+
+/* Refresh conntrack for this many jiffies and do accounting.
+ * You should use this function just in protocol helpers. */
+void ip_ct_refresh_acct(struct ip_conntrack *ct,
+			enum ip_conntrack_info ctinfo,
+			const struct sk_buff *skb,
+			unsigned long extra_jiffies)
+{
+	__ip_ct_refresh(ct, ctinfo, skb, extra_jiffies);
+}
+
+/* Just refresh a conntrack some extra jiffies. */
+void ip_ct_refresh(struct ip_conntrack *ct,
+		   unsigned long extra_jiffies)
+{
+	__ip_ct_refresh(ct, 0, NULL, extra_jiffies);
 }
 
 int ip_ct_no_defrag;
===== net/ipv4/netfilter/ip_conntrack_standalone.c 1.53 vs edited =====
--- 1.53/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-21 06:13:43 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-12-05 23:17:37 +01:00
@@ -889,6 +889,7 @@
 EXPORT_SYMBOL(ip_conntrack_helper_register);
 EXPORT_SYMBOL(ip_conntrack_helper_unregister);
 EXPORT_SYMBOL(ip_ct_selective_cleanup);
+EXPORT_SYMBOL(ip_ct_refresh);
 EXPORT_SYMBOL(ip_ct_refresh_acct);
 EXPORT_SYMBOL(ip_ct_protos);
 EXPORT_SYMBOL(ip_ct_find_proto);

--------------030906080509000002080106--
