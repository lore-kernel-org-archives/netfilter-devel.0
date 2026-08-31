Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CACF2AD2C
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 19:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788203322; cv=none; b=QMoZjOt+R8zcQOjN7M6hspQ4p5NrdVWd34fce9T1vWyWo4AmiEh6PTA+Prhn/4vTQEbfHe/lQr8KEb3LxnCu8gnwTYzB2c23cgWt8LEkZ1CudFPUZZCKKrc8M2XMwKBU45S8KHLadkqzZvxozTklX8vCuuuYnvUCt+us0pq713A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788203322; c=relaxed/simple;
	bh=B/aJqUHjb5Z8xLiixk10fDLaupV71WOqcT+9CRHD1oo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oj+5gh0dZJooIYMWW0YXi/AcOaiY4FxyzlPPtkd6ul3++wYANJw7Vjcb/B+71aROMEuxmO0aS1CHcFhNUD5lD/5uAG4ixrYT5BkKFCYq6v8wsB8ABhPjB3Hgf44YFV/r1xbPTxjR0e8NyCcjcqWDIfc2AxnxumPxHcbloCF26/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UtS4UsIY; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UtS4UsIY"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d91518a63fso13959665ad.0
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 12:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788203319; x=1788808119; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n+zodE8v2r1Ow4jiromcQ0qC+wD6QbMNqV6QEefK45Q=;
        b=UtS4UsIY6BsxoAvs0/9dLIWYRz3sW/72AIeRYG+uWNKtrTO5glNog7os4ktZQphRQ0
         60UWGgAqrwBHAoO6dvFomFAPzIB5uq7ZjZxqqMp7WgkDUrZyrIbhU6hVnOmI2sLKiCsg
         awLugxR2cn0sDaN5nDWa8nsSTsDhE0JKi6iBW2SsH3wS+uAMSoeLJCPvz07gkOYPDShZ
         znQYlCM8l7dWc8C8eLedYk5PKvr+2TnW9vap4MZsgakRNmoC7Xmp5G+aYNB1SgzbL2eE
         8YHJurqjK0V2wE3pDnyazzzfXrGydvG0nEJ18HlTloH6jyEwDaKaaefEX04WtMuksEuR
         rt/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788203319; x=1788808119;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n+zodE8v2r1Ow4jiromcQ0qC+wD6QbMNqV6QEefK45Q=;
        b=UkNwtxB68MvYficp736pPupBlkugOBPHPAWUNt4CzPj+FprAkJEVu2UXuc2otNocvY
         5ytX9Fdpfb3USaRSLaUpXe8ftNuQQIb+tbiPFedPXygRgFYk5kMDLwRkDoLJ18UrqcqV
         DPaCZJ75X1VKDywuP9nydqnUxuPuex2lS7ICgcGBbfzNXDD7zA/Z9C6kZJdcVOlxKIVz
         T7UiJPem/vi310aAZWsJIBwobs5aXf5GisLk4bgfk16Zr2ngV+OcugnIvT0wnZ77uMpO
         R1sQ306tXtDpGQLEXzjAhjydh/ciguPJ2OjBJ4EOwewErfcTsL/kCEnltKCVx1+Rbedo
         bLbQ==
X-Forwarded-Encrypted: i=1; AKwUvBwh1KnaIXe6eZkFXqG4MHOV9+pdIfnQ/+W6WZnqjdbQ5fe0SMNRXZypFvGrDcTBQgqQY6ImcZ/WN3tWLJVhnDU=@vger.kernel.org
X-Gm-Message-State: AFuF++nlkyu2ETAK5zoHZDmALL1QjhH5lZlLwAI8+CS8w77O+1kkof8h
	BwE0Y2bO9aA0S7m5cxiv4lcp51W56CsTvd0v134G1MB7hc1tSomNFkMt
X-Gm-Gg: AYBFou0IcGtgCHJ/a35yVXb805n9mjo6GJBJriy/rBaXFs+6KjeUEU+QJaAQ2K4EvRm
	vR+kUP/mHJz/jTqjFnJ5HJwGgTVmtZYUVr4OTNWhBZNcm0VSZbMLuEiMHbMGEVbQIu+6YeHAfAK
	OD/TUbhFe229tP4stXkG7n3//6IUFWD/IZXGgO8bRsWv3I3o4rNaBK3sj2yRFtiRa70SvH4/71f
	Q6PIDNWlQGTcOM7HLraV9Ocyox9gBgLov3HzaACCtyKQSJKh76XDq9SpYPfqv3lb2slyRroFUK6
	AYcgJqbolobcOTqxJ5S0xgWxUQgMnLfmWTFyzP9fDLHzON3HeLNpinSSktHraa3xq2+dZ8a9nwF
	lMbNKx/zRMleu5Puf4vSu0p24/Lq+7OQZ18jIwQEPbyVVr3CVZkeNntMiM7kcZv3j9TbDnpWdLS
	C1L4sqD5TqcOziz2lFjDUxWJ4Rs179dMTeRwPqUmZuMX1KbfKIudBsmJzjqzg0ODQZXH3Ncx4yS
	CR+WLP4zOJN5W4UXDJfojua3NTLLAz4DipPB6wOUF3tziN4
X-Received: by 2002:a17:903:2f8b:b0:2d3:160b:c01f with SMTP id d9443c01a7336-2d74ddd684cmr400731515ad.6.1788203319368;
        Mon, 31 Aug 2026 12:08:39 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f95a160sm31727994eec.18.2026.08.31.12.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 12:08:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <98d4603b-0559-46ea-8b76-1f0245b3b266@roeck-us.net>
Date: Mon, 31 Aug 2026 12:08:37 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] A Syzbot-style Platform for Verifying and Fixing
 LLM-reported Bugs
To: Yuan Tan <yuantan098@gmail.com>, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, workflows@vger.kernel.org,
 frankw@nebusec.ai, jhs@mojatatu.com, ksummit@lists.linux.dev,
 kuba@kernel.org, pabeni@redhat.com, kerneljasonxing@gmail.com,
 roman.gushchin@linux.dev, jgg@nvidia.com, mchehab+huawei@kernel.org,
 torvalds@linux-foundation.org, ben.copeland@linaro.org,
 gregkh@linuxfoundation.org
References: <20260830115546.3942129-1-yuantan098@gmail.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20260830115546.3942129-1-yuantan098@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/30/26 04:55, Yuan Tan wrote:
> 
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

Is "Claskiko" misspelled ? I don't find a reference to it.

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

I think it is a mistake to claim that "Not exploitable / No PoC --> false
positive". Not all bugs are vulnerabilities, much less exploitable ones.

Guenter

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

