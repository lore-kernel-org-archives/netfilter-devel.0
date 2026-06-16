Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 446F13D6CAC;
	Tue, 16 Jun 2026 05:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781588605; cv=none; b=XBx8XVJk3F/xJrb78JPUh7Q/DKEejjRL+5ZCa58bYM12WrYujeJVa0TtUgwFSvkb/HYWO4Hl50BJ8PfIfDNNKgIBnvyJcsHgI+RI+R8YVQ3vV3D7EGaXPKl/01P1VUHngtyu2W8g0FyvPGS84yLgg1VtY84D1tpDAdwnoFrrScE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781588605; c=relaxed/simple;
	bh=Jc/dB/qATMwKcqjp7eug5QCGnHMmV685eL4CUSZDy28=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ix/D2ZD74xOBX4kgBmr9LD5M+DgDTXWmVF2Unm0bawbwVdekWUYwx6cth5r229R/btNBUFCTBQwBdRXp3u7RlZWJiFEzgMQ2lin2IzwAguvF1epdxXbokPy5bKr8J813JBgLKCpErVYZmJwolYhwLuKTv+I2NruI3PmSAjAC2dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=Fj9zjcO5; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="Fj9zjcO5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-Id:In-Reply-To:References:MIME-Version:
	Content-Transfer-Encoding; bh=cH+itFuMcKnoK06jUJSiW4EBWbAjsOCQxK
	Ok+cnVLos=; b=Fj9zjcO5cGtlNuzXsNM8XCP/AEXyuPSD2Z2gaAnXgZvFRCAcuV
	vmvqMzhAYVRB7OSm4DpBxiHHqHWk4bc+lNMY67KWex2r+FnBTDst/tiCRAdYL4Po
	epHbLeHHuI5RYECaO/JEUqv4/kBL4Sq+5XQ4N7dM8+xN6aoHb9xfQAj0o=
Received: from c9a6c405b3f2.. (unknown [202.112.238.121])
	by web2 (Coremail) with SMTP id yQQGZQBXMZlM4jBqXCpTAg--.51787S4;
	Tue, 16 Jun 2026 13:42:50 +0800 (CST)
From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
To: bpf@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrii@kernel.org,
	eddyz87@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	shuah@kernel.org,
	kartikey406@gmail.com,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 2/2] selftests/bpf: Cover small conntrack opts error writes
Date: Tue, 16 Jun 2026 05:42:35 +0000
Message-Id: <c4c898dd23181b676ebf6b6b4d9c54f51bb69c75.1781586477.git.chenyy23@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1781586477.git.chenyy23@mails.tsinghua.edu.cn>
References: <cover.1781586477.git.chenyy23@mails.tsinghua.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:yQQGZQBXMZlM4jBqXCpTAg--.51787S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCw17GFy5uF4xAw18Gw45KFg_yoWrWrWUpF
	93ZanFkFyrJ3W2qw1xJFs2qF45tFs7XFyUGrs3Jw4akF4kZa40vF42gF4jqF9xuFs5Zr1S
	kws5tFnxCrZ7uaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S
	6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxw
	ACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCY02Avz4vE14v_GrWl
	42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
	WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAK
	I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r
	4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
	cVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0pR6OJOUUUUU=
X-CM-SenderInfo: xfkh05r1stqzpdlo2hxwvl0wxkxdhvlgxou0/

Add a conntrack kfunc regression check for opts__sz values that do not
cover opts->error. The BPF program initializes opts->error with a guard
value, calls the lookup and allocation kfuncs with opts__sz set to
sizeof(opts->netns_id), and verifies that the guard is still intact
after the kfunc returns NULL.

Without the conntrack wrapper guard, the kfunc error path overwrites
that guard with -EINVAL even though the verifier checked only the first
four bytes of the options object.

Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
---
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  6 +++++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 26 +++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index b33dba4b126e2..14d4c1793aed5 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -5,6 +5,8 @@
 #include "test_bpf_nf.skel.h"
 #include "test_bpf_nf_fail.skel.h"
 
+#define CT_OPTS_ERROR_GUARD 0x12345678
+
 static char log_buf[1024 * 1024];
 
 struct {
@@ -119,6 +121,10 @@ static void test_bpf_nf_ct(int mode)
 	ASSERT_EQ(skel->bss->test_einval_reserved_new, -EINVAL, "Test EINVAL for reserved in new struct not set to 0");
 	ASSERT_EQ(skel->bss->test_einval_netns_id, -EINVAL, "Test EINVAL for netns_id < -1");
 	ASSERT_EQ(skel->bss->test_einval_len_opts, -EINVAL, "Test EINVAL for len__opts != NF_BPF_CT_OPTS_SZ");
+	ASSERT_EQ(skel->bss->test_einval_len_opts_small_lookup, CT_OPTS_ERROR_GUARD,
+		  "Test no error write for lookup opts__sz before error field");
+	ASSERT_EQ(skel->bss->test_einval_len_opts_small_alloc, CT_OPTS_ERROR_GUARD,
+		  "Test no error write for alloc opts__sz before error field");
 	ASSERT_EQ(skel->bss->test_eproto_l4proto, -EPROTO, "Test EPROTO for l4proto != TCP or UDP");
 	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
 	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index 076fbf03a1268..df43649ecb785 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -10,6 +10,8 @@
 #define EINVAL 22
 #define ENOENT 2
 
+#define CT_OPTS_ERROR_GUARD 0x12345678
+
 #define NF_CT_ZONE_DIR_ORIG (1 << IP_CT_DIR_ORIGINAL)
 #define NF_CT_ZONE_DIR_REPL (1 << IP_CT_DIR_REPLY)
 
@@ -19,6 +21,8 @@ int test_einval_reserved = 0;
 int test_einval_reserved_new = 0;
 int test_einval_netns_id = 0;
 int test_einval_len_opts = 0;
+int test_einval_len_opts_small_lookup = 0;
+int test_einval_len_opts_small_alloc = 0;
 int test_eproto_l4proto = 0;
 int test_enonet_netns_id = 0;
 int test_enoent_lookup = 0;
@@ -124,6 +128,28 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 	else
 		test_einval_len_opts = opts_def.error;
 
+	opts_def.error = CT_OPTS_ERROR_GUARD;
+	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		       sizeof(opts_def.netns_id));
+	if (ct) {
+		bpf_ct_release(ct);
+		test_einval_len_opts_small_lookup = -EINVAL;
+	} else {
+		test_einval_len_opts_small_lookup = opts_def.error;
+	}
+
+	opts_def.error = CT_OPTS_ERROR_GUARD;
+	ct = alloc_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
+		      sizeof(opts_def.netns_id));
+	if (ct) {
+		ct = bpf_ct_insert_entry(ct);
+		if (ct)
+			bpf_ct_release(ct);
+		test_einval_len_opts_small_alloc = -EINVAL;
+	} else {
+		test_einval_len_opts_small_alloc = opts_def.error;
+	}
+
 	opts_def.l4proto = IPPROTO_ICMP;
 	ct = lookup_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
 		       sizeof(opts_def));
-- 
2.34.1

