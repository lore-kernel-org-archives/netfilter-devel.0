Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ACA32470E
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 06:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788504707; cv=none; b=kijVaxsevgbip+zBhrW/YF2qwS2sKrP6J0nGyB3axxdG1Qi2zp0RbnsXz7J1miTt3RCCN/R68X0eajTumZZ96QsbKQfdCu2cpOvr+JHpLevMhZJKRaxugwneqdRPrhQRiawpN3MRJEE0ciLC82lwFKfSmvyx2S/xagOtU6qqSQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788504707; c=relaxed/simple;
	bh=oyqJZbXNlDevLR8Z5mJBsgSPmH6VQ+/8O5cMCu096tM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K99i11sHM3a1RV9ecE0ypEAtQCcorbKQ/pmKoq8lRrLerEbeTC1BbnbmTTYNWJAwHvEBJNTtAPravBOG0xteFPdgJh/6ETYm/jfw4xFkAdGR6WlUuT/XPRMQe6AKssAlIuvqWZPjJmkkyB4yjURgmjhqJDDTqA09PFCVKMtNXRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=qFoDmZpV; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="qFoDmZpV"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc1cc1b42b5so786789a12.2
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Sep 2026 23:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788504705; x=1789109505; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b6hpLljP9SdtNHrhq7gNNxoYeFIHd2MdFkQZBmDruA8=;
        b=qFoDmZpVRIazDnJ+s+E0E40r8w0wLYbMO6UR0K+4Gq/DdIRyDIzqFl6gtSTWJF/Jzr
         ijSTyIU9G5qwfxZjvU0PlTm++Rl006wOoTpG6bHZ0zwlNVqoso3I4W5vVS4T5OFcC0nW
         C64U+hjqjoYSFtRWJZr3Cp3zNBNW6dttCWsmr7hdLOp6iJfoPZLlPA9Q55j1Kcvkxm4g
         MamO4VVkdSsIvafS5d8nU1wc5ZN4gviYrrAdhsRey3h/YjiGdcjXREAl3ag6x+TyJ7FT
         IhmQdBHOONFqtuNTA+B4wllcITyInUt5ImoNiuOC7IXQt9n0kzB20AVCwQAjaIl4/bWQ
         BMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788504705; x=1789109505;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b6hpLljP9SdtNHrhq7gNNxoYeFIHd2MdFkQZBmDruA8=;
        b=ft3mF4EuwFmCEajnc2BsOS3m/8lR4oKKtRRZiWXWwpJzmW68ncNWKttOsAI0UsDevZ
         XwE1RGs5TE8pkLNzgi5Ont0agYOMV9pY1rjdZuHR9GqXeHivgLDWg6xhAOLrorHTtiUK
         ZWhEweehtQWNK69cO8f9I9wsK1r/YWg6iOo3JyPBmeOBkshO656s5Qz05ZrUBFL0ENI0
         DJUYxE37ofBs54BX8g7gioy2lXy5WieGyyHobna3154AInT5N7VfiCJYIekiX5AUyZB6
         ErEpu8fORMDC39SbnkPhCwW8o9RJ8Jm++l3LLJ4bZgG4oiQZ12PTZue5uGQeEYG4+zI7
         mn4g==
X-Forwarded-Encrypted: i=1; AKwUvBzAmO4bGzD3Huv54EE5JMEKB1NmtTKAJ36iNCdJyj9aA5nHWPHcSwAiln85xYLtncb+Y2QmePKPXUZyLOdD7+0=@vger.kernel.org
X-Gm-Message-State: AFuF++mm/Hnn9pYq8jgGMEWunnrnw3H1yRpvDSkWf/48eBVau2doLTb/
	LPsVLfjL/ELrjyb3loZLPxB5Hy+9r5azsweI70o+T2WGl7pHnKmGqhHiaiLKKWNtvxfO
X-Gm-Gg: AYBFou1FBcENGLBqaOzT0AS15qu1QUe01nBHL5iQ/m3BE4yIlyrYIb07VUTMxFNEUHJ
	F49mbS43KLtvDkH1L8MF1VSjwTcfs+qjzotDQpUJWA/Bi/F/dVyrezhUQWZzK7CGF5PyHYmOxQ/
	9x8d2BChD0prslQSMzmtqBkhSEdUiZuQhD9620Tc9emX5CPZqoGbmWx8rKGDsFbVK3yKz4Xkolw
	h2koQPjXbrCn0tW7vKMTguU7lzI58ahQDIjRJvYNx2k6VD/fXLcZxMYz+1TD/uuBQTRY9+C8dyv
	VD3hfMzk7sNnPgQFyGdEqlpNRwW+1Wud+vIB0vS5qIs1hv2GJ3M279zmPwMq/+GNulrlErArwS7
	xm57/k7k3V3dWP8guHo+LX9u0JswMVVhJ5WQMpdcfn05zFuYz8zULpKfqQMpJh0qQIwZCQqvINi
	rsp74t5KY1MpiFxON0crd9G7gg82r6oWY1eOZmENrIsMu7I+gX2xunMXPH3eQRv8QujbJTnEDW+
	wdGDUHHo53pmvBS+y/HtPkmGm/t+TWgisYLP5vSvQ==
X-Received: by 2002:a05:6a20:158d:b0:3da:34a7:6444 with SMTP id adf61e73a8af0-3da3a15ac1cmr5550804637.26.1788504705322;
        Thu, 03 Sep 2026 23:51:45 -0700 (PDT)
Received: from [192.168.4.59] (c-73-93-246-205.hsd1.ca.comcast.net. [73.93.246.205])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339aa37dbdsm3862921eec.11.2026.09.03.23.51.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 23:51:44 -0700 (PDT)
Message-ID: <2a994f26-1eb8-40c4-84ca-c48a52c065d5@nebusec.ai>
Date: Thu, 3 Sep 2026 23:51:42 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] A Syzbot-style Platform for Verifying and Fixing
 LLM-reported Bugs
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, workflows@vger.kernel.org,
 frankw@nebusec.ai, jhs@mojatatu.com, ksummit@lists.linux.dev,
 kuba@kernel.org, pabeni@redhat.com, kerneljasonxing@gmail.com,
 roman.gushchin@linux.dev, jgg@nvidia.com, mchehab+huawei@kernel.org,
 torvalds@linux-foundation.org, ben.copeland@linaro.org,
 gregkh@linuxfoundation.org, yuantan098@gmail.com
References: <20260830115546.3942129-1-yuantan098@gmail.com>
Content-Language: en-US
From: Yuan Tan <yuant@nebusec.ai>
In-Reply-To: <20260830115546.3942129-1-yuantan098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 8/30/26 04:55, Yuan Tan wrote:
> Hi all,
>
> A month ago, I posted an RFC[1] to the mailing list proposing an automated
> platform that validates AI-reported bugs and prepares draft fixes, and
> later discussed the idea at the Netdev conference. After further
> development, it is finally ready.
>
> While preparing to send this email, I noticed that Roman has since started
> a related discussion:
> [MAINTAINERS SUMMIT] The place of AI code review in the Linux Kernel process
>
> It turns out this platform already addresses several of the needs raised
> there.
>
> The platform is available at:
> https://bugtracker.nebusec.ai
>
> It is currently hosted under my company's domain for convenience. I would
> prefer to move it to a neutral, community-oriented domain once the project
> name is settled.
> Access is currently restricted to maintainers whose email addresses are
> listed in the Linux kernel MAINTAINERS file.
> For now, only bug reports from the net subsystem have been fully imported
> and processed.
>
> -------------------------------------------------------------------------
>
> LLM-powered tools such as Sashiko and Claskiko produce a significant number
> of false positives. Pre-existing bugs uncovered by these tools are also not
> collected in one place and they remain scattered across individual review
> reports.
>
> To address this, like syzbot for fuzzer-found bugs, this platform provides
> an **automated** tracking layer for AI-reported bugs, but goes further by
> generating PoCs, running them in QEMU to produce crash logs, triaging
> severity, and drafting patches. This requires no extra effort from
> maintainers; instead, it may helps them understand and fix these bugs more
> efficiently.
>
>
> The platform offers the following capabilities:
>
> 1. Collect and Deduplicate
>
> The platform ingests bug reports from multiple sources, including Sashiko,
> Claskiko, and others. It deduplicates them and monitors mailing lists and
> git history to track whether they have been fixed.
>
> It also provides visibility into the Sashiko/Claskiko ingestion queue, so
> users can see which reports are waiting to be collected and processed.
>
>
> 2. Verify by generating PoC and running it in QEMU
>
> An agent attempts to generate a proof-of-concept for each bug to determine
> whether it is a false positive. According to paper Patch-to-PoC[2] and
> follow-up research, GPT-5.4 achieves up to a 95% success rate in generating
> PoCs for genuinely exploitable bugs.
>
> This makes PoC generation a strong signal: if a bug has no PoC, it is very
> likely a false positive. And even in cases where a real bug is missed, the
> difficulty of generating a PoC suggests it is unlikely to be practically
> exploitable.
>
>
> 3. Draft Patch
>
> The platform produces a draft patch to give maintainers a starting point
> and suggested fix direction. These still require human review. Patches can
> be downloaded via b4 am.
>
> These patches are not sent to mailing lists to avoid adding AI-generated
> noise.
>
>
> 4. Triage
>
> Based on the PoC, the agent evaluates the conditions required to trigger
> the bug, for example, whether it requires a namespace, root privileges, or
> can be triggered by an unprivileged user.
>
> Bugs that require root are generally less important, while those reachable
> by unprivileged users are more likely to have real security impact.
>
> If a bug can be triggered from namespace, it is still worth
> paying attention to.
> In particular, a bug should not be considered root-only merely because
> triggering it requires CAP_NET_ADMIN in a network namespace. On systems
> that allow unprivileged user namespaces, an ordinary user may be able to
> create a user namespace, create a network namespace owned by it, and obtain
> capabilities such as CAP_NET_ADMIN with respect to that namespace. Such
> bugs may therefore still be reachable by an otherwise unprivileged local
> user.
>
> For example, this configuration has historically been available by default
> on distributions such as Ubuntu 22.04 LTS and earlier.
>
> Jamal previously offered some suggestions on this severity classification
> scheme which I have not yet had time to implement; that will come in a
> future update.
>
>
> 5. Chat with agent
>
> Each bug page includes a chat interface for discussing the bug and its fix
> with the agent.
>
>
>
> Based on earlier feedback, the system is not fully public. Only email
> addresses listed in the MAINTAINERS file are eligible to register, to
> prevent bugs with potential security impact from being exposed publicly.
>
> Jason’s idea of delegating fixes could also be implemented on this
> platform. This is essentially what my volunteer bug-fixing team and I have
> been doing over the past six months: anyone interested can pick up an issue
> and try to fix it. 
> Each subsystem’s maintainers could choose whether to make its issues
> public. Making them public would also let potential reporters check whether
> an issue is already known before submitting a new report.
>
> Bugs are also categorized by subsystem, so after logging in, maintainers
> see only the bugs relevant to the modules they maintain.
>
>
> Welcome any suggestions:)  I will continue maintaining this system and
> adding more features, not only out of personal interest, but also our
> bug-fixing volunteer team is using it too.
>
> We periodically burn tokens and run state-of-the-art models against the
> full kernel source code, with the goal of finding security vulnerabilities
> before attackers do. While I am not an expert in the net subsystem and
> cannot review patches myself at this time, I still hope this platform can
> be of help to the community.
>
> If this system proves genuinely useful, I am happy to transfer project
> ownership to the Linux Foundation or another neutral host.
>
> Going forward, the platform will expose a public API so that other bug
> finding research teams can submit their findings here for centralized
> processing. We also plan to ingest syzbot-found bugs to provide them with
> the same triage workflow.
>
> P.S. I have been struggling to come up with a good name for this platform. A
> few candidates I am considering are Palomar, Tengu, FixArc, and Ephemeris.
> If anyone has a preference or a better suggestion, I would love to hear it.
>
>
> Current Limitations
>
> - For a tracked bug, the system currently only knows that a fix exists; it
> does not yet distinguish between a patch that has been posted to the
> mailing list and one that has already been merged.
>
> - PoC generation and false-positive verification are not yet supported for
> driver-related bugs.
>
> - Unable to scrape Sashiko/Clashiko review reports that are still under embargo.
>
> - Only net subsystem bugs from Sashiko and Claskiko have been imported with
> a fully automated fix-detection pipeline so far. Bugs from other subsystems
> are shown but may already be fixed. If other subsystem maintainers are
> interested, I will prioritize adding support.
>
>
> [1] https://lore.kernel.org/all/20260708092247.4188498-1-yuantan098@gmail.com/
> [2] Juefei Pu, Xingyu Li, Zhengchuan Liang, et al. "Patch-to-PoC: A
> Systematic Study of Agentic LLM Systems for Linux Kernel N-Day
> Reproduction." arXiv:2602.07287, 2026. https://arxiv.org/abs/2602.07287
>
>
> Thanks,
> Yuan
>

A couple of updates since my last email:

Previously, the bug list was not automatically filtered based on the
maintainer’s subsystems in the MAINTAINERS file after login. This has
now been fixed.

Also, a quick update for netdev:

We recently ran exploitability analysis on several hundred bugs and
imported the results into the tracker, so you can now directly see which
bugs appear to have higher security impact.

We identified 55 bugs that can be used for local privilege escalation.
The good news is that 46 of them have already been fixed, while 9 are
still unfixed. Fortunately, 8 of those 9 require |CONFIG_USER_NS=y| to
be exploitable.

I’m especially proud that students on my team contributed 34 of the
patches for those fixes, and I’m very grateful to the maintainers for
all the reviews and guidance. Once we finish the patches we’re currently
looking at, we’ll start working on these newly identified
privilege-escalation bugs.

The exploitability analysis still has to be run manually and is not yet
integrated into the system. Once the full pipeline is integrated, it
should make it much easier to see which bugs pose a greater security risk.

So although the LLM has found a large number of bugs, only a very small
fraction of them appear to be usable for local privilege escalation.

If any maintainers outside netdev are interested in using the tracker,
just let me know. I can prioritize importing the fixed bugs and Sashiko
findings for those subsystems first. Cleaning and importing the data
takes some time.


