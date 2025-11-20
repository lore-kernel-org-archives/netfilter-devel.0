Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F50253958
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2025 21:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763672948; cv=none; b=onZogzzk7wL3B69WFWAldtjLL6k0SBFnM6nS20fPZu6wxMe9fc2JEwEohoV/Tv77OA/wzGsH3hl5kR5YZnS+45glX7Ko83cPJtzrGiHLxO1jWi2wqjG59cC9Rhp9KQwzVnZqohr00Lbj9HqJ5X9VEB/XiiGlGl91lwqzU8Kphjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763672948; c=relaxed/simple;
	bh=us5L7H7BGwUbW2AenhLAoupRndlCrmY6okJ//AIURUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PE6yWVqNXpT2bufp+efFyKItbvwXzvfNrZTJfRqRPsJOkVj8pU6tc19VnQM/6G/r7gxJWT8scjb+Nj3tPOZhxPgRTvxUJ72dt2JbK4LXz1CrU66/4pmQrLUlVuY/rUjuYLaj0acGa3tdm4t1ggKYOriencj+iYjqww1Px9iA91o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VpOZGvuT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VpOZGvuT"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CE38E60269;
	Thu, 20 Nov 2025 22:09:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763672943;
	bh=82nxwgk7jTuYD+joUmMmWMKZitQGDRXxhdLCDO452sY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VpOZGvuTGK1odVJaKLccvdVtvUJGRImDlu1VGHYORhvdoW5EvbWKOuZbJR/c1rP6G
	 4zusb77wj2o6MrFxdBHnJvKID/AmF69vkNUgYu/1wOo6kCOGWkpysOlPqyBYZhnSG3
	 LWEd5w39d8M1OCSxb3XsJDcmAUdJQMVR/rXW7PH0Ykm/iVrWj723MzDP1yp/0sdWd5
	 Hs8YgfKVFmdn18wW+Lm2476X1hxyT0tmdhWEcXXATUKJ1dVeRpeyTHdnwhjxznieSu
	 lGIn3dv0eSHB2hS/1awOzCbhHDOV4wX8fSVH8DZVgCdFP8fLxO3EljdppMwar40P+c
	 x4M+wiLrTGjLQ==
Date: Thu, 20 Nov 2025 22:09:00 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: move fuzzer functionality to separate tool
Message-ID: <aR-DbAhL4i1pnum3@calendula>
References: <20251120113332.10687-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251120113332.10687-1-fw@strlen.de>

On Thu, Nov 20, 2025 at 12:33:29PM +0100, Florian Westphal wrote:
> This means some loss of functionality since you can no longer combine
> --fuzzer with options like --debug, --define, --include.
> 
> On the upside, this adds new --random-outflags mode which will randomly
> switch --terse, --numeric, --echo ... on/off.
> 
> Update README to reflect this change.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks!

> ---
>  Makefile.am            |  15 +-
>  include/afl++.h        |  25 ---
>  src/afl++.c            | 219 ---------------------
>  src/main.c             |  97 ---------
>  tests/afl++/README     |  36 ++--
>  tests/afl++/run-afl.sh |   6 +-
>  tools/.gitignore       |   4 +
>  tools/nft-afl.c        | 437 +++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 479 insertions(+), 360 deletions(-)
>  delete mode 100644 src/afl++.c
>  create mode 100644 tools/nft-afl.c
> 
> diff --git a/Makefile.am b/Makefile.am
> index d2cae2a31aaa..e278a193942c 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -31,6 +31,7 @@ LDADD =
>  lib_LTLIBRARIES =
>  noinst_LTLIBRARIES =
>  sbin_PROGRAMS =
> +noinst_PROGRAMS =
>  check_PROGRAMS =
>  dist_man_MANS =
>  CLEANFILES =
> @@ -294,10 +295,6 @@ sbin_PROGRAMS += src/nft
>  
>  src_nft_SOURCES = src/main.c
>  
> -if BUILD_AFL
> -src_nft_SOURCES += src/afl++.c
> -endif
> -
>  if BUILD_CLI
>  src_nft_SOURCES += src/cli.c
>  endif
> @@ -318,6 +315,16 @@ examples_nft_json_file_LDADD = src/libnftables.la
>  
>  ###############################################################################
>  
> +if BUILD_AFL
> +noinst_PROGRAMS += tools/nft-afl
> +
> +tools_nft_afl_SOURCES = tools/nft-afl.c
> +tools_nft_afl_SOURCES += -I$(srcdir)/include
> +tools_nft_afl_LDADD = src/libnftables.la
> +endif
> +
> +###############################################################################
> +
>  if BUILD_MAN
>  
>  dist_man_MANS += \
> diff --git a/include/afl++.h b/include/afl++.h
> index a23bcef1bd0d..69858295ed7c 100644
> --- a/include/afl++.h
> +++ b/include/afl++.h
> @@ -20,29 +20,4 @@ enum nft_afl_fuzzer_stage {
>  	NFT_AFL_FUZZER_NETLINK_RW,
>  };
>  
> -static inline void nft_afl_print_build_info(FILE *fp)
> -{
> -#if HAVE_FUZZER_BUILD && defined(FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION)
> -	fprintf(fp, "\nWARNING: BUILT WITH FUZZER SUPPORT AND AFL INSTRUMENTATION\n");
> -#elif defined(FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION)
> -	fprintf(fp, "\nWARNING: BUILT WITH AFL INSTRUMENTATION\n");
> -#elif HAVE_FUZZER_BUILD
> -	fprintf(fp, "\nWARNING: BUILT WITH FUZZER SUPPORT BUT NO AFL INSTRUMENTATION\n");
> -#endif
> -}
> -
> -#if HAVE_FUZZER_BUILD
> -extern int nft_afl_init(struct nft_ctx *nft, enum nft_afl_fuzzer_stage s);
> -extern int nft_afl_main(struct nft_ctx *nft);
> -#else
> -static inline int nft_afl_main(struct nft_ctx *ctx)
> -{
> -        return -1;
> -}
> -static inline int nft_afl_init(struct nft_ctx *nft, enum nft_afl_fuzzer_stage s){ return -1; }
> -#endif
> -
> -#ifndef FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
> -#define __AFL_INIT() do { } while (0)
> -#endif
>  #endif
> diff --git a/src/afl++.c b/src/afl++.c
> deleted file mode 100644
> index 79925952cd6f..000000000000
> --- a/src/afl++.c
> +++ /dev/null
> @@ -1,219 +0,0 @@
> -/*
> - * Copyright (c) Red Hat GmbH.	Author: Florian Westphal <fw@strlen.de>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 (or any
> - * later) as published by the Free Software Foundation.
> - */
> -
> -#include <nft.h>
> -#include <stdio.h>
> -
> -#include <errno.h>
> -#include <ctype.h>
> -#include <limits.h>
> -#include <fcntl.h>
> -#include <unistd.h>
> -#include <time.h>
> -
> -#include <sys/stat.h>
> -#include <sys/wait.h>
> -
> -#include <afl++.h>
> -#include <nftables.h>
> -
> -static const char self_fault_inject_file[] = "/proc/self/make-it-fail";
> -
> -#ifdef __AFL_FUZZ_TESTCASE_LEN
> -/* the below macro gets passed via afl-cc, declares prototypes
> - * depending on the afl-cc flavor.
> - */
> -__AFL_FUZZ_INIT();
> -#else
> -/* this lets the source compile without afl-clang-fast/lto */
> -static unsigned char fuzz_buf[4096];
> -static ssize_t fuzz_len;
> -
> -#define __AFL_FUZZ_TESTCASE_LEN fuzz_len
> -#define __AFL_FUZZ_TESTCASE_BUF fuzz_buf
> -#define __AFL_FUZZ_INIT() do { } while (0)
> -#define __AFL_LOOP(x) \
> -   ((fuzz_len = read(0, fuzz_buf, sizeof(fuzz_buf))) > 0 ? 1 : 0)
> -#endif
> -
> -struct nft_afl_state {
> -	FILE *make_it_fail_fp;
> -};
> -
> -static struct nft_afl_state state;
> -
> -static char *preprocess(unsigned char *input, ssize_t len)
> -{
> -	ssize_t real_len = strnlen((char *)input, len);
> -
> -	if (real_len == 0)
> -		return NULL;
> -
> -	if (real_len >= len)
> -		input[len - 1] = 0;
> -
> -	return (char *)input;
> -}
> -
> -static bool kernel_is_tainted(void)
> -{
> -	FILE *fp = fopen("/proc/sys/kernel/tainted", "r");
> -	unsigned int taint;
> -	bool ret = false;
> -
> -	if (fp) {
> -		if (fscanf(fp, "%u", &taint) == 1 && taint) {
> -			fprintf(stderr, "Kernel is tainted: 0x%x\n", taint);
> -			sleep(3);	/* in case we run under fuzzer, don't restart right away */
> -			ret = true;
> -		}
> -
> -		fclose(fp);
> -	}
> -
> -	return ret;
> -}
> -
> -static void fault_inject_write(FILE *fp, unsigned int v)
> -{
> -	rewind(fp);
> -	fprintf(fp, "%u\n", v);
> -	fflush(fp);
> -}
> -
> -static void fault_inject_enable(const struct nft_afl_state *state)
> -{
> -	if (state->make_it_fail_fp)
> -		fault_inject_write(state->make_it_fail_fp, 1);
> -}
> -
> -static void fault_inject_disable(const struct nft_afl_state *state)
> -{
> -	if (state->make_it_fail_fp)
> -		fault_inject_write(state->make_it_fail_fp, 0);
> -}
> -
> -static bool nft_afl_run_cmd(struct nft_ctx *ctx, const char *input_cmd)
> -{
> -	if (kernel_is_tainted())
> -		return false;
> -
> -	switch (ctx->afl_ctx_stage) {
> -	case NFT_AFL_FUZZER_PARSER:
> -	case NFT_AFL_FUZZER_EVALUATION:
> -	case NFT_AFL_FUZZER_NETLINK_RO:
> -		nft_run_cmd_from_buffer(ctx, input_cmd);
> -		return true;
> -	case NFT_AFL_FUZZER_NETLINK_RW:
> -		break;
> -	}
> -
> -	fault_inject_enable(&state);
> -	nft_run_cmd_from_buffer(ctx, input_cmd);
> -	fault_inject_disable(&state);
> -
> -	return kernel_is_tainted();
> -}
> -
> -static FILE *fault_inject_open(void)
> -{
> -	return fopen(self_fault_inject_file, "r+");
> -}
> -
> -static bool nft_afl_state_init(struct nft_afl_state *state)
> -{
> -	state->make_it_fail_fp = fault_inject_open();
> -	return true;
> -}
> -
> -int nft_afl_init(struct nft_ctx *ctx, enum nft_afl_fuzzer_stage stage)
> -{
> -#ifdef FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
> -	const char instrumented[] = "afl instrumented";
> -#else
> -	const char instrumented[] = "no afl instrumentation";
> -#endif
> -	nft_afl_print_build_info(stderr);
> -
> -	if (!nft_afl_state_init(&state))
> -		return -1;
> -
> -	ctx->afl_ctx_stage = stage;
> -
> -	if (state.make_it_fail_fp) {
> -		unsigned int value;
> -		int ret;
> -
> -		rewind(state.make_it_fail_fp);
> -		ret = fscanf(state.make_it_fail_fp, "%u", &value);
> -		if (ret != 1 || value != 1) {
> -			fclose(state.make_it_fail_fp);
> -			state.make_it_fail_fp = NULL;
> -		}
> -
> -		/* if its enabled, disable and then re-enable ONLY
> -		 * when submitting data to the kernel.
> -		 *
> -		 * Otherwise even libnftables memory allocations could fail
> -		 * which is not what we want.
> -		 */
> -		fault_inject_disable(&state);
> -	}
> -
> -	fprintf(stderr, "starting (%s, %s fault injection)", instrumented, state.make_it_fail_fp ? "with" : "no");
> -	return 0;
> -}
> -
> -int nft_afl_main(struct nft_ctx *ctx)
> -{
> -	unsigned char *buf;
> -	ssize_t len;
> -
> -	if (kernel_is_tainted())
> -		return -1;
> -
> -	if (state.make_it_fail_fp) {
> -		FILE *fp = fault_inject_open();
> -
> -		/* reopen is needed because /proc/self is a symlink, i.e.
> -		 * fp refers to parent process, not "us".
> -		 */
> -		if (!fp) {
> -			fprintf(stderr, "Could not reopen %s: %s", self_fault_inject_file, strerror(errno));
> -			return -1;
> -		}
> -
> -		fclose(state.make_it_fail_fp);
> -		state.make_it_fail_fp = fp;
> -	}
> -
> -	buf = __AFL_FUZZ_TESTCASE_BUF;
> -
> -	while (__AFL_LOOP(UINT_MAX)) {
> -		char *input;
> -
> -		len = __AFL_FUZZ_TESTCASE_LEN;  // do not use the macro directly in a call!
> -
> -		input = preprocess(buf, len);
> -		if (!input)
> -			continue;
> -
> -		/* buf is null terminated at this point */
> -		if (!nft_afl_run_cmd(ctx, input))
> -			continue;
> -
> -		/* Kernel is tainted.
> -		 * exit() will cause a restart from afl-fuzz.
> -		 * Avoid burning cpu cycles in this case.
> -		 */
> -		sleep(1);
> -	}
> -
> -	/* afl-fuzz will restart us. */
> -	return 0;
> -}
> diff --git a/src/main.c b/src/main.c
> index c2e909d2841a..29b0533dee7c 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -21,7 +21,6 @@
>  #include <nftables/libnftables.h>
>  #include <utils.h>
>  #include <cli.h>
> -#include <afl++.h>
>  
>  static struct nft_ctx *nft;
>  
> @@ -87,11 +86,6 @@ enum opt_vals {
>  	OPT_TERSE		= 't',
>  	OPT_OPTIMIZE		= 'o',
>  	OPT_INVALID		= '?',
> -
> -#if HAVE_FUZZER_BUILD
> -	/* keep last */
> -        OPT_FUZZER		= 254
> -#endif
>  };
>  
>  struct nft_opt {
> @@ -149,10 +143,6 @@ static const struct nft_opt nft_options[] = {
>  				     "Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)"),
>  	[IDX_OPTIMIZE]	    = NFT_OPT("optimize",		OPT_OPTIMIZE,		NULL,
>  				     "Optimize ruleset"),
> -#if HAVE_FUZZER_BUILD
> -	[IDX_FUZZER]	    = NFT_OPT("fuzzer",			OPT_FUZZER,		"stage",
> -				      "fuzzer stage to run (parser, eval, netlink-ro, netlink-rw)"),
> -#endif
>  };
>  
>  #define NR_NFT_OPTIONS (sizeof(nft_options) / sizeof(nft_options[0]))
> @@ -243,7 +233,6 @@ static void show_help(const char *name)
>  		print_option(&nft_options[i]);
>  
>  	fputs("\n", stdout);
> -	nft_afl_print_build_info(stdout);
>  }
>  
>  static void show_version(void)
> @@ -286,7 +275,6 @@ static void show_version(void)
>  	       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME,
>  	       cli, json, minigmp, xt);
>  
> -	nft_afl_print_build_info(stdout);
>  }
>  
>  static const struct {
> @@ -327,38 +315,6 @@ static const struct {
>  	},
>  };
>  
> -#if HAVE_FUZZER_BUILD
> -static const struct {
> -	const char			*name;
> -	enum nft_afl_fuzzer_stage	stage;
> -} fuzzer_stage_param[] = {
> -	{
> -		.name		= "parser",
> -		.stage		= NFT_AFL_FUZZER_PARSER,
> -	},
> -	{
> -		.name		= "eval",
> -		.stage		= NFT_AFL_FUZZER_EVALUATION,
> -	},
> -	{
> -		.name		= "netlink-ro",
> -		.stage		= NFT_AFL_FUZZER_NETLINK_RO,
> -	},
> -	{
> -		.name		= "netlink-rw",
> -		.stage		= NFT_AFL_FUZZER_NETLINK_RW,
> -	},
> -};
> -static void afl_exit(const char *err)
> -{
> -	fprintf(stderr, "Error: fuzzer: %s\n", err);
> -	sleep(60);	/* assume we're running under afl-fuzz and would be restarted right away */
> -	exit(EXIT_FAILURE);
> -}
> -#else
> -static inline void afl_exit(const char *err) { }
> -#endif
> -
>  static void nft_options_error(int argc, char * const argv[], int pos)
>  {
>  	int i;
> @@ -407,7 +363,6 @@ static bool nft_options_check(int argc, char * const argv[])
>  int main(int argc, char * const *argv)
>  {
>  	const struct option *options = get_options();
> -	enum nft_afl_fuzzer_stage fuzzer_stage = 0;
>  	bool interactive = false, define = false;
>  	const char *optstring = get_optstring();
>  	unsigned int output_flags = 0;
> @@ -549,26 +504,6 @@ int main(int argc, char * const *argv)
>  		case OPT_OPTIMIZE:
>  			nft_ctx_set_optimize(nft, 0x1);
>  			break;
> -#if HAVE_FUZZER_BUILD
> -		case OPT_FUZZER:
> -			{
> -				unsigned int i;
> -
> -				for (i = 0; i < array_size(fuzzer_stage_param); i++) {
> -					if (strcmp(fuzzer_stage_param[i].name, optarg))
> -						continue;
> -					fuzzer_stage = fuzzer_stage_param[i].stage;
> -					break;
> -				}
> -
> -				if (i == array_size(fuzzer_stage_param)) {
> -					fprintf(stderr, "invalid fuzzer stage `%s'\n",
> -						optarg);
> -					goto out_fail;
> -				}
> -			}
> -			break;
> -#endif
>  		case OPT_INVALID:
>  			goto out_fail;
>  		}
> @@ -581,38 +516,6 @@ int main(int argc, char * const *argv)
>  
>  	nft_ctx_output_set_flags(nft, output_flags);
>  
> -	if (fuzzer_stage) {
> -		unsigned int input_flags;
> -
> -		if (filename || define || interactive)
> -			afl_exit("-D/--define, -f/--filename and -i/--interactive are incompatible options");
> -
> -		rc = nft_afl_init(nft, fuzzer_stage);
> -		if (rc != 0)
> -			afl_exit("cannot initialize");
> -
> -		input_flags = nft_ctx_input_get_flags(nft);
> -
> -		/* DNS lookups can result in severe fuzzer slowdown */
> -		input_flags |= NFT_CTX_INPUT_NO_DNS;
> -		nft_ctx_input_set_flags(nft, input_flags);
> -
> -		if (fuzzer_stage < NFT_AFL_FUZZER_NETLINK_RW)
> -			nft_ctx_set_dry_run(nft, true);
> -
> -		fprintf(stderr, "Awaiting fuzzer-generated inputs\n");
> -	}
> -
> -	__AFL_INIT();
> -
> -	if (fuzzer_stage) {
> -		rc = nft_afl_main(nft);
> -		if (rc != 0)
> -			afl_exit("fatal error");
> -
> -		return EXIT_SUCCESS;
> -	}
> -
>  	if (optind != argc) {
>  		char *buf;
>  
> diff --git a/tests/afl++/README b/tests/afl++/README
> index 9ff7e6485987..ef3219ff0c2c 100644
> --- a/tests/afl++/README
> +++ b/tests/afl++/README
> @@ -17,15 +17,26 @@ Important options are:
>  --disable-shared, so that libnftables is instrumented too.
>  --enable-fuzzer
>  
> ---enable-fuzzer is not strictly required, you can run normal nft builds under
> -afl-fuzz too.  But the execution speed will be much slower.
> +--enable-fuzzer provides tools/nft-afl that allows more fine-grained control
> +nft-afl provides a few options to guide the fuzzing process, some are shared
> +with nft binary:
>  
> ---enable-fuzzer also provides the nft --fuzzer command line option that allows
> -more fine-grained control over what code paths should be covered by the fuzzing
> -process.
> +--check
>  
> -When fuzzing in this mode, then each new input passes through the following
> -processing stages:
> +Prevents the fuzzer-generated rulesets from being committed to the kernel.
> +
> +--random-outflags
> +
> +Periodically alter output behaviour by enabling or disabling --terse,
> +--numeric, --echo and so on.
> +
> +--json
> +
> +Format output in JSON
> +
> +--fuzzer <stage>
> +
> +Instruct nft-afl to stop fuzzing after reaching the given stage.  Stages are:
>  
>  1: 'parser':
>      Only run / exercise the flex/bison parser.
> @@ -38,6 +49,7 @@ processing stages:
>  3: 'netlink-ro':
>      Also build/serialize the ruleset into netlink-commands to send to the
>      kernel, but omit the final write so the kernel will not see the message.
> +    This is the default mode.
>  
>  4: 'netlink-rw':
>      Same as 3 but the message will be sent to the kernel.
> @@ -56,17 +68,17 @@ and its libraries.
>  All --fuzzer modes EXCEPT 'netlink-rw' do imply --check as these modes never
>  alter state in the kernel.
>  
> -In rw mode, before each input, nft checks the kernel "taint" status as provided
> +Before each input, nft-afl checks the kernel "taint" status as provided
>  by "/proc/sys/kernel/tainted".  If this is non-zero, fuzzing stops.
>  
> -To run nftables under afl++, run nftables like this:
> +To run libnftables under afl++, run nft-afl like this:
>  
>  unshare -n \
>    afl-fuzz -g 16 -G 2000 -t 5000 -i tests/afl++/in -o tests/afl++/out \
> -  -- src/nft --fuzzer <arg>
> +  -- tools/nft-afl
>  
> -arg should be either "netlink-ro" (if you only want to exercise nft userspace)
> -or "netlink-rw" (if you want to test kernel code paths too).
> +arg should be either "netlink-ro" (if you only want to exercise libnftables
> +userspace) or "netlink-rw" (if you want to test kernel code paths too).
>  
>  Its also a good idea to do this from tmux/screen so you can disconnect/reattach
>  later.  You can also spawn multiple instances.
> diff --git a/tests/afl++/run-afl.sh b/tests/afl++/run-afl.sh
> index ee9d98fee3c5..9638bfb0a88b 100755
> --- a/tests/afl++/run-afl.sh
> +++ b/tests/afl++/run-afl.sh
> @@ -3,7 +3,7 @@
>  set -e
>  
>  ME=$(dirname $0)
> -SRC_NFT="$(dirname $0)/../../src/nft"
> +SRC_NFT="$(dirname $0)/../../tools/nft-afl"
>  
>  cd $ME/../..
>  
> @@ -43,5 +43,5 @@ done
>  
>  echo "built initial set of inputs to fuzz from shell test case dump files."
>  echo "sample invocations:"
> -echo "unshare -n afl-fuzz -g 16 -G 2000 -t 5000 -i tests/afl++/in -o tests/afl++/out -- src/nft --fuzzer netlink-ro"
> -echo "unshare -n afl-fuzz -g 16 -G 2000 -t 5000 -i tests/afl++/in-json -o tests/afl++/out -- src/nft -j --check --fuzzer netlink-rw"
> +echo "unshare -n afl-fuzz -g 16 -G 2000 -t 5000 -i tests/afl++/in -o tests/afl++/out -- "$SRC_NFT" --fuzzer netlink-ro"
> +echo "unshare -n afl-fuzz -g 16 -G 2000 -t 5000 -i tests/afl++/in-json -o tests/afl++/out -- "$SRC_NFT" -j --check --fuzzer netlink-rw"
> diff --git a/tools/.gitignore b/tools/.gitignore
> index 2d06c49835b1..56dd2226c1bd 100644
> --- a/tools/.gitignore
> +++ b/tools/.gitignore
> @@ -1 +1,5 @@
>  nftables.service
> +*.o
> +.deps/
> +.libs/
> +nft-afl
> diff --git a/tools/nft-afl.c b/tools/nft-afl.c
> new file mode 100644
> index 000000000000..62034de7ea27
> --- /dev/null
> +++ b/tools/nft-afl.c
> @@ -0,0 +1,437 @@
> +/*
> + * Copyright (c) Red Hat GmbH.	Author: Florian Westphal <fw@strlen.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 (or any
> + * later) as published by the Free Software Foundation.
> + */
> +
> +#include <nft.h>
> +#include <stdio.h>
> +#include <stdbool.h>
> +
> +#include <errno.h>
> +#include <ctype.h>
> +#include <limits.h>
> +#include <fcntl.h>
> +#include <getopt.h>
> +#include <unistd.h>
> +#include <time.h>
> +
> +#include <sys/random.h>
> +#include <sys/stat.h>
> +#include <sys/wait.h>
> +
> +#include <afl++.h>
> +#include <nftables.h>
> +
> +static const char self_fault_inject_file[] = "/proc/self/make-it-fail";
> +
> +#ifdef __AFL_FUZZ_TESTCASE_LEN
> +/* the below macro gets passed via afl-cc, declares prototypes
> + * depending on the afl-cc flavor.
> + */
> +__AFL_FUZZ_INIT();
> +#else
> +/* this lets the source compile without afl-clang-fast/lto */
> +static unsigned char fuzz_buf[4096];
> +static ssize_t fuzz_len;
> +
> +#define __AFL_INIT() do { } while (0)
> +#define __AFL_FUZZ_TESTCASE_LEN fuzz_len
> +#define __AFL_FUZZ_TESTCASE_BUF fuzz_buf
> +#define __AFL_FUZZ_INIT() do { } while (0)
> +#define __AFL_LOOP(x) \
> +   ((fuzz_len = read(0, fuzz_buf, sizeof(fuzz_buf))) > 0 ? 1 : 0)
> +#endif
> +
> +struct nft_afl_state {
> +	FILE *make_it_fail_fp;
> +};
> +
> +static struct nft_afl_state state;
> +
> +enum nft_fuzzer_opts {
> +	OPT_HELP = 'h',
> +	OPT_CHECK = 'c',
> +	OPT_JSON = 'j',
> +	OPT_INVALID = '?',
> +
> +	/* --long only */
> +	OPT_FUZZER = 1,
> +	OPT_RANDOUTFLAGS = 2,
> +};
> +
> +static const char optstring[] = "hcj";
> +
> +static struct option options[] = {
> +	{
> +		.name = "help",
> +		.val = OPT_HELP,
> +	}, {
> +		.name = "check",
> +		.val = OPT_CHECK,
> +	}, {
> +		.name = "json",
> +		.val = OPT_JSON,
> +	}, {
> +		.name = "fuzzer",
> +		.val = OPT_FUZZER,
> +		.has_arg = 1,
> +	}, {
> +		.name = "random-outflags",
> +		.val = OPT_RANDOUTFLAGS,
> +	}, {
> +	}
> +};
> +
> +static const struct {
> +	const char			*name;
> +	enum nft_afl_fuzzer_stage	stage;
> +} fuzzer_stage_param[] = {
> +	{
> +		.name		= "parser",
> +		.stage		= NFT_AFL_FUZZER_PARSER,
> +	},
> +	{
> +		.name		= "eval",
> +		.stage		= NFT_AFL_FUZZER_EVALUATION,
> +	},
> +	{
> +		.name		= "netlink-ro",
> +		.stage		= NFT_AFL_FUZZER_NETLINK_RO,
> +	},
> +	{
> +		.name		= "netlink-rw",
> +		.stage		= NFT_AFL_FUZZER_NETLINK_RW,
> +	},
> +};
> +
> +static void nft_afl_print_build_info(FILE *fp)
> +{
> +#ifdef FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
> +	fprintf(fp, "\nWARNING: BUILT WITH FUZZER SUPPORT AND AFL INSTRUMENTATION\n");
> +#else
> +	fprintf(fp, "\nWARNING: BUILT WITH FUZZER SUPPORT BUT NO AFL INSTRUMENTATION\n");
> +#endif
> +}
> +
> +static void nft_afl_exit(const char *err)
> +{
> +	fprintf(stderr, "Error: fuzzer: %s\n", err);
> +	sleep(60);	/* assume we're running under afl-fuzz and would be restarted right away */
> +	exit(EXIT_FAILURE);
> +}
> +
> +static char *preprocess(unsigned char *input, ssize_t len)
> +{
> +	ssize_t real_len = strnlen((char *)input, len);
> +
> +	if (real_len == 0)
> +		return NULL;
> +
> +	if (real_len >= len)
> +		input[len - 1] = 0;
> +
> +	return (char *)input;
> +}
> +
> +static bool kernel_is_tainted(void)
> +{
> +	FILE *fp = fopen("/proc/sys/kernel/tainted", "r");
> +	unsigned int taint;
> +	bool ret = false;
> +
> +	if (fp) {
> +		if (fscanf(fp, "%u", &taint) == 1 && taint) {
> +			fprintf(stderr, "Kernel is tainted: 0x%x\n", taint);
> +			sleep(3);	/* in case we run under fuzzer, don't restart right away */
> +			ret = true;
> +		}
> +
> +		fclose(fp);
> +	}
> +
> +	return ret;
> +}
> +
> +static void fault_inject_write(FILE *fp, unsigned int v)
> +{
> +	rewind(fp);
> +	fprintf(fp, "%u\n", v);
> +	fflush(fp);
> +}
> +
> +static void fault_inject_enable(const struct nft_afl_state *state)
> +{
> +	if (state->make_it_fail_fp)
> +		fault_inject_write(state->make_it_fail_fp, 1);
> +}
> +
> +static void fault_inject_disable(const struct nft_afl_state *state)
> +{
> +	if (state->make_it_fail_fp)
> +		fault_inject_write(state->make_it_fail_fp, 0);
> +}
> +
> +static void nft_afl_run_cmd(struct nft_ctx *ctx, const char *input_cmd)
> +{
> +	if (kernel_is_tainted())
> +		return;
> +
> +	switch (ctx->afl_ctx_stage) {
> +	case NFT_AFL_FUZZER_PARSER:
> +	case NFT_AFL_FUZZER_EVALUATION:
> +	case NFT_AFL_FUZZER_NETLINK_RO:
> +		nft_run_cmd_from_buffer(ctx, input_cmd);
> +		return;
> +	case NFT_AFL_FUZZER_NETLINK_RW:
> +		break;
> +	}
> +
> +	fault_inject_enable(&state);
> +	nft_run_cmd_from_buffer(ctx, input_cmd);
> +	fault_inject_disable(&state);
> +
> +	kernel_is_tainted();
> +}
> +
> +static FILE *fault_inject_open(void)
> +{
> +	return fopen(self_fault_inject_file, "r+");
> +}
> +
> +static bool nft_afl_state_init(struct nft_afl_state *state)
> +{
> +	state->make_it_fail_fp = fault_inject_open();
> +	return true;
> +}
> +
> +static int nft_afl_init(struct nft_ctx *ctx, enum nft_afl_fuzzer_stage stage)
> +{
> +#ifdef FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
> +	const char instrumented[] = "afl instrumented";
> +#else
> +	const char instrumented[] = "no afl instrumentation";
> +#endif
> +	unsigned int input_flags;
> +
> +	nft_afl_print_build_info(stderr);
> +
> +	if (!nft_afl_state_init(&state))
> +		return -1;
> +
> +	ctx->afl_ctx_stage = stage;
> +
> +	if (state.make_it_fail_fp) {
> +		unsigned int value;
> +		int ret;
> +
> +		rewind(state.make_it_fail_fp);
> +		ret = fscanf(state.make_it_fail_fp, "%u", &value);
> +		if (ret != 1 || value != 1) {
> +			fclose(state.make_it_fail_fp);
> +			state.make_it_fail_fp = NULL;
> +		}
> +
> +		/* if its enabled, disable and then re-enable ONLY
> +		 * when submitting data to the kernel.
> +		 *
> +		 * Otherwise even libnftables memory allocations could fail
> +		 * which is not what we want.
> +		 */
> +		fault_inject_disable(&state);
> +	}
> +
> +	input_flags = nft_ctx_input_get_flags(ctx);
> +	input_flags |= NFT_CTX_INPUT_NO_DNS;
> +	nft_ctx_input_set_flags(ctx, input_flags);
> +
> +	if (stage < NFT_AFL_FUZZER_NETLINK_RW)
> +		nft_ctx_set_dry_run(ctx, true);
> +
> +	fprintf(stderr, "starting (%s, %s fault injection)", instrumented, state.make_it_fail_fp ? "with" : "no");
> +	return 0;
> +}
> +
> +static uint32_t random_u32(void)
> +{
> +	uint32_t v;
> +
> +	if (getrandom(&v, sizeof(v), GRND_NONBLOCK) == (ssize_t)sizeof(v))
> +		return v;
> +
> +	v = (uint32_t)time(NULL) + (uint32_t)getpid();
> +	srandom(v + random());
> +
> +	v = random();
> +	v += random();
> +
> +	return v;
> +}
> +
> +static uint32_t random_outflags(void)
> +{
> +	uint32_t random_value;
> +
> +	random_value = random_u32();
> +
> +	/* never enable json automatically, rely on command line for this */
> +	return random_value & ~NFT_CTX_OUTPUT_JSON;
> +}
> +
> +static void show_help(const char *name)
> +{
> +	int i;
> +
> +	printf("Usage: %s [ options ]\n\nOptions\n", name);
> +
> +	for (i = 0; i < (int)(sizeof(options) / sizeof(options[0])) - 1; i++) {
> +		printf("--%s", options[i].name);
> +
> +		if (options[i].has_arg)
> +			fputs(" <arg>", stdout);
> +
> +		puts("");
> +	}
> +
> +	puts("");
> +	puts("Also see \"nft --help\" for more information on common command line options.");
> +}
> +
> +static void show_help_fuzzer(const char *name)
> +{
> +	int i;
> +
> +	show_help(name);
> +	puts("");
> +
> +	for (i = 0; i < (int)(sizeof(fuzzer_stage_param) / sizeof(fuzzer_stage_param[0])); i++)
> +		printf("--fuzzer %s\n", fuzzer_stage_param[i].name);
> +
> +	puts("Hint: combine \"--fuzzer netlink-rw\" with \"--check\" to not apply changes\n");
> +}
> +
> +static int nft_afl_main(struct nft_ctx *ctx)
> +{
> +	unsigned char *buf;
> +	ssize_t len;
> +
> +	if (kernel_is_tainted())
> +		return -1;
> +
> +	if (state.make_it_fail_fp) {
> +		FILE *fp = fault_inject_open();
> +
> +		/* reopen is needed because /proc/self is a symlink, i.e.
> +		 * fp refers to parent process, not "us".
> +		 */
> +		if (!fp) {
> +			fprintf(stderr, "Could not reopen %s: %s", self_fault_inject_file, strerror(errno));
> +			return -1;
> +		}
> +
> +		fclose(state.make_it_fail_fp);
> +		state.make_it_fail_fp = fp;
> +	}
> +
> +	buf = __AFL_FUZZ_TESTCASE_BUF;
> +
> +	while (__AFL_LOOP(UINT_MAX)) {
> +		char *input;
> +
> +		len = __AFL_FUZZ_TESTCASE_LEN;  // do not use the macro directly in a call!
> +
> +		input = preprocess(buf, len);
> +		if (!input)
> +			continue;
> +
> +		/* buf is null terminated at this point */
> +		nft_afl_run_cmd(ctx, input);
> +	}
> +
> +	/* afl-fuzz will restart us. */
> +	return 0;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	enum nft_afl_fuzzer_stage fuzzer_stage = NFT_AFL_FUZZER_NETLINK_RO;
> +	unsigned int json_output_flag = 0;
> +	bool random_output_flags = false;
> +	int ret = EXIT_SUCCESS;
> +	struct nft_ctx *nft;
> +	unsigned int i;
> +
> +	nft = nft_ctx_new(NFT_CTX_DEFAULT);
> +
> +	while (1) {
> +		int val = getopt_long(argc, argv, optstring, options, NULL);
> +		if (val == -1)
> +			break;
> +
> +		switch (val) {
> +		case OPT_HELP:
> +			show_help(argv[0]);
> +			goto out;
> +		case OPT_CHECK:
> +			nft_ctx_set_dry_run(nft, true);
> +			break;
> +		case OPT_FUZZER:
> +			for (i = 0; i < array_size(fuzzer_stage_param); i++) {
> +				if (strcmp(fuzzer_stage_param[i].name, optarg))
> +					continue;
> +				fuzzer_stage = fuzzer_stage_param[i].stage;
> +				break;
> +			}
> +
> +			if (!strcmp(optarg, "help")) {
> +				show_help_fuzzer(argv[0]);
> +				goto out;
> +			}
> +
> +			if (i == array_size(fuzzer_stage_param)) {
> +				fprintf(stderr, "invalid fuzzer stage `%s'\n",
> +					optarg);
> +				show_help_fuzzer(argv[0]);
> +				goto out_fail;
> +			}
> +			break;
> +		case OPT_RANDOUTFLAGS:
> +			random_output_flags = true;
> +			break;
> +		case OPT_JSON:
> +#ifdef HAVE_LIBJANSSON
> +			json_output_flag = NFT_CTX_OUTPUT_JSON;
> +#else
> +			fprintf(stderr, "Error: JSON support not compiled-in\n");
> +			goto out_fail;
> +#endif
> +		case OPT_INVALID:
> +			nft_afl_exit("Unknown option");
> +			goto out_fail;
> +		}
> +	}
> +
> +	ret = nft_afl_init(nft, fuzzer_stage);
> +	if (ret != 0)
> +		nft_afl_exit("cannot initialize");
> +
> +	__AFL_INIT();
> +
> +	if (random_output_flags) {
> +		unsigned int output_flags = random_outflags();
> +
> +		nft_ctx_output_set_flags(nft, output_flags | json_output_flag);
> +	}
> +
> +	ret = nft_afl_main(nft);
> +	if (ret != 0)
> +		nft_afl_exit("fatal error");
> +out:
> +	nft_ctx_free(nft);
> +	return ret;
> +out_fail:
> +	nft_ctx_free(nft);
> +	return EXIT_FAILURE;
> +}
> -- 
> 2.51.0
> 
> 
