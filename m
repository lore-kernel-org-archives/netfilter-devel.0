Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793503333;
	b=DveTqzu9ObABWxou5oTP9mGevhhR72SkJrdjynZJfBYJyPxjmojNGiv1TT0uRgZZmMfx
	 HmxK9+cJiUBeZ1HI31QOjnT7vuiqLtNWNSh2CKPHRQ4Z2Y7295pAhdsLT+CQhbqyIcjN1
	 DKFy9cclxDG7U79p9cvePqu8DbVXi046G0oERtW5RuoqGB0UkxHKFIQyptDtYzOdsRLKp
	 fSDJs11lUVzPqgoTr3cKwFaibpZJ7xd9LhrK+MQzRGzdhXO8DD7Rt3LL+3vS+u4EoZgvb
	 qKfrl8el8b+urkJx7hV3kkRTszLah9q2bJbu00ADmzvFMaLPD8obNackjD49Yr3W0Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793503333;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=ASOAS90bvyZ7pXVSBkOD0AtmITigpjXJ5ID4H0IjZVM=;
	b=B1UmoXjTocPR1hmxzAGuGSsK/4Pvf4R7iKTfU2KZ/e/e306X6kmj8EpkESSPWQzjXWx4
	 YDHC5mTT9ciUDkFJRpv5pTLoPTy4r7PmdTHamk4c+KHOlSKLTbkxAr9RDEHOo2Zi1nJyg
	 ztzoJ0Cn2KtFn4s0rrdknsfNP9OooAkr9xCOGeljpO41HhQJFD0ILSO4c6Nc+Sh9rBuL3
	 UnY3uqF57T6zUshI2Ra2lAhpYS0nKCpHc9yr84ur9pPbWmL1w11pcKtxv9KAQnbHNFnBM
	 NhR+Q/wvHIDIaDYyXtke+8iu5DT0LgFyD1N1hqmTJPCnrcBy4rCfuduwfva41BBYojg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="TS9L7BV/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04F9606A324;
	Sun,  1 Nov 2026 03:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=TS9L7BV/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396911F000C1;
	Sun,  1 Nov 2026 03:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793503332;
	bh=ASOAS90bvyZ7pXVSBkOD0AtmITigpjXJ5ID4H0IjZVM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TS9L7BV/NrJIYxrOAsybZLoQw3AGFMtc+WdaYs+sgZF4kxeXbfosu4J4enSV+IKG0
	 3Lmwm1w0fWNhqraY5YZzQ9LwTypKrLPZj5pvAyiVJZfyMuqZCUZ46cobsYOwt07Pvt
	 LSJMMEmD7G3tC6BcNHSui75q74eAxaLxgUhmHLcw=
Date: Sat, 31 Oct 2026 20:22:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhiqi Zhang <zhiqizhangg@gmail.com>
Cc: linux-kernel@vger.kernel.org, kunit-dev@googlegroups.com, Pablo Neira
 Ayuso <pablo@netfilter.org>, Finke Lennart <lfinke@student.ethz.ch>,
 netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] lib/ts_fsm: preserve token types when exporting
 patterns
Message-Id: <20261031202211.22f18bca7819dbe2d107d17d@linux-foundation.org>
In-Reply-To: <20261031052307.23533-1-zhiqizhangg@gmail.com>
References: <20261031052307.23533-1-zhiqizhangg@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 31 Oct 2026 13:23:07 +0800 Zhiqi Zhang <zhiqizhangg@gmail.com> wrote:

> fsm_init() replaces each token type with an internal character-class mask.
> fsm_get_pattern() then returns these masks as if they were public token
> types. Exporting a pattern and preparing another FSM configuration from
> it can therefore change the matching behaviour or fail with -EINVAL.
> 
> For example, a single TS_FSM_DIGIT token (type 2) becomes the _D mask (4).
> Preparing the exported pattern interprets 4 as TS_FSM_PRINT, so the new
> configuration accepts "A" while the original rejects it. The text ematch
> dump path uses textsearch_get_pattern() to return patterns to userspace.
> 
> Keep the public token types in the configuration and look up their masks
> in match_token(). This preserves the exported representation without
> adding another pattern allocation. Initialization still validates every
> type before it can be used to index token_map.
> 
> Add KUnit coverage for exporting and recreating all token types and a
> sequence with a repeated character class. Also check that exporting and
> recreating the pattern leaves the original configuration usable.
> 

The main user of textsearch appears to be netfilter, so please let's
keep the relevant developers in the loop.

netfilter peeps: I'm seeing a small number of textsearch patches lately
and I'm totally unfamiliar with it.  Can you please propose a
MAINTAINERS patch?

hp2:/usr/src/mm> scripts/get_maintainer.pl -f --nogit --nogit-fallback --no-rolestats lib/ts_bm.c lib/ts_fsm.c lib/ts_kmp.c  
Andrew Morton <akpm@linux-foundation.org>
linux-kernel@vger.kernel.org

Lonely!




Zhiqi, a thing which is missing from the changelog, and it's really
important, is a description of the userspace-visible runtime effects of
the bug.

> I identified this issue. OpenAI Codex helped confirm it and drafted the
> fix, KUnit tests and changelog. I reviewed the fix, built it and verified
> that the tests passed.

I'm suspecting "no such effects are known".  But that isn't enough -
once the issue is out there, LLM-using bad actors might be able to find
ways of exploiting the bug, so please discuss that aspect also.

My LLM suggested

: The userspace consequence is worth spelling out: dumping and restoring
: a traffic-control rule can silently change which packets it matches, or
: fail to restore the rule with EINVAL.

Also, and fyi, it told me

: Related finding: BM/KMP also export transformed patterns. With
: TS_IGNORECASE, repeated folding of 0xff changes it again
: (ff -> df -> bf). That's a separate API roundtrip problem, but I found
: no current userspace dump/restore path exposing it: em_text doesn't
: enable that flag, and xt_string retains the original pattern.

Also, regarding your patch:

: One small test improvement: after copying the exported pattern, add
: KUNIT_EXPECT_MEMEQ(test, exported, pattern, len). That directly checks
: the exported representation as well as its matching behavior.

And I'm thinking that a cc:stable is justified here.

Thanks.

> ---
> Validation in isolated QEMU TCG guests:
> - ARM64 GCC 13.3: the same KUnit test and config change from 2/15 passing
>   before the fix to 15/15 passing afterwards.
> - ARM32 GCC 13.3 and ARM64 Clang 18.1.3: 15/15 passing.
> - An ARM64 rtnetlink smoke test creates a basic classifier with a text
>   ematch, dumps it, restores its payload, and dumps it again. The DIGIT
>   token changes 2 -> 4 -> 151 before the fix, and stays 2 afterwards.
> - W=1 for the changed objects: no warnings. Sparse reports no diagnostics
>   for these objects (an unchanged ARM64 vDSO object has a declaration
>   warning). Strict checkpatch passes after suppressing the new-file
>   MAINTAINERS reminder.
> 
> Packet traffic, module loading and throughput were not tested. Resolving
> masks in match_token() adds a lookup on nonliteral matches.
> 
>  lib/Kconfig.debug                |  14 ++++
>  lib/tests/Makefile               |   1 +
>  lib/tests/textsearch_fsm_kunit.c | 137 +++++++++++++++++++++++++++++++
>  lib/ts_fsm.c                     |   7 +-
>  4 files changed, 153 insertions(+), 6 deletions(-)
>  create mode 100644 lib/tests/textsearch_fsm_kunit.c
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 2d22638ec..416d033b0 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2531,6 +2531,20 @@ config STRING_HELPERS_KUNIT_TEST
>  	depends on KUNIT
>  	default KUNIT_ALL_TESTS
>  
> +config TEXTSEARCH_FSM_KUNIT_TEST
> +	tristate "KUnit tests for FSM text search" if !KUNIT_ALL_TESTS
> +	depends on KUNIT
> +	select TEXTSEARCH
> +	select TEXTSEARCH_FSM
> +	default KUNIT_ALL_TESTS
> +	help
> +	  Test that exporting and recreating an FSM text search configuration
> +	  preserves its matching behaviour. Exercise each public token type
> +	  and a sequence of tokens with a repeated character class. Check
> +	  that exporting also leaves the original configuration usable.
> +
> +	  If unsure, say N.
> +
>  config STRING_KUNIT_BENCH
>         bool "Benchmark string functions at runtime"
>         depends on STRING_KUNIT_TEST
> diff --git a/lib/tests/Makefile b/lib/tests/Makefile
> index df0537e1b..fa47ef5d3 100644
> --- a/lib/tests/Makefile
> +++ b/lib/tests/Makefile
> @@ -54,6 +54,7 @@ CFLAGS_stackinit_kunit.o += $(call cc-disable-warning, switch-unreachable)
>  obj-$(CONFIG_STACKINIT_KUNIT_TEST) += stackinit_kunit.o
>  obj-$(CONFIG_STRING_KUNIT_TEST) += string_kunit.o
>  obj-$(CONFIG_STRING_HELPERS_KUNIT_TEST) += string_helpers_kunit.o
> +obj-$(CONFIG_TEXTSEARCH_FSM_KUNIT_TEST) += textsearch_fsm_kunit.o
>  obj-$(CONFIG_USERCOPY_KUNIT_TEST) += usercopy_kunit.o
>  obj-$(CONFIG_UTIL_MACROS_KUNIT) += util_macros_kunit.o
>  obj-$(CONFIG_RATELIMIT_KUNIT_TEST) += test_ratelimit.o
> diff --git a/lib/tests/textsearch_fsm_kunit.c b/lib/tests/textsearch_fsm_kunit.c
> new file mode 100644
> index 000000000..bbf944ef8
> --- /dev/null
> +++ b/lib/tests/textsearch_fsm_kunit.c
> @@ -0,0 +1,137 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* Tests for exporting and recreating FSM text search configurations. */
> +
> +#include <kunit/test.h>
> +#include <linux/limits.h>
> +#include <linux/module.h>
> +#include <linux/string.h>
> +#include <linux/textsearch.h>
> +#include <linux/textsearch_fsm.h>
> +
> +struct fsm_test_case {
> +	const char *name;
> +	u16 type;
> +	const char *match;
> +	const char *miss;
> +};
> +
> +static const struct fsm_test_case fsm_test_cases[] = {
> +	{ "specific", TS_FSM_SPECIFIC, "x", "y" },
> +	{ "wildcard", TS_FSM_WILDCARD, "A", "" },
> +	{ "digit", TS_FSM_DIGIT, "7", "A" },
> +	{ "xdigit", TS_FSM_XDIGIT, "f", "g" },
> +	{ "print", TS_FSM_PRINT, "A", "\n" },
> +	{ "alpha", TS_FSM_ALPHA, "A", "7" },
> +	{ "alnum", TS_FSM_ALNUM, "7", "!" },
> +	{ "ascii", TS_FSM_ASCII, "A", "\200" },
> +	{ "cntrl", TS_FSM_CNTRL, "\n", "A" },
> +	{ "graph", TS_FSM_GRAPH, "!", " " },
> +	{ "lower", TS_FSM_LOWER, "a", "A" },
> +	{ "upper", TS_FSM_UPPER, "A", "a" },
> +	{ "punct", TS_FSM_PUNCT, "!", "A" },
> +	{ "space", TS_FSM_SPACE, " ", "A" },
> +};
> +
> +static void fsm_case_to_desc(const struct fsm_test_case *params, char *desc)
> +{
> +	snprintf(desc, KUNIT_PARAM_DESC_SIZE, "%s", params->name);
> +}
> +
> +KUNIT_ARRAY_PARAM(fsm, fsm_test_cases, fsm_case_to_desc);
> +
> +static void fsm_destroy_config(void *conf)
> +{
> +	textsearch_destroy(conf);
> +}
> +
> +static void fsm_expect_matches(struct kunit *test, struct ts_config *conf,
> +			       const struct fsm_test_case *params)
> +{
> +	struct ts_state state = {};
> +	unsigned int pos;
> +
> +	pos = textsearch_find_continuous(conf, &state, params->match,
> +					 strlen(params->match));
> +	KUNIT_EXPECT_EQ(test, pos, 0U);
> +	pos = textsearch_find_continuous(conf, &state, params->miss,
> +					 strlen(params->miss));
> +	KUNIT_EXPECT_EQ(test, pos, UINT_MAX);
> +}
> +
> +static void fsm_check_roundtrip(struct kunit *test,
> +				const struct ts_fsm_token *pattern,
> +				unsigned int len,
> +				const struct fsm_test_case *params)
> +{
> +	struct ts_fsm_token *exported;
> +	struct ts_config *conf, *recreated;
> +	int err;
> +
> +	conf = textsearch_prepare("fsm", pattern, len, GFP_KERNEL, TS_AUTOLOAD);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, conf);
> +	err = kunit_add_action_or_reset(test, fsm_destroy_config, conf);
> +	KUNIT_ASSERT_EQ(test, err, 0);
> +	fsm_expect_matches(test, conf, params);
> +
> +	KUNIT_ASSERT_EQ(test, textsearch_get_pattern_len(conf), len);
> +	exported = kunit_kmalloc(test, len, GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, exported);
> +	memcpy(exported, textsearch_get_pattern(conf), len);
> +
> +	/* Exporting a pattern must preserve the existing search behaviour. */
> +	fsm_expect_matches(test, conf, params);
> +
> +	recreated = textsearch_prepare("fsm", exported, len, GFP_KERNEL,
> +				       TS_AUTOLOAD);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL_MSG(test, recreated,
> +					 "exported token: type=%u recur=%u value=%u",
> +					 exported->type, exported->recur,
> +					 exported->value);
> +	err = kunit_add_action_or_reset(test, fsm_destroy_config, recreated);
> +	KUNIT_ASSERT_EQ(test, err, 0);
> +	fsm_expect_matches(test, recreated, params);
> +	fsm_expect_matches(test, conf, params);
> +}
> +
> +static void fsm_test_pattern_roundtrip(struct kunit *test)
> +{
> +	const struct fsm_test_case *params = test->param_value;
> +	struct ts_fsm_token pattern = {
> +		.type = params->type,
> +		.recur = TS_FSM_SINGLE,
> +		.value = 'x',
> +	};
> +
> +	fsm_check_roundtrip(test, &pattern, sizeof(pattern), params);
> +}
> +
> +static void fsm_test_sequence_roundtrip(struct kunit *test)
> +{
> +	static const struct ts_fsm_token pattern[] = {
> +		{ TS_FSM_DIGIT, TS_FSM_MULTI, 0 },
> +		{ TS_FSM_SPECIFIC, TS_FSM_SINGLE, ':' },
> +		{ TS_FSM_UPPER, TS_FSM_SINGLE, 0 },
> +	};
> +	static const struct fsm_test_case params = {
> +		.match = "77:A",
> +		.miss = "77:a",
> +	};
> +
> +	fsm_check_roundtrip(test, pattern, sizeof(pattern), &params);
> +}
> +
> +static struct kunit_case fsm_kunit_test_cases[] = {
> +	KUNIT_CASE_PARAM(fsm_test_pattern_roundtrip, fsm_gen_params),
> +	KUNIT_CASE(fsm_test_sequence_roundtrip),
> +	{}
> +};
> +
> +static struct kunit_suite fsm_test_suite = {
> +	.name = "textsearch-fsm",
> +	.test_cases = fsm_kunit_test_cases,
> +};
> +
> +kunit_test_suite(fsm_test_suite);
> +
> +MODULE_DESCRIPTION("FSM text search configuration tests");
> +MODULE_LICENSE("GPL");
> diff --git a/lib/ts_fsm.c b/lib/ts_fsm.c
> index 053615f4f..8725ea6f0 100644
> --- a/lib/ts_fsm.c
> +++ b/lib/ts_fsm.c
> @@ -126,7 +126,7 @@ _W|_L,         _W|_L,        _W|_L,        _W|_L};		/* 252-255 */
>  static inline int match_token(struct ts_fsm_token *t, u8 d)
>  {
>  	if (t->type)
> -		return (token_lookup_tbl[d] & t->type) != 0;
> +		return (token_lookup_tbl[d] & token_map[t->type]) != 0;
>  	else
>  		return t->value == d;
>  }
> @@ -288,11 +288,6 @@ static struct ts_config *fsm_init(const void *pattern, unsigned int len,
>  	fsm->ntokens = ntokens;
>  	memcpy(fsm->tokens, pattern, len);
>  
> -	for (i = 0; i < fsm->ntokens; i++) {
> -		struct ts_fsm_token *t = &fsm->tokens[i];
> -		t->type = token_map[t->type];
> -	}
> -
>  	return conf;
>  
>  errout:
> 
> base-commit: 2a500a04d6f969318c05f46aedb6e73fc1963a00
> -- 
> 2.54.0 (Apple Git-157)
