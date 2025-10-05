Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915A6259C80
	for <netfilter-devel@vger.kernel.org>; Sun,  5 Oct 2025 12:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759668920; cv=none; b=bMnudHhw7GkxNOW09EuOKEhggEEygbBgHgm6q0fEeKvDZD+k8oFv7rSSySysUeb7vI0w7zTEusOM2jZXvhrGVHAhLiRapRD4Or+/dlomZZJpWpOcrazQD1VNkPX1x197PVnaHLdZBsmx+7U+FkJV1+nvLeSEkFh9X2f7eN6ijSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759668920; c=relaxed/simple;
	bh=dTcmbiXVCA2rRhVJG4+pyC1BgxhelRum23qRce23ll0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nXM+wQR6LQa0byfsARBLMzmb6HsjkRTFw+S2uHnuEhV2Vv83+RGOPcwu+TH0K9O/tPhyAubhyvU/eHmyUZEH/J1W4AXBxCT7iCmHDYjL+Bvxjj/Upk0rY3p8SiG3OpzF8GsL1Tp/M33OfI5XRMTxINzUY4HPFxN88uxYzavAYII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zmv1fF+q; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zmv1fF+q"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-579d7104c37so5321641e87.3
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Oct 2025 05:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759668916; x=1760273716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nriFf6SG46hPmvDtZ6ezC03CijMFvE5839nLw2I1iW0=;
        b=Zmv1fF+q6zmWtyIT86FpnWc3VVypllcVlG3to+xcBcOchl0LSLFOhboEIimIhJhcJE
         DoSk+hiUpkebwhmhckRqRXF3/paQqMvfDBP80uIP73NoSPKYEbiKSQAQoL+zal5+ruAl
         bP5WenkcGZDRZmwIUU1RW2UvPXtCtXPVK3bwZ7Ife9NouwRuerNN6+fGriqFcWmnLjJh
         hBr1l5LMgIanYEgfj2cEDhspZWByXXaLzEd7/zNZv7dVDndboT0GZJAAR/7sFcYEI7Yb
         7aUb8HSFKefP4KyDupEAqhDrfhdoeDSACXPWYiJnMQ+hcOSQJF1c1ce5jtZuR1Alg7oS
         +alg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759668916; x=1760273716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nriFf6SG46hPmvDtZ6ezC03CijMFvE5839nLw2I1iW0=;
        b=oN3FXhxmIlXpsp1AcDoCUtCtBwFwEM062ZMskTM8dib4txCnma3R/bt8JShvh6QJtO
         mhQvkiJ116+eDAuHD91+5wVxNPpGjJBDiInX5C3ivFAeuuD69Jz4gNOursK7gPds4zpv
         xdl6Vv1NG9V623N1+hcQEQrRthzmFUJJ/c9FwrgcXWa5j4/OMqHdyDurJJSAYMa/2OA7
         n+DVDyckPKhXKrxcn2EGG0213Uyby+hDnZW/xGyBIjIFaGx/9O5TFBAADKsn/kn8tT1b
         MlyCy7YyzSLzT6UO3EX27duGxVnzEvmNa65mDpm0QH/irO1BKIy5obsW2c8ig7YNnDZI
         TLyw==
X-Gm-Message-State: AOJu0YwXJ4ECwb8x7IZ46f1TpZNBrLDgA7lG0pOam1VyoD7NqzhzeZ7q
	kIHI+sTEZJFv00GNcj32vxWVXMQGaIJAFVyw7v5NuoKMjrJQAh8v0PUdUDPhmQQ0qBE=
X-Gm-Gg: ASbGncsVWxCl0ggWYxn7Ulas6UUaKnbbH9/kzaZ3hceUlHfIqLn0E1QX0UhOwXn2b25
	tY5eleASF3jjp60vu/OyufIJt8lHTARMXMxXiOKkqwcCt2YjVdoZkiTasAPcx7uj94gBImmx2S7
	rEmh7lA8BKqV5J8AeiufNsE+VRK7HTsxbK9t7332VsxTy0mmx0eF5GldcE4iAUrBfiKDNmxmGb/
	ZejJoYAiXpPF0VV5LnTjBsthA1CsjZmFUE8G77zyFyQ3FxNe2YKVIqz2lub8b6ktW9qdswDSvBu
	iYhW2pU6NmtLaMnkV6ANWiDnsJ9mMM0b2qoUTXU5vbEyTwJEnaUEtSWf1RWhRHZ6HwJ6+AKnJWc
	BhTFPXi/Megpie7MPTWQf+t/UBDcgLJv1zrBrVADfxNck/Gn94mm6Ysna86qBas27Zh38wHK76Y
	SRHvGoDPK0q//mT3B35vhEooo9d7uM
X-Google-Smtp-Source: AGHT+IFPHRO9fjarVD2RF+WpJq3RRM+PO5geawpThpXI90xeMAVx2l8XSAbkeP0ZkUymYc65hp3/2w==
X-Received: by 2002:a05:6512:2242:b0:57b:b4da:2712 with SMTP id 2adb3069b0e04-58cb9f0b31emr2926620e87.4.1759668915836;
        Sun, 05 Oct 2025 05:55:15 -0700 (PDT)
Received: from pop-os.. ([2a02:2121:347:bd74:2631:aa1a:6b23:6a5])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b01141f09sm3885823e87.62.2025.10.05.05.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Oct 2025 05:55:15 -0700 (PDT)
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	fmancera@suse.de,
	Nikolaos Gkarlis <nickgarlis@gmail.com>
Subject: [PATCH v3] selftests: netfilter: add nfnetlink ACK handling tests
Date: Sun,  5 Oct 2025 14:54:39 +0200
Message-Id: <20251005125439.827945-1-nickgarlis@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aOJZn0TLARyv5Ocj@strlen.de>
References: <aOJZn0TLARyv5Ocj@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add nfnetlink selftests to validate the ACKs sent after a batch
message. These tests verify that:

  - ACKs are always received in order.
  - Module loading does not affect the responses.
  - The number of ACKs matches the number of requests, unless a
    fatal error occurs.

Signed-off-by: Nikolaos Gkarlis <nickgarlis@gmail.com>
---
 .../testing/selftests/net/netfilter/Makefile  |   3 +
 .../selftests/net/netfilter/nfnetlink.c       | 437 ++++++++++++++++++
 .../selftests/net/netfilter/nfnetlink.sh      |   6 +
 3 files changed, 446 insertions(+)
 create mode 100644 tools/testing/selftests/net/netfilter/nfnetlink.c
 create mode 100755 tools/testing/selftests/net/netfilter/nfnetlink.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index a98ed892f55f..cb38c8a9b2cc 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -37,6 +37,7 @@ TEST_PROGS += nft_zones_many.sh
 TEST_PROGS += rpath.sh
 TEST_PROGS += vxlan_mtu_frag.sh
 TEST_PROGS += xt_string.sh
+TEST_PROGS += nfnetlink.sh
 
 TEST_PROGS_EXTENDED = nft_concat_range_perf.sh
 
@@ -46,6 +47,7 @@ TEST_GEN_FILES += conntrack_dump_flush
 TEST_GEN_FILES += conntrack_reverse_clash
 TEST_GEN_FILES += sctp_collision
 TEST_GEN_FILES += udpclash
+TEST_GEN_FILES += nfnetlink
 
 include ../../lib.mk
 
@@ -54,6 +56,7 @@ $(OUTPUT)/nf_queue: LDLIBS += $(MNL_LDLIBS)
 
 $(OUTPUT)/conntrack_dump_flush: CFLAGS += $(MNL_CFLAGS)
 $(OUTPUT)/conntrack_dump_flush: LDLIBS += $(MNL_LDLIBS)
+$(OUTPUT)/nfnetlink: LDLIBS += $(MNL_LDLIBS)
 $(OUTPUT)/udpclash: LDLIBS += -lpthread
 
 TEST_FILES := lib.sh
diff --git a/tools/testing/selftests/net/netfilter/nfnetlink.c b/tools/testing/selftests/net/netfilter/nfnetlink.c
new file mode 100644
index 000000000000..d6a2895be1f0
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nfnetlink.c
@@ -0,0 +1,437 @@
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sched.h>
+#include <time.h>
+#include <arpa/inet.h>
+#include <libmnl/libmnl.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter.h>
+#include <sys/types.h>
+
+#include "../../kselftest_harness.h"
+
+#define BATCH_PAGE_SIZE 8192
+
+static bool batch_begin(struct mnl_nlmsg_batch *batch, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
+
+	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
+	nlh->nlmsg_type = NFNL_MSG_BATCH_BEGIN;
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
+	nlh->nlmsg_seq = seq;
+
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = NFPROTO_UNSPEC;
+	nfh->version = NFNETLINK_V0;
+	nfh->res_id = NFNL_SUBSYS_NFTABLES;
+
+	return mnl_nlmsg_batch_next(batch);
+}
+
+static bool batch_end(struct mnl_nlmsg_batch *batch, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
+
+	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
+	nlh->nlmsg_type = NFNL_MSG_BATCH_END;
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
+	nlh->nlmsg_seq = seq;
+
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = NFPROTO_UNSPEC;
+	nfh->version = NFNETLINK_V0;
+	nfh->res_id = NFNL_SUBSYS_NFTABLES;
+
+	return mnl_nlmsg_batch_next(batch);
+}
+
+static bool
+create_table(struct mnl_nlmsg_batch *batch, const char *name, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
+
+	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
+	nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_NEWTABLE;
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE | NLM_F_ACK;
+	nlh->nlmsg_seq = seq;
+
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = NFPROTO_INET;
+	nfh->version = NFNETLINK_V0;
+	nfh->res_id = 0;
+
+	mnl_attr_put_strz(nlh, NFTA_TABLE_NAME, name);
+
+	return mnl_nlmsg_batch_next(batch);
+}
+
+static bool
+create_chain(struct mnl_nlmsg_batch *batch, const char *table,
+	     const char *chain, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
+
+	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
+	nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_NEWCHAIN;
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE | NLM_F_ACK;
+	nlh->nlmsg_seq = seq;
+
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = NFPROTO_INET;
+	nfh->version = NFNETLINK_V0;
+	nfh->res_id = 0;
+
+	mnl_attr_put_strz(nlh, NFTA_CHAIN_TABLE, table);
+	mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME, chain);
+
+	return mnl_nlmsg_batch_next(batch);
+}
+
+static bool
+create_rule_with_ct(struct mnl_nlmsg_batch *batch, const char *table,
+		    const char *chain, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
+	struct nlattr *nest1, *nest2, *nest3, *nest4;
+
+	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
+	nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_NEWRULE;
+	nlh->nlmsg_flags =
+	    NLM_F_REQUEST | NLM_F_CREATE | NLM_F_APPEND | NLM_F_ACK;
+	nlh->nlmsg_seq = seq;
+
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = NFPROTO_INET;
+	nfh->version = NFNETLINK_V0;
+	nfh->res_id = 0;
+
+	mnl_attr_put_strz(nlh, NFTA_RULE_TABLE, table);
+	mnl_attr_put_strz(nlh, NFTA_RULE_CHAIN, chain);
+
+	/* Create expressions list */
+	nest1 = mnl_attr_nest_start(nlh, NFTA_RULE_EXPRESSIONS);
+
+	/* CT expression to load ct state */
+	nest2 = mnl_attr_nest_start(nlh, NFTA_LIST_ELEM);
+	mnl_attr_put_strz(nlh, NFTA_EXPR_NAME, "ct");
+
+	nest3 = mnl_attr_nest_start(nlh, NFTA_EXPR_DATA);
+	mnl_attr_put_u32(nlh, NFTA_CT_KEY, htonl(NFT_CT_STATE));
+	mnl_attr_put_u32(nlh, NFTA_CT_DREG, htonl(NFT_REG_1));
+	mnl_attr_nest_end(nlh, nest3);
+
+	mnl_attr_nest_end(nlh, nest2);
+
+	/* Bitwise expression */
+	nest2 = mnl_attr_nest_start(nlh, NFTA_LIST_ELEM);
+	mnl_attr_put_strz(nlh, NFTA_EXPR_NAME, "bitwise");
+
+	nest3 = mnl_attr_nest_start(nlh, NFTA_EXPR_DATA);
+	mnl_attr_put_u32(nlh, NFTA_BITWISE_SREG, htonl(NFT_REG_1));
+	mnl_attr_put_u32(nlh, NFTA_BITWISE_DREG, htonl(NFT_REG_1));
+	mnl_attr_put_u32(nlh, NFTA_BITWISE_LEN, htonl(4));
+
+	uint32_t mask =
+	    NF_CT_STATE_BIT(IP_CT_ESTABLISHED) | NF_CT_STATE_BIT(IP_CT_RELATED);
+	nest4 = mnl_attr_nest_start(nlh, NFTA_BITWISE_MASK);
+	mnl_attr_put(nlh, NFTA_DATA_VALUE, sizeof(mask), &mask);
+	mnl_attr_nest_end(nlh, nest4);
+
+	uint32_t val = 0x00000000;
+	nest4 = mnl_attr_nest_start(nlh, NFTA_BITWISE_XOR);
+	mnl_attr_put(nlh, NFTA_DATA_VALUE, sizeof(val), &val);
+	mnl_attr_nest_end(nlh, nest4);
+
+	mnl_attr_nest_end(nlh, nest3);
+	mnl_attr_nest_end(nlh, nest2);
+
+	/* Cmp expression */
+	nest2 = mnl_attr_nest_start(nlh, NFTA_LIST_ELEM);
+	mnl_attr_put_strz(nlh, NFTA_EXPR_NAME, "cmp");
+
+	nest3 = mnl_attr_nest_start(nlh, NFTA_EXPR_DATA);
+	mnl_attr_put_u32(nlh, NFTA_CMP_SREG, htonl(NFT_REG_1));
+	mnl_attr_put_u32(nlh, NFTA_CMP_OP, htonl(NFT_CMP_NEQ));
+
+	uint32_t cmp_data = 0x00000000;
+	nest4 = mnl_attr_nest_start(nlh, NFTA_CMP_DATA);
+	mnl_attr_put(nlh, NFTA_DATA_VALUE, sizeof(cmp_data), &cmp_data);
+	mnl_attr_nest_end(nlh, nest4);
+
+	mnl_attr_nest_end(nlh, nest3);
+	mnl_attr_nest_end(nlh, nest2);
+
+	/* Counter expression */
+	nest2 = mnl_attr_nest_start(nlh, NFTA_LIST_ELEM);
+	mnl_attr_put_strz(nlh, NFTA_EXPR_NAME, "counter");
+
+	mnl_attr_nest_end(nlh, nest2);
+
+	mnl_attr_nest_end(nlh, nest1);
+
+	return mnl_nlmsg_batch_next(batch);
+}
+
+static bool create_invalid_table(struct mnl_nlmsg_batch *batch, uint32_t seq)
+{
+	struct nlmsghdr *nlh;
+	struct nfgenmsg *nfh;
+
+	nlh = mnl_nlmsg_put_header(mnl_nlmsg_batch_current(batch));
+	nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_NEWTABLE;
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE | NLM_F_ACK;
+	nlh->nlmsg_seq = seq;
+
+	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
+	nfh->nfgen_family = NFPROTO_INET;
+	nfh->version = NFNETLINK_V0;
+	nfh->res_id = 0;
+
+	/* Intentionally omit table name attribute to cause error */
+
+	return mnl_nlmsg_batch_next(batch);
+}
+
+static void validate_res(struct mnl_socket *nl, uint32_t first_seq,
+			 uint32_t expected_acks,
+			 struct __test_metadata *_metadata)
+{
+	char buf[BATCH_PAGE_SIZE];
+	int ret, acks_received = 0;
+	uint32_t last_seq = 0;
+	bool out_of_order = false;
+
+	while (1) {
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		if (ret == -1) {
+			if (errno == EAGAIN || errno == EWOULDBLOCK) {
+				break;
+			}
+
+			TH_LOG("Unexpected error on recv: %s", strerror(errno));
+			ASSERT_TRUE(false);
+			return;
+		}
+
+		struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
+		while (mnl_nlmsg_ok(nlh, ret)) {
+			if (nlh->nlmsg_type == NLMSG_ERROR) {
+				struct nlmsgerr *err =
+				    mnl_nlmsg_get_payload(nlh);
+				acks_received++;
+
+				if (err->error != 0) {
+					TH_LOG("[seq=%u] Error: %s",
+					       nlh->nlmsg_seq,
+					       strerror(-err->error));
+				} else {
+					TH_LOG("[seq=%u] ACK", nlh->nlmsg_seq);
+				}
+
+				if (nlh->nlmsg_seq <= last_seq) {
+					out_of_order = true;
+					TH_LOG
+					    ("Out of order ack: seq %u after %u",
+					     nlh->nlmsg_seq, last_seq);
+				}
+				last_seq = nlh->nlmsg_seq;
+			}
+			nlh = mnl_nlmsg_next(nlh, &ret);
+		}
+	}
+
+	ASSERT_FALSE(out_of_order);
+
+	ASSERT_EQ(acks_received, expected_acks);
+}
+
+FIXTURE(nfnetlink_batch)
+{
+	struct mnl_socket *nl;
+};
+
+FIXTURE_SETUP(nfnetlink_batch)
+{
+	struct timeval tv = {.tv_sec = 1,.tv_usec = 0 };
+
+	ASSERT_EQ(unshare(CLONE_NEWNET), 0);
+
+	self->nl = mnl_socket_open(NETLINK_NETFILTER);
+	ASSERT_NE(self->nl, NULL);
+
+	ASSERT_EQ(mnl_socket_bind(self->nl, 0, MNL_SOCKET_AUTOPID), 0);
+
+	ASSERT_EQ(setsockopt
+		  (mnl_socket_get_fd(self->nl), SOL_SOCKET, SO_RCVTIMEO, &tv,
+		   sizeof(tv)), 0);
+}
+
+FIXTURE_TEARDOWN(nfnetlink_batch)
+{
+	if (self->nl) {
+		mnl_socket_close(self->nl);
+	}
+}
+
+TEST_F(nfnetlink_batch, simple_batch)
+{
+	struct mnl_nlmsg_batch *batch;
+	char buf[BATCH_PAGE_SIZE];
+	uint32_t seq = time(NULL);
+	int ret;
+
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+	ASSERT_NE(batch, NULL);
+
+	ASSERT_TRUE(batch_begin(batch, seq++));
+	create_table(batch, "test_table1", seq++);
+	batch_end(batch, seq++);
+
+	ret = mnl_socket_sendto(self->nl, mnl_nlmsg_batch_head(batch),
+				mnl_nlmsg_batch_size(batch));
+	ASSERT_GT(ret, 0);
+
+	// Expect 3 acks: batch_begin, create_table, batch_end
+	validate_res(self->nl, seq - 3, 3, _metadata);
+
+	mnl_nlmsg_batch_stop(batch);
+}
+
+/*
+ * This test simulates the replay path by executing a batch that depends
+ * on the nft_ct module. The purpose is to verify that the same number of
+ * ACKs is received regardless of whether the module gets loaded automatically
+ * or not. If the module is built in or not present, the test will pass anyway.
+ */
+TEST_F(nfnetlink_batch, module_load)
+{
+	struct mnl_nlmsg_batch *batch;
+	char buf[BATCH_PAGE_SIZE];
+	uint32_t seq = time(NULL) + 1000;
+	int ret;
+
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+	ASSERT_NE(batch, NULL);
+
+	batch_begin(batch, seq++);
+	create_table(batch, "test_table2", seq++);
+	create_chain(batch, "test_table2", "test_chain", seq++);
+	create_rule_with_ct(batch, "test_table2", "test_chain", seq++);
+	batch_end(batch, seq++);
+
+	ret = mnl_socket_sendto(self->nl, mnl_nlmsg_batch_head(batch),
+				mnl_nlmsg_batch_size(batch));
+	ASSERT_GT(ret, 0);
+
+	// Expect 5 acks: batch_begin, table, chain, rule, batch_end
+	validate_res(self->nl, seq - 5, 5, _metadata);
+
+	mnl_nlmsg_batch_stop(batch);
+}
+
+/*
+ * Repeat the previous test, but this time the nft_ct module should have been
+ * loaded by the previous test (if it exists and is not built-in). In any case,
+ * the same number of ACKs as before is expected.
+ */
+TEST_F(nfnetlink_batch, post_module_load)
+{
+	struct mnl_nlmsg_batch *batch;
+	char buf[BATCH_PAGE_SIZE];
+	uint32_t seq = time(NULL) + 2000;
+	int ret;
+
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+	ASSERT_NE(batch, NULL);
+
+	batch_begin(batch, seq++);
+	create_table(batch, "test_table6", seq++);
+	create_chain(batch, "test_table6", "test_chain", seq++);
+	create_rule_with_ct(batch, "test_table6", "test_chain", seq++);
+	batch_end(batch, seq++);
+
+	ret = mnl_socket_sendto(self->nl, mnl_nlmsg_batch_head(batch),
+				mnl_nlmsg_batch_size(batch));
+	ASSERT_GT(ret, 0);
+
+	validate_res(self->nl, seq - 5, 5, _metadata);
+
+	mnl_nlmsg_batch_stop(batch);
+}
+
+TEST_F(nfnetlink_batch, invalid_batch)
+{
+	struct mnl_nlmsg_batch *batch;
+	char buf[BATCH_PAGE_SIZE];
+	uint32_t seq = time(NULL) + 3000;
+	int ret;
+
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+	ASSERT_NE(batch, NULL);
+
+	batch_begin(batch, seq++);
+	create_table(batch, "test_table3", seq++);
+	create_invalid_table(batch, seq++);
+	create_chain(batch, "test_table3", "test_chain", seq++);
+	batch_end(batch, seq++);
+
+	ret = mnl_socket_sendto(self->nl, mnl_nlmsg_batch_head(batch),
+				mnl_nlmsg_batch_size(batch));
+	ASSERT_GT(ret, 0);
+
+	// Expect 5 acks: batch_begin, table, invalid_table(error), chain, batch_end
+	validate_res(self->nl, seq - 5, 5, _metadata);
+
+	mnl_nlmsg_batch_stop(batch);
+}
+
+TEST_F(nfnetlink_batch, batch_with_fatal_error)
+{
+	struct mnl_nlmsg_batch *batch;
+	char buf[BATCH_PAGE_SIZE];
+	uint32_t seq = time(NULL) + 4000;
+	uid_t uid;
+	int ret;
+
+	batch = mnl_nlmsg_batch_start(buf, sizeof(buf));
+	ASSERT_NE(batch, NULL);
+
+	batch_begin(batch, seq++);
+	create_table(batch, "test_table4", seq++);
+	create_table(batch, "test_table5", seq++);
+	batch_end(batch, seq++);
+
+	// Drop privileges to trigger EPERM
+	uid = geteuid();
+	if (uid == 0) {
+		ASSERT_EQ(seteuid(65534), 0);
+	}
+
+	ret = mnl_socket_sendto(self->nl, mnl_nlmsg_batch_head(batch),
+				mnl_nlmsg_batch_size(batch));
+
+	// Restore privileges
+	if (uid == 0) {
+		seteuid(uid);
+	}
+
+	ASSERT_GT(ret, 0);
+
+	// EPERM is fatal and should abort batch, expect only 1 ACK
+	validate_res(self->nl, seq - 4, 1, _metadata);
+
+	mnl_nlmsg_batch_stop(batch);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/net/netfilter/nfnetlink.sh b/tools/testing/selftests/net/netfilter/nfnetlink.sh
new file mode 100755
index 000000000000..3d264a4bde6f
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nfnetlink.sh
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+# If nft_ct is a module and is loaded, remove it to test module auto-loading.
+# If removal fails, continue anyway since it won't affect the test result.
+rmmod nft_ct 2>/dev/null
+./nfnetlink
\ No newline at end of file
-- 
2.34.1

