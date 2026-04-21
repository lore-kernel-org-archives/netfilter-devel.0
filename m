Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA1163845D8
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 12:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776775754; cv=none; b=K7AEqeXQCflGrXWHOFQYXfCyrGXY1Qf8PKZ1aGdTL6Yf5mXN0xnmQlaZ2tC77XBZ1u839xP0BRSTOFT8Q6Ts8V4pO0W60biLN1XM+u9b7L5o4v/e0fKVhzKBySQrJ1FoJuDDKeOBiTbG3eL19qu1X+xcXbxe9BeegEtq+NaHd4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776775754; c=relaxed/simple;
	bh=pLtUm3OqzCQeZJmni3gZn1EAGz4h84MfZk1Zqlt3Vq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAmAS3Son95dyc8ahjRNMHHTVX+U0DxSRkquo3ubRUdgbVwb73qBmObPYLBzfVB0BP7NvZxfGX89GeE26rIuxOPHvI2QXnqvHu5ZASRdQR70UbFTLKyJ32aEr5Qzod0xN9b+9KNiHtmRevDnSTjYR+ToLzU8gLR+jJOOZFI+uSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowAC3Kvs3cudpsdDYAA--.16054S2;
	Tue, 21 Apr 2026 20:48:56 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	jeremy@azazel.net,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	k4729.23098@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH net 1/1] netfilter: shift-out-of-bounds in nft_bitwise
Date: Tue, 21 Apr 2026 20:42:34 +0800
Message-ID: <5166c80ac3006080e4542ef4c3bf28bc78c696bc.1776667409.git.k4729.23098@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1776667409.git.k4729.23098@gmail.com>
References: <cover.1776667409.git.k4729.23098@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowAC3Kvs3cudpsdDYAA--.16054S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CrWrGr13Jry5tr1xWFyxuFg_yoW8tw43pa
	sxK34ftFZrJFy2gw1Syry0yFn5Jrn3Cr13CrnxZFykZ3WUJr1rJ3WrK39Ivw1UGFs29Fs3
	ZanIvFn3Kan5CFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_
	JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUFg4SDUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQsECWnnOeEFwgAAsW

From: Kai Ma <k4729.23098@gmail.com>

Handle zero shift operands explicitly in nft_bitwise_eval_lshift() and
nft_bitwise_eval_rshift().

Shift expressions accept values in the range [0, 31], but the carry
propagation code assumes a non-zero shift and computes the carry from the
adjacent 32-bit word unconditionally. For a zero shift operand, the
expected result is to leave the value unchanged.

Treat zero shift as a no-op before entering the carry propagation loops.
This preserves the existing behaviour for non-zero shifts and matches the
expected semantics of shifting by zero.

Fixes: 567d746b55bc ("netfilter: bitwise: add support for shifts.")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Kai Ma <k4729.23098@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/netfilter/nft_bitwise.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index d550910aabec..f74774b176af 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -39,10 +39,16 @@ static void nft_bitwise_eval_lshift(u32 *dst, const u32 *src,
 				    const struct nft_bitwise *priv)
 {
 	u32 shift = priv->data.data[0];
-	unsigned int i;
+	unsigned int i, n = DIV_ROUND_UP(priv->len, sizeof(u32));
 	u32 carry = 0;
 
-	for (i = DIV_ROUND_UP(priv->len, sizeof(u32)); i > 0; i--) {
+	if (!shift) {
+		for (i = 0; i < n; i++)
+			dst[i] = src[i];
+		return;
+	}
+
+	for (i = n; i > 0; i--) {
 		dst[i - 1] = (src[i - 1] << shift) | carry;
 		carry = src[i - 1] >> (BITS_PER_TYPE(u32) - shift);
 	}
@@ -52,10 +58,16 @@ static void nft_bitwise_eval_rshift(u32 *dst, const u32 *src,
 				    const struct nft_bitwise *priv)
 {
 	u32 shift = priv->data.data[0];
-	unsigned int i;
+	unsigned int i, n = DIV_ROUND_UP(priv->len, sizeof(u32));
 	u32 carry = 0;
 
-	for (i = 0; i < DIV_ROUND_UP(priv->len, sizeof(u32)); i++) {
+	if (!shift) {
+		for (i = 0; i < n; i++)
+			dst[i] = src[i];
+		return;
+	}
+
+	for (i = 0; i < n; i++) {
 		dst[i] = carry | (src[i] >> shift);
 		carry = src[i] << (BITS_PER_TYPE(u32) - shift);
 	}
-- 
2.43.0

