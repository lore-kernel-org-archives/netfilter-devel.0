Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DFA2EAB7A
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Oct 2025 14:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760883488; cv=none; b=ZaDI6yD5Z3BEmAujAycqJfAJRUb53+SINrDhaoq8FkoThxH4XkrFB5VbAsTBR3puNp6Dskao4fjcBuTG4BWJCMuAiuLqG//T8tyGJCq5nkPBMSO8xx8qatwoOwIAPjHKnRuCgZr+qJFH40kR4djc8I2b/HQB8RM2M5wFbwn1Zds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760883488; c=relaxed/simple;
	bh=Z5wEjasElzbjgSWduWlXRmneqRd9AgJkG+5qL1qTCl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QPHtRebeOK1xxbxZLoXqlgXdhc/CaOsSF7mwbXwNs3LPO3F9axFL1Kdin6UpewEbFEBeOISeu7joTjqQrBvofeAY7up0qhIuMQpCeQ/777437l4UMeGGg1uiYEjfFl7Q2BC1e8m4FLBCmNKKVWgiVQgQkiiXsStytTm3mnIs160=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 39F2561A28; Sun, 19 Oct 2025 16:17:53 +0200 (CEST)
Date: Sun, 19 Oct 2025 16:17:51 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] support for afl++ (american fuzzy lop++) fuzzer
Message-ID: <aPTzD7qoSIQ5AXB-@strlen.de>
References: <20251017115145.20679-1-fw@strlen.de>
 <ddf0bfea-0239-42bd-ba1b-5e6f340f1af4@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddf0bfea-0239-42bd-ba1b-5e6f340f1af4@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 10/17/25 1:51 PM, Florian Westphal wrote:
> > afl comes with a compiler frontend that can add instrumentation suitable
> > for running nftables via the "afl-fuzz" fuzzer.
> > 
> > This change adds a "--with-fuzzer" option to configure script and enables
> > specific handling in nftables and libnftables to speed up the fuzzing process.
> > It also adds the "--fuzzer" command line option.
> > 
> 
> Hi Florian, I think this is awesome. I have been playing with it since you
> posted this patch.. and found a couple of things already!

Great :)

> > In case a kernel splat is detected, the fuzzing process stops and all further
> > fuzzer attemps are blocked until reboot.
> > 
> I do not think this is what happens or I am maybe misunderstanding
> something.I got a kernel splat - soft lockup as the CPU was stuck for 40s
> (!). Anyway, kernel was then tainted but the fuzzer didn't stop it continued
> running but not executing the commands as kernel was tainted.. see the
> comments below.

Yes, I don't know how to stop it.  IIRC exit() just makes afl-fuzz resume
with next cycle.

> While this prevents the execution of the command, the input is already
> generated. See comments in main function.

Yes.  I just want it to stop burning cpu cycles if kernel is already
tainted.

> > +	buf = __AFL_FUZZ_TESTCASE_BUF;
> > +
> > +	while (__AFL_LOOP(UINT_MAX)) {
> > +		char *input;
> > +
> > +		len = __AFL_FUZZ_TESTCASE_LEN;  // do not use the macro directly in a call!
> > +
> > +		input = preprocess(buf, len);
> > +		if (!input)
> > +			continue;
> > +
> > +		/* buf is null terminated at this point */
> > +		if (!nft_afl_run_cmd(ctx, input))
> > +			continue;
> 
> If we get a kernel splat and kernel is tainted but continue running (soft
> lockup, warning..) the fuzzer won't stop, it won't execute more commands but
> it will generate inputs for hours.

Yes, it should not continue to burn cpu cycles.

> In addition I noticed that when a kernel splat happens the ruleset that
> triggered it isn't saved anywhere, it would be nice to save them so we have
> a reproducer right away.

I had such code but removed it for this version.

I can send a followup patch to re-add it but I think that it is better
for kernel fuzzing to extend knft acordingly, as nft is restricted by
the input grammar wrt. the nonsense that it can create.

> I have a server at home that I am not using.. I would love to automate a
> script to run this in multiple VMs and generate reports :)

Yes, that would be good.  Note that I still primarily use it with
netlink-ro mode to not exercise he kernel, its easy to make graph
validation (or abort path) take very long to finish.

There is still a patch series in the queue to limit jumps in nftables
and I did not yet have time in looking at the abort path, Its simply not
an issue for normal cases (you assume the input is going to be
committed...).  But for faster netlink-rw/knft fuzzing it would make
sense to look into async abort (like we do for commit cleanup).
