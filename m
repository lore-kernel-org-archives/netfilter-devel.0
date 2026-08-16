Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D7E39AD5E
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 17:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786900018; cv=none; b=gicdOs5oHxWco0ptWVkPblUDIDDR6oBgENTho8pRbasRo1dwWETvtDM2TZupnO+SZHbBTaXVfHg5Mk3/LG0gUTOD85WenmQCs/zvwm3v2jpR17iEZ4SdS+Yty3eJ22YxeRSZZbKjrMeAnYSz1Yxil5+vYV5fNnZs73ComdzarrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786900018; c=relaxed/simple;
	bh=8qNZFThDXTxE9NVGLl+9G6+Cxvg4naDwuzb6SLiQuLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJUdR/S6gsejV/dpQ9gHFDVUiq9OEKrvaDQWZq2f79zyNFlxDKAhjQKd+B7WW0PuTCQEsBEGDvYRdc9hHjW1dn1GjUi1H59q689AhDYlYMIsLPyxHZ+8CFW0Bp/tEUOEbb7cBPfgh9e0Pq4NAbY8WbN+Z9rZInn3D7W7AFmiDIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fzthR3dV; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fzthR3dV"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49558ce01afso19860295e9.1
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Aug 2026 10:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786900015; x=1787504815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DuxZwIcZAysRXAH+nqg9/bm9jSLM6Ud0irjYjttvIoA=;
        b=fzthR3dVk9U3y091A60F0Uqa32RnnaFYOL2tYceOYODk7VRFf0UCUjyeMLokhQ4Q+B
         iuAG5LvmH/ATF33anQ1YGU67njKr+s2/TZVbcxtzdlOU1fbyzwIe4d+VnoXuBY1aEVha
         PuqgMHBo1GG9BQRNpZtfHoC0B54WspLtzoSfZIiujcCASH71/OSsGXYjuZXPQJ8lJ5pD
         gy/aaS7uuqNaDQxRxfN5yxkeK47r2MFzQSdpwAu7MbfLJfSqvHDKeED2+baUcoebdFrK
         viJUFurCLGTOId48wgzamAvnTvwqvijW8w++w36ciN38z0ByMMbQCsyjf+HIsXmZpdzu
         HsAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786900015; x=1787504815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DuxZwIcZAysRXAH+nqg9/bm9jSLM6Ud0irjYjttvIoA=;
        b=YRvrIB5zMKPdCgXs750t3g8OFAh5NWQwm0pI8bAJpCx3bubhObd/dttWG4o7sBAkco
         TiPUSC4KmZykDOrp7wOPAk5F5P680quoDPCPKc8PS2oU88xLH60KG0HSUAojCYhZllw5
         Z/6U5pAKIqcDMHpHlilYu+Z6PjVDr2jgMv5XX6dQfjrUx9NfhiOa/sxVXg6WfHA7JSpg
         S/zlp3G2c3NP07hYAXKNkYHn8FzvsPm/Ht5Qou+m61W6hkc3ELbMqAd/Qxqd9VQ+gCrI
         lZOKpPpx586mnjPTm0cKiCPUaouKqhnLYtTqAwNSaClAmd80cD3w3JmYzyOqz7w1lSlp
         oxUA==
X-Forwarded-Encrypted: i=1; AHgh+Roz2hGPYQg5pvhA1l2Da1CpdzjRSVlFA+TGqI5sgXSSXnP2dXe3jmr94pkSYJOs4qaFr8/gZm02nfDuG1juxWE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6/3S0T+eAmY62jGpZudhclZnPBVZCjP1eVuh0ZWTEQB/83hJZ
	Eb+YRHAmREEt8P2nAddHDivkh13rhPiTaaH7YQSCEbGCVK/qoVOcA05J
X-Gm-Gg: AR+sD133yFZnAY+u5gWJumFLoReI2zLEmZM8y7HbOWw49CfTLowmizw4ZxNIPRWDlaM
	kypmv+9XywZ2sa68nJPQLNVzPuxCrXTEXWu4Vmz4cRWFnRIZfvHKINFU97tKi48VKTqdCX/wFrL
	wxedvh9UMSKlgeEYhpAmP+LRPBm5UUl9/OQb32bKCh7jh3xyS7Jd8XOrV2lYGhYKDH0zZljB6ef
	NYKom0N4rs4V3XosSzzY0vrFax2myBtyEi3YFTbiTnJ/mm1b7FDECYrZOEMVU6tMLWCBm6YqwE9
	1kFKmVlZ/5T80dnr1PxdRSwl2d6UvnJYXM0g6iD9uizldkdmEDvBPGwuqpfk/dBt9125hmsardw
	IEO/AgDAKVWFMlZiFv6mumnxYPUJFTrwgSrT57/zRyF9gSlo7oG8Q6RzL4mkqG32YROAQdvRogG
	tp1ZCPclhWDX/O5/HoBRQyznwIPs6TBbYtpHlx6WUUxtZeqzZQBh381lAD+k1c4ywe4f3jgs3hh
	Fme8z/5LfIn9J9Y1E0ST/DTIdCXIuAburzzajoH9hrZ8V0P38HWgX9iz9UQdLGetj3XztC5/BeP
	vlf6b7Y1rnO7PltdTF9ZvIxITMaUPn98XlkyqUM=
X-Received: by 2002:a05:600c:8218:b0:499:593b:a15b with SMTP id 5b1f17b1804b1-499879357cemr334789675e9.1.1786900014893;
        Sun, 16 Aug 2026 10:06:54 -0700 (PDT)
Received: from localhost.localdomain (p54a14b85.dip0.t-ipconnect.de. [84.161.75.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999618acafsm55671335e9.14.2026.08.16.10.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 10:06:54 -0700 (PDT)
From: Bernard Ladenthin <bernard.ladenthin@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	kunit-dev@googlegroups.com,
	davem@davemloft.net,
	Bernard Ladenthin <bernard.ladenthin@gmail.com>
Subject: [PATCH 2/4] lib/tests: add KUnit tests for the textsearch infrastructure
Date: Sun, 16 Aug 2026 19:05:38 +0200
Message-ID: <20260816170541.3384-3-bernard.ladenthin@gmail.com>
X-Mailer: git-send-email 2.49.0.windows.1
In-Reply-To: <20260816170541.3384-1-bernard.ladenthin@gmail.com>
References: <20260816170541.3384-1-bernard.ladenthin@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

lib/textsearch.c and the algorithms registered with it have had no test
coverage since the infrastructure was added in 2005. Every bug found in
lib/ts_bm.c since then was found by inspection, or by a user hitting it in
production:

  commit 3f330317ab49 ("[TEXTSEARCH]: Fix broken good shift array calculation in Boyer-Moore")
  commit 3ffaa8c7c0f8 ("[TEXTSEARCH]: Fix Boyer Moore initialization bug")
  commit aebb6a849cfe ("textsearch: fix Boyer-Moore text search bug")
  commit 6f67fbf8192d ("lib/ts_bm: reset initial match offset for every block of text")
  commit 9003ec6f7f39 ("lib/ts_bm: fix integer overflow in pattern length calculation")

Add a KUnit suite that runs the same cases against every algorithm taking
a plain byte-string pattern. All implementations are then held to the same
interface contract. The cases cover matches at the start, middle and end
of the text, the absence of a match, pattern accessors, rejection of
zero-length patterns, and that textsearch_next() advances and eventually
terminates.

Three of the five fixes listed above concern multi-block handling. The
suite therefore also drives the algorithms through a get_next_block() that
hands the text out in fixed-size chunks, the way skb_seq_read() does.
Those cases check what has to hold for any block layout. A match contained
in a single block is found. Every reported offset is a real match.
Iteration makes progress and terminates. Matches spanning a block boundary
are left alone, since ts_bm documents those as missed while ts_kmp finds
them.

ts_fsm is not covered. fsm_init() consumes an array of struct ts_fsm_token
rather than a byte string, so it cannot share these test vectors.

The loop in ts_next_advances is bounded. An algorithm that fails to
advance then reports a failure instead of hanging the test run.

Signed-off-by: Bernard Ladenthin <bernard.ladenthin@gmail.com>
---
This is my first kernel submission. Corrections on anything I got wrong in
the process are welcome.

 lib/Kconfig.debug            |  19 ++
 lib/tests/Makefile           |   1 +
 lib/tests/textsearch_kunit.c | 327 +++++++++++++++++++++++++++++++++++
 3 files changed, 347 insertions(+)
 create mode 100644 lib/tests/textsearch_kunit.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1244dcac2294..783cf6bf1469 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3531,6 +3531,25 @@ config GLOB_KUNIT_TEST
 
 	  If unsure, say N
 
+config TEXTSEARCH_KUNIT_TEST
+	tristate "Textsearch infrastructure test" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	select TEXTSEARCH
+	select TEXTSEARCH_KMP
+	select TEXTSEARCH_BM
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to test the textsearch infrastructure at
+	  runtime.
+
+	  This test suite exercises lib/textsearch.c together with the
+	  string-pattern algorithms registered with it. The same cases are
+	  run against every algorithm, checking the reported match offsets
+	  and that repeated searches over one buffer make progress and
+	  terminate.
+
+	  If unsure, say N
+
 endif # RUNTIME_TESTING_MENU
 
 config ARCH_USE_MEMTEST
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index 4ead57602eac..a2d0390c18d4 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -54,6 +54,7 @@ CFLAGS_stackinit_kunit.o += $(call cc-disable-warning, switch-unreachable)
 obj-$(CONFIG_STACKINIT_KUNIT_TEST) += stackinit_kunit.o
 obj-$(CONFIG_STRING_KUNIT_TEST) += string_kunit.o
 obj-$(CONFIG_STRING_HELPERS_KUNIT_TEST) += string_helpers_kunit.o
+obj-$(CONFIG_TEXTSEARCH_KUNIT_TEST) += textsearch_kunit.o
 obj-$(CONFIG_USERCOPY_KUNIT_TEST) += usercopy_kunit.o
 obj-$(CONFIG_UTIL_MACROS_KUNIT) += util_macros_kunit.o
 obj-$(CONFIG_RATELIMIT_KUNIT_TEST) += test_ratelimit.o
diff --git a/lib/tests/textsearch_kunit.c b/lib/tests/textsearch_kunit.c
new file mode 100644
index 000000000000..b8a79240366d
--- /dev/null
+++ b/lib/tests/textsearch_kunit.c
@@ -0,0 +1,327 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for the textsearch infrastructure.
+ *
+ * The cases below are run against every string-pattern algorithm registered
+ * with lib/textsearch.c, so that all implementations are held to the same
+ * interface contract.
+ *
+ * ts_fsm is deliberately not covered: fsm_init() consumes an array of
+ * struct ts_fsm_token rather than a plain byte string, so it cannot share
+ * these test vectors.
+ */
+
+#include <kunit/test.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/textsearch.h>
+
+static const char * const ts_algo_names[] = { "kmp", "bm" };
+
+static void ts_algo_desc(const char * const *algo, char *desc)
+{
+	strscpy(desc, *algo, KUNIT_PARAM_DESC_SIZE);
+}
+
+KUNIT_ARRAY_PARAM(ts_algo, ts_algo_names, ts_algo_desc);
+
+/*
+ * Build a configuration for the algorithm under test. Skips the case rather
+ * than failing it when the algorithm is not registered, so that a kernel
+ * built without, say, CONFIG_TEXTSEARCH_BM still reports cleanly.
+ */
+static struct ts_config *ts_conf_get(struct kunit *test, const char *pattern)
+{
+	const char *algo = *(const char * const *)test->param_value;
+	struct ts_config *conf;
+
+	conf = textsearch_prepare(algo, pattern, strlen(pattern),
+				  GFP_KERNEL, TS_AUTOLOAD);
+	if (IS_ERR(conf))
+		kunit_skip(test, "algorithm \"%s\" not registered (%pe)",
+			   algo, conf);
+
+	return conf;
+}
+
+static void ts_find_middle(struct kunit *test)
+{
+	static const char text[] = "We dance the funky chicken";
+	static const char pattern[] = "chicken";
+	struct ts_config *conf = ts_conf_get(test, pattern);
+	struct ts_state state;
+
+	KUNIT_EXPECT_EQ(test,
+			textsearch_find_continuous(conf, &state, text,
+						   strlen(text)),
+			strlen(text) - strlen(pattern));
+
+	textsearch_destroy(conf);
+}
+
+static void ts_find_at_start(struct kunit *test)
+{
+	static const char text[] = "abcdefg";
+	static const char pattern[] = "abc";
+	struct ts_config *conf = ts_conf_get(test, pattern);
+	struct ts_state state;
+
+	KUNIT_EXPECT_EQ(test,
+			textsearch_find_continuous(conf, &state, text,
+						   strlen(text)),
+			0);
+
+	textsearch_destroy(conf);
+}
+
+static void ts_find_at_end(struct kunit *test)
+{
+	static const char text[] = "abcdefg";
+	static const char pattern[] = "efg";
+	struct ts_config *conf = ts_conf_get(test, pattern);
+	struct ts_state state;
+
+	KUNIT_EXPECT_EQ(test,
+			textsearch_find_continuous(conf, &state, text,
+						   strlen(text)),
+			4);
+
+	textsearch_destroy(conf);
+}
+
+static void ts_find_no_match(struct kunit *test)
+{
+	static const char text[] = "abcdefg";
+	static const char pattern[] = "xyz";
+	struct ts_config *conf = ts_conf_get(test, pattern);
+	struct ts_state state;
+
+	KUNIT_EXPECT_EQ(test,
+			textsearch_find_continuous(conf, &state, text,
+						   strlen(text)),
+			UINT_MAX);
+
+	textsearch_destroy(conf);
+}
+
+/*
+ * textsearch_find() resets state->offset and textsearch_next() relies on the
+ * algorithm having advanced it past the match it just reported. An algorithm
+ * that leaves state->offset alone reports the same position forever.
+ */
+static void ts_next_advances(struct kunit *test)
+{
+	static const char text[] = "aaaa";
+	static const char pattern[] = "aa";
+	struct ts_config *conf = ts_conf_get(test, pattern);
+	unsigned int pos, prev;
+	struct ts_state state;
+	int i;
+
+	pos = textsearch_find_continuous(conf, &state, text, strlen(text));
+	KUNIT_ASSERT_EQ(test, pos, 0);
+
+	/* Bounded so that a non-advancing algorithm fails instead of hanging. */
+	for (i = 0; i < 8; i++) {
+		prev = pos;
+
+		pos = textsearch_next(conf, &state);
+		if (pos == UINT_MAX)
+			break;
+
+		KUNIT_ASSERT_GT_MSG(test, pos, prev,
+				    "textsearch_next() reported %u after %u; it must advance past the previous match",
+				    pos, prev);
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, pos, UINT_MAX,
+			    "search did not terminate within 8 iterations");
+
+	textsearch_destroy(conf);
+}
+
+/* The full set of matches must be reported exactly once, in order. */
+static void ts_next_finds_all(struct kunit *test)
+{
+	static const char text[] = "xxABxxABxx";
+	static const char pattern[] = "AB";
+	static const unsigned int expect[] = { 2, 6 };
+	struct ts_config *conf = ts_conf_get(test, pattern);
+	struct ts_state state;
+	unsigned int pos;
+	int i;
+
+	pos = textsearch_find_continuous(conf, &state, text, strlen(text));
+
+	for (i = 0; i < ARRAY_SIZE(expect); i++) {
+		KUNIT_ASSERT_EQ_MSG(test, pos, expect[i],
+				    "match %d: expected offset %u, got %u",
+				    i, expect[i], pos);
+		pos = textsearch_next(conf, &state);
+	}
+
+	KUNIT_EXPECT_EQ_MSG(test, pos, UINT_MAX,
+			    "expected exactly %zu matches", ARRAY_SIZE(expect));
+
+	textsearch_destroy(conf);
+}
+
+/*
+ * A block source that hands the text out in fixed-size chunks, so that the
+ * algorithms are driven the way a non-linear skb drives them. Boundaries sit
+ * at multiples of @chunk, mirroring skb_seq_read().
+ */
+struct ts_chunk_state {
+	const char	*data;
+	unsigned int	len;
+	unsigned int	chunk;
+};
+
+static unsigned int ts_get_chunk(unsigned int consumed, const u8 **dst,
+				 struct ts_config *conf,
+				 struct ts_state *state)
+{
+	struct ts_chunk_state *cs = (struct ts_chunk_state *)state->cb;
+	unsigned int end;
+
+	if (consumed >= cs->len)
+		return 0;
+
+	end = (consumed / cs->chunk + 1) * cs->chunk;
+	if (end > cs->len)
+		end = cs->len;
+
+	*dst = (const u8 *)cs->data + consumed;
+	return end - consumed;
+}
+
+static unsigned int ts_find_chunked(struct ts_config *conf,
+				    struct ts_state *state, const char *text,
+				    unsigned int len, unsigned int chunk)
+{
+	struct ts_chunk_state *cs = (struct ts_chunk_state *)state->cb;
+
+	BUILD_BUG_ON(sizeof(struct ts_chunk_state) > sizeof(state->cb));
+
+	conf->get_next_block = ts_get_chunk;
+	cs->data = text;
+	cs->len = len;
+	cs->chunk = chunk;
+
+	return textsearch_find(conf, state);
+}
+
+/*
+ * A match that lies entirely inside one block must be found no matter how the
+ * text is split up. Matches spanning a block boundary are deliberately not
+ * covered: ts_bm documents those as missed, ts_kmp finds them.
+ */
+static void ts_blocks_match_within_block(struct kunit *test)
+{
+	static const char text[] = "xxxxABCDxxxx";
+	static const char pattern[] = "ABCD";
+	struct ts_config *conf = ts_conf_get(test, pattern);
+	struct ts_state state;
+
+	/* chunk 4 puts "ABCD" exactly in the second block */
+	KUNIT_EXPECT_EQ_MSG(test,
+			    ts_find_chunked(conf, &state, text,
+					    strlen(text), 4),
+			    4, "match inside a single block must be found");
+
+	/* one block for the whole text must agree with the chunked run */
+	KUNIT_EXPECT_EQ(test,
+			ts_find_chunked(conf, &state, text, strlen(text),
+					strlen(text)),
+			4);
+
+	textsearch_destroy(conf);
+}
+
+/* Iterating over a chunked buffer must terminate and must make progress. */
+static void ts_blocks_iteration_terminates(struct kunit *test)
+{
+	static const char text[] = "abababababab";
+	static const char pattern[] = "ab";
+	struct ts_config *conf = ts_conf_get(test, pattern);
+	unsigned int chunk, pos, prev;
+	struct ts_state state;
+	int i;
+
+	for (chunk = 1; chunk <= strlen(text); chunk++) {
+		pos = ts_find_chunked(conf, &state, text, strlen(text), chunk);
+
+		for (i = 0; i < 32 && pos != UINT_MAX; i++) {
+			KUNIT_ASSERT_LE_MSG(test, pos + strlen(pattern),
+					    strlen(text),
+					    "chunk %u: reported match at %u runs past the text",
+					    chunk, pos);
+			KUNIT_ASSERT_MEMEQ_MSG(test, text + pos, pattern,
+					       strlen(pattern),
+					       "chunk %u: offset %u is not a real match",
+					       chunk, pos);
+			prev = pos;
+			pos = textsearch_next(conf, &state);
+			if (pos == UINT_MAX)
+				break;
+			KUNIT_ASSERT_GT_MSG(test, pos, prev,
+					    "chunk %u: reported %u after %u",
+					    chunk, pos, prev);
+		}
+
+		KUNIT_EXPECT_EQ_MSG(test, pos, UINT_MAX,
+				    "chunk %u: search did not terminate", chunk);
+	}
+
+	textsearch_destroy(conf);
+}
+
+static void ts_get_pattern(struct kunit *test)
+{
+	static const char pattern[] = "chicken";
+	struct ts_config *conf = ts_conf_get(test, pattern);
+
+	KUNIT_EXPECT_EQ(test, textsearch_get_pattern_len(conf),
+			strlen(pattern));
+	KUNIT_EXPECT_MEMEQ(test, textsearch_get_pattern(conf), pattern,
+			   strlen(pattern));
+
+	textsearch_destroy(conf);
+}
+
+/* textsearch_prepare() documents -EINVAL for a zero-length pattern. */
+static void ts_prepare_zero_len(struct kunit *test)
+{
+	const char *algo = *(const char * const *)test->param_value;
+	struct ts_config *conf;
+
+	conf = textsearch_prepare(algo, "", 0, GFP_KERNEL, TS_AUTOLOAD);
+	KUNIT_ASSERT_TRUE(test, IS_ERR(conf));
+	KUNIT_EXPECT_EQ(test, PTR_ERR(conf), -EINVAL);
+}
+
+static struct kunit_case textsearch_test_cases[] = {
+	KUNIT_CASE_PARAM(ts_find_middle, ts_algo_gen_params),
+	KUNIT_CASE_PARAM(ts_find_at_start, ts_algo_gen_params),
+	KUNIT_CASE_PARAM(ts_find_at_end, ts_algo_gen_params),
+	KUNIT_CASE_PARAM(ts_find_no_match, ts_algo_gen_params),
+	KUNIT_CASE_PARAM(ts_next_advances, ts_algo_gen_params),
+	KUNIT_CASE_PARAM(ts_next_finds_all, ts_algo_gen_params),
+	KUNIT_CASE_PARAM(ts_blocks_match_within_block, ts_algo_gen_params),
+	KUNIT_CASE_PARAM(ts_blocks_iteration_terminates, ts_algo_gen_params),
+	KUNIT_CASE_PARAM(ts_get_pattern, ts_algo_gen_params),
+	KUNIT_CASE_PARAM(ts_prepare_zero_len, ts_algo_gen_params),
+	{}
+};
+
+static struct kunit_suite textsearch_test_suite = {
+	.name = "textsearch",
+	.test_cases = textsearch_test_cases,
+};
+
+kunit_test_suite(textsearch_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for the textsearch infrastructure");
+MODULE_LICENSE("GPL");
-- 
2.49.0.windows.1

