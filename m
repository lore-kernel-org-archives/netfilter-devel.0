From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] return value of conntrack protocol helper functions and a
 macro for stats
Date: Thu, 05 Aug 2004 15:34:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4112377A.8050106@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020601010103030403050207"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020601010103030403050207
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch applies to last Harald's patch bombing. It's based on 
Martin's idea of removing negative values in conntrack protocol helper 
functions. Please see:

http://lists.netfilter.org/pipermail/netfilter-devel/2004-June/015769.html

Now functions packet and error return CONNTRACK_CONT to let the packet 
continue its travel through the conntrack system. It also add a macro to 
increase vars used for stats.

regards,
Pablo

--------------020601010103030403050207
Content-Type: text/x-patch;
 name="conntrack_cont-and-fix-stats.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="conntrack_cont-and-fix-stats.patch"

diff -u -r1.2 ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h	4 Aug 2004 15:26:52 -0000	1.2
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h	5 Aug 2004 11:09:17 -0000
@@ -10,6 +10,10 @@
 #include <linux/compiler.h>
 #include <asm/atomic.h>
 
+/* Protocol specific functions (packet and error) return CONNTRACK_CONT
+ * to perform no action on a packet. */
+#define CONNTRACK_CONT -1
+
 enum ip_conntrack_info
 {
 	/* Part of an established connection (either direction). */
@@ -303,12 +307,13 @@
 	unsigned int insert_failed;
 	unsigned int drop;
 	unsigned int early_drop;
-	unsigned int icmp_error;
+	unsigned int error;
 	unsigned int expect_new;
 	unsigned int expect_create;
 	unsigned int expect_delete;
 };
 
+#define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
 
 /* eg. PROVIDES_CONNTRACK(ftp); */
 #define PROVIDES_CONNTRACK(name)                        \
diff -u -r1.2 ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	4 Aug 2004 15:26:55 -0000	1.2
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	5 Aug 2004 11:17:18 -0000
@@ -182,7 +182,7 @@
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
 
 	kmem_cache_free(ip_conntrack_expect_cachep, exp);
-	__get_cpu_var(ip_conntrack_stat).expect_delete++;
+	CONNTRACK_STAT_INC(expect_delete);
 }
 
 inline void ip_conntrack_expect_put(struct ip_conntrack_expect *exp)
@@ -351,14 +351,14 @@
 	DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
 	kmem_cache_free(ip_conntrack_cachep, ct);
 	atomic_dec(&ip_conntrack_count);
-	__get_cpu_var(ip_conntrack_stat).delete++;
+	CONNTRACK_STAT_INC(delete);
 }
 
 static void death_by_timeout(unsigned long ul_conntrack)
 {
 	struct ip_conntrack *ct = (void *)ul_conntrack;
 
-	__get_cpu_var(ip_conntrack_stat).delete_list++;
+	CONNTRACK_STAT_INC(delete_list);
 
 	WRITE_LOCK(&ip_conntrack_lock);
 	clean_from_lists(ct);
@@ -488,12 +488,12 @@
 		atomic_inc(&ct->ct_general.use);
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		WRITE_UNLOCK(&ip_conntrack_lock);
-	 	__get_cpu_var(ip_conntrack_stat).insert++;
+		CONNTRACK_STAT_INC(insert);
 		return NF_ACCEPT;
 	}
 
 	WRITE_UNLOCK(&ip_conntrack_lock);
-	__get_cpu_var(ip_conntrack_stat).insert_failed++;
+	CONNTRACK_STAT_INC(insert_failed);
 	return NF_DROP;
 }
 
@@ -537,7 +537,7 @@
 	if (del_timer(&h->ctrack->timeout)) {
 		death_by_timeout((unsigned long)h->ctrack);
 		dropped = 1;
-		__get_cpu_var(ip_conntrack_stat).early_drop++;
+		CONNTRACK_STAT_INC(early_drop);
 	}
 	ip_conntrack_put(h->ctrack);
 	return dropped;
@@ -667,13 +667,13 @@
 		if (expected->expectfn)
 			expected->expectfn(conntrack);
 	
-		__get_cpu_var(ip_conntrack_stat).expect_new++;
+		CONNTRACK_STAT_INC(expect_new);
 
 		goto ret;
 	} else  {
 		conntrack->helper = ip_ct_find_helper(&repl_tuple);
 
-		__get_cpu_var(ip_conntrack_stat).new++;
+		CONNTRACK_STAT_INC(new);
 	}
 
 end:	atomic_inc(&ip_conntrack_count);
@@ -777,7 +777,7 @@
 
 	/* Previously seen (loopback or untracked)?  Ignore. */
 	if ((*pskb)->nfct) {
-		__get_cpu_var(ip_conntrack_stat).ignore++;
+		CONNTRACK_STAT_INC(ignore);
 		return NF_ACCEPT;
 	}
 
@@ -786,41 +786,42 @@
 	/* It may be an special packet, error, unclean...
 	 * inverse of the return code tells to the netfilter
 	 * core what to do with the packet. */
-	if (proto->error != NULL 
-	    && (ret = proto->error(*pskb, &ctinfo, hooknum)) <= 0) {
-		__get_cpu_var(ip_conntrack_stat).icmp_error++;
-		return -ret;
+	if (proto->error != NULL) {
+		ret = proto->error(*pskb, &ctinfo, hooknum);
+		if (ret != CONNTRACK_CONT) {
+			CONNTRACK_STAT_INC(error);
+			CONNTRACK_STAT_INC(invalid);
+			return ret;
+		}
 	}
 
 	if (!(ct = resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo))) {
 		/* Not valid part of a connection */
-		__get_cpu_var(ip_conntrack_stat).invalid++;
+		CONNTRACK_STAT_INC(invalid);
 		return NF_ACCEPT;
 	}
 
 	if (IS_ERR(ct)) {
 		/* Too stressed to deal. */
-		__get_cpu_var(ip_conntrack_stat).drop++;
+		CONNTRACK_STAT_INC(drop);
 		return NF_DROP;
 	}
 
 	IP_NF_ASSERT((*pskb)->nfct);
 
 	ret = proto->packet(ct, *pskb, ctinfo);
-	if (ret < 0) {
-		/* Invalid: inverse of the return code tells
-		 * the netfilter core what to do*/
+	if (ret != CONNTRACK_CONT) {
 		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct = NULL;
-		__get_cpu_var(ip_conntrack_stat).invalid++;
-		return -ret;
+		CONNTRACK_STAT_INC(invalid);
+		return ret;
 	}
 
-	if (ret != NF_DROP && ct->helper) {
+	if (ct->helper != NULL) {
 		ret = ct->helper->help(*pskb, ct, ctinfo);
 		if (ret == -1) {
 			/* Invalid */
-			__get_cpu_var(ip_conntrack_stat).invalid++;
+			CONNTRACK_STAT_INC(invalid);
 			nf_conntrack_put((*pskb)->nfct);
 			(*pskb)->nfct = NULL;
 			return NF_ACCEPT;
@@ -1024,7 +1025,7 @@
 
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
-	__get_cpu_var(ip_conntrack_stat).expect_create++;
+	CONNTRACK_STAT_INC(expect_create);
 
 	return ret;
 }
diff -u -r1.2 ip_conntrack_proto_generic.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_generic.c	4 Aug 2004 15:26:55 -0000	1.2
+++ b/net/ipv4/netfilter/ip_conntrack_proto_generic.c	5 Aug 2004 11:08:28 -0000
@@ -53,7 +53,7 @@
 		  enum ip_conntrack_info ctinfo)
 {
 	ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_generic_timeout);
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
 
 /* Called when a new connection for this protocol found. */
diff -u -r1.2 ip_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	4 Aug 2004 15:26:55 -0000	1.2
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	5 Aug 2004 11:16:11 -0000
@@ -102,7 +102,7 @@
 		ip_ct_refresh_acct(ct, ctinfo, skb, ip_ct_icmp_timeout);
 	}
 
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
 
 /* Called when a new connection for this protocol found. */
@@ -193,7 +193,7 @@
 
 	/* Update skb to refer to this connection */
 	skb->nfct = &h->ctrack->infos[*ctinfo];
-	return -NF_ACCEPT;
+	return NF_ACCEPT;
 }
 
 /* Small and modified version of icmp_rcv */
@@ -208,7 +208,7 @@
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
 				      "ip_ct_icmp: short packet ");
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
 	}
 
 	/* See ip_conntrack_proto_tcp.c */
@@ -222,13 +222,13 @@
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				      "ip_ct_icmp: bad HW ICMP checksum ");
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
 	case CHECKSUM_NONE:
 		if ((u16)csum_fold(skb_checksum(skb, 0, skb->len, 0))) {
 			if (LOG_INVALID(IPPROTO_ICMP))
 				nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 					      "ip_ct_icmp: bad ICMP checksum ");
-			return -NF_ACCEPT;
+			return NF_ACCEPT;
 		}
 	default:
 		break;
@@ -245,7 +245,7 @@
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
 				      "ip_ct_icmp: invalid ICMP type ");
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
 	}
 
 	/* Need to track icmp error message? */
@@ -254,7 +254,7 @@
 	    && icmph.type != ICMP_TIME_EXCEEDED
 	    && icmph.type != ICMP_PARAMETERPROB
 	    && icmph.type != ICMP_REDIRECT)
-		return NF_ACCEPT;
+		return CONNTRACK_CONT;
 
 	return icmp_error_message(skb, ctinfo, hooknum);
 }
diff -u -r1.2 ip_conntrack_proto_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	4 Aug 2004 15:26:55 -0000	1.2
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	5 Aug 2004 11:16:17 -0000
@@ -769,7 +769,7 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				"ip_ct_tcp: short packet ");
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
   	}
   
 	/* Not whole TCP header or malformed packet */
@@ -777,7 +777,7 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				"ip_ct_tcp: truncated/malformed packet ");
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
 	}
   
 	/* Checksum invalid? Ignore.
@@ -793,7 +793,7 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_tcp: bad TCP checksum ");
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
 	}
 
 	/* Check TCP flags. */
@@ -802,10 +802,10 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_tcp: invalid TCP flag combination ");
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
 	}
 
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
 
 static inline void copy_whole_tcp_header(const struct sk_buff *skb,
@@ -864,7 +864,7 @@
 		    	if (del_timer(&conntrack->timeout))
 		    		conntrack->timeout.function((unsigned long)
 		    					    conntrack);
-		    	return -NF_DROP;
+		    	return NF_DROP;
 		}
 		conntrack->proto.tcp.last_index = index;
 		conntrack->proto.tcp.last_dir = dir;
@@ -874,7 +874,7 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_tcp: invalid SYN (ignored) ");
-		return NF_ACCEPT;
+		return CONNTRACK_CONT;
 	case TCP_CONNTRACK_MAX:
 		/* Invalid packet */
 		DEBUGP("ip_ct_tcp: Invalid dir=%i index=%u ostate=%u\n",
@@ -884,7 +884,7 @@
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_tcp: invalid state ");
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
 	case TCP_CONNTRACK_SYN_SENT:
 		if (old_state >= TCP_CONNTRACK_TIME_WAIT) {	
 		    	/* Attempt to reopen a closed connection.
@@ -893,7 +893,7 @@
 		    	if (del_timer(&conntrack->timeout))
 		    		conntrack->timeout.function((unsigned long)
 		    					    conntrack);
-		    	return -NF_REPEAT;
+		    	return NF_REPEAT;
 		}
 		break;
 	case TCP_CONNTRACK_CLOSE:
@@ -908,7 +908,7 @@
 			if (LOG_INVALID(IPPROTO_TCP))
 				nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 					  "ip_ct_tcp: invalid RST (ignored) ");
-			return NF_ACCEPT;
+			return CONNTRACK_CONT;
 		}
 		/* Just fall trough */
 	default:
@@ -919,7 +919,7 @@
 	if (!tcp_in_window(&conntrack->proto.tcp, dir, &index, 
 			   skb, iph, tcph)) {
 		WRITE_UNLOCK(&tcp_lock);
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
 	}
 	/* From now on we have got in-window packets */
 	
@@ -950,7 +950,7 @@
 			if (del_timer(&conntrack->timeout))
 				conntrack->timeout.function((unsigned long)
 							    conntrack);
-			return NF_ACCEPT;
+			return CONNTRACK_CONT;
 		}
 	} else if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
 		   && (old_state == TCP_CONNTRACK_SYN_RECV
@@ -963,7 +963,7 @@
 	}
 	ip_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
 
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
  
   /* Called when a new connection for this protocol found. */
diff -u -r1.2 ip_conntrack_proto_udp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c	4 Aug 2004 15:26:55 -0000	1.2
+++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c	5 Aug 2004 11:15:31 -0000
@@ -74,7 +74,7 @@
 	} else
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_udp_timeout);
 
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
 
 /* Called when a new connection for this protocol found. */
@@ -95,7 +95,7 @@
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_udp: short packet ");
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
 	}
 	
 	/* Truncated/malformed packets */
@@ -103,12 +103,12 @@
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_udp: truncated/malformed packet ");
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
 	}
 	
 	/* Packet with no checksum */
 	if (!hdr.check)
-		return NF_ACCEPT;
+		return CONNTRACK_CONT;
 
 	/* Checksum invalid? Ignore.
 	 * We skip checking packets on the outgoing path
@@ -122,10 +122,10 @@
 		if (LOG_INVALID(IPPROTO_UDP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 				  "ip_ct_udp: bad UDP checksum ");
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
 	}
 	
-	return NF_ACCEPT;
+	return CONNTRACK_CONT;
 }
 
 struct ip_conntrack_protocol ip_conntrack_protocol_udp =

--------------020601010103030403050207--
