Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2037C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jun 2022 20:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbiFIUme (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jun 2022 16:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiFIUmd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jun 2022 16:42:33 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E201057C
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jun 2022 13:42:32 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id d14so7164193eda.12
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2022 13:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m9Yl7nzTx0OD4N9aXK262OY1ZSO7wd+ZnePk/hSoSHE=;
        b=Oc8sD7KjKlcgJZngloYumEyH2JQ6708UdPr7q3MtR4/PO8SocrK8wgajtoEwO43rOU
         H5Q3v9qL0C60+I0i18qWBpY9QtT0Z30fsz7Aw92Qr6BOzW4kN6/2TRi4M39eKtghwx+f
         UJAnnBi7tLUekKpn2bnSMm1Gt67jCbh/6qoi58X6v8cEibvSXXVNKjmeD44eGZCUXz7N
         SaAPLNWaR2SKt8LtqGkqIVHDBk2xw1z8Bqqa8FJKdwrDgbRb+PQ44UjJoVtzhYF3d3lQ
         L0aMfKDnX+IfwZf/bLrxH0YFsCbGd1z988fpIuY3CBNHnVgcTejOkU74pnHRIZ3mU0Na
         10hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m9Yl7nzTx0OD4N9aXK262OY1ZSO7wd+ZnePk/hSoSHE=;
        b=BW49qsPKW3Jm8qOosUeCTP6zW0oV0bRlL+0z9qkzmGqmzGsUgmlYIk7Os9LaH3n1U8
         YbdUS9e4lvKpFfuKXY22wPn5/fFaCbPpIy6rwoJPDT9g/gLBU/0s1dMeun4TqDM/bH6E
         XZ2VaYvl9k1dNmEMqaDPTA6Cgs648d7NvPy+Ft17j5viwg0fupZwFaS4Ct9On9wlM4J2
         sOUs4LAhd28qohwn0p6fJ0YUB3SkXkCaBhdUKL3kH2w+kQSy/kI0u+wRf8PenlPDVsad
         dM+iJqsADuF1GkmlpWhp/ZoBQ4+JB7fs7SNcs3wJOD9kNmGn62/mFRgOzGNgXVfGeJ9w
         PHgw==
X-Gm-Message-State: AOAM530ef8nfbQI+6qzc+8++GMw0CmofUx/E1ZHKFR9A+gVHnQUfa4L4
        xN+MiPem8FYBHryQI2M9k1pZ1DZJR+Bchg==
X-Google-Smtp-Source: ABdhPJweryE9xXbu1gWl+DibhgK16FRcM67bbkkAF7BXj7obx7qQH3AP8ck2KnpLta1e46N/kS2lnQ==
X-Received: by 2002:a05:6402:3906:b0:42a:ad43:6477 with SMTP id fe6-20020a056402390600b0042aad436477mr47133564edb.20.1654807350452;
        Thu, 09 Jun 2022 13:42:30 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf473.dynamic.kabel-deutschland.de. [95.91.244.115])
        by smtp.gmail.com with ESMTPSA id hz14-20020a1709072cee00b00708e906faecsm10856246ejc.124.2022.06.09.13.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 13:42:29 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 1/1] conntrack: use same modifier socket for bulk ops
Date:   Thu,  9 Jun 2022 22:41:42 +0200
Message-Id: <20220609204142.54700-2-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220609204142.54700-1-mikhail.sennikovskii@ionos.com>
References: <20220609204142.54700-1-mikhail.sennikovskii@ionos.com>
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
 src/conntrack.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 27e2bea..6022d19 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2470,6 +2470,23 @@ static void nfct_mnl_socket_close(const struct nfct_mnl_socket *sock)
 	mnl_socket_close(sock->mnl);
 }
 
+static int nfct_mnl_socket_check_open(struct nfct_mnl_socket *socket,
+				       unsigned int events)
+{
+	if (socket->mnl != NULL)
+		return 0;
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
@@ -3383,19 +3400,17 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
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
@@ -3418,8 +3433,6 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 				    cmd, filter_dump);
 
 		nfct_filter_dump_destroy(filter_dump);
-
-		nfct_mnl_socket_close(modifier_sock);
 		break;
 
 	case EXP_DELETE:
@@ -3857,6 +3870,7 @@ static const char *ct_unsupp_cmd_file(const struct ct_cmd *cmd)
 int main(int argc, char *argv[])
 {
 	struct nfct_mnl_socket *sock = &_sock;
+	struct nfct_mnl_socket *modifier_sock = &_modifier_sock;
 	struct ct_cmd *cmd, *next;
 	LIST_HEAD(cmd_list);
 	int res = 0;
@@ -3900,6 +3914,7 @@ int main(int argc, char *argv[])
 		free(cmd);
 	}
 	nfct_mnl_socket_close(sock);
+	nfct_mnl_socket_check_close(modifier_sock);
 
 	return res < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
 }
-- 
2.25.1

