From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng 5/5] port the module to Linux 2.6
Date: Wed, 19 Jan 2005 01:47:52 +0100
Message-ID: <20050119004752.GF12967@roonstrasse.net>
References: <20050119004332.GA12629@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PGNNI9BzQDUtgA2J"
Cc: Robert Iakobashvili <roberti@GoNetworks.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050119004332.GA12629@roonstrasse.net>
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


--PGNNI9BzQDUtgA2J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

now this is the "real" patch which ports the module to the Linux 2.6
API.


--PGNNI9BzQDUtgA2J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="05-ported_to_linux26.patch"

Wed Jan 19 01:34:37 CET 2005  max@duempel.org
  * ported to linux 2.6
diff -rN -u h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c
--- h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c	2005-01-19 01:35:53.452771648 +0100
+++ h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c	2005-01-19 01:34:21.000000000 +0100
@@ -27,6 +27,10 @@
 MODULE_DESCRIPTION("H.323 'brute force' connection tracking module");
 MODULE_LICENSE("GPL");
 
+/* This is slow, but it's simple. --RR */
+static char h323_buffer[65536];
+static DECLARE_LOCK(h323_buffer_lock);
+
 DECLARE_LOCK(ip_h323_lock);
 struct module *ip_conntrack_h323 = THIS_MODULE;
 
@@ -37,30 +41,23 @@
 #endif
 
 /* FIXME: This should be in userspace.  Later. */
-static int h245_help(const struct iphdr *iph, size_t len,
+static int h245_help(struct sk_buff *skb,
 		     struct ip_conntrack *ct,
 		     enum ip_conntrack_info ctinfo)
 {
-	struct tcphdr *tcph = (void *)iph + iph->ihl * 4;
-	unsigned char *data = (unsigned char *) tcph + tcph->doff * 4;
+	struct iphdr *iph = skb->nh.iph;
+	struct tcphdr _tcph, *tcph;
+	unsigned char *data;
 	unsigned char *data_limit;
-	u_int32_t tcplen = len - iph->ihl * 4;
-	u_int32_t datalen = tcplen - tcph->doff * 4;
+	unsigned dataoff, datalen;
 	int dir = CTINFO2DIR(ctinfo);
 	struct ip_ct_h225_master *info = &ct->help.ct_h225_info;
-	struct ip_conntrack_expect expect, *exp = &expect;
-	struct ip_ct_h225_expect *exp_info = &exp->help.exp_h225_info;
+	struct ip_conntrack_expect *exp;
+	struct ip_ct_h225_expect *exp_info;
 	u_int16_t data_port;
 	u_int32_t data_ip;
 	unsigned int i;
-
-	DEBUGP("ct_h245_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
-		NIPQUAD(iph->saddr), ntohs(tcph->source),
-		NIPQUAD(iph->daddr), ntohs(tcph->dest));
-
-	/* Can't track connections formed before we registered */
-	if (!info)
-		return NF_ACCEPT;
+	int ret;
 
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED
@@ -69,34 +66,49 @@
 		return NF_ACCEPT;
 	}
 
-	/* Not whole TCP header or too short packet? */
-	if (tcplen < sizeof(struct tcphdr) || tcplen < tcph->doff * 4 + 5) {
-		DEBUGP("ct_h245_help: tcplen = %u\n", (unsigned)tcplen);
+	tcph = skb_header_pointer(skb, skb->nh.iph->ihl*4,
+				  sizeof(_tcph), &_tcph);
+	if (tcph == NULL)
 		return NF_ACCEPT;
-	}
 
-	/* Checksum invalid?  Ignore. */
-	/* FIXME: Source route IP option packets --RR */
-	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
-			      csum_partial((char *)tcph, tcplen, 0))) {
-		DEBUGP("ct_h245_help: bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u\n",
-		       tcph, tcplen, NIPQUAD(iph->saddr),
-		       NIPQUAD(iph->daddr));
+	DEBUGP("ct_h245_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
+		NIPQUAD(iph->saddr), ntohs(tcph->source),
+		NIPQUAD(iph->daddr), ntohs(tcph->dest));
+
+	dataoff = skb->nh.iph->ihl*4 + tcph->doff*4;
+	/* No data? */
+	if (dataoff >= skb->len) {
+		DEBUGP("ct_h245_help: skblen = %u\n", skb->len);
 		return NF_ACCEPT;
 	}
+	datalen = skb->len - dataoff;
 
-	data_limit = (unsigned char *) data + datalen;
+	LOCK_BH(&h323_buffer_lock);
+	data = skb_header_pointer(skb, dataoff,
+				  datalen, h323_buffer);
+	BUG_ON(data == NULL);
+
+	data_limit = data + datalen - 6;
 	/* bytes: 0123   45
 	          ipadrr port */
-	for (i = 0; data < (data_limit - 5); data++, i++) {
+	for (i = 0; data <= data_limit; data++, i++) {
 		data_ip = *((u_int32_t *)data);
 		if (data_ip == iph->saddr) {
 			data_port = *((u_int16_t *)(data + 4));
-			memset(&expect, 0, sizeof(expect));
+
 			/* update the H.225 info */
 			DEBUGP("ct_h245_help: new RTCP/RTP requested %u.%u.%u.%u:->%u.%u.%u.%u:%u\n",
 				NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
 				NIPQUAD(iph->saddr), ntohs(data_port));
+
+			exp = ip_conntrack_expect_alloc();
+			if (exp == NULL) {
+				ret = NF_ACCEPT;
+				goto out;
+			}
+
+			exp_info = &exp->help.exp_h225_info;
+
 			LOCK_BH(&ip_h323_lock);
 			info->is_h225 = H225_PORT + 1;
 			exp_info->port = data_port;
@@ -118,14 +130,16 @@
 			exp->expectfn = NULL;
 
 			/* Ignore failure; should only happen with NAT */
-			ip_conntrack_expect_related(ct, exp);
+			ip_conntrack_expect_related(exp, ct);
 
 			UNLOCK_BH(&ip_h323_lock);
 		}
 	}
 
-	return NF_ACCEPT;
-
+	ret = NF_ACCEPT;
+ out:
+	UNLOCK_BH(&h323_buffer_lock);
+	return ret;
 }
 
 /* H.245 helper is not registered! */
@@ -151,30 +165,23 @@
 }
 
 /* FIXME: This should be in userspace.  Later. */
-static int h225_help(const struct iphdr *iph, size_t len,
+static int h225_help(struct sk_buff *skb,
 		     struct ip_conntrack *ct,
 		     enum ip_conntrack_info ctinfo)
 {
-	struct tcphdr *tcph = (void *)iph + iph->ihl * 4;
-	unsigned char *data = (unsigned char *) tcph + tcph->doff * 4;
+	struct iphdr *iph = skb->nh.iph;
+	struct tcphdr _tcph, *tcph;
+	unsigned char *data;
 	unsigned char *data_limit;
-	u_int32_t tcplen = len - iph->ihl * 4;
-	u_int32_t datalen = tcplen - tcph->doff * 4;
+	unsigned dataoff, datalen;
 	int dir = CTINFO2DIR(ctinfo);
 	struct ip_ct_h225_master *info = &ct->help.ct_h225_info;
-	struct ip_conntrack_expect expect, *exp = &expect;
-	struct ip_ct_h225_expect *exp_info = &exp->help.exp_h225_info;
+	struct ip_conntrack_expect *exp;
+	struct ip_ct_h225_expect *exp_info;
 	u_int16_t data_port;
 	u_int32_t data_ip;
 	unsigned int i;
-
-	DEBUGP("ct_h225_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
-		NIPQUAD(iph->saddr), ntohs(tcph->source),
-		NIPQUAD(iph->daddr), ntohs(tcph->dest));
-
-	/* Can't track connections formed before we registered */
-	if (!info)
-		return NF_ACCEPT;
+	int ret;
 
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED
@@ -183,26 +190,32 @@
 		return NF_ACCEPT;
 	}
 
-	/* Not whole TCP header or too short packet? */
-	if (tcplen < sizeof(struct tcphdr) || tcplen < tcph->doff * 4 + 5) {
-		DEBUGP("ct_h225_help: tcplen = %u\n", (unsigned)tcplen);
+	tcph = skb_header_pointer(skb, skb->nh.iph->ihl*4,
+				  sizeof(_tcph), &_tcph);
+	if (tcph == NULL)
 		return NF_ACCEPT;
-	}
 
-	/* Checksum invalid?  Ignore. */
-	/* FIXME: Source route IP option packets --RR */
-	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
-			      csum_partial((char *)tcph, tcplen, 0))) {
-		DEBUGP("ct_h225_help: bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u\n",
-		       tcph, tcplen, NIPQUAD(iph->saddr),
-		       NIPQUAD(iph->daddr));
+	DEBUGP("ct_h225_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
+		NIPQUAD(iph->saddr), ntohs(tcph->source),
+		NIPQUAD(iph->daddr), ntohs(tcph->dest));
+
+	dataoff = skb->nh.iph->ihl*4 + tcph->doff*4;
+	/* No data? */
+	if (dataoff >= skb->len) {
+		DEBUGP("ct_h225_help: skblen = %u\n", skb->len);
 		return NF_ACCEPT;
 	}
+	datalen = skb->len - dataoff;
+
+	LOCK_BH(&h323_buffer_lock);
+	data = skb_header_pointer(skb, dataoff,
+				  datalen, h323_buffer);
+	BUG_ON(data == NULL);
 
-	data_limit = (unsigned char *) data + datalen;
+	data_limit = data + datalen - 6;
 	/* bytes: 0123   45
 	          ipadrr port */
-	for (i = 0; data < (data_limit - 5); data++, i++) {
+	for (i = 0; data <= data_limit; data++, i++) {
 		data_ip = *((u_int32_t *)data);
 		if (data_ip == iph->saddr) {
 			data_port = *((u_int16_t *)(data + 4));
@@ -220,9 +233,15 @@
 				UNLOCK_BH(&ip_h323_lock);
 #endif
 			} else {
-				memset(&expect, 0, sizeof(expect));
-
 				/* update the H.225 info */
+				exp = ip_conntrack_expect_alloc();
+				if (exp == NULL) {
+					ret = NF_ACCEPT;
+					goto out;
+				}
+
+				exp_info = &exp->help.exp_h225_info;
+
 				LOCK_BH(&ip_h323_lock);
 				info->is_h225 = H225_PORT;
 				exp_info->port = data_port;
@@ -244,7 +263,7 @@
 				exp->expectfn = h225_expect;
 
 				/* Ignore failure */
-				ip_conntrack_expect_related(ct, exp);
+				ip_conntrack_expect_related(exp, ct);
 
 				DEBUGP("ct_h225_help: new H.245 requested %u.%u.%u.%u->%u.%u.%u.%u:%u\n",
 					NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
@@ -271,8 +290,10 @@
 		}
 	}
 
-	return NF_ACCEPT;
-
+	ret = NF_ACCEPT;
+ out:
+	UNLOCK_BH(&h323_buffer_lock);
+	return ret;
 }
 
 static struct ip_conntrack_helper h225 = {
@@ -301,5 +322,7 @@
 
 EXPORT_SYMBOL(ip_h323_lock);
 
+PROVIDES_CONNTRACK(h225);
+PROVIDES_CONNTRACK(h245);
 module_init(init);
 module_exit(fini);
diff -rN -u h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c
--- h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c	2005-01-19 01:35:53.450771952 +0100
+++ h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c	2005-01-19 01:34:21.000000000 +0100
@@ -71,7 +71,7 @@
 		  struct ip_conntrack *ct,
 		  struct ip_nat_info *info)
 {
-	struct ip_nat_multi_range mr;
+	struct ip_nat_range range;
 	u_int32_t newdstip, newsrcip, newip;
 	u_int16_t port;
 	struct ip_ct_h225_expect *exp_info;
@@ -119,21 +119,20 @@
 
 	DEBUGP("h225_nat_expected: IP to %u.%u.%u.%u\n", NIPQUAD(newip));
 
-	mr.rangesize = 1;
 	/* We don't want to manip the per-protocol, just the IPs... */
-	mr.range[0].flags = IP_NAT_RANGE_MAP_IPS;
-	mr.range[0].min_ip = mr.range[0].max_ip = newip;
+	range.flags = IP_NAT_RANGE_MAP_IPS;
+	range.min_ip = range.max_ip = newip;
 
 	/* ... unless we're doing a MANIP_DST, in which case, make
 	   sure we map to the correct port */
 	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_DST) {
-		mr.range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
-		mr.range[0].min = mr.range[0].max
+		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
+		range.min = range.max
 			= ((union ip_conntrack_manip_proto)
 				{ .tcp = { port } });
 	}
 
-	ret = ip_nat_setup_info(ct, &mr, hooknum);
+	ret = ip_nat_setup_info(ct, &range, hooknum);
 
 	if (is_h225) {
 		DEBUGP("h225_nat_expected: H.225, setting NAT helper for %p\n", ct);
@@ -148,14 +147,22 @@
 				     enum ip_conntrack_info ctinfo)
 {
 	struct iphdr *iph = (*pskb)->nh.iph;
-	struct tcphdr *tcph = (void *)iph + iph->ihl*4;
-	char *data = (char *) tcph + tcph->doff * 4;
-	u_int32_t tcplen = (*pskb)->len - iph->ihl*4;
-	u_int32_t datalen = tcplen - tcph->doff*4;
+	struct tcphdr _tcph, *tcph;
+	u_int32_t tcplen, datalen;
 	struct ip_ct_h225_master *info = &ct->help.ct_h225_info;
-	u_int32_t newip;
-	u_int16_t port;
+	struct {
+		u_int32_t ip;
+		u_int16_t port;
+	} __attribute__ ((__packed__)) newdata;
 	int i;
+	int ret;
+
+	tcph = skb_header_pointer(*pskb, iph->ihl * 4, sizeof(_tcph), &_tcph);
+	if (tcph == NULL)
+		return NF_ACCEPT;
+
+	tcplen = (*pskb)->len - iph->ihl * 4;
+	datalen = tcplen - tcph->doff * 4;
 
 	MUST_BE_LOCKED(&ip_h323_lock);
 
@@ -197,39 +204,22 @@
 		/* Change address inside packet to match way we're mapping
 		   this connection. */
 		if (i == IP_CT_DIR_ORIGINAL) {
-			newip = ct->tuplehash[!info->dir].tuple.dst.ip;
-			port = ct->tuplehash[!info->dir].tuple.dst.u.tcp.port;
+			newdata.ip = ct->tuplehash[!info->dir].tuple.dst.ip;
+			newdata.port = ct->tuplehash[!info->dir].tuple.dst.u.tcp.port;
 		} else {
-			newip = ct->tuplehash[!info->dir].tuple.src.ip;
-			port = ct->tuplehash[!info->dir].tuple.src.u.tcp.port;
+			newdata.ip = ct->tuplehash[!info->dir].tuple.src.ip;
+			newdata.port = ct->tuplehash[!info->dir].tuple.src.u.tcp.port;
 		}
 
-		DEBUGP("h323_signal_address_fixup: orig %s IP:port %u.%u.%u.%u:%u\n",
-			i == IP_CT_DIR_ORIGINAL ? "source" : "dest  ",
-			NIPQUAD(*((u_int32_t *)(data + info->offset[i]))),
-			ntohs(*((u_int16_t *)(data + info->offset[i] + 4))));
-
 		/* Modify the packet */
-		*(u_int32_t *)(data + info->offset[i]) = newip;
-		*(u_int16_t *)(data + info->offset[i] + 4) = port;
-
-		DEBUGP("h323_signal_address_fixup:  new %s IP:port %u.%u.%u.%u:%u\n",
-			i == IP_CT_DIR_ORIGINAL ? "source" : "dest  ",
-			NIPQUAD(*((u_int32_t *)(data + info->offset[i]))),
-			ntohs(*((u_int16_t *)(data + info->offset[i] + 4))));
+		ret = ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
+					       info->seq[i] - ntohl(tcph->seq),
+					       sizeof(newdata),
+					       (const char*)&newdata, sizeof(newdata));
+		if (!ret)
+			return 0;
 	}
 
-	/* fix checksum information */
-
-	(*pskb)->csum = csum_partial((char *)tcph + tcph->doff*4,
-				     datalen, 0);
-
-	tcph->check = 0;
-	tcph->check = tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
-				   csum_partial((char *)tcph, tcph->doff*4,
-					   (*pskb)->csum));
-	ip_send_check(iph);
-
 	return 1;
 }
 
@@ -239,15 +229,23 @@
 			   enum ip_conntrack_info ctinfo,
 			   struct ip_conntrack_expect *expect)
 {
-	u_int32_t newip;
-	u_int16_t port;
+	struct {
+		u_int32_t ip;
+		u_int16_t port;
+	} __attribute__ ((__packed__)) newdata;
 	struct ip_conntrack_tuple newtuple;
 	struct iphdr *iph = (*pskb)->nh.iph;
-	struct tcphdr *tcph = (void *)iph + iph->ihl*4;
-	char *data = (char *) tcph + tcph->doff * 4;
-	u_int32_t tcplen = (*pskb)->len - iph->ihl*4;
+	struct tcphdr _tcph, *tcph;
+	u_int32_t tcplen;
 	struct ip_ct_h225_master *master_info = &ct->help.ct_h225_info;
 	int is_h225;
+	int ret;
+
+	tcph = skb_header_pointer(*pskb, iph->ihl * 4, sizeof(_tcph), &_tcph);
+	if (tcph == NULL)
+		return NF_ACCEPT;
+
+	tcplen = (*pskb)->len - iph->ihl * 4;
 
 	MUST_BE_LOCKED(&ip_h323_lock);
 	DEBUGP("h323_data_fixup: offset %u + 6 in %u\n", info->offset, tcplen);
@@ -270,13 +268,13 @@
 	   this connection. */
 	if (info->dir == IP_CT_DIR_REPLY) {
 		/* Must be where client thinks server is */
-		newip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+		newdata.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
 		/* Expect something from client->server */
 		newtuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
 		newtuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
 	} else {
 		/* Must be where server thinks client is */
-		newip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
+		newdata.ip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
 		/* Expect something from server->client */
 		newtuple.src.ip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
 		newtuple.dst.ip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
@@ -293,45 +291,29 @@
 	}
 
 	/* Try to get same port: if not, try to change it. */
-	for (port = ntohs(info->port); port != 0; port++) {
+	for (newdata.port = ntohs(info->port); newdata.port != 0; newdata.port++) {
 		if (is_h225)
-			newtuple.dst.u.tcp.port = htons(port);
+			newtuple.dst.u.tcp.port = htons(newdata.port);
 		else
-			newtuple.dst.u.udp.port = htons(port);
+			newtuple.dst.u.udp.port = htons(newdata.port);
 
 		if (ip_conntrack_change_expect(expect, &newtuple) == 0)
 			break;
 	}
-	if (port == 0) {
+	if (newdata.port == 0) {
 		DEBUGP("h323_data_fixup: no free port found!\n");
 		return 0;
 	}
 
-	port = htons(port);
-
-	DEBUGP("h323_data_fixup: orig IP:port %u.%u.%u.%u:%u\n",
-		NIPQUAD(*((u_int32_t *)(data + info->offset))),
-		ntohs(*((u_int16_t *)(data + info->offset + 4))));
+	newdata.port = htons(newdata.port);
 
 	/* Modify the packet */
-	*(u_int32_t *)(data + info->offset) = newip;
-	*(u_int16_t *)(data + info->offset + 4) = port;
-
-	DEBUGP("h323_data_fixup: new IP:port %u.%u.%u.%u:%u\n",
-		NIPQUAD(*((u_int32_t *)(data + info->offset))),
-		ntohs(*((u_int16_t *)(data + info->offset + 4))));
-
-	/* fix checksum information  */
-	/* FIXME: usually repeated multiple times in the case of H.245! */
-
-	(*pskb)->csum = csum_partial((char *)tcph + tcph->doff*4,
-				     tcplen - tcph->doff*4, 0);
-
-	tcph->check = 0;
-	tcph->check = tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
-				   csum_partial((char *)tcph, tcph->doff*4,
-					   (*pskb)->csum));
-	ip_send_check(iph);
+	ret = ip_nat_mangle_tcp_packet(pskb, ct, ctinfo,
+				       expect->seq - ntohl(tcph->seq),
+				       sizeof(newdata),
+				       (const char*)&newdata, sizeof(newdata));
+	if (!ret)
+		return 0;
 
 	return 1;
 }
@@ -416,5 +398,7 @@
 	ip_nat_helper_unregister(&h225);
 }
 
+NEEDS_CONNTRACK(h225);
+NEEDS_CONNTRACK(h245);
 module_init(init);
 module_exit(fini);
diff -rN -u h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/Makefile.ladd h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/Makefile.ladd
--- h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/Makefile.ladd	2005-01-19 01:35:53.452771648 +0100
+++ h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/Makefile.ladd	2005-01-19 01:34:21.000000000 +0100
@@ -2,8 +2,5 @@
  
 # H.323 support
 obj-$(CONFIG_IP_NF_H323) += ip_conntrack_h323.o
-ifdef CONFIG_IP_NF_H323
-	export-objs += ip_conntrack_h323.o
-endif
 obj-$(CONFIG_IP_NF_NAT_H323) += ip_nat_h323.o
 


--PGNNI9BzQDUtgA2J--
