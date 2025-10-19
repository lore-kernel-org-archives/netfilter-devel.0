Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68852E172D
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Oct 2025 09:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760866463; cv=none; b=BdMOoDEQAVJZUcjQg+1Q3ri8cbjCqYlIlNuZblnMhLU8qGVT5YJV+KGI0nuTIygsEmOSmdvnP5+jfptxFh4eX3R2ywZProR2Ff4xQlmNpwgS9SBqLe94mHG25ieplO9M8PB6GC9A3Ry6dy7M//6XDyKwVsnly/vXZIgWRnWKpi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760866463; c=relaxed/simple;
	bh=XudtDQSMwWH9CDzEwuo6JAePaGm0YQanzRNw76/sXfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CzGQJ9JJIFdKpcDU4yo3q5DUxhaPZ30ohuoGxkAzRR+S0vIcm5LLmO1Tq3OXH31aEfRJeaumsLVi1XvpK0Ohm/YDq1PNsZVhnBi3M5xFUg4/LWkZBY+3/dMSJNyL2HVldl8b0Vf3ZXyUqaZ9wB0CcX3GO2NRlhjFje7/GNmjMa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U4YOPIN5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2jjYce0O; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HVdzshaw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ukGEIdMx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U4YOPIN5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2jjYce0O";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HVdzshaw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ukGEIdMx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AFD7D1F393;
	Sun, 19 Oct 2025 09:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760866458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7lLUKe2TuZ0jJds+bALjC8gRe2thG+XEJh0GYqFg2As=;
	b=U4YOPIN5Q56d9/JTQtYLmTpYI3Giz/mkG85AeLZfVXcISy7mz0VoOd8nJe/pWwacckojz/
	CjU3TU0MlSUo3lOLjIjbjioFMIVmoQes+XPC0ggCBHUscW0AHsFfsbzjfESvAwcnpHz8LW
	KuhZRNpGJpWhlJJsIjbqBc3SKWVJZ2A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760866458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7lLUKe2TuZ0jJds+bALjC8gRe2thG+XEJh0GYqFg2As=;
	b=2jjYce0OzMj7KEj8KxQd4i0++gVM9I9gfuocf6nCbgk/4IR4k1x+UzIFGAJfmeZIZ9DnQS
	yxO8+hbxigcDxjDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HVdzshaw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ukGEIdMx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760866454; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7lLUKe2TuZ0jJds+bALjC8gRe2thG+XEJh0GYqFg2As=;
	b=HVdzshaw9y4kmEs1uJ5dIFLK43fbuE8JWC/Ca7so+31HWV0+cz9xuAp447VW6y66rJ0JxM
	NgPCrrSFkQktkFi1D9vVcxPiIG0Zhb/10dxgmqqH7EvTNqxBxMBm91305Q6hi5RPAw+kFJ
	fDSScg3gwabu8+izzLsgcefRxPDM7Eg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760866454;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7lLUKe2TuZ0jJds+bALjC8gRe2thG+XEJh0GYqFg2As=;
	b=ukGEIdMx5wRAn/KQPGqK0mx4wTjbhd0dKtT1G01T2szJbhRdxdgKv8AiOEqSEJOYuBQqtg
	v6frfGUND+2YvODA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 778B9139D8;
	Sun, 19 Oct 2025 09:34:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id en/mGZaw9GjLCAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sun, 19 Oct 2025 09:34:14 +0000
Message-ID: <ddf0bfea-0239-42bd-ba1b-5e6f340f1af4@suse.de>
Date: Sun, 19 Oct 2025 11:34:03 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft v2] support for afl++ (american fuzzy lop++) fuzzer
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251017115145.20679-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20251017115145.20679-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AFD7D1F393
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 



On 10/17/25 1:51 PM, Florian Westphal wrote:
> afl comes with a compiler frontend that can add instrumentation suitable
> for running nftables via the "afl-fuzz" fuzzer.
> 
> This change adds a "--with-fuzzer" option to configure script and enables
> specific handling in nftables and libnftables to speed up the fuzzing process.
> It also adds the "--fuzzer" command line option.
> 

Hi Florian, I think this is awesome. I have been playing with it since 
you posted this patch.. and found a couple of things already!

> afl-fuzz initialisation gets delayed until after the netlink context is set up
> and symbol tables such as (e.g. route marks) have been parsed.
> 
> When afl-fuzz restarts the process with a new input round, it will
> resume *after* this point (see __AFL_INIT macro in main.c).
> 
> With --fuzzer <stage>, nft will perform multiple fuzzing rounds per
> invocation: this increases processing rate by an order of magnitude.
> The argument to '--fuzzer' specifies the last stage to run:
> 
> 1: 'parser':
>      Only run / exercise the flex/bison parser.
> 
> 2: 'eval': stop after the evaluation phase.
>      This attempts to build a complete ruleset in memory, does
>      symbol resolution, adds needed shift/masks to payload instructions
>      etc.
> 
> 3: 'netlink-ro':
>      'netlink-ro' builds the netlink buffer to send to the kernel,
>      without actually doing so.
> 
> 4: 'netlink-rw':
>      Pass generated command/ruleset will be passed to the kernel.
>      You can combine it with the '--check' option to send data to the kernel
>      but without actually committing any changes.
>      This could still end up triggering a kernel crash if there are bugs
>      in the valiation / transaction / abort phases.
> 
> Use 'netlink-ro' if you want to prevent nft from ever submitting any
> changes to the kernel or if you are only interested in fuzzing nftables
> and its libraries.
> 
> In case a kernel splat is detected, the fuzzing process stops and all further
> fuzzer attemps are blocked until reboot.
> 

I do not think this is what happens or I am maybe misunderstanding 
something.I got a kernel splat - soft lockup as the CPU was stuck for 
40s (!). Anyway, kernel was then tainted but the fuzzer didn't stop it 
continued running but not executing the commands as kernel was tainted.. 
see the comments below.

> [...]
> +/* this lets the source compile without afl-clang-fast/lto */
> +static unsigned char fuzz_buf[4096];
> +static ssize_t fuzz_len;
> +
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
> +static bool nft_afl_run_cmd(struct nft_ctx *ctx, const char *input_cmd)
> +{
> +	if (kernel_is_tainted())
> +		return false;
> +

While this prevents the execution of the command, the input is already 
generated. See comments in main function.

> +	switch (ctx->afl_ctx_stage) {
> +	case NFT_AFL_FUZZER_PARSER:
> +	case NFT_AFL_FUZZER_EVALUATION:
> +	case NFT_AFL_FUZZER_NETLINK_RO:
> +		nft_run_cmd_from_buffer(ctx, input_cmd);
> +		return true;
> +	case NFT_AFL_FUZZER_NETLINK_RW:
> +		break;
> +	}
> +
> +	fault_inject_enable(&state);
> +	nft_run_cmd_from_buffer(ctx, input_cmd);
> +	fault_inject_disable(&state);
> +
> +	return kernel_is_tainted();
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
> +int nft_afl_init(struct nft_ctx *ctx, enum nft_afl_fuzzer_stage stage)
> +{
> +#ifdef FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
> +	const char instrumented[] = "afl instrumented";
> +#else
> +	const char instrumented[] = "no afl instrumentation";
> +#endif
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
> +	fprintf(stderr, "starting (%s, %s fault injection)", instrumented, state.make_it_fail_fp ? "with" : "no");
> +	return 0;
> +}
> +
> +int nft_afl_main(struct nft_ctx *ctx)
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
> +		if (!nft_afl_run_cmd(ctx, input))
> +			continue;

If we get a kernel splat and kernel is tainted but continue running 
(soft lockup, warning..) the fuzzer won't stop, it won't execute more 
commands but it will generate inputs for hours.

In addition I noticed that when a kernel splat happens the ruleset that 
triggered it isn't saved anywhere, it would be nice to save them so we 
have a reproducer right away.. For one of the kernel splats I got, I was 
able to generate a reproducer by looking at the trace.. but for the 
other I couldn't.

I have a server at home that I am not using.. I would love to automate a 
script to run this in multiple VMs and generate reports :)

