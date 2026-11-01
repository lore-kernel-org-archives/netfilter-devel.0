Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793521073;
	b=MGKJbtUteDLq56GcQIq7QFtma6EQxmotsaJJmwUy/cqlMpRHuoeZZZD8sQ+hcrCdR8ts
	 JfjVZ+6f2VjsZTzUphTvmJWHv++XZ0qD5iBhMCgqkh8L9rG8MD3RHKThzXwipOtUbguiN
	 O1ZZnaV5Z14xI3ipqL541vXSfZLesZxQyMQkCg7q4Rk6DxwD2PKIKWYH63qKRIpQH3AAC
	 H+MB+nVaqd/0RUYWnjDfAE4weS5zZcFZzmwrQvavcaC6oJ69btkaz6gqnlr2ugVvWrO56
	 wsn7z9Q/PPnLG5LIY4A2uWslQm4ca4t4dmafDTQhh3oyGUx7Hadk/ex9LZw7NEiJqVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793521073;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QcfjJsTF/PzZsq0pp89MIFI9OrI6d1YbyNN4vvIC+34=;
	b=lhfFvhB69NsxEkItydjSlMt7aIORBv9VlZRn0ceEixsbAXJqHzxnd/BrKvRY9fUcN7Pc
	 x2u6ObyCa0faxaEdl2sdwXCatqn3bf/SGZ7NZ2TA8gnxW6S/aSi+2u8BDsYHtaHkznQDi
	 FyAoEhgajxFIFeC58UNG64nxzrTOAXVtRw1sAWy3PVE4tnFLZNmFmaf/68N+2xmkfpuE3
	 CkxlNYVWCG9m2nWRHCFu9r1JjJQV1/njayDCM2qmpzwbtnjWvcc7olW39MQBQL+KoHbKo
	 wwXOfiC/GeMcjZ5NfBhvopTTCGQM7wdpqH2paHbmu+S0Gd9d7tnNGzBwr4dGqFvhnuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e8e8M3op;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD76606A337
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 08:17:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AD76606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e8e8M3op
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3ab41538192so1727401a91.0
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 01:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793521072; x=1794125872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QcfjJsTF/PzZsq0pp89MIFI9OrI6d1YbyNN4vvIC+34=;
        b=e8e8M3oplfgu5sCEqtHoHQEyAn0EuYk2yBGHdapnBg0ZMprlQ4nqm1ZwDPbBKayJab
         s0cqprNNEPneFYAXDPQ4XFvisR13ReC11uu4CmlWz1sBAlue+bi72FRuCAj9R0n3V/fK
         B0IeyTADL1R0Xi4WAaN/gSLCn6xasCwYjByONBsRo8tgdP9wHHCNRtBfv4PpXkASbTeV
         433cAL1np3FyKbFdZibworL1HTNwbh4l4fCgQJc11ahxKh2Gi+4uQsjWYjYPVTutAi5Z
         33boMkwOZQbpz6fRDCW7gXEzF/7CuoOMNyPV2H1nJuxGBMTA4UvBxzmpF4LexK8m6Mmj
         7jDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793521072; x=1794125872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QcfjJsTF/PzZsq0pp89MIFI9OrI6d1YbyNN4vvIC+34=;
        b=1fXZmxBwlKQgTYlk2wHmRzJ4n8eTU1d60ML0Ey53YmDiAFABgrxpmDrxLlczy77ku0
         DcKE0pC0/2+EdG6meICyVwbkrM40eEkKfKG6EbTnXmOwZOSqpiDdX+NlJfwwfixoWZwj
         gKChVSicReHHZESPOFYTjd1/cqZ34YS8ovwWS7hJuV5KMnajBVUtOzrMxdlBysW8I2rq
         SxpqCWL2KIY/8XAHIi3OplnWi2xr0eS2AWtVHU/cH4Xj/hhoDEdJFbAgXsLUe+QaW+hY
         yJ4/w5nv4e985H9GtIbm3wkzYB5zWad5pzPa+gq7gf8u+Ldk4iz/+1b/Cbzygp+Du7ie
         fdlQ==
X-Forwarded-Encrypted: i=1; AKwUvBwhwrVw7eZ89tBSevJa7UR8k9yuIPHVidW0p1n5Nss87WvgtdU2SCswR3zFdKXh2+7yBoXpJ+zwD9o+Nteoqv8=@vger.kernel.org
X-Gm-Message-State: APuU4Z+SPMDGbQf7mjn0cuCJzI80RvH9/vryyC8f5dSnpJfSxae7XUPL
	qu+fzymXYekq5vuMDk3mkj0sK8R0guV3fDb901NNv2/mPsEk3WM2SDMr
X-Gm-Gg: AYBFou3//boqVZRzVQ2N89Q26MG2ZxHWDij71dTyKmo6n7bCSshc6eTOntRG6iEMJxr
	tpwdeyogqBRR8NTkK3Munut6HRUIePIxEBWuxWvgYQbE9ZcefuV2AyrWvlFBMnRrvgYR4ugGwXA
	kZ7X6Qt3Auf5GfpkIi4V62kEdLH2LEBNvCx3JYGXkueUiAcWc4QKwzBe4LFAE9PvTkc64+ygG1n
	C/1DIg9PeAjwukcDRgckIDYaghoCc9lFMPTQDbAT3qfrGDhnQ5wmhDdq/3cGA8QX7ay0ukgN/su
	AZ4oUVbtOWMzAMK4A5NsomQw/yFcglgAKl7msW8O3TGnSSOHX14U2aXeW9umUcLqUQMghjPY8fz
	t6Aax5Oy2r1qYptiEbIP8/BF9SZMtqOF3R1VT3MFN9USixw0bGPxBOASYKPcR3VZuvl+3D8bKFy
	eWGPJwwCkBdykRaoY4+RVpQ2d+JNGNQOKnoe1v+tG0TJawIh725wjT8guFU8Gmhmk0V0HUr/1p3
	GTlUVSXDqM875C6/eCGZvUOl346jO/1ITIkPppFqbL1J1yLfRAUt5v9SkicQsj7c+Cij0n3Q8xM
	c8J/UAK32J0KAtI4lheV7RekXfpJnwVSqN4wHxWVpuatQFDm2esQ/IuGhIRjuZaDYaKBMB0YESU
	QLQ==
X-Received: by 2002:a17:90b:17c1:b0:3ac:9706:7739 with SMTP id 98e67ed59e1d1-3ae89724dfcmr5080442a91.17.1793521072372;
        Sun, 01 Nov 2026 01:17:52 -0700 (PDT)
Received: from LDYT9Q2G2M ([2a09:bac5:cad2:3228::4ff:28])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae84596e3bsm10011455a91.9.2026.11.01.01.17.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 01 Nov 2026 01:17:51 -0700 (PDT)
From: Zhiqi Zhang <zhiqizhangg@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	kunit-dev@googlegroups.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Finke Lennart <lfinke@student.ethz.ch>,
	netfilter-devel@vger.kernel.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	netdev@vger.kernel.org
Subject: [PATCH v2 2/2] lib/ts_fsm: add KUnit coverage for exported patterns
Date: Sun,  1 Nov 2026 16:17:36 +0800
Message-ID: <20261101081736.51803-3-zhiqizhangg@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261101081736.51803-1-zhiqizhangg@gmail.com>
References: <20261101081736.51803-1-zhiqizhangg@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add regression coverage for exporting an FSM pattern and preparing another
configuration from it. Check all 14 public token types with positive and
negative matching examples, and a sequence containing a repeated class.

Compare the exported bytes with the input pattern as well as checking
matching behaviour. Verify that the original configuration remains usable
after exporting and recreating the pattern. Register cleanup actions so
that early assertion failures still destroy the configurations.

OpenAI Codex drafted these tests and the changelog and drove the recorded
automated validation.

Signed-off-by: Zhiqi Zhang <zhiqizhangg@gmail.com>
---
 lib/Kconfig.debug                |  14 ++++
 lib/tests/Makefile               |   1 +
 lib/tests/textsearch_fsm_kunit.c | 138 +++++++++++++++++++++++++++++++
 3 files changed, 153 insertions(+)
 create mode 100644 lib/tests/textsearch_fsm_kunit.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2d22638ec..416d033b0 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2531,6 +2531,20 @@ config STRING_HELPERS_KUNIT_TEST
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
 
+config TEXTSEARCH_FSM_KUNIT_TEST
+	tristate "KUnit tests for FSM text search" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	select TEXTSEARCH
+	select TEXTSEARCH_FSM
+	default KUNIT_ALL_TESTS
+	help
+	  Test that exporting and recreating an FSM text search configuration
+	  preserves its matching behaviour. Exercise each public token type
+	  and a sequence of tokens with a repeated character class. Check
+	  that exporting also leaves the original configuration usable.
+
+	  If unsure, say N.
+
 config STRING_KUNIT_BENCH
        bool "Benchmark string functions at runtime"
        depends on STRING_KUNIT_TEST
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index df0537e1b..fa47ef5d3 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -54,6 +54,7 @@ CFLAGS_stackinit_kunit.o += $(call cc-disable-warning, switch-unreachable)
 obj-$(CONFIG_STACKINIT_KUNIT_TEST) += stackinit_kunit.o
 obj-$(CONFIG_STRING_KUNIT_TEST) += string_kunit.o
 obj-$(CONFIG_STRING_HELPERS_KUNIT_TEST) += string_helpers_kunit.o
+obj-$(CONFIG_TEXTSEARCH_FSM_KUNIT_TEST) += textsearch_fsm_kunit.o
 obj-$(CONFIG_USERCOPY_KUNIT_TEST) += usercopy_kunit.o
 obj-$(CONFIG_UTIL_MACROS_KUNIT) += util_macros_kunit.o
 obj-$(CONFIG_RATELIMIT_KUNIT_TEST) += test_ratelimit.o
diff --git a/lib/tests/textsearch_fsm_kunit.c b/lib/tests/textsearch_fsm_kunit.c
new file mode 100644
index 000000000..6cb173b97
--- /dev/null
+++ b/lib/tests/textsearch_fsm_kunit.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Tests for exporting and recreating FSM text search configurations. */
+
+#include <kunit/test.h>
+#include <linux/limits.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/textsearch.h>
+#include <linux/textsearch_fsm.h>
+
+struct fsm_test_case {
+	const char *name;
+	u16 type;
+	const char *match;
+	const char *miss;
+};
+
+static const struct fsm_test_case fsm_test_cases[] = {
+	{ "specific", TS_FSM_SPECIFIC, "x", "y" },
+	{ "wildcard", TS_FSM_WILDCARD, "A", "" },
+	{ "digit", TS_FSM_DIGIT, "7", "A" },
+	{ "xdigit", TS_FSM_XDIGIT, "f", "g" },
+	{ "print", TS_FSM_PRINT, "A", "\n" },
+	{ "alpha", TS_FSM_ALPHA, "A", "7" },
+	{ "alnum", TS_FSM_ALNUM, "7", "!" },
+	{ "ascii", TS_FSM_ASCII, "A", "\200" },
+	{ "cntrl", TS_FSM_CNTRL, "\n", "A" },
+	{ "graph", TS_FSM_GRAPH, "!", " " },
+	{ "lower", TS_FSM_LOWER, "a", "A" },
+	{ "upper", TS_FSM_UPPER, "A", "a" },
+	{ "punct", TS_FSM_PUNCT, "!", "A" },
+	{ "space", TS_FSM_SPACE, " ", "A" },
+};
+
+static void fsm_case_to_desc(const struct fsm_test_case *params, char *desc)
+{
+	snprintf(desc, KUNIT_PARAM_DESC_SIZE, "%s", params->name);
+}
+
+KUNIT_ARRAY_PARAM(fsm, fsm_test_cases, fsm_case_to_desc);
+
+static void fsm_destroy_config(void *conf)
+{
+	textsearch_destroy(conf);
+}
+
+static void fsm_expect_matches(struct kunit *test, struct ts_config *conf,
+			       const struct fsm_test_case *params)
+{
+	struct ts_state state = {};
+	unsigned int pos;
+
+	pos = textsearch_find_continuous(conf, &state, params->match,
+					 strlen(params->match));
+	KUNIT_EXPECT_EQ(test, pos, 0U);
+	pos = textsearch_find_continuous(conf, &state, params->miss,
+					 strlen(params->miss));
+	KUNIT_EXPECT_EQ(test, pos, UINT_MAX);
+}
+
+static void fsm_check_roundtrip(struct kunit *test,
+				const struct ts_fsm_token *pattern,
+				unsigned int len,
+				const struct fsm_test_case *params)
+{
+	struct ts_fsm_token *exported;
+	struct ts_config *conf, *recreated;
+	int err;
+
+	conf = textsearch_prepare("fsm", pattern, len, GFP_KERNEL, TS_AUTOLOAD);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, conf);
+	err = kunit_add_action_or_reset(test, fsm_destroy_config, conf);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	fsm_expect_matches(test, conf, params);
+
+	KUNIT_ASSERT_EQ(test, textsearch_get_pattern_len(conf), len);
+	exported = kunit_kmalloc(test, len, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, exported);
+	memcpy(exported, textsearch_get_pattern(conf), len);
+	KUNIT_EXPECT_MEMEQ(test, exported, pattern, len);
+
+	/* Exporting a pattern must preserve the existing search behaviour. */
+	fsm_expect_matches(test, conf, params);
+
+	recreated = textsearch_prepare("fsm", exported, len, GFP_KERNEL,
+				       TS_AUTOLOAD);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL_MSG(test, recreated,
+					 "exported token: type=%u recur=%u value=%u",
+					 exported->type, exported->recur,
+					 exported->value);
+	err = kunit_add_action_or_reset(test, fsm_destroy_config, recreated);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	fsm_expect_matches(test, recreated, params);
+	fsm_expect_matches(test, conf, params);
+}
+
+static void fsm_test_pattern_roundtrip(struct kunit *test)
+{
+	const struct fsm_test_case *params = test->param_value;
+	struct ts_fsm_token pattern = {
+		.type = params->type,
+		.recur = TS_FSM_SINGLE,
+		.value = 'x',
+	};
+
+	fsm_check_roundtrip(test, &pattern, sizeof(pattern), params);
+}
+
+static void fsm_test_sequence_roundtrip(struct kunit *test)
+{
+	static const struct ts_fsm_token pattern[] = {
+		{ TS_FSM_DIGIT, TS_FSM_MULTI, 0 },
+		{ TS_FSM_SPECIFIC, TS_FSM_SINGLE, ':' },
+		{ TS_FSM_UPPER, TS_FSM_SINGLE, 0 },
+	};
+	static const struct fsm_test_case params = {
+		.match = "77:A",
+		.miss = "77:a",
+	};
+
+	fsm_check_roundtrip(test, pattern, sizeof(pattern), &params);
+}
+
+static struct kunit_case fsm_kunit_test_cases[] = {
+	KUNIT_CASE_PARAM(fsm_test_pattern_roundtrip, fsm_gen_params),
+	KUNIT_CASE(fsm_test_sequence_roundtrip),
+	{}
+};
+
+static struct kunit_suite fsm_test_suite = {
+	.name = "textsearch-fsm",
+	.test_cases = fsm_kunit_test_cases,
+};
+
+kunit_test_suite(fsm_test_suite);
+
+MODULE_DESCRIPTION("FSM text search configuration tests");
+MODULE_LICENSE("GPL");
-- 
2.54.0 (Apple Git-157)

