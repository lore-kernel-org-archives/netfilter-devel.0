From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] data_reg: calm down compilation warning in nftnl_data_reg_value_json_parse()
Date: Thu, 28 Dec 2017 19:24:08 +0100
Message-ID: <20171228182408.24202-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932280AbdL1SYU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Dec 2017 13:24:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 424BF25D4A
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 19:24:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F07A7FF14E
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 19:24:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C14DFC5E2
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 19:24:11 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5F9734265A30
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 19:24:11 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

expr/data_reg.c: In function 'nftnl_data_reg_json_parse':
expr/data_reg.c:69:27: warning: '%d' directive writing between 1 and 10 bytes into a region of size 2 [-Wformat-overflow=]
   sprintf(node_name, "data%d", i);
                           ^~
expr/data_reg.c:69:22: note: directive argument in the range [0, 2147483647]
   sprintf(node_name, "data%d", i);

Buffer overflow is triggerable when reg->len > 396, but len never goes
over 128 due to type validation just a bit before.

Use snprintf() and make sure buffer is large enough to store the
"data256" string.

Reported-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/data_reg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 70232028869a..1f689c5b6c7b 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -59,14 +59,15 @@ static int nftnl_data_reg_verdict_json_parse(union nftnl_data_reg *reg, json_t *
 static int nftnl_data_reg_value_json_parse(union nftnl_data_reg *reg, json_t *data,
 					 struct nftnl_parse_err *err)
 {
-	int i;
-	char node_name[6];
+	char node_name[strlen("data256") + 1] = {};
+	int ret, remain = size, offset = 0, i;
 
 	if (nftnl_jansson_parse_val(data, "len", NFTNL_TYPE_U8, &reg->len, err) < 0)
 			return DATA_NONE;
 
 	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
-		sprintf(node_name, "data%d", i);
+		ret = snprintf(node_name, sizeof(node_name), "data%u", i);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 		if (nftnl_jansson_str2num(data, node_name, BASE_HEX,
 					&reg->val[i], NFTNL_TYPE_U32, err) != 0)
-- 
2.11.0

