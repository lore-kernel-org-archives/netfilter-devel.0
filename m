Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0ED81514FB
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 12:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732019837; cv=none; b=U8yerLRcFkpbaGc92epbNn6r6qJr253zew0+ST+VYfCNC5ehc6s67XHLETAq522czay0/moRVRNTykHG1DhihlHTtT6+jNYKEIVihYzVLxAsq6Mww4xBDzq8uJJtDoGXbFvmAqbY2nzDHjS8RL6easD7sNyyQtjOiX4bAS9ooxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732019837; c=relaxed/simple;
	bh=eM4eG76YX7QtoYtfCMxzrlp83EwGaYo4aIvc7Vdro5I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JvgfzL7b5OWHvFNqUEO6khi7VeMvdUJPHUKDQKokcbfTg6lMzpoenx4uqNYtXzpXTXH/QXBprEC/R91M5nDnU1zlC/aLgFdChUB/utBWAY98hrt+jIeCxIFq2ZQXWRfApZHgqgwPotP/fw2S0hq0QCvWrhZRjt7lBVJxk2XnRZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jeremy@azazel.net
Subject: [PATCH libnftnl 1/2] include: add new bitwise boolean attributes to nf_tables.h
Date: Tue, 19 Nov 2024 13:37:07 +0100
Message-Id: <20241119123708.185552-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeremy Sowden <jeremy@azazel.net>

The kernel now has native support for AND, OR and XOR bitwise
operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
rebase on top of git HEAD

 include/linux/netfilter/nf_tables.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 9e9079321380..1e95b5469f7c 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -564,16 +564,27 @@ enum nft_immediate_attributes {
 /**
  * enum nft_bitwise_ops - nf_tables bitwise operations
  *
- * @NFT_BITWISE_BOOL: mask-and-xor operation used to implement NOT, AND, OR and
- *                    XOR boolean operations
+ * @NFT_BITWISE_BOOL: mask-and-xor operation used to implement NOT, AND, OR
+ *                    and XOR boolean operations
  * @NFT_BITWISE_LSHIFT: left-shift operation
  * @NFT_BITWISE_RSHIFT: right-shift operation
+ * @NFT_BITWISE_AND: and operation
+ * @NFT_BITWISE_OR: or operation
+ * @NFT_BITWISE_XOR: xor operation
  */
 enum nft_bitwise_ops {
 	NFT_BITWISE_BOOL,
 	NFT_BITWISE_LSHIFT,
 	NFT_BITWISE_RSHIFT,
+	NFT_BITWISE_AND,
+	NFT_BITWISE_OR,
+	NFT_BITWISE_XOR,
 };
+/*
+ * Old name for NFT_BITWISE_MASK_XOR, predating the addition of NFT_BITWISE_AND,
+ * NFT_BITWISE_OR and NFT_BITWISE_XOR.  Retained for backwards-compatibility.
+ */
+#define NFT_BITWISE_BOOL NFT_BITWISE_MASK_XOR
 
 /**
  * enum nft_bitwise_attributes - nf_tables bitwise expression netlink attributes
@@ -586,6 +597,7 @@ enum nft_bitwise_ops {
  * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
  * @NFTA_BITWISE_DATA: argument for non-boolean operations
  *                     (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_SREG2: second source register (NLA_U32: nft_registers)
  *
  * The bitwise expression supports boolean and shift operations.  It implements
  * the boolean operations by performing the following operation:
@@ -609,6 +621,7 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_XOR,
 	NFTA_BITWISE_OP,
 	NFTA_BITWISE_DATA,
+	NFTA_BITWISE_SREG2,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
-- 
2.30.2

