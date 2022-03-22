Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81880C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Mar 2022 14:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237693AbiCVO1z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Mar 2022 10:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241358AbiCVO1K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Mar 2022 10:27:10 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFD124BF0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2022 07:25:42 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w4so21842100edc.7
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2022 07:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JdDSX3rDhQBuZROOIbffN4jnyj6w4Eg5vz9lMsqfyyE=;
        b=TuwbuQcR9IQu0H/OCyIN+KHiusHn1SOjgj/tk8ITLm55iDoXFi7vEQZKLeH4WPVrkQ
         EbC2Qhvr3m55PV0CvWG3HAzkoe1zFrBRusJto8wNyIfRM0Dn0gRkYC0a5J9hkpL/aZ8g
         02LMD+ckqgNm8pZPoK5HsZMRg1yBnGohO59xw12s/KPpKs+S+ebBN/Xdg+nN3HAOZYyc
         YdvLvL+9RkMYbUw3C464kA1ttvSSaocw38crzftswW0ElhWg6nHwDgUYzATtQKaeDjhv
         5/q5wl5qsEcHpnraPVYqfDxS4LChfiEtD7WbgPjen+Uv2BWUFUUJ9ImvnoY2Z7htX6O+
         Zfzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JdDSX3rDhQBuZROOIbffN4jnyj6w4Eg5vz9lMsqfyyE=;
        b=x1yJyWv0EoQV0bwsRTlCCv1Bci3t+JWuaQQnxUBd+LQIKHj6u2eXyj3szX2rNnV48r
         11R065d/cxhOdAjrw0JZ7N0ZUSmlhgc1fe+hXlWFNXIC0gyLs1uk+ggR+za5IEUwFOlf
         YOwi7bYM4s8xW3VgXap1GzifN0XxofQwyYc6QelYHnXrjq4J7HT+X0cGla+YViuQ3cYN
         X7GxsRyTeQFEfp+D+ya6FfkxJE12QM7q4ElB4GOkvK4vEEh4JWdmveCpxq1aKp1nIifs
         Du8rp7+DLfLUfnrKeI3HUQoaXpY3CoISQnNumfssyHHCVRPU1IK0HkNh7XVwJ08AkiNE
         ntxQ==
X-Gm-Message-State: AOAM531mf+nJafYCfIbY5Ax+sau974wLNz9ZStwwxqwPGtMafmSt2Wx5
        FSTaKii1ah0kCVmmvBi9F4yR+/G1WFhICQ==
X-Google-Smtp-Source: ABdhPJwU3+31DI24ZlVp8HnytbDgrcpPOfsZitk8BspFrlpqszJDrdRSPjFCz8omU5RTdTKQA5+2Lg==
X-Received: by 2002:a05:6402:5106:b0:419:45cd:7ab0 with SMTP id m6-20020a056402510600b0041945cd7ab0mr9264712edd.116.1647959140466;
        Tue, 22 Mar 2022 07:25:40 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bd42e.dynamic.kabel-deutschland.de. [95.91.212.46])
        by smtp.gmail.com with ESMTPSA id k12-20020aa7c38c000000b0041939d9ccd0sm3351465edq.81.2022.03.22.07.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:25:39 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 1/1] conntrack: use same mnl socket for bulk operations
Date:   Tue, 22 Mar 2022 15:25:24 +0100
Message-Id: <20220322142524.35109-2-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220322142524.35109-1-mikhail.sennikovskii@ionos.com>
References: <20220322142524.35109-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For bulk ct entry loads (with -R option) reusing the same mnl socket
for all entries results in >1.5-time reduction of entries creation
time. This becomes signifficant when loading tens of thouthand of
entries.
E.g. in the tests performed with the tests/conntrack/bulk-load-stress.sh
the time used for loading of 131070 ct entries (2 * 0xffff)
was reduced from 1.06s to 0.7s when the same mnl socket was used.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 70 +++++++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 31 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 679a1d2..b17ea5d 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -71,6 +71,7 @@
 struct nfct_mnl_socket {
 	struct mnl_socket	*mnl;
 	uint32_t		portid;
+	uint32_t		events;
 };
 
 static struct nfct_mnl_socket _sock;
@@ -2438,13 +2439,27 @@ static int nfct_mnl_socket_open(struct nfct_mnl_socket *socket,
 	}
 	if (mnl_socket_bind(socket->mnl, events, MNL_SOCKET_AUTOPID) < 0) {
 		perror("mnl_socket_bind");
+		mnl_socket_close(socket->mnl);
+		memset(socket, 0, sizeof(*socket));
 		return -1;
 	}
 	socket->portid = mnl_socket_get_portid(socket->mnl);
+	socket->events = events;
 
 	return 0;
 }
 
+static int nfct_mnl_socket_check_open(struct nfct_mnl_socket *socket,
+				       unsigned int events)
+{
+	if (socket->mnl != NULL) {
+		assert(events == socket->events);
+		return 0;
+	}
+
+	return nfct_mnl_socket_open(socket, events);
+}
+
 static struct nlmsghdr *
 nfct_mnl_nlmsghdr_put(char *buf, uint16_t subsys, uint16_t type,
 		      uint16_t flags, uint8_t family)
@@ -2470,6 +2485,14 @@ static void nfct_mnl_socket_close(const struct nfct_mnl_socket *sock)
 	mnl_socket_close(sock->mnl);
 }
 
+static void nfct_mnl_socket_check_close(struct nfct_mnl_socket *sock)
+{
+	if (sock->mnl) {
+		nfct_mnl_socket_close(sock);
+		memset(sock, 0, sizeof(*sock));
+	}
+}
+
 static int __nfct_mnl_dump(struct nfct_mnl_socket *sock,
 			   const struct nlmsghdr *nlh, mnl_cb_t cb, void *data)
 {
@@ -3276,20 +3299,18 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 	switch(cmd->command) {
 	case CT_LIST:
-		if (nfct_mnl_socket_open(sock, 0) < 0)
+		if (nfct_mnl_socket_check_open(sock, 0) < 0)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		if (cmd->type == CT_TABLE_DYING) {
 			res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_DYING,
 					    mnl_nfct_dump_cb, cmd, NULL);
-			nfct_mnl_socket_close(sock);
 			break;
 		} else if (cmd->type == CT_TABLE_UNCONFIRMED) {
 			res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_UNCONFIRMED,
 					    mnl_nfct_dump_cb, cmd, NULL);
-			nfct_mnl_socket_close(sock);
 			break;
 		}
 
@@ -3334,7 +3355,6 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			fflush(stdout);
 		}
 
-		nfct_mnl_socket_close(sock);
 		break;
 
 	case EXP_LIST:
@@ -3365,7 +3385,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			nfct_set_attr(cmd->tmpl.ct, ATTR_CONNLABELS,
 					xnfct_bitmask_clone(cmd->tmpl.label_modify));
 
-		res = nfct_mnl_socket_open(sock, 0);
+		res = nfct_mnl_socket_check_open(sock, 0);
 		if (res < 0)
 			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
 
@@ -3376,7 +3396,6 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (res >= 0)
 			counter++;
 
-		nfct_mnl_socket_close(sock);
 		break;
 
 	case EXP_CREATE:
@@ -3393,8 +3412,8 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case CT_UPDATE:
-		if (nfct_mnl_socket_open(sock, 0) < 0 ||
-		    nfct_mnl_socket_open(modifier_sock, 0) < 0)
+		if (nfct_mnl_socket_check_open(sock, 0) < 0 ||
+		    nfct_mnl_socket_check_open(modifier_sock, 0) < 0)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfct_filter_init(cmd);
@@ -3402,13 +3421,11 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 				    IPCTNL_MSG_CT_GET, mnl_nfct_update_cb,
 				    cmd, NULL);
 
-		nfct_mnl_socket_close(modifier_sock);
-		nfct_mnl_socket_close(sock);
 		break;
 
 	case CT_DELETE:
-		if (nfct_mnl_socket_open(sock, 0) < 0 ||
-		    nfct_mnl_socket_open(modifier_sock, 0) < 0)
+		if (nfct_mnl_socket_check_open(sock, 0) < 0 ||
+		    nfct_mnl_socket_check_open(modifier_sock, 0) < 0)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfct_filter_init(cmd);
@@ -3432,8 +3449,6 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 		nfct_filter_dump_destroy(filter_dump);
 
-		nfct_mnl_socket_close(modifier_sock);
-		nfct_mnl_socket_close(sock);
 		break;
 
 	case EXP_DELETE:
@@ -3470,14 +3485,13 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case CT_FLUSH:
-		res = nfct_mnl_socket_open(sock, 0);
+		res = nfct_mnl_socket_check_open(sock, 0);
 		if (res < 0)
 			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
 
 		res = nfct_mnl_request(sock, NFNL_SUBSYS_CTNETLINK, cmd->family,
 				       IPCTNL_MSG_CT_DELETE, NLM_F_ACK, NULL, NULL);
 
-		nfct_mnl_socket_close(sock);
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"connection tracking table has been emptied.\n");
 		break;
@@ -3503,9 +3517,9 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			if (cmd->event_mask & CT_EVENT_F_DEL)
 				nl_events |= NF_NETLINK_CONNTRACK_DESTROY;
 
-			res = nfct_mnl_socket_open(sock, nl_events);
+			res = nfct_mnl_socket_check_open(sock, nl_events);
 		} else {
-			res = nfct_mnl_socket_open(sock,
+			res = nfct_mnl_socket_check_open(sock,
 						   NF_NETLINK_CONNTRACK_NEW |
 						   NF_NETLINK_CONNTRACK_UPDATE |
 						   NF_NETLINK_CONNTRACK_DESTROY);
@@ -3563,7 +3577,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			}
 			res = mnl_cb_run(buf, res, 0, 0, event_cb, cmd);
 		}
-		mnl_socket_close(sock->mnl);
+		nfct_mnl_socket_check_close(sock);
 		break;
 
 	case EXP_EVENT:
@@ -3597,15 +3611,12 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open(sock, 0) < 0)
+		if (nfct_mnl_socket_check_open(sock, 0) < 0)
 			goto try_proc_count;
 
 		res = nfct_mnl_request(sock, NFNL_SUBSYS_CTNETLINK, AF_UNSPEC,
 				       IPCTNL_MSG_CT_GET_STATS, 0,
 				       nfct_global_stats_cb, NULL);
-
-		nfct_mnl_socket_close(sock);
-
 		/* don't look at /proc, we got the information via ctnetlink */
 		if (res >= 0)
 			break;
@@ -3642,15 +3653,12 @@ try_proc_count:
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open(sock, 0) < 0)
+		if (nfct_mnl_socket_check_open(sock, 0) < 0)
 			goto try_proc;
 
 		res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
 				    IPCTNL_MSG_CT_GET_STATS_CPU,
 				    nfct_stats_cb, NULL, NULL);
-
-		nfct_mnl_socket_close(sock);
-
 		/* don't look at /proc, we got the information via ctnetlink */
 		if (res >= 0)
 			break;
@@ -3661,15 +3669,12 @@ try_proc_count:
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open(sock, 0) < 0)
+		if (nfct_mnl_socket_check_open(sock, 0) < 0)
 			goto try_proc;
 
 		res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK_EXP,
 				    IPCTNL_MSG_EXP_GET_STATS_CPU,
 				    nfexp_stats_cb, NULL, NULL);
-
-		nfct_mnl_socket_close(sock);
-
 		/* don't look at /proc, we got the information via ctnetlink */
 		if (res >= 0)
 			break;
@@ -3931,5 +3936,8 @@ int main(int argc, char *argv[])
 		free(cmd);
 	}
 
+	nfct_mnl_socket_check_close(&_modifier_sock);
+	nfct_mnl_socket_check_close(&_sock);
+
 	return res < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
 }
-- 
2.25.1

