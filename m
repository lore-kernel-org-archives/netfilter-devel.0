Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F69EC0650E
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 19:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C873206A3
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 19:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfGAT0k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 15:26:40 -0400
Received: from ja.ssi.bg ([178.16.129.10]:36588 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726076AbfGAT0k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 15:26:40 -0400
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x61JQ2RT005029;
        Mon, 1 Jul 2019 22:26:02 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.15.2/8.15.2/Submit) id x61JQ1Vg005027;
        Mon, 1 Jul 2019 22:26:01 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        lvs-users@linuxvirtualserver.org, netfilter-devel@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@yandex-team.ru>
Subject: [PATCH] ipvsadm: allow tunneling with gre encapsulation
Date:   Mon,  1 Jul 2019 22:25:37 +0300
Message-Id: <20190701192537.4991-1-ja@ssi.bg>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add support for real server tunnels with GRE encapsulation:
--tun-type gre [--tun-nocsum|--tun-csum]

Co-developed-by: Vadim Fedorenko <vfedorenko@yandex-team.ru>
Signed-off-by: Vadim Fedorenko <vfedorenko@yandex-team.ru>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 ipvsadm.8       | 19 ++++++++++++++-----
 ipvsadm.c       | 20 +++++++++++++++++++-
 libipvs/ip_vs.h |  1 +
 3 files changed, 34 insertions(+), 6 deletions(-)

	Jesper, this will follow the other patchset from 30-MAY-2019,
"Allow tunneling with gue encapsulation".

diff --git a/ipvsadm.8 b/ipvsadm.8
index 256718e..6b81fc7 100644
--- a/ipvsadm.8
+++ b/ipvsadm.8
@@ -342,7 +342,7 @@ the request sent to the virtual service.
 .ti +8
 .B --tun-type \fItun-type\fP
 .ti +16
-\fItun-type\fP is one of \fIipip\fP|\fIgue\fP.
+\fItun-type\fP is one of \fIipip\fP|\fIgue\fP|\fIgre\fP.
 The default value of \fItun-type\fP is \fIipip\fP.
 .sp
 .ti +8
@@ -354,14 +354,14 @@ Only valid for \fItun-type\fP \fIgue\fP.
 .ti +8
 .B --tun-nocsum
 .ti +16
-Specify that UDP checksums are disabled. This is the default.
-Only valid for \fItun-type\fP \fIgue\fP.
+Specify that tunnel checksums are disabled. This is the default.
+Only valid for \fItun-type\fP \fIgue\fP and \fIgre\fP.
 .sp
 .ti +8
 .B --tun-csum
 .ti +16
-Specify that UDP checksums are enabled.
-Only valid for \fItun-type\fP \fIgue\fP.
+Specify that tunnel checksums are enabled.
+Only valid for \fItun-type\fP \fIgue\fP and \fIgre\fP.
 .sp
 .ti +8
 .B --tun-remcsum
@@ -623,6 +623,15 @@ echo "
 -a -t 207.175.44.110:80 -r 192.168.10.5:80 -i --tun-type gue --tun-port 6079
 " | ipvsadm -R
 .fi
+.SH EXAMPLE 4 - Virtual Service with GRE Tunneling
+The following commands configure a Linux Director to use GRE
+encapsulation.
+.PP
+.nf
+ipvsadm -A -t 10.0.0.1:80 -s rr
+ipvsadm -a -t 10.0.0.1:80 -r 192.168.11.1:80 -i --tun-type gre \
+--tun-csum
+.fi
 .SH IPv6
 IPv6 addresses should be surrounded by square brackets ([ and ]).
 .PP
diff --git a/ipvsadm.c b/ipvsadm.c
index 2f103cd..7619740 100644
--- a/ipvsadm.c
+++ b/ipvsadm.c
@@ -297,6 +297,7 @@ static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 static const char * const tunnames[] = {
 	"ipip",
 	"gue",
+	"gre",
 };
 
 static const char * const tunflags[] = {
@@ -334,6 +335,7 @@ tunnel_types_v_options[IP_VS_CONN_F_TUNNEL_TYPE_MAX][NUMBER_OF_TUN_OPT] = {
 	/*  tprt nocs csum remc */
 /* ipip */ {'x', 'x', 'x', 'x'},
 /* gue */  {'+', '1', '1', '1'},
+/* gre */  {'x', '1', '1', 'x'},
 };
 
 /* printing format flags */
@@ -1335,6 +1337,8 @@ static int parse_tun_type(const char *tun_type)
 		type = IP_VS_CONN_F_TUNNEL_TYPE_IPIP;
 	else if (!strcmp(tun_type, "gue"))
 		type = IP_VS_CONN_F_TUNNEL_TYPE_GUE;
+	else if (!strcmp(tun_type, "gre"))
+		type = IP_VS_CONN_F_TUNNEL_TYPE_GRE;
 	else
 		type = -1;
 
@@ -1506,7 +1510,7 @@ static void usage_exit(const char *program, const int exit_status)
 		"  --gatewaying   -g                   gatewaying (direct routing) (default)\n"
 		"  --ipip         -i                   ipip encapsulation (tunneling)\n"
 		"  --masquerading -m                   masquerading (NAT)\n"
-		"  --tun-type      type                one of ipip|gue,\n"
+		"  --tun-type      type                one of ipip|gue|gre,\n"
 		"                                      the default tunnel type is %s.\n"
 		"  --tun-port      port                tunnel destination port\n"
 		"  --tun-nocsum                        tunnel encapsulation without checksum\n"
@@ -1795,6 +1799,11 @@ static inline char *fwd_tun_info(ipvs_dest_entry_t *e)
 				 tunnames[e->tun_type], ntohs(e->tun_port),
 				 tunflags[e->tun_flags]);
 			break;
+		case IP_VS_CONN_F_TUNNEL_TYPE_GRE:
+			snprintf(info, 16, "%s:%s",
+				 tunnames[e->tun_type],
+				 tunflags[e->tun_flags]);
+			break;
 		default:
 			free(info);
 			return NULL;
@@ -1896,6 +1905,15 @@ static inline void
 print_tunnel_rule(char *svc_name, char *dname, ipvs_dest_entry_t *e)
 {
 	switch (e->tun_type) {
+	case IP_VS_CONN_F_TUNNEL_TYPE_GRE:
+		printf("-a %s -r %s %s -w %d --tun-type %s %s\n",
+		       svc_name,
+		       dname,
+		       fwd_switch(e->conn_flags),
+		       e->weight,
+		       tunnames[e->tun_type],
+		       tun_flags_opts[e->tun_flags]);
+		break;
 	case IP_VS_CONN_F_TUNNEL_TYPE_GUE:
 		printf("-a %s -r %s %s -w %d --tun-type %s --tun-port %d %s\n",
 		       svc_name,
diff --git a/libipvs/ip_vs.h b/libipvs/ip_vs.h
index fa3770c..2670c23 100644
--- a/libipvs/ip_vs.h
+++ b/libipvs/ip_vs.h
@@ -111,6 +111,7 @@
 enum {
 	IP_VS_CONN_F_TUNNEL_TYPE_IPIP = 0,	/* IPIP */
 	IP_VS_CONN_F_TUNNEL_TYPE_GUE,		/* GUE */
+	IP_VS_CONN_F_TUNNEL_TYPE_GRE,		/* GRE */
 	IP_VS_CONN_F_TUNNEL_TYPE_MAX,
 };
 
-- 
2.21.0

