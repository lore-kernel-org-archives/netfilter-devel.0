Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F333BC43334
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jun 2022 16:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbiFBQez (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Jun 2022 12:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237124AbiFBQey (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Jun 2022 12:34:54 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661BF1E1764
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2022 09:34:53 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id fu3so9527015ejc.7
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Jun 2022 09:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L4oxgNzgU6MbSzhzI6I+WZEyCWEZeECXAaeL4a0SGw4=;
        b=G5mkw5pEwYFHwdXOwoyZklyrb2MjyyKMeiliwhM9CZEi0QNJDQpMo7vq4HeRqcdvzo
         9b2lNwf+ZCk43TK0EMeu7klAq5ZPYUpC6W2D+Hy65lirpyuTgasU3PA15F3m7lNn9KyA
         1GeN6PzSbwu3eySBNdBgRQYInRPik38E10zwD+GHKp6Q8dhGsvC1iKWKNJ26GS/E2ROF
         ziISO1lcR36eQiPMDnwujfw6qeRAfODd94RbHY3fFJRfAmSlD7at8zZiCOgxcZDz0IYe
         ws43lmtbRWe9pGo6DykufBvs5ll7v0kBrmLp8kmb7NuRcRsavuQWnM0P+Zbnf08dHfhw
         +pvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L4oxgNzgU6MbSzhzI6I+WZEyCWEZeECXAaeL4a0SGw4=;
        b=QMKuFsFT5bsaYrB4Sd0J/Ncc8LD0fNxBZoL3qIGIttuzOj8CwIrgMA1b4BesXagnDd
         1SoOoHYeTuaKmVqqtpBOQ/zheHikKXMpIYrOXfEmmjbSKO15trNKM7QgdyqhpPUdKNWg
         H0QjrKr7MyMpxPLjH9MDS0oKlYmlCC8TVg8XR9UrpMoVPOZpZ062DtRcwvRYETw7VD2l
         0lCSTOGaB39T9H7mzfl/+4fZ8f+x9HwJnu4dskrQCw2EChJ7xF/Vpbvo9X89cV5jqGx0
         ht0+JVDX7HpCcpQXWnIcqNHizeAc6WQyujEKTFrxSmadnVnk+MyD/MNgHt+C5bhOWdlG
         Q0JQ==
X-Gm-Message-State: AOAM532vVs1ktEKVqKNI1xh0M7n4UqPaC+XXSrLkaX4fvaAHkt3LEa7g
        AYmnijhgK4NxegBRD7+hnjOjHImbTTHJOA==
X-Google-Smtp-Source: ABdhPJyfXr+6Lo8EEKnx6nquujZ6mgmgXhkeIOTWsxAlOurj91jwQpVyuFIp/5+mkSEf+LhSbkdkug==
X-Received: by 2002:a17:907:629a:b0:6ff:8cd8:2192 with SMTP id nd26-20020a170907629a00b006ff8cd82192mr4968596ejc.30.1654187691246;
        Thu, 02 Jun 2022 09:34:51 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net ([2a02:3032:d:38a1:cadc:e8b7:bdfd:d7d0])
        by smtp.gmail.com with ESMTPSA id i14-20020a17090685ce00b00706287ba061sm1881833ejy.180.2022.06.02.09.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 09:34:50 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 1/1] conntrack: use same modifier socket for bulk ops
Date:   Thu,  2 Jun 2022 18:34:29 +0200
Message-Id: <20220602163429.52490-2-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220602163429.52490-1-mikhail.sennikovskii@ionos.com>
References: <20220602163429.52490-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For bulk ct entry loads (with -R option) reusing the same mnl
modifier socket for all entries results in reduction of entries
creation time, which becomes especially signifficant when loading
tens of thouthand of entries.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 27e2bea..be8690b 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -71,6 +71,7 @@
 struct nfct_mnl_socket {
 	struct mnl_socket	*mnl;
 	uint32_t		portid;
+	uint32_t		events;
 };
 
 static struct nfct_mnl_socket _sock;
@@ -2441,6 +2442,7 @@ static int nfct_mnl_socket_open(struct nfct_mnl_socket *socket,
 		return -1;
 	}
 	socket->portid = mnl_socket_get_portid(socket->mnl);
+	socket->events = events;
 
 	return 0;
 }
@@ -2470,6 +2472,25 @@ static void nfct_mnl_socket_close(const struct nfct_mnl_socket *sock)
 	mnl_socket_close(sock->mnl);
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
@@ -3383,19 +3404,17 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 		break;
 
 	case CT_UPDATE:
-		if (nfct_mnl_socket_open(modifier_sock, 0) < 0)
+		if (nfct_mnl_socket_check_open(modifier_sock, 0) < 0)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfct_filter_init(cmd);
 		res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
 				    IPCTNL_MSG_CT_GET, mnl_nfct_update_cb,
 				    cmd, NULL);
-
-		nfct_mnl_socket_close(modifier_sock);
 		break;
 
 	case CT_DELETE:
-		if (nfct_mnl_socket_open(modifier_sock, 0) < 0)
+		if (nfct_mnl_socket_check_open(modifier_sock, 0) < 0)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfct_filter_init(cmd);
@@ -3418,8 +3437,6 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 				    cmd, filter_dump);
 
 		nfct_filter_dump_destroy(filter_dump);
-
-		nfct_mnl_socket_close(modifier_sock);
 		break;
 
 	case EXP_DELETE:
@@ -3857,6 +3874,7 @@ static const char *ct_unsupp_cmd_file(const struct ct_cmd *cmd)
 int main(int argc, char *argv[])
 {
 	struct nfct_mnl_socket *sock = &_sock;
+	struct nfct_mnl_socket *modifier_sock = &_modifier_sock;
 	struct ct_cmd *cmd, *next;
 	LIST_HEAD(cmd_list);
 	int res = 0;
@@ -3900,6 +3918,7 @@ int main(int argc, char *argv[])
 		free(cmd);
 	}
 	nfct_mnl_socket_close(sock);
+	nfct_mnl_socket_check_close(modifier_sock);
 
 	return res < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
 }
-- 
2.25.1

