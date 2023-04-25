Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE07C77B61
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Apr 2023 14:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbjDYOyO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Apr 2023 10:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbjDYOyN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2023 10:54:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7FA0D19A2
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2023 07:54:11 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] mnl: handle singleton element in netdevice set
Date:   Tue, 25 Apr 2023 16:54:07 +0200
Message-Id: <20230425145407.2802-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

expr_evaluate_set() turns sets with singleton element into value,
nft_dev_add() expects a list of expression, so it crashes.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1676
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c                                     | 46 +++++++++++++------
 .../testcases/chains/0042chain_variable_0     |  4 ++
 .../chains/dumps/0042chain_variable_0.nft     |  4 ++
 3 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index c590c9554e0c..5dcfd9a04c4b 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -720,31 +720,49 @@ err:
  */
 
 struct nft_dev {
-	const char	*ifname;
-	struct location	*location;
+	const char		*ifname;
+	const struct location	*location;
 };
 
-static struct nft_dev *nft_dev_array(const struct expr *dev_expr, int *num_devs)
+static void nft_dev_add(struct nft_dev *dev_array, const struct expr *expr, int i)
 {
-	struct nft_dev *dev_array;
 	unsigned int ifname_len;
 	char ifname[IFNAMSIZ];
+
+	ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
+	memset(ifname, 0, sizeof(ifname));
+	mpz_export_data(ifname, expr->value, BYTEORDER_HOST_ENDIAN, ifname_len);
+	dev_array[i].ifname = xstrdup(ifname);
+	dev_array[i].location = &expr->location;
+}
+
+static struct nft_dev *nft_dev_array(const struct expr *dev_expr, int *num_devs)
+{
+	struct nft_dev *dev_array;
 	int i = 0, len = 1;
 	struct expr *expr;
 
-	list_for_each_entry(expr, &dev_expr->expressions, list)
-		len++;
+	switch (dev_expr->etype) {
+	case EXPR_SET:
+	case EXPR_LIST:
+		list_for_each_entry(expr, &dev_expr->expressions, list)
+			len++;
 
-	dev_array = xmalloc(sizeof(struct nft_dev) * len);
+		dev_array = xmalloc(sizeof(struct nft_dev) * len);
 
-	list_for_each_entry(expr, &dev_expr->expressions, list) {
-		ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
-		memset(ifname, 0, sizeof(ifname));
-		mpz_export_data(ifname, expr->value, BYTEORDER_HOST_ENDIAN,
-				ifname_len);
-		dev_array[i].ifname = xstrdup(ifname);
-		dev_array[i].location = &expr->location;
+		list_for_each_entry(expr, &dev_expr->expressions, list) {
+			nft_dev_add(dev_array, expr, i);
+			i++;
+		}
+		break;
+	case EXPR_VALUE:
+		len++;
+		dev_array = xmalloc(sizeof(struct nft_dev) * len);
+		nft_dev_add(dev_array, dev_expr, i);
 		i++;
+		break;
+	default:
+		assert(0);
 	}
 
 	dev_array[i].ifname = NULL;
diff --git a/tests/shell/testcases/chains/0042chain_variable_0 b/tests/shell/testcases/chains/0042chain_variable_0
index 58535f76cc32..f71b04155e44 100755
--- a/tests/shell/testcases/chains/0042chain_variable_0
+++ b/tests/shell/testcases/chains/0042chain_variable_0
@@ -25,11 +25,15 @@ table netdev filter2 {
 $NFT -f - <<< $EXPECTED
 
 EXPECTED="define if_main = { lo, dummy0 }
+define lan_interfaces = { lo }
 
 table netdev filter3 {
 	chain Main_Ingress3 {
 		type filter hook ingress devices = \$if_main priority -500; policy accept;
 	}
+	chain Main_Egress3 {
+		type filter hook egress devices = \$lan_interfaces priority -500; policy accept;
+	}
 }"
 
 $NFT -f - <<< $EXPECTED
diff --git a/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft b/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft
index 12931aadb39f..5ec230d0bcfa 100644
--- a/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft
+++ b/tests/shell/testcases/chains/dumps/0042chain_variable_0.nft
@@ -12,4 +12,8 @@ table netdev filter3 {
 	chain Main_Ingress3 {
 		type filter hook ingress devices = { dummy0, lo } priority -500; policy accept;
 	}
+
+	chain Main_Egress3 {
+		type filter hook egress device "lo" priority -500; policy accept;
+	}
 }
-- 
2.30.2

