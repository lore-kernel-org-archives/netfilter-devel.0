From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng 3/5] whitespace and indentation
Date: Wed, 19 Jan 2005 01:45:54 +0100
Message-ID: <20050119004554.GC12967@roonstrasse.net>
References: <20050119004332.GA12629@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="p4qYPpj5QlsIQJ0K"
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


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

fix indentation.


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="03-whitespace_fixes.patch"

Wed Jan 19 01:33:59 CET 2005  max@duempel.org
  * whitespace fixes
diff -rN -u h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c
--- h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c	2005-01-19 01:35:46.792784120 +0100
+++ h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c	2005-01-19 01:35:46.826778952 +0100
@@ -1,5 +1,5 @@
-/* 
- * H.323 'brute force' extension for H.323 connection tracking. 
+/*
+ * H.323 'brute force' extension for H.323 connection tracking.
  * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  * (c) 2005 Max Kellermann <max@duempel.org>
  *
@@ -61,7 +61,7 @@
 	/* Can't track connections formed before we registered */
 	if (!info)
 		return NF_ACCEPT;
-		
+
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED
 	    && ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
@@ -104,7 +104,7 @@
 			exp_info->offset = i;
 
 			exp->seq = ntohl(tcph->seq) + i;
-		    
+
 			exp->tuple = ((struct ip_conntrack_tuple)
 				{ { ct->tuplehash[!dir].tuple.src.ip,
 				    { 0 } },
@@ -114,9 +114,9 @@
 			exp->mask = ((struct ip_conntrack_tuple)
 				{ { 0xFFFFFFFF, { 0 } },
 				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFFFF }});
-	
+
 			exp->expectfn = NULL;
-			
+
 			/* Ignore failure; should only happen with NAT */
 			ip_conntrack_expect_related(ct, exp);
 
@@ -149,7 +149,7 @@
 	ct->helper = &h245;
 	DEBUGP("h225_expect: helper for %p added\n", ct);
 	WRITE_UNLOCK(&ip_conntrack_lock);
-	
+
 	return NF_ACCEPT;	/* unused */
 }
 
@@ -170,7 +170,7 @@
 	u_int16_t data_port;
 	u_int32_t data_ip;
 	unsigned int i;
-	
+
 	DEBUGP("ct_h225_help: help entered %u.%u.%u.%u:%u->%u.%u.%u.%u:%u\n",
 		NIPQUAD(iph->saddr), ntohs(tcph->source),
 		NIPQUAD(iph->daddr), ntohs(tcph->dest));
@@ -201,7 +201,7 @@
 		       NIPQUAD(iph->daddr));
 		return NF_ACCEPT;
 	}
-	
+
 	data_limit = (unsigned char *) data + datalen;
 	/* bytes: 0123   45
 	          ipadrr port */
@@ -243,9 +243,9 @@
 				exp->mask = ((struct ip_conntrack_tuple)
 					{ { 0xFFFFFFFF, { 0 } },
 					  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFFFF }});
-	
+
 				exp->expectfn = h225_expect;
-				
+
 				/* Ignore failure */
 				ip_conntrack_expect_related(ct, exp);
 
@@ -254,7 +254,7 @@
 					NIPQUAD(iph->saddr), ntohs(data_port));
 
 				UNLOCK_BH(&ip_h323_lock);
-                	}  
+			}
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 		} else if (data_ip == iph->daddr) {
 			data_port = *((u_int16_t *)(data + 4));
@@ -299,7 +299,7 @@
 
 static void __exit fini(void)
 {
-	/* Unregister H.225 helper */	
+	/* Unregister H.225 helper */
 	ip_conntrack_helper_unregister(&h225);
 }
 
diff -rN -u h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c
--- h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c	2005-01-19 01:35:46.790784424 +0100
+++ h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c	2005-01-19 01:35:46.825779104 +0100
@@ -1,5 +1,5 @@
-/* 
- * H.323 'brute force' extension for NAT alteration. 
+/*
+ * H.323 'brute force' extension for NAT alteration.
  * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  * (c) 2005 Max Kellermann <max@duempel.org>
  *
@@ -39,7 +39,7 @@
 
 /* FIXME: Time out? --RR */
 
-static unsigned int 
+static unsigned int
 h225_nat_expected(struct sk_buff **pskb,
 		  unsigned int hooknum,
 		  struct ip_conntrack *ct,
@@ -47,12 +47,12 @@
 
 static unsigned int h225_nat_help(struct ip_conntrack *ct,
 				  struct ip_conntrack_expect *exp,
-			 	  struct ip_nat_info *info,
-			 	  enum ip_conntrack_info ctinfo,
-			 	  unsigned int hooknum,
-			 	  struct sk_buff **pskb);
-		  
-static struct ip_nat_helper h245 = 
+				  struct ip_nat_info *info,
+				  enum ip_conntrack_info ctinfo,
+				  unsigned int hooknum,
+				  struct sk_buff **pskb);
+
+static struct ip_nat_helper h245 =
 	{ { NULL, NULL },
           "H.245",				/* name */
 	  0,					/* flags */
@@ -78,7 +78,7 @@
 	struct ip_ct_h225_master *master_info;
 	struct ip_conntrack *master = master_ct(ct);
 	unsigned int is_h225, ret;
-	
+
 	IP_NF_ASSERT(info);
 	IP_NF_ASSERT(master);
 
@@ -111,7 +111,7 @@
 	port = exp_info->port;
 	is_h225 = master_info->is_h225 == H225_PORT;
 	UNLOCK_BH(&ip_h323_lock);
-	
+
 	if (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC)
 		newip = newsrcip;
 	else
@@ -134,7 +134,7 @@
 	}
 
 	ret = ip_nat_setup_info(ct, &mr, hooknum);
-	
+
 	if (is_h225) {
 		DEBUGP("h225_nat_expected: H.225, setting NAT helper for %p\n", ct);
 		/* NAT expectfn called with ip_nat_lock write-locked */
@@ -144,15 +144,15 @@
 }
 
 static int h323_signal_address_fixup(struct ip_conntrack *ct,
-			      	     struct sk_buff **pskb,
-			      	     enum ip_conntrack_info ctinfo)
+				     struct sk_buff **pskb,
+				     enum ip_conntrack_info ctinfo)
 {
 	struct iphdr *iph = (*pskb)->nh.iph;
 	struct tcphdr *tcph = (void *)iph + iph->ihl*4;
 	char *data = (char *) tcph + tcph->doff * 4;
 	u_int32_t tcplen = (*pskb)->len - iph->ihl*4;
 	u_int32_t datalen = tcplen - tcph->doff*4;
-	struct ip_ct_h225_master *info = &ct->help.ct_h225_info; 
+	struct ip_ct_h225_master *info = &ct->help.ct_h225_info;
 	u_int32_t newip;
 	u_int16_t port;
 	int i;
@@ -168,8 +168,8 @@
 		|| between(info->seq[IP_CT_DIR_REPLY], ntohl(tcph->seq), ntohl(tcph->seq) + datalen)))
 		return 1;
 
-	DEBUGP("h323_signal_address_fixup: offsets %u + 6  and %u + 6 in %u\n", 
-		info->offset[IP_CT_DIR_ORIGINAL], 
+	DEBUGP("h323_signal_address_fixup: offsets %u + 6  and %u + 6 in %u\n",
+		info->offset[IP_CT_DIR_ORIGINAL],
 		info->offset[IP_CT_DIR_REPLY],
 		tcplen);
 	DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
@@ -179,7 +179,7 @@
 		DEBUGP("h323_signal_address_fixup: %s %s\n",
 			info->dir == IP_CT_DIR_ORIGINAL ? "original" : "reply",
 			i == IP_CT_DIR_ORIGINAL ? "caller" : "callee");
-		if (!between(info->seq[i], ntohl(tcph->seq), 
+		if (!between(info->seq[i], ntohl(tcph->seq),
 			     ntohl(tcph->seq) + datalen))
 			continue;
 		if (!between(info->seq[i] + 6, ntohl(tcph->seq),
@@ -204,18 +204,18 @@
 			port = ct->tuplehash[!info->dir].tuple.src.u.tcp.port;
 		}
 
-		DEBUGP("h323_signal_address_fixup: orig %s IP:port %u.%u.%u.%u:%u\n", 
-			i == IP_CT_DIR_ORIGINAL ? "source" : "dest  ", 
-			NIPQUAD(*((u_int32_t *)(data + info->offset[i]))), 
+		DEBUGP("h323_signal_address_fixup: orig %s IP:port %u.%u.%u.%u:%u\n",
+			i == IP_CT_DIR_ORIGINAL ? "source" : "dest  ",
+			NIPQUAD(*((u_int32_t *)(data + info->offset[i]))),
 			ntohs(*((u_int16_t *)(data + info->offset[i] + 4))));
 
 		/* Modify the packet */
 		*(u_int32_t *)(data + info->offset[i]) = newip;
 		*(u_int16_t *)(data + info->offset[i] + 4) = port;
-	
-		DEBUGP("h323_signal_address_fixup:  new %s IP:port %u.%u.%u.%u:%u\n", 
-			i == IP_CT_DIR_ORIGINAL ? "source" : "dest  ", 
-			NIPQUAD(*((u_int32_t *)(data + info->offset[i]))), 
+
+		DEBUGP("h323_signal_address_fixup:  new %s IP:port %u.%u.%u.%u:%u\n",
+			i == IP_CT_DIR_ORIGINAL ? "source" : "dest  ",
+			NIPQUAD(*((u_int32_t *)(data + info->offset[i]))),
 			ntohs(*((u_int16_t *)(data + info->offset[i] + 4))));
 	}
 
@@ -291,7 +291,7 @@
 		newtuple.dst.protonum = IPPROTO_UDP;
 		newtuple.src.u.udp.port = expect->tuple.src.u.udp.port;
 	}
-	
+
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(info->port); port != 0; port++) {
 		if (is_h225)
@@ -309,16 +309,16 @@
 
 	port = htons(port);
 
-	DEBUGP("h323_data_fixup: orig IP:port %u.%u.%u.%u:%u\n", 
-		NIPQUAD(*((u_int32_t *)(data + info->offset))), 
+	DEBUGP("h323_data_fixup: orig IP:port %u.%u.%u.%u:%u\n",
+		NIPQUAD(*((u_int32_t *)(data + info->offset))),
 		ntohs(*((u_int16_t *)(data + info->offset + 4))));
 
 	/* Modify the packet */
 	*(u_int32_t *)(data + info->offset) = newip;
 	*(u_int16_t *)(data + info->offset + 4) = port;
-	
-	DEBUGP("h323_data_fixup: new IP:port %u.%u.%u.%u:%u\n", 
-		NIPQUAD(*((u_int32_t *)(data + info->offset))), 
+
+	DEBUGP("h323_data_fixup: new IP:port %u.%u.%u.%u:%u\n",
+		NIPQUAD(*((u_int32_t *)(data + info->offset))),
 		ntohs(*((u_int16_t *)(data + info->offset + 4))));
 
 	/* fix checksum information  */
@@ -338,14 +338,14 @@
 
 static unsigned int h225_nat_help(struct ip_conntrack *ct,
 				  struct ip_conntrack_expect *exp,
-			 	  struct ip_nat_info *info,
-			 	  enum ip_conntrack_info ctinfo,
-			 	  unsigned int hooknum,
-			 	  struct sk_buff **pskb)
+				  struct ip_nat_info *info,
+				  enum ip_conntrack_info ctinfo,
+				  unsigned int hooknum,
+				  struct sk_buff **pskb)
 {
 	int dir;
 	struct ip_ct_h225_expect *exp_info;
-	
+
 	/* Only mangle things once: original direction in POST_ROUTING
 	   and reply direction on PRE_ROUTING. */
 	dir = CTINFO2DIR(ctinfo);
@@ -373,7 +373,7 @@
 		UNLOCK_BH(&ip_h323_lock);
 		return NF_ACCEPT;
 	}
-		
+
 	exp_info = &exp->help.exp_h225_info;
 
 	LOCK_BH(&ip_h323_lock);
@@ -402,7 +402,7 @@
 static int __init init(void)
 {
 	int ret;
-	
+
 	ret = ip_nat_helper_register(&h225);
 
 	if (ret != 0)


--p4qYPpj5QlsIQJ0K--
