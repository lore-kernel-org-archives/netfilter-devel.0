Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1735DC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 17:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351896AbhLARhU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 12:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351972AbhLARga (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 12:36:30 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C137C061759
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 09:33:09 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v11so54002657wrw.10
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Dec 2021 09:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ew5BT+BshzHwi0ct5xBIsFHTBsxDnRESP/dYENOXMbo=;
        b=hBO8LoHcgbVWRpQCfiIEfGixEuxgOhEqhulEJIpl09fLjLNpLNibV+WsxHGp1ijivr
         TXxL5JebJgjwlPVrxrBcF7XHw14BFSA3UqSJ+FtT/pt3X07mCnCsWCJWFKK0m2kna8lX
         V2Y/kmIDXTEP0vmmLy+G+SQEAnGUJpAIioQRwAM4SrXGdkxNxIUxGUPrmmqO52Jtox6H
         jWX+YzZ6c+8soEIvhAPOIu8XeqmQRt7VDJbINMYe+T3YBRT/q2o2Oy9/FLL5+SCbGIvq
         wRWFPW8tc7ZgjvxkfKISroApZvrdKZ/Sgi/EjuFN0ed//q/zz6rJ0RimPXp8+pfjQUMk
         awqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ew5BT+BshzHwi0ct5xBIsFHTBsxDnRESP/dYENOXMbo=;
        b=b9L/1kZ5GsndJWdXVqp2vj7Xr5NPDgulCYrcXat6N9V1dbSReJ4+0WBBISgISYYkd9
         /s5ryq4V0zM5YMaKufAOd9JG9gALHiq43tW32BdMLdSE3RGucioDrY3x2g59GVqVRACb
         pU8csAjPXtdExbEFsa0LyRGWGBs+z1XjZlYMrpaKVr2L3xH6FYM4sCQpF/Wrfpzpqdz+
         aKNBDbHCOJTfwcj4flaVBWK939TjE7pabAwy2kDJzA93qIvq0zal7w03jKuf61c2kQml
         KRRR7lHeDLYXa0C83qYUgRjJ3dpJUN0uY2ggMqUSxnNutKxeyFo8xxAlRFZhOmrngXXx
         mHlg==
X-Gm-Message-State: AOAM530fnmIEir7w5sTp+Ye409r2r7TT8hbDEeqaACocd3jmea4fXC8l
        BXXiKiy7UY6X8c38t2dj7u/yVz9PH1eZbw==
X-Google-Smtp-Source: ABdhPJyLO4IYLEAIvpy17d4xM3SP63GgeNIeeKqGtPfJ/cEz/mLHDBqFhpMypAFzdTGttcF45dKXJA==
X-Received: by 2002:adf:eece:: with SMTP id a14mr8109407wrp.333.1638379986867;
        Wed, 01 Dec 2021 09:33:06 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf77c.dynamic.kabel-deutschland.de. [95.91.247.124])
        by smtp.gmail.com with ESMTPSA id r17sm1918291wmq.5.2021.12.01.09.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:33:06 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 3/6] conntrack: pass sock to nfct_mnl_xxx functions
Date:   Wed,  1 Dec 2021 18:32:50 +0100
Message-Id: <20211201173253.33432-4-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201173253.33432-1-mikhail.sennikovskii@ionos.com>
References: <20211201173253.33432-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In preparation for using multiple instances of mnl sockets
required for conntrack entries update and delete support.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 94 ++++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 40 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index f042d9d..0949f6a 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2399,18 +2399,19 @@ out_err:
 	return ret;
 }
 
-static int nfct_mnl_socket_open(unsigned int events)
+static int nfct_mnl_socket_open(struct nfct_mnl_socket *socket,
+		      unsigned int events)
 {
-	sock.mnl = mnl_socket_open(NETLINK_NETFILTER);
-	if (sock.mnl == NULL) {
+	socket->mnl = mnl_socket_open(NETLINK_NETFILTER);
+	if (socket->mnl == NULL) {
 		perror("mnl_socket_open");
 		return -1;
 	}
-	if (mnl_socket_bind(sock.mnl, events, MNL_SOCKET_AUTOPID) < 0) {
+	if (mnl_socket_bind(socket->mnl, events, MNL_SOCKET_AUTOPID) < 0) {
 		perror("mnl_socket_bind");
 		return -1;
 	}
-	sock.portid = mnl_socket_get_portid(sock.mnl);
+	socket->portid = mnl_socket_get_portid(socket->mnl);
 
 	return 0;
 }
@@ -2436,13 +2437,14 @@ nfct_mnl_nlmsghdr_put(char *buf, uint16_t subsys, uint16_t type,
 	return nlh;
 }
 
-static void nfct_mnl_socket_close(void)
+static void nfct_mnl_socket_close(struct nfct_mnl_socket *socket)
 {
-	mnl_socket_close(sock.mnl);
+	mnl_socket_close(socket->mnl);
 }
 
 static int
-nfct_mnl_call(uint16_t subsys, uint16_t type, uint16_t flags,
+nfct_mnl_call(struct nfct_mnl_socket *socket,
+	      uint16_t subsys, uint16_t type, uint16_t flags,
 	      const struct nf_conntrack *ct, uint8_t family,
 	      const struct nfct_filter_dump *filter_dump,
 	      mnl_cb_t cb, void* context)
@@ -2468,46 +2470,49 @@ nfct_mnl_call(uint16_t subsys, uint16_t type, uint16_t flags,
 	if (filter_dump)
 		nfct_nlmsg_build_filter(nlh, filter_dump);
 
-	res = mnl_socket_sendto(sock.mnl, nlh, nlh->nlmsg_len);
+	res = mnl_socket_sendto(socket->mnl, nlh, nlh->nlmsg_len);
 	if (res < 0)
 		return res;
 
-	res = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
+	res = mnl_socket_recvfrom(socket->mnl, buf, sizeof(buf));
 	while (res > 0) {
-		res = mnl_cb_run(buf, res, nlh->nlmsg_seq, sock.portid,
+		res = mnl_cb_run(buf, res, nlh->nlmsg_seq, socket->portid,
 				 cb, context);
 		if (res <= MNL_CB_STOP)
 			break;
 
-		res = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
+		res = mnl_socket_recvfrom(socket->mnl, buf, sizeof(buf));
 	}
 
 	return res;
 }
 
 static int
-nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
+nfct_mnl_dump(struct nfct_mnl_socket *socket,
+	      uint16_t subsys, uint16_t type, mnl_cb_t cb,
 	      struct ct_cmd *cmd, const struct nfct_filter_dump *filter_dump)
 {
-	return nfct_mnl_call(subsys, type, NLM_F_REQUEST|NLM_F_DUMP,
+	return nfct_mnl_call(socket, subsys, type, NLM_F_REQUEST|NLM_F_DUMP,
 		      NULL, cmd ? cmd->family : AF_UNSPEC,
 		      filter_dump,
 		      cb, cmd);
 }
 
 static int
-nfct_mnl_get(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
+nfct_mnl_get(struct nfct_mnl_socket *socket,
+	      uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
 {
-	return nfct_mnl_call(subsys, type, NLM_F_REQUEST|NLM_F_DUMP,
+	return nfct_mnl_call(socket, subsys, type, NLM_F_REQUEST|NLM_F_DUMP,
 		      NULL, family,
 		      NULL,
 		      cb, NULL);
 }
 
 static int
-nfct_mnl_create(uint16_t subsys, uint16_t type, const struct nf_conntrack *ct)
+nfct_mnl_create(struct nfct_mnl_socket *socket,
+	      uint16_t subsys, uint16_t type, const struct nf_conntrack *ct)
 {
-	return nfct_mnl_call(subsys, type,
+	return nfct_mnl_call(socket, subsys, type,
 		      NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK|NLM_F_EXCL,
 		      ct, 0,
 		      NULL,
@@ -3242,20 +3247,22 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 
 	switch(cmd->command) {
 	case CT_LIST:
-		if (nfct_mnl_socket_open(0) < 0)
+		if (nfct_mnl_socket_open(&sock, 0) < 0)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		if (cmd->type == CT_TABLE_DYING) {
-			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+			res = nfct_mnl_dump(&sock,
+					    NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_DYING,
 					    mnl_nfct_dump_cb, cmd, NULL);
-			nfct_mnl_socket_close();
+			nfct_mnl_socket_close(&sock);
 			break;
 		} else if (cmd->type == CT_TABLE_UNCONFIRMED) {
-			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+			res = nfct_mnl_dump(&sock,
+					    NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_UNCONFIRMED,
 					    mnl_nfct_dump_cb, cmd, NULL);
-			nfct_mnl_socket_close();
+			nfct_mnl_socket_close(&sock);
 			break;
 		}
 
@@ -3284,11 +3291,13 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 						  &cmd->tmpl.filter_status_kernel);
 		}
 		if (cmd->options & CT_OPT_ZERO) {
-			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+			res = nfct_mnl_dump(&sock,
+					    NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_CTRZERO,
 					    mnl_nfct_dump_cb, cmd, filter_dump);
 		} else {
-			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+			res = nfct_mnl_dump(&sock,
+					    NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET,
 					    mnl_nfct_dump_cb, cmd, filter_dump);
 		}
@@ -3300,7 +3309,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			fflush(stdout);
 		}
 
-		nfct_mnl_socket_close();
+		nfct_mnl_socket_close(&sock);
 		break;
 
 	case EXP_LIST:
@@ -3331,17 +3340,18 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			nfct_set_attr(cmd->tmpl.ct, ATTR_CONNLABELS,
 					xnfct_bitmask_clone(cmd->tmpl.label_modify));
 
-		res = nfct_mnl_socket_open(0);
+		res = nfct_mnl_socket_open(&sock, 0);
 		if (res < 0)
 			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
 
-		res = nfct_mnl_create(NFNL_SUBSYS_CTNETLINK,
+		res = nfct_mnl_create(&sock,
+							NFNL_SUBSYS_CTNETLINK,
 							IPCTNL_MSG_CT_NEW,
 							cmd->tmpl.ct);
 		if (res >= 0)
 			counter++;
 
-		nfct_mnl_socket_close();
+		nfct_mnl_socket_close(&sock);
 		break;
 
 	case EXP_CREATE:
@@ -3468,9 +3478,10 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			if (cmd->event_mask & CT_EVENT_F_DEL)
 				nl_events |= NF_NETLINK_CONNTRACK_DESTROY;
 
-			res = nfct_mnl_socket_open(nl_events);
+			res = nfct_mnl_socket_open(&sock, nl_events);
 		} else {
-			res = nfct_mnl_socket_open(NF_NETLINK_CONNTRACK_NEW |
+			res = nfct_mnl_socket_open(&sock,
+						   NF_NETLINK_CONNTRACK_NEW |
 						   NF_NETLINK_CONNTRACK_UPDATE |
 						   NF_NETLINK_CONNTRACK_DESTROY);
 		}
@@ -3561,14 +3572,15 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open(0) < 0)
+		if (nfct_mnl_socket_open(&sock, 0) < 0)
 			goto try_proc_count;
 
-		res = nfct_mnl_get(NFNL_SUBSYS_CTNETLINK,
+		res = nfct_mnl_get(&sock,
+				   NFNL_SUBSYS_CTNETLINK,
 				   IPCTNL_MSG_CT_GET_STATS,
 				   nfct_global_stats_cb, AF_UNSPEC);
 
-		nfct_mnl_socket_close();
+		nfct_mnl_socket_close(&sock);
 
 		/* don't look at /proc, we got the information via ctnetlink */
 		if (res >= 0)
@@ -3606,14 +3618,15 @@ try_proc_count:
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open(0) < 0)
+		if (nfct_mnl_socket_open(&sock, 0) < 0)
 			goto try_proc;
 
-		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+		res = nfct_mnl_dump(&sock,
+				    NFNL_SUBSYS_CTNETLINK,
 				    IPCTNL_MSG_CT_GET_STATS_CPU,
 				    nfct_stats_cb, NULL, NULL);
 
-		nfct_mnl_socket_close();
+		nfct_mnl_socket_close(&sock);
 
 		/* don't look at /proc, we got the information via ctnetlink */
 		if (res >= 0)
@@ -3625,14 +3638,15 @@ try_proc_count:
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open(0) < 0)
+		if (nfct_mnl_socket_open(&sock, 0) < 0)
 			goto try_proc;
 
-		res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK_EXP,
+		res = nfct_mnl_dump(&sock,
+				    NFNL_SUBSYS_CTNETLINK_EXP,
 				    IPCTNL_MSG_EXP_GET_STATS_CPU,
 				    nfexp_stats_cb, NULL, NULL);
 
-		nfct_mnl_socket_close();
+		nfct_mnl_socket_close(&sock);
 
 		/* don't look at /proc, we got the information via ctnetlink */
 		if (res >= 0)
-- 
2.25.1

