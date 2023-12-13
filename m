Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAD898
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 08:41:36 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rDSIh-0001N9-AI; Wed, 13 Dec 2023 17:41:35 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink: fix stack buffer overflow with sub-reg sized prefixes
Date: Wed, 13 Dec 2023 17:41:26 +0100
Message-ID: <20231213164130.10891-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The calculation of the dynamic on-stack array is incorrect,
the scratch space can be too low which gives stack corruption:

AddressSanitizer: dynamic-stack-buffer-overflow on address 0x7ffdb454f064..
    #1 0x7fabe92aaac4 in __mpz_export_data src/gmputil.c:108
    #2 0x7fabe92d71b1 in netlink_export_pad src/netlink.c:251
    #3 0x7fabe92d91d8 in netlink_gen_prefix src/netlink.c:476

div_round_up() cannot be used here, it fails to account for register
padding.  A 16 bit prefix will need 2 registers (start, end -- 8 bytes
in total).

Remove the dynamic sizing and add an assertion in case upperlayer
ever passes invalid expr sizes down to us.

After this fix, the combination is rejected by the kernel
because of the maps' wrong data size, before the fix userspace
may crash before.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c                                              | 7 +++++--
 .../bogons/nft-f/dynamic-stack-buffer-overflow_gen_prefix  | 5 +++++
 2 files changed, 10 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/dynamic-stack-buffer-overflow_gen_prefix

diff --git a/src/netlink.c b/src/netlink.c
index 76e6be58f8f7..1fb6b414c1b4 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -465,11 +465,14 @@ static void netlink_gen_range(const struct expr *expr,
 static void netlink_gen_prefix(const struct expr *expr,
 			       struct nft_data_linearize *nld)
 {
-	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE) * 2;
-	unsigned char data[len];
+	unsigned int len = (netlink_padded_len(expr->len) / BITS_PER_BYTE) * 2;
+	unsigned char data[NFT_REG32_COUNT * sizeof(uint32_t)];
 	int offset;
 	mpz_t v;
 
+	if (len > sizeof(data))
+		BUG("Value export of %u bytes would overflow", len);
+
 	offset = netlink_export_pad(data, expr->prefix->value, expr);
 	mpz_init_bitmask(v, expr->len - expr->prefix_len);
 	mpz_add(v, expr->prefix->value, v);
diff --git a/tests/shell/testcases/bogons/nft-f/dynamic-stack-buffer-overflow_gen_prefix b/tests/shell/testcases/bogons/nft-f/dynamic-stack-buffer-overflow_gen_prefix
new file mode 100644
index 000000000000..23c2dc31fab9
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/dynamic-stack-buffer-overflow_gen_prefix
@@ -0,0 +1,5 @@
+table ip test {
+	chain test {
+		tcp dport set ip daddr map { 192.168.0.1 : 0x000/0001 }
+	}
+}
-- 
2.41.0

