From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] build: make use of library dependencies
Date: Sun,  5 Jul 2009 18:08:46 +0200
Message-ID: <1246810126-23428-3-git-send-email-jengelh@medozas.de>
References: <1246810126-23428-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: tgraf@suug.ch
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48991 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZGEQIp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:08:45 -0400
In-Reply-To: <1246810126-23428-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 lib/Makefile.am |    3 +++
 src/Makefile.am |   50 +++++++++++++++++++++++++-------------------------
 2 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/lib/Makefile.am b/lib/Makefile.am
index 118a077..4156f52 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -11,10 +11,12 @@ libnl_la_SOURCES = \
 	error.c handlers.c msg.c nl.c object.c socket.c utils.c
 
 libnl_genl_la_LDFLAGS = -version-info 2:0:0
+libnl_genl_la_LIBADD  = libnl.la
 libnl_genl_la_SOURCES = \
 	genl/ctrl.c genl/family.c genl/genl.c genl/mngt.c
 
 libnl_nf_la_LDFLAGS = -version-info 2:0:0
+libnl_nf_la_LIBADD  = libnl-route.la
 libnl_nf_la_SOURCES = \
 	netfilter/ct.c netfilter/ct_obj.c netfilter/log.c \
 	netfilter/log_msg.c netfilter/log_msg_obj.c netfilter/log_obj.c \
@@ -22,6 +24,7 @@ libnl_nf_la_SOURCES = \
 	netfilter/queue_msg.c netfilter/queue_msg_obj.c netfilter/queue_obj.c
 
 libnl_route_la_LDFLAGS = -version-info 2:0:0
+libnl_route_la_LIBADD  = libnl.la
 libnl_route_la_SOURCES = \
 	route/addr.c route/class.c route/class_api.c route/class_obj.c \
 	route/classifier.c route/cls_api.c route/cls_obj.c route/link.c \
diff --git a/src/Makefile.am b/src/Makefile.am
index 9f52cd6..96dc52b 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -20,67 +20,67 @@ noinst_PROGRAMS = \
 rtnl_utils_c = rtnl-utils.c utils.c
 
 genl_ctrl_list_SOURCES = genl-ctrl-list.c ctrl-utils.c utils.c
-genl_ctrl_list_LDADD = -lnl -lnl-genl
+genl_ctrl_list_LDADD = -lnl-genl
 
 nf_ct_list_SOURCES = nf-ct-list.c ct-utils.c utils.c
-nf_ct_list_LDADD = -lnl -lnl-nf -lnl-route
+nf_ct_list_LDADD = -lnl-nf
 nf_log_SOURCES = nf-log.c log-utils.c ${rtnl_utils_c}
-nf_log_LDADD = -lnl -lnl-nf -lnl-route
+nf_log_LDADD = -lnl-nf
 nf_queue_SOURCES = nf-queue.c queue-utils.c ${rtnl_utils_c}
-nf_queue_LDADD = -lnl -lnl-nf -lnl-route
+nf_queue_LDADD = -lnl-nf
 
 addr_c = addr-utils.c ${rtnl_utils_c}
 nl_addr_add_SOURCES = nl-addr-add.c ${addr_c}
-nl_addr_add_LDADD = -lnl -lnl-route
+nl_addr_add_LDADD = -lnl-route
 nl_addr_delete_SOURCES = nl-addr-delete.c ${addr_c}
-nl_addr_delete_LDADD = -lnl -lnl-route
+nl_addr_delete_LDADD = -lnl-route
 nl_addr_list_SOURCES = nl-addr-list.c ${addr_c}
-nl_addr_list_LDADD = -lnl -lnl-route
+nl_addr_list_LDADD = -lnl-route
 
 link_c = link-utils.c ${rtnl_utils_c}
 nl_link_list_SOURCES = nl-link-list.c ${link_c}
-nl_link_list_LDADD = -lnl -lnl-route
+nl_link_list_LDADD = -lnl-route
 nl_link_set_SOURCES = nl-link-set.c ${link_c}
-nl_link_set_LDADD = -lnl -lnl-route
+nl_link_set_LDADD = -lnl-route
 nl_link_stats_SOURCES = nl-link-stats.c ${link_c}
-nl_link_stats_LDADD = -lnl -lnl-route
+nl_link_stats_LDADD = -lnl-route
 nl_link_ifindex2name_SOURCES = nl-link-ifindex2name.c ${rtnl_utils_c}
-nl_link_ifindex2name_LDADD = -lnl -lnl-route
+nl_link_ifindex2name_LDADD = -lnl-route
 nl_link_name2ifindex_SOURCES = nl-link-name2ifindex.c ${rtnl_utils_c}
-nl_link_name2ifindex_LDADD = -lnl -lnl-route
+nl_link_name2ifindex_LDADD = -lnl-route
 
 nl_monitor_SOURCES = nl-monitor.c ${rtnl_utils_c}
-nl_monitor_LDADD = -lnl -lnl-route
+nl_monitor_LDADD = -lnl-route
 
 neigh_c = neigh-utils.c ${rtnl_utils_c}
 nl_neigh_add_SOURCES = nl-neigh-add.c ${neigh_c}
-nl_neigh_add_LDADD = -lnl -lnl-route
+nl_neigh_add_LDADD = -lnl-route
 nl_neigh_delete_SOURCES = nl-neigh-delete.c ${neigh_c}
-nl_neigh_delete_LDADD = -lnl -lnl-route
+nl_neigh_delete_LDADD = -lnl-route
 nl_neigh_list_SOURCES = nl-neigh-list.c ${neigh_c}
-nl_neigh_list_LDADD = -lnl -lnl-route
+nl_neigh_list_LDADD = -lnl-route
 
 nl_neightbl_list_SOURCES = nl-neightbl-list.c ${rtnl_utils_c}
-nl_neightbl_list_LDADD = -lnl -lnl-route
+nl_neightbl_list_LDADD = -lnl-route
 
 qdisc_c = qdisc-utils.c ${rtnl_utils_c}
 nl_qdisc_delete_SOURCES = nl-qdisc-delete.c ${qdisc_c}
-nl_qdisc_delete_LDADD = -lnl -lnl-route
+nl_qdisc_delete_LDADD = -lnl-route
 nl_qdisc_list_SOURCES = nl-qdisc-list.c ${qdisc_c}
-nl_qdisc_list_LDADD = -lnl -lnl-route
+nl_qdisc_list_LDADD = -lnl-route
 
 route_c = route-utils.c ${rtnl_utils_c}
 nl_route_add_SOURCES = nl-route-add.c ${route_c}
-nl_route_add_LDADD = -lnl -lnl-route
+nl_route_add_LDADD = -lnl-route
 nl_route_delete_SOURCES = nl-route-delete.c ${route_c}
-nl_route_delete_LDADD = -lnl -lnl-route
+nl_route_delete_LDADD = -lnl-route
 nl_route_get_SOURCES = nl-route-get.c ${route_c}
-nl_route_get_LDADD = -lnl -lnl-route
+nl_route_get_LDADD = -lnl-route
 nl_route_list_SOURCES = nl-route-list.c ${route_c}
-nl_route_list_LDADD = -lnl -lnl-route
+nl_route_list_LDADD = -lnl-route
 
 nl_rule_list_SOURCES = nl-rule-list.c rule-utils.c ${rtnl_utils_c}
-nl_rule_list_LDADD = -lnl -lnl-route
+nl_rule_list_LDADD = -lnl-route
 
 nl_tctree_list_SOURCES = nl-tctree-list.c ${rtnl_utils_c}
-nl_tctree_list_LDADD = -lnl -lnl-route
+nl_tctree_list_LDADD = -lnl-route
-- 
1.6.3.3

