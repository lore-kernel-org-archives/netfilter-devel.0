Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C16C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348862AbhKXWsr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243822AbhKXWsr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:47 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D825FC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=c4xUIge6moSsJz06dPbPa8cuDJ+Z3y2n20LGQJK0n2c=; b=P80nmr3TI85v6K9NrY1+k1EXgZ
        NQdiFqNbN5q+aDEVyIQsYJ+aWrx1OCYuA6Myq05HeA6YDUhT9UFV9KqIoZx4eLFY2Mfwr9mCQIi7A
        8nZQr15M1pc4CkSkIwG+fIATqsw/aRphvSD+u5qQZUgbViwgghP5BnTeEWzR+PBC8IyhtvngxWbSC
        37yOEAsY6K2W7PEJsfZQxJKY5P8dW+qeSKFvoJ3WLtjWYgOKJDKVB8dWbcc6wQoNjiSJneRMm03Sb
        Qm9LqLE2V37T9ygDJBSEjR6ap/puYAj03jQdW0x6FwoF9SA5NHu40a11wxkmtEbCVCIu4gnYBbnTn
        c66zsS4g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0hB-00563U-BU
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:53 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 31/32] output: JSON: fix possible truncation of socket path
Date:   Wed, 24 Nov 2021 22:24:43 +0000
Message-Id: <20211124222444.2597311-49-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124222444.2597311-1-jeremy@azazel.net>
References: <20211124222444.2597311-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Verify that the path is short enough, and replace `strncpy` with `strcpy`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ulogd_output_JSON.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index f60bd6ea51da..33428c96b84b 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -147,7 +147,8 @@ static void close_socket(struct json_priv *op) {
 static int _connect_socket_unix(struct ulogd_pluginstance *pi)
 {
 	struct json_priv *op = (struct json_priv *) &pi->private;
-	struct sockaddr_un u_addr;
+	struct sockaddr_un u_addr = { .sun_family = AF_UNIX };
+	const char *socket_path = file_ce(pi->config_kset).u.string;
 	int sfd;
 
 	close_socket(op);
@@ -155,14 +156,16 @@ static int _connect_socket_unix(struct ulogd_pluginstance *pi)
 	ulogd_log(ULOGD_DEBUG, "connecting to unix:%s\n",
 		  file_ce(pi->config_kset).u.string);
 
+	if (strlen(socket_path) >= sizeof(u_addr.sun_path))
+		return -1;
+
+	strcpy(u_addr.sun_path, socket_path);
+
 	sfd = socket(AF_UNIX, SOCK_STREAM, 0);
-	if (sfd == -1) {
+	if (sfd == -1)
 		return -1;
-	}
-	u_addr.sun_family = AF_UNIX;
-	strncpy(u_addr.sun_path, file_ce(pi->config_kset).u.string,
-		sizeof(u_addr.sun_path) - 1);
-	if (connect(sfd, (struct sockaddr *) &u_addr, sizeof(struct sockaddr_un)) == -1) {
+
+	if (connect(sfd, (struct sockaddr *) &u_addr, sizeof(u_addr)) == -1) {
 		close(sfd);
 		return -1;
 	}
-- 
2.33.0

