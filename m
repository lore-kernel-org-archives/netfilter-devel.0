From: Juan Carlos Castro y Castro <jcastro@instant.com.br>
Subject: Patch to make TARPIT compile under 2.6.22
Date: Wed, 01 Aug 2007 21:38:34 -0300
Message-ID: <46B1278A.1050701@instant.com.br>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080704050006040608000700"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------080704050006040608000700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Please CC me as I'm not on the list. Here attached is a patch that I 
made to make pom-ng ipt_TARPIT.c compile under kernel 2.6.22+. It is 
against the latest SVN version as of now. Please tell me if this should 
be submitted in another fashion.

I inspired myself in a patch I saw for Gentoo vmware-modules here: 
http://bugs.gentoo.org/show_bug.cgi?id=182595

--------------080704050006040608000700
Content-Type: text/x-patch;
 name="tarpit-2-6-22.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tarpit-2-6-22.patch"

--- patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c	2007-08-01 20:08:12.000000000 -0300
+++ patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c.new	2007-08-01 21:30:12.000000000 -0300
@@ -84,12 +84,22 @@
 	u_int16_t tmp;
 
 	/* A truncated TCP header isn't going to be useful */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	if (oskb->len < (((struct iphdr *)skb_network_header(oskb))->ihl*4) + sizeof(struct tcphdr))
+#else
 	if (oskb->len < (oskb->nh.iph->ihl*4) + sizeof(struct tcphdr))
+#endif
 		return;
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	otcph = (struct tcphdr *)((u_int32_t*)((struct iphdr *)skb_network_header(oskb))
+				  + ((struct iphdr *)skb_network_header(oskb))->ihl);
+	otcplen = oskb->len - ((struct iphdr *)skb_network_header(oskb))->ihl*4;
+#else
 	otcph = (struct tcphdr *)((u_int32_t*)oskb->nh.iph
 				  + oskb->nh.iph->ihl);
 	otcplen = oskb->len - oskb->nh.iph->ihl*4;
+#endif
 
 	/* No replies for RST or FIN */
 	if (otcph->rst || otcph->fin)
@@ -100,9 +110,15 @@
 		return;
 
 	/* Check checksum. */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	if (tcp_v4_check(otcplen, ((struct iphdr *)skb_network_header(oskb))->saddr,
+			 ((struct iphdr *)skb_network_header(oskb))->daddr,
+			 csum_partial((char *)otcph, otcplen, 0)) != 0)
+#else
 	if (tcp_v4_check(otcplen, oskb->nh.iph->saddr,
 			 oskb->nh.iph->daddr,
 			 csum_partial((char *)otcph, otcplen, 0)) != 0)
+#endif
 		return;
 
 	/* Copy skb (even if skb is about to be dropped, we can't just
@@ -119,25 +135,48 @@
 	nskb->nf_debug = 0;
 #endif
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	ntcph = (struct tcphdr *)((u_int32_t*)((struct iphdr *)skb_network_header(nskb)) +
+					((struct iphdr *)skb_network_header(nskb))->ihl);
+#else
 	ntcph = (struct tcphdr *)((u_int32_t*)nskb->nh.iph + nskb->nh.iph->ihl);
+#endif
 
 	/* Truncate to length (no data) */
 	ntcph->doff = sizeof(struct tcphdr)/4;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	skb_trim(nskb, ((struct iphdr *)skb_network_header(nskb))->ihl*4 + sizeof(struct tcphdr));
+	((struct iphdr *)skb_network_header(nskb))->tot_len = htons(nskb->len);
+#else
 	skb_trim(nskb, nskb->nh.iph->ihl*4 + sizeof(struct tcphdr));
 	nskb->nh.iph->tot_len = htons(nskb->len);
+#endif
 
 	/* Swap source and dest */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	((struct iphdr *)skb_network_header(nskb))->daddr =
+		xchg(&((struct iphdr *)skb_network_header(nskb))->saddr, ((struct iphdr *)skb_network_header(nskb))->daddr);
+#else
 	nskb->nh.iph->daddr = xchg(&nskb->nh.iph->saddr, nskb->nh.iph->daddr);
+#endif
 	tmp = ntcph->source;
 	ntcph->source = ntcph->dest;
 	ntcph->dest = tmp;
 
 	/* Use supplied sequence number or make a new one */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	ntcph->seq = otcph->ack ? otcph->ack_seq
+		: htonl(secure_tcp_sequence_number(((struct iphdr *)skb_network_header(nskb))->saddr,
+						   ((struct iphdr *)skb_network_header(nskb))->daddr,
+						   ntcph->source,
+						   ntcph->dest));
+#else
 	ntcph->seq = otcph->ack ? otcph->ack_seq
 		: htonl(secure_tcp_sequence_number(nskb->nh.iph->saddr,
 						   nskb->nh.iph->daddr,
 						   ntcph->source,
 						   ntcph->dest));
+#endif
 
 	/* Our SYN-ACKs must have a >0 window */
 	ntcph->window = (otcph->syn && !otcph->ack) ? htons(5) : 0;
@@ -158,6 +197,17 @@
 
 	/* Adjust TCP checksum */
 	ntcph->check = 0;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	ntcph->check = tcp_v4_check(sizeof(struct tcphdr),
+				   ((struct iphdr *)skb_network_header(nskb))->saddr,
+				   ((struct iphdr *)skb_network_header(nskb))->daddr,
+				   csum_partial((char *)ntcph,
+						sizeof(struct tcphdr), 0));
+
+	fl.nl_u.ip4_u.daddr = ((struct iphdr *)skb_network_header(nskb))->daddr;
+	fl.nl_u.ip4_u.saddr = local ? ((struct iphdr *)skb_network_header(nskb))->saddr : 0;
+	fl.nl_u.ip4_u.tos = RT_TOS(((struct iphdr *)skb_network_header(nskb))->tos) | RTO_CONN;
+#else
 	ntcph->check = tcp_v4_check(sizeof(struct tcphdr),
 				   nskb->nh.iph->saddr,
 				   nskb->nh.iph->daddr,
@@ -167,6 +217,7 @@
 	fl.nl_u.ip4_u.daddr = nskb->nh.iph->daddr;
 	fl.nl_u.ip4_u.saddr = local ? nskb->nh.iph->saddr : 0;
 	fl.nl_u.ip4_u.tos = RT_TOS(nskb->nh.iph->tos) | RTO_CONN;
+#endif
 	fl.oif = 0;
 
 	if (ip_route_output_key(&nrt, &fl))
@@ -175,6 +226,20 @@
 	dst_release(nskb->dst);
 	nskb->dst = &nrt->u.dst;
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	/* Adjust IP TTL */
+	((struct iphdr *)skb_network_header(nskb))->ttl = dst_metric(nskb->dst, RTAX_HOPLIMIT);
+
+	/* Set DF, id = 0 */
+	((struct iphdr *)skb_network_header(nskb))->frag_off = htons(IP_DF);
+	((struct iphdr *)skb_network_header(nskb))->id = 0;
+
+	/* Adjust IP checksum */
+	((struct iphdr *)skb_network_header(nskb))->check = 0;
+	((struct iphdr *)skb_network_header(nskb))->check =
+			ip_fast_csum((unsigned char *)((struct iphdr *)skb_network_header(nskb)),
+				   ((struct iphdr *)skb_network_header(nskb))->ihl);
+#else
 	/* Adjust IP TTL */
 	nskb->nh.iph->ttl = dst_metric(nskb->dst, RTAX_HOPLIMIT);
 
@@ -186,6 +251,7 @@
 	nskb->nh.iph->check = 0;
 	nskb->nh.iph->check = ip_fast_csum((unsigned char *)nskb->nh.iph,
 					   nskb->nh.iph->ihl);
+#endif
 
 	/* "Never happens" */
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12)
@@ -228,11 +294,19 @@
 
 	/* Our naive response construction doesn't deal with IP
            options, and probably shouldn't try. */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12)
+	if (((struct iphdr *)skb_network_header(skb))->ihl*4 != sizeof(struct iphdr))
+#else
 	if (skb->nh.iph->ihl*4 != sizeof(struct iphdr))
+#endif
 		return NF_DROP;
 
 	/* We aren't interested in fragments */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12)
+	if (((struct iphdr *)skb_network_header(skb))->frag_off & htons(IP_OFFSET))
+#else
 	if (skb->nh.iph->frag_off & htons(IP_OFFSET))
+#endif
 		return NF_DROP;
 
 	tarpit_tcp(skb,rt,hooknum == NF_IP_LOCAL_IN);

--------------080704050006040608000700--
