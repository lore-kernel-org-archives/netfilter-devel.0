Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0060C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jan 2022 18:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbiACSLr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jan 2022 13:11:47 -0500
Received: from mail.netfilter.org ([217.70.188.207]:57472 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiACSLr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jan 2022 13:11:47 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4012B63F4F
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jan 2022 19:09:01 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH ulogd2 2/2] output: JSON: remove bogus check for host and port
Date:   Mon,  3 Jan 2022 19:11:38 +0100
Message-Id: <20220103181138.101880-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220103181138.101880-1-pablo@netfilter.org>
References: <20220103181138.101880-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

struct config_entry already provides storage for the host and port
strings, .u.string is never NULL.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 output/ulogd_output_JSON.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index 83ad03efa145..bbc3dba5d41a 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -531,11 +531,6 @@ static int json_init_socket(struct ulogd_pluginstance *upi)
 {
 	struct json_priv *op = (struct json_priv *) &upi->private;
 
-	if (host_ce(upi->config_kset).u.string == NULL)
-		return -1;
-	if (port_ce(upi->config_kset).u.string == NULL)
-		return -1;
-
 	if (op->mode == JSON_MODE_UNIX &&
 	    validate_unix_socket(upi) < 0)
 		return -1;
-- 
2.30.2

