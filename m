From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: Remove duplicated rcu_read_lock.
Date: Sun, 14 May 2017 03:51:04 +0900
Message-ID: <20170513185104.6271-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34707 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753683AbdEMSwh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 May 2017 14:52:37 -0400
Received: by mail-pg0-f65.google.com with SMTP id u187so11601124pgb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 13 May 2017 11:52:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some functions are called by nf_hook() and these
functions hold rcu_read_lock() But nf_hook() already holds
rcu_read_lock() therefore callee's rcu_read_lock() are useless.
Below messages are calltrace.

1. ip_vs_in_stats
-ip_vs_leave
--ip_{tcp, udp, sctp}_conn_schedule
---ip_vs_protocol.conn_schedule
----ip_vs_try_to_schedule
-----ip_vs_in_icmp
------ip_vs_in
-------ip_vs_remote_request4
--------nf_hook_ops.hook
---------nf_hook()
-------ip_vs_local_request4
--------nf_hook_ops.hook
---------nf_hook()
-------ip_vs_remote_request6
--------nf_hook_ops.hook
---------nf_hook()
-------ip_vs_local_request6
--------nf_hook_ops.hook
---------nf_hook()
------ip_vs_forward_icmp
--------nf_hook_ops.hook
---------nf_hook()
-----ip_vs_in_icmp_v6
------ip_vs_in
-------nf_hook()
------ip_vs_forward_icmp_v6
-------nf_hook_ops.hook
--------nf_hook()
-----ip_vs_in
------nf_hook()
-ip_vs_in_icmp
--nf_hook()
-ip_vs_in_icmp_v6
--nf_hook()
-ip_vs_in
--nf_hook()

2.ip_vs_out_stats
-handle_response_icmp
--ip_vs_out_icmp
---ip_vs_out
----ip_vs_reply4
-----nf_hook_ops.hook
------nf_hook()
----ip_vs_local_reply4
-----nf_hook_ops.hook
------nf_hook()
----ip_vs_reply6
-----nf_hook_ops.hook
------nf_hook()
----ip_vs_local_reply6
-----nf_hook_ops.hook
------nf_hook()
--ip_vs_out_icmp_v6
---ip_vs_out
----nf_hook()
-handle_response
--ip_vs_out
---nf_hook()
-ip_vs_in_icmp
--nf_hook()

3.__ip_vs_rs_conn_out
-ip_vs_out
--nf_hook()

4.ip_vs_in_icmp
-nf_hook()

5.ip_vs_has_real_service
-ip_vs_out
--nf_hook()

6.ip_vs_ftp_out
-ip_vs_app.pkt_out
--app_tcp_pkt_out
---ip_vs_app_pkt_out
----{tcp, udp, sctp}_snat_handler
-----ip_vs_protocol.snat_handler
------handle_response
-------ip_vs_out
--------nf_hook()
--ip_vs_app_pkt_out
---nf_hook()

7.{tcp, udp, sctp}_conn_schedule
-nf_hook()

8. ip_vs_icmp_xmit
-ip_vs_in_icmp
--nf_hook()

9. ip_vs_icmp_xmit_v6
-ip_vs_in_icmp_v6
--nf_hook()

10. nf_conntrack_broadcast_help
-snmp_conntrack_help
--nf_conntrack_helper.help
---nf_hook()
-netbios_ns_help
--nf_conntrack_helper.help
---nf_hook()

11. pptp_expectfn
-exp_gre
--nf_conntrack_expect.expectfn
---init_conntrack
----nf_hook()

12. set_expected_rtp_rtcp
-process_sdp
--process_invite_response
---sip_handler.response
----process_sip_response
-----process_sip_msg
------sip_help_{tcp, udp}
-----nf_conntrack_helper.help
------nf_hook()
--process_update_response
---sip_handler.response
----process_sip_response
-----process_sip_msg
------sip_help_{tcp, udp}
-----nf_conntrack_helper.help
------nf_hook()
--process_prack_response
---sip_handler.response
----process_sip_response
-----process_sip_msg
------sip_help_{tcp, udp}
-----nf_conntrack_helper.help
------nf_hook()
--process_invite_request
---sip_handler.response
----process_sip_response
-----process_sip_msg
------sip_help_{tcp, udp}
-----nf_conntrack_helper.help
------nf_hook()
--sip_handler.request
---process_sip_request
----process_sip_msg
----sip_help_{tcp, udp}
-----nf_conntrack_helper.help
------nf_hook()

13. ctnl_timeout_find_get
-nf_ct_timeout_find_get_hook

14. tcpmss_reverse_mtu
-tcpmss_mangle_packet
--tcpmss_tg{4, 6}
---xt_target.target
----nf_hook()

15. tproxy_laddr4
-tproxy_tg4
--tproxy_tg4_{v0, v1}
---xt_target.target
----nf_hook()

16. match_lookup_rt6
-match_type6
--addrtype_mt6
---addrtype_mt_v1
---xt_match.match
----nf_hook()

17. check_hlist
-count_tree
--count_them
---connlimit_mt
---xt_match.match
----nf_hook()

18. hashlimit_mt_common
-hashlimit_mt_v1
--xt_match.match
---nf_hook()
-hashlimit_mt
--xt_match.match
---nf_hook()

19. xt_osf_match_packet
-xt_match.match
--nf_hook()

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netfilter/ipvs/ip_vs_core.c        | 12 ++++--------
 net/netfilter/ipvs/ip_vs_ctl.c         |  4 +---
 net/netfilter/ipvs/ip_vs_ftp.c         |  4 ++--
 net/netfilter/ipvs/ip_vs_proto_sctp.c  |  5 +----
 net/netfilter/ipvs/ip_vs_proto_tcp.c   |  6 +-----
 net/netfilter/ipvs/ip_vs_proto_udp.c   |  5 +----
 net/netfilter/ipvs/ip_vs_xmit.c        |  8 ++------
 net/netfilter/nf_conntrack_broadcast.c |  3 +--
 net/netfilter/nf_conntrack_pptp.c      |  3 +--
 net/netfilter/nf_conntrack_sip.c       |  4 +---
 net/netfilter/nfnetlink_cttimeout.c    |  3 +--
 net/netfilter/xt_TCPMSS.c              |  3 +--
 net/netfilter/xt_TPROXY.c              |  3 +--
 net/netfilter/xt_addrtype.c            |  3 +--
 net/netfilter/xt_connlimit.c           |  3 ---
 net/netfilter/xt_hashlimit.c           |  9 +++++----
 net/netfilter/xt_osf.c                 |  3 +--
 17 files changed, 25 insertions(+), 56 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index d2d7bdf..cc4ddb9 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -125,14 +125,13 @@ ip_vs_in_stats(struct ip_vs_conn *cp, struct sk_buff *skb)
 		s->cnt.inbytes += skb->len;
 		u64_stats_update_end(&s->syncp);
 
-		rcu_read_lock();
+		/* rcu_read_lock()ed by nf_hook */
 		svc = rcu_dereference(dest->svc);
 		s = this_cpu_ptr(svc->stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
 		s->cnt.inpkts++;
 		s->cnt.inbytes += skb->len;
 		u64_stats_update_end(&s->syncp);
-		rcu_read_unlock();
 
 		s = this_cpu_ptr(ipvs->tot_stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
@@ -159,14 +158,13 @@ ip_vs_out_stats(struct ip_vs_conn *cp, struct sk_buff *skb)
 		s->cnt.outbytes += skb->len;
 		u64_stats_update_end(&s->syncp);
 
-		rcu_read_lock();
+		/* rcu_read_lock()ed by nf_hook */
 		svc = rcu_dereference(dest->svc);
 		s = this_cpu_ptr(svc->stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
 		s->cnt.outpkts++;
 		s->cnt.outbytes += skb->len;
 		u64_stats_update_end(&s->syncp);
-		rcu_read_unlock();
 
 		s = this_cpu_ptr(ipvs->tot_stats.cpustats);
 		u64_stats_update_begin(&s->syncp);
@@ -1222,7 +1220,7 @@ static struct ip_vs_conn *__ip_vs_rs_conn_out(unsigned int hooknum,
 	if (!pptr)
 		return NULL;
 
-	rcu_read_lock();
+	/* rcu_read_lock()ed by nf_hook */
 	dest = ip_vs_find_real_service(ipvs, af, iph->protocol,
 				       &iph->saddr, pptr[0]);
 	if (dest) {
@@ -1237,7 +1235,6 @@ static struct ip_vs_conn *__ip_vs_rs_conn_out(unsigned int hooknum,
 						  pptr[0], pptr[1]);
 		}
 	}
-	rcu_read_unlock();
 
 	return cp;
 }
@@ -1680,11 +1677,10 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 			if (dest) {
 				struct ip_vs_dest_dst *dest_dst;
 
-				rcu_read_lock();
+				/* rcu_read_lock()ed by nf_hook */
 				dest_dst = rcu_dereference(dest->dest_dst);
 				if (dest_dst)
 					mtu = dst_mtu(dest_dst->dst_cache);
-				rcu_read_unlock();
 			}
 			if (mtu > 68 + sizeof(struct iphdr))
 				mtu -= sizeof(struct iphdr);
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 668d964..de1d5c9 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -550,18 +550,16 @@ bool ip_vs_has_real_service(struct netns_ipvs *ipvs, int af, __u16 protocol,
 	/* Check for "full" addressed entries */
 	hash = ip_vs_rs_hashkey(af, daddr, dport);
 
-	rcu_read_lock();
+	/* rcu_read_lock()ed by nf_hook */
 	hlist_for_each_entry_rcu(dest, &ipvs->rs_table[hash], d_list) {
 		if (dest->port == dport &&
 		    dest->af == af &&
 		    ip_vs_addr_equal(af, &dest->addr, daddr) &&
 		    (dest->protocol == protocol || dest->vfwmark)) {
 			/* HIT */
-			rcu_read_unlock();
 			return true;
 		}
 	}
-	rcu_read_unlock();
 
 	return false;
 }
diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index fb780be..ea0702d 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -268,14 +268,14 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 			 * Mangling can only fail under memory pressure,
 			 * hopefully it will succeed on the retransmitted
 			 * packet.
+			 *
+			 * rcu_read_lock()ed by nf_hook
 			 */
-			rcu_read_lock();
 			mangled = nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
 							   iph->ihl * 4,
 							   start - data,
 							   end - start,
 							   buf, buf_len);
-			rcu_read_unlock();
 			if (mangled) {
 				ip_vs_nfct_expect_related(skb, ct, n_cp,
 							  IPPROTO_TCP, 0, 0);
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index 56f8e4b..801b366 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -39,7 +39,7 @@ sctp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 		return 0;
 	}
 
-	rcu_read_lock();
+	/* rcu_read_lock()ed by nf_hook */
 	if (likely(!ip_vs_iph_inverse(iph)))
 		svc = ip_vs_service_find(ipvs, af, skb->mark, iph->protocol,
 					 &iph->daddr, ports[1]);
@@ -54,7 +54,6 @@ sctp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 			 * It seems that we are very loaded.
 			 * We have to drop this packet :(
 			 */
-			rcu_read_unlock();
 			*verdict = NF_DROP;
 			return 0;
 		}
@@ -68,11 +67,9 @@ sctp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 				*verdict = ip_vs_leave(svc, skb, pd, iph);
 			else
 				*verdict = NF_DROP;
-			rcu_read_unlock();
 			return 0;
 		}
 	}
-	rcu_read_unlock();
 	/* NF_ACCEPT */
 	return 1;
 }
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 12dc8d5..245513a 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -63,9 +63,8 @@ tcp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 	}
 
 	/* No !th->ack check to allow scheduling on SYN+ACK for Active FTP */
-	rcu_read_lock();
-
 	if (likely(!ip_vs_iph_inverse(iph)))
+		/* rcu_read_lock()ed by nf_hook */
 		svc = ip_vs_service_find(ipvs, af, skb->mark, iph->protocol,
 					 &iph->daddr, ports[1]);
 	else
@@ -80,7 +79,6 @@ tcp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 			 * It seems that we are very loaded.
 			 * We have to drop this packet :(
 			 */
-			rcu_read_unlock();
 			*verdict = NF_DROP;
 			return 0;
 		}
@@ -95,11 +93,9 @@ tcp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 				*verdict = ip_vs_leave(svc, skb, pd, iph);
 			else
 				*verdict = NF_DROP;
-			rcu_read_unlock();
 			return 0;
 		}
 	}
-	rcu_read_unlock();
 	/* NF_ACCEPT */
 	return 1;
 }
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index e494e9a..563b148 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -53,7 +53,7 @@ udp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 		return 0;
 	}
 
-	rcu_read_lock();
+	/* rcu_read_lock()ed by nf_hook */
 	if (likely(!ip_vs_iph_inverse(iph)))
 		svc = ip_vs_service_find(ipvs, af, skb->mark, iph->protocol,
 					 &iph->daddr, ports[1]);
@@ -69,7 +69,6 @@ udp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 			 * It seems that we are very loaded.
 			 * We have to drop this packet :(
 			 */
-			rcu_read_unlock();
 			*verdict = NF_DROP;
 			return 0;
 		}
@@ -84,11 +83,9 @@ udp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
 				*verdict = ip_vs_leave(svc, skb, pd, iph);
 			else
 				*verdict = NF_DROP;
-			rcu_read_unlock();
 			return 0;
 		}
 	}
-	rcu_read_unlock();
 	/* NF_ACCEPT */
 	return 1;
 }
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 2eab1e0..56588a2 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -1322,7 +1322,7 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	rt_mode = (hooknum != NF_INET_FORWARD) ?
 		  IP_VS_RT_MODE_LOCAL | IP_VS_RT_MODE_NON_LOCAL |
 		  IP_VS_RT_MODE_RDR : IP_VS_RT_MODE_NON_LOCAL;
-	rcu_read_lock();
+	/* rcu_read_lock()ed by nf_hook */
 	local = __ip_vs_get_out_rt(cp->ipvs, cp->af, skb, cp->dest, cp->daddr.ip, rt_mode,
 				   NULL, iph);
 	if (local < 0)
@@ -1368,12 +1368,10 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	skb->ignore_df = 1;
 
 	rc = ip_vs_nat_send_or_cont(NFPROTO_IPV4, skb, cp, local);
-	rcu_read_unlock();
 	goto out;
 
   tx_error:
 	kfree_skb(skb);
-	rcu_read_unlock();
 	rc = NF_STOLEN;
   out:
 	LeaveFunction(10);
@@ -1414,7 +1412,7 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	rt_mode = (hooknum != NF_INET_FORWARD) ?
 		  IP_VS_RT_MODE_LOCAL | IP_VS_RT_MODE_NON_LOCAL |
 		  IP_VS_RT_MODE_RDR : IP_VS_RT_MODE_NON_LOCAL;
-	rcu_read_lock();
+	/* rcu_read_lock()ed by nf_hook */
 	local = __ip_vs_get_out_rt_v6(cp->ipvs, cp->af, skb, cp->dest,
 				      &cp->daddr.in6, NULL, ipvsh, 0, rt_mode);
 	if (local < 0)
@@ -1460,12 +1458,10 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	skb->ignore_df = 1;
 
 	rc = ip_vs_nat_send_or_cont(NFPROTO_IPV6, skb, cp, local);
-	rcu_read_unlock();
 	goto out;
 
 tx_error:
 	kfree_skb(skb);
-	rcu_read_unlock();
 	rc = NF_STOLEN;
 out:
 	LeaveFunction(10);
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 4e99cca..276fb27 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -40,7 +40,7 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 	if (CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL)
 		goto out;
 
-	rcu_read_lock();
+	/* rcu_read_lock()ed by nf_hook */
 	in_dev = __in_dev_get_rcu(rt->dst.dev);
 	if (in_dev != NULL) {
 		for_primary_ifa(in_dev) {
@@ -50,7 +50,6 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 			}
 		} endfor_ifa(in_dev);
 	}
-	rcu_read_unlock();
 
 	if (mask == 0)
 		goto out;
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 6959e93..7041e1b 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -113,7 +113,7 @@ static void pptp_expectfn(struct nf_conn *ct,
 	/* Can you see how rusty this code is, compared with the pre-2.6.11
 	 * one? That's what happened to my shiny newnat of 2002 ;( -HW */
 
-	rcu_read_lock();
+	/* rcu_read_lock()ed by nf_hook */
 	nf_nat_pptp_expectfn = rcu_dereference(nf_nat_pptp_hook_expectfn);
 	if (nf_nat_pptp_expectfn && ct->master->status & IPS_NAT_MASK)
 		nf_nat_pptp_expectfn(ct, exp);
@@ -136,7 +136,6 @@ static void pptp_expectfn(struct nf_conn *ct,
 			pr_debug("not found\n");
 		}
 	}
-	rcu_read_unlock();
 }
 
 static int destroy_sibling_or_exp(struct net *net, struct nf_conn *ct,
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index d38af42..78687fc 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -884,7 +884,6 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 	tuple.dst.u3		= *daddr;
 	tuple.dst.u.udp.port	= port;
 
-	rcu_read_lock();
 	do {
 		exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &tuple);
 
@@ -911,6 +910,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 	rtcp_port = htons(base_port + 1);
 
 	if (direct_rtp) {
+		/* rcu_read_lock()ed by nf_hook */
 		hooks = rcu_dereference(nf_nat_sip_hooks);
 		if (hooks &&
 		    !hooks->sdp_port(skb, protoff, dataoff, dptr, datalen,
@@ -919,7 +919,6 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 	}
 
 	if (skip_expect) {
-		rcu_read_unlock();
 		return NF_ACCEPT;
 	}
 
@@ -952,7 +951,6 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 err2:
 	nf_ct_expect_put(rtp_exp);
 err1:
-	rcu_read_unlock();
 	return ret;
 }
 
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index a3e7bb5..87d751a 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -524,12 +524,12 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 }
 
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+/* rcu_read_lock()ed by caller */
 static struct ctnl_timeout *
 ctnl_timeout_find_get(struct net *net, const char *name)
 {
 	struct ctnl_timeout *timeout, *matching = NULL;
 
-	rcu_read_lock();
 	list_for_each_entry_rcu(timeout, &net->nfct_timeout_list, head) {
 		if (strncmp(timeout->name, name, CTNL_TIMEOUT_NAME_MAX) != 0)
 			continue;
@@ -545,7 +545,6 @@ ctnl_timeout_find_get(struct net *net, const char *name)
 		break;
 	}
 err:
-	rcu_read_unlock();
 	return matching;
 }
 
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index c64aca6..9dc155f 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -62,11 +62,10 @@ static u_int32_t tcpmss_reverse_mtu(struct net *net,
 		memset(fl6, 0, sizeof(*fl6));
 		fl6->daddr = ipv6_hdr(skb)->saddr;
 	}
-	rcu_read_lock();
+	/* rcu_read_lock()ed by nf_hook */
 	ai = nf_get_afinfo(family);
 	if (ai != NULL)
 		ai->route(net, (struct dst_entry **)&rt, &fl, false);
-	rcu_read_unlock();
 
 	if (rt != NULL) {
 		mtu = dst_mtu(&rt->dst);
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index df7f1df..1790773 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -70,13 +70,12 @@ tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
 		return user_laddr;
 
 	laddr = 0;
-	rcu_read_lock();
+	/* rcu_read_lock()ed by nf_hook */
 	indev = __in_dev_get_rcu(skb->dev);
 	for_primary_ifa(indev) {
 		laddr = ifa->ifa_local;
 		break;
 	} endfor_ifa(indev);
-	rcu_read_unlock();
 
 	return laddr ? laddr : daddr;
 }
diff --git a/net/netfilter/xt_addrtype.c b/net/netfilter/xt_addrtype.c
index e329dab..cec7e76 100644
--- a/net/netfilter/xt_addrtype.c
+++ b/net/netfilter/xt_addrtype.c
@@ -47,8 +47,8 @@ static u32 match_lookup_rt6(struct net *net, const struct net_device *dev,
 	if (dev)
 		flow.flowi6_oif = dev->ifindex;
 
-	rcu_read_lock();
 
+	/* rcu_read_lock()ed by nf_hook */
 	afinfo = nf_get_afinfo(NFPROTO_IPV6);
 	if (afinfo != NULL) {
 		const struct nf_ipv6_ops *v6ops;
@@ -63,7 +63,6 @@ static u32 match_lookup_rt6(struct net *net, const struct net_device *dev,
 	} else {
 		route_err = 1;
 	}
-	rcu_read_unlock();
 
 	if (route_err)
 		return XT_ADDRTYPE_UNREACHABLE;
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index b8fd4ab..97589b8 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -144,7 +144,6 @@ static unsigned int check_hlist(struct net *net,
 	unsigned int length = 0;
 
 	*addit = true;
-	rcu_read_lock();
 
 	/* check the saved connections */
 	hlist_for_each_entry_safe(conn, n, head, node) {
@@ -179,8 +178,6 @@ static unsigned int check_hlist(struct net *net,
 		length++;
 	}
 
-	rcu_read_unlock();
-
 	return length;
 }
 
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 762e187..8ffe05e 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -659,12 +659,13 @@ hashlimit_mt_common(const struct sk_buff *skb, struct xt_action_param *par,
 	if (hashlimit_init_dst(hinfo, &dst, skb, par->thoff) < 0)
 		goto hotdrop;
 
-	rcu_read_lock_bh();
+	local_bh_disable();
+	/* rcu_read_lock()ed by nf_hook */
 	dh = dsthash_find(hinfo, &dst);
 	if (dh == NULL) {
 		dh = dsthash_alloc_init(hinfo, &dst, &race);
 		if (dh == NULL) {
-			rcu_read_unlock_bh();
+			local_bh_enable();
 			goto hotdrop;
 		} else if (race) {
 			/* Already got an entry, update expiration timeout */
@@ -689,12 +690,12 @@ hashlimit_mt_common(const struct sk_buff *skb, struct xt_action_param *par,
 		/* below the limit */
 		dh->rateinfo.credit -= cost;
 		spin_unlock(&dh->lock);
-		rcu_read_unlock_bh();
+		local_bh_enable();
 		return !(cfg->mode & XT_HASHLIMIT_INVERT);
 	}
 
 	spin_unlock(&dh->lock);
-	rcu_read_unlock_bh();
+	local_bh_enable();
 	/* default match is underlimit - so over the limit, we need to invert */
 	return cfg->mode & XT_HASHLIMIT_INVERT;
 
diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index c05fefc..f4c48b51 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -224,7 +224,7 @@ xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
 				sizeof(struct tcphdr), optsize, opts);
 	}
 
-	rcu_read_lock();
+	/* rcu_read_lock()ed by nf_hook */
 	list_for_each_entry_rcu(kf, &xt_osf_fingers[df], finger_entry) {
 		int foptsize, optnum;
 
@@ -338,7 +338,6 @@ xt_osf_match_packet(const struct sk_buff *skb, struct xt_action_param *p)
 		    info->loglevel == XT_OSF_LOGLEVEL_FIRST)
 			break;
 	}
-	rcu_read_unlock();
 
 	if (!fcount && (info->flags & XT_OSF_LOG))
 		nf_log_packet(net, xt_family(p), xt_hooknum(p), skb, xt_in(p),
-- 
2.9.3

