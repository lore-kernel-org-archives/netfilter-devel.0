Received: from mail-pz2-f9.google.com (mail-pz2-f9.google.com [74.125.228.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97863F58C4
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 09:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788428906; cv=none; b=uhyEYoctc0m/Rg1PaDIgeLe2I7ZotX0Iohbs15h1z471MqtyBL/5B/Fy8ehvaC6NMTg/3fyqaMcciBV8/hCCF9dK0XC9DD332aBKW+LDcP7kX82ZjLWtBNENpOWsVls6SvQmd8JDFJEmpGFjA0LJQ+hpmxUUnWtztke6IsZHBtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788428906; c=relaxed/simple;
	bh=hF3aba3OkkGR6nT7aAbji+fGNkeAzhptQNwpXYG6dpc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XbM7Mjhxcf6y8UVO5UN1tuVtr/lyZalmy156hLI7D/H7MPp07z6X23kdbPUxjiebzlO/O6WcnJYJ2Q/6EmmevaQ7h/esJfZ+MzSeAw0Vo8Hq3nT6KRdDTw1PmpVCwv8Qi9XZoWQO6QCVhlM/ygBMIEPwu/KH0N1AqtLDrcykoZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=gQiH/qMm; arc=none smtp.client-ip=74.125.228.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="gQiH/qMm"
Received: by mail-pz2-f9.google.com with SMTP id 41be03b00d2f7-cc1cb94b583so749182a12.0
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Sep 2026 02:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788428903; x=1789033703; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hF3aba3OkkGR6nT7aAbji+fGNkeAzhptQNwpXYG6dpc=;
        b=gQiH/qMm6Fcj/TrOKMDZR5rQ7vmlQQ4FOeuTyKlMjY+ePmqdlsJbK5gqemlYpIXPnS
         ZZ29YbxzNvZa+sO6KLDdRvqCERX7D3R1x9FBq32CK9jraNkViewBypxwy+BT1PeU34cK
         s04Uar8ovMDrXioW8pCgOOIJygtsFqRvlKgO/2Qo3STEHjV5+KU2VAsAozdR+M9w1fOh
         lhL20HRhg6LW6gHQ3LGdDThPavteJGMuSavMH1zjKRhh7NHdMR+dkV/dIS8dIq4QCW0s
         PoteBgDsbEY6uaWe60R8zDp0DOFPgCFfpFS6vtTKZHIYKtXH0xml9GSjvGX+gv7rUmwt
         e64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788428903; x=1789033703;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hF3aba3OkkGR6nT7aAbji+fGNkeAzhptQNwpXYG6dpc=;
        b=VNv1txsB772iV5nXHxq4OuLCY9DxsGJl3UMjvhFxKyTXB1FQrVxqTNpwdb5v3HsfU6
         ZVK5jgoHcffJtRBFgDTU//x5se8kquCGbw/flomxWhYNhxDs7uxT1wB9r/b8fdzrnsbF
         AEZR3vbyMIbMWb7JnZs0ap/ogV4SJodwhfo6zPcMO3P/g7TszZeC2vS33WObm0e6hGnX
         SwFKTA3N7j9Uh/sdi/w9iS+q5cQWtFiZraBD5W50oY1MCwKtOaG9gOt3yw4Q1rqz+4GA
         0csXrjeylkpvN7thrABfZL9bqJSViTum88IiGyaHOUg2EPSbzkWog+dqH8itIfizyGQ0
         HV8w==
X-Forwarded-Encrypted: i=1; AKwUvBwAJctGgMVXbRjDgvgT3xVv4Y0/le9tuhlQ/KzMAm4qf5fi4YjRuRelC0gQKVVgrP//FjwLF94WejrLv6wk9kc=@vger.kernel.org
X-Gm-Message-State: AFuF++m0omHSxp+XMvyrvxWtB6R7hypWJQSgYzQMkLDyVT3ncD0d/EtT
	YgzjSZTy8nRW6cf/BriTrk+WBypUDhItndj5Uf2y0PA2DaBaQyOOQK/rgOSBYQFrt2P+
X-Gm-Gg: AYBFou1wEnqHwjFu94qzENjSTVJRKRijJkirGL/E2j7TY3FwRSEfteDZeAvH27hpRD4
	/7ZtkKdxD1oC9b7e/dh755T2IYvKj4pNfenCPpUzLpsFMg46E9DteoEd4NqAnEq98K8zp42TQ54
	gsYMwrvIMz/xw1McxGqKtewhHoOH2rzSd7RcjqS8Fpq/4V0t9Jc7DZIlXamM/PMSQ+iGf6FAcJr
	RvETOfCqP/NGUUmWdPJ2m/5vx0cDsmWlVvLjLVDx5C0e+rVxQYJp7+AuNPYeWSG9hrbXtwPMG7S
	8AWQ0icaDpeTqzC78rlN9XR0z4DxZWqWePLj9UD4my698zWEfGZbF5PKdvz/o2zl/q6y4xi9P0d
	OQON+uwDyJ1lgEvchMdIlj6NKsTv0hgKipoB2ZljNQS4lYtaIziVoatVZFryk14LZxgNzrhkexh
	UuzKSbMJCrNHLAHxOM1kZWcAp8qO1THNNXbwLIEuLATreoaUP51tIlbTO2iABv7WYUs1zxIVUKU
	pedl2UaUiRUcevXneZ8/wXFLrV5LeN6+klH1IsrmAapnLxE/OYGrEhEJ8+X/ouY+w==
X-Received: by 2002:a05:6a21:3944:b0:3b4:5ff3:45cb with SMTP id adf61e73a8af0-3d9ad99cf80mr18333091637.8.1788428902766;
        Thu, 03 Sep 2026 02:48:22 -0700 (PDT)
Received: from [192.168.4.59] (c-73-93-246-205.hsd1.ca.comcast.net. [73.93.246.205])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33256414c60sm5194889eec.24.2026.09.03.02.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 02:48:22 -0700 (PDT)
Message-ID: <70c7fe22-d879-41c8-b154-25049818953b@nebusec.ai>
Date: Thu, 3 Sep 2026 02:48:20 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] A Syzbot-style Platform for Verifying and Fixing
 LLM-reported Bugs
To: Guenter Roeck <linux@roeck-us.net>, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, workflows@vger.kernel.org,
 frankw@nebusec.ai, jhs@mojatatu.com, ksummit@lists.linux.dev,
 kuba@kernel.org, pabeni@redhat.com, kerneljasonxing@gmail.com,
 roman.gushchin@linux.dev, jgg@nvidia.com, mchehab+huawei@kernel.org,
 torvalds@linux-foundation.org, ben.copeland@linaro.org,
 gregkh@linuxfoundation.org, yuantan098@gmail.com
References: <20260830115546.3942129-1-yuantan098@gmail.com>
 <98d4603b-0559-46ea-8b76-1f0245b3b266@roeck-us.net>
Content-Language: en-US
From: Yuan Tan <yuant@nebusec.ai>
In-Reply-To: <98d4603b-0559-46ea-8b76-1f0245b3b266@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 8/31/26 12:08, Guenter Roeck wrote:
> On 8/30/26 04:55, Yuan Tan wrote:
>>
>> Hi all,
>>
>> A month ago, I posted an RFC[1] to the mailing list proposing an
>> automated
>> platform that validates AI-reported bugs and prepares draft fixes, and
>> later discussed the idea at the Netdev conference. After further
>> development, it is finally ready.
>>
>> While preparing to send this email, I noticed that Roman has since
>> started
>> a related discussion:
>> [MAINTAINERS SUMMIT] The place of AI code review in the Linux Kernel
>> process
>>
>> It turns out this platform already addresses several of the needs raised
>> there.
>>
>> The platform is available at:
>> https://bugtracker.nebusec.ai
>>
>> It is currently hosted under my company's domain for convenience. I
>> would
>> prefer to move it to a neutral, community-oriented domain once the
>> project
>> name is settled.
>> Access is currently restricted to maintainers whose email addresses are
>> listed in the Linux kernel MAINTAINERS file.
>> For now, only bug reports from the net subsystem have been fully
>> imported
>> and processed.
>>
>> -------------------------------------------------------------------------
>>
>>
>> LLM-powered tools such as Sashiko and Claskiko produce a significant
>> number
>
> Is "Claskiko" misspelled ? I don't find a reference to it.
>
>> of false positives. Pre-existing bugs uncovered by these tools are
>> also not
>> collected in one place and they remain scattered across individual
>> review
>> reports.
>>
>> To address this, like syzbot for fuzzer-found bugs, this platform
>> provides
>> an **automated** tracking layer for AI-reported bugs, but goes
>> further by
>> generating PoCs, running them in QEMU to produce crash logs, triaging
>> severity, and drafting patches. This requires no extra effort from
>> maintainers; instead, it may helps them understand and fix these bugs
>> more
>> efficiently.
>>
>>
>> The platform offers the following capabilities:
>>
>> 1. Collect and Deduplicate
>>
>> The platform ingests bug reports from multiple sources, including
>> Sashiko,
>> Claskiko, and others. It deduplicates them and monitors mailing lists
>> and
>> git history to track whether they have been fixed.
>>
>> It also provides visibility into the Sashiko/Claskiko ingestion
>> queue, so
>> users can see which reports are waiting to be collected and processed.
>>
>>
>> 2. Verify by generating PoC and running it in QEMU
>>
>> An agent attempts to generate a proof-of-concept for each bug to
>> determine
>> whether it is a false positive. According to paper Patch-to-PoC[2] and
>> follow-up research, GPT-5.4 achieves up to a 95% success rate in
>> generating
>> PoCs for genuinely exploitable bugs.
>>
>> This makes PoC generation a strong signal: if a bug has no PoC, it is
>> very
>> likely a false positive. And even in cases where a real bug is
>> missed, the
>> difficulty of generating a PoC suggests it is unlikely to be practically
>> exploitable.
>>
>
> I think it is a mistake to claim that "Not exploitable / No PoC --> false
> positive". Not all bugs are vulnerabilities, much less exploitable ones.
>
> Guenter
>

Thanks, that is a good distinction. I think my wording here was misleading.

By “PoC”, I do not mean an exploit demonstrating security impact or
privilege escalation. The PoC generated at this stage is only intended
to reproduce the reported bug. For example, by triggering a KASAN
report, a kernel crash, or another observable runtime failure.

So the purpose of this step is primarily to validate reachability:
whether there exists a concrete execution path that causes the reported
bug to manifest at runtime.

This is substantially easier than exploit generation, especially with
sanitizer feedback available. More importantly, if the LLM has explored
all reachable paths relevant to the reported bug and none of them can
trigger the reported behavior, then we consider the report very likely
to be a false positive. 

In practice, of course, failure to generate a PoC is not formal proof
that the bug does not exist, but failing to find a triggering path after
exploring the relevant reachable paths still provides useful evidence
that the report may be a false positive.

I should change the text to distinguish a reproduction PoC from an
exploit PoC and avoid equating “not exploitable” with “false positive.”

Separately, we have also built a system for analyzing exploitability,
primarily whether a bug can be turned into a local privilege escalation.
This is a different stage from the reproduction PoC described above. We
can integrate that analysis into the platform as well, although it will
take some additional time to do so. In the meantime, we should be able
to import some of the existing analysis results first.

Yuan

>>
>> 3. Draft Patch
>>
>> The platform produces a draft patch to give maintainers a starting point
>> and suggested fix direction. These still require human review.
>> Patches can
>> be downloaded via b4 am.
>>
>> These patches are not sent to mailing lists to avoid adding AI-generated
>> noise.
>>
>>
>> 4. Triage
>>
>> Based on the PoC, the agent evaluates the conditions required to trigger
>> the bug, for example, whether it requires a namespace, root
>> privileges, or
>> can be triggered by an unprivileged user.
>>
>> Bugs that require root are generally less important, while those
>> reachable
>> by unprivileged users are more likely to have real security impact.
>>
>> If a bug can be triggered from namespace, it is still worth
>> paying attention to.
>> In particular, a bug should not be considered root-only merely because
>> triggering it requires CAP_NET_ADMIN in a network namespace. On systems
>> that allow unprivileged user namespaces, an ordinary user may be able to
>> create a user namespace, create a network namespace owned by it, and
>> obtain
>> capabilities such as CAP_NET_ADMIN with respect to that namespace. Such
>> bugs may therefore still be reachable by an otherwise unprivileged local
>> user.
>>
>> For example, this configuration has historically been available by
>> default
>> on distributions such as Ubuntu 22.04 LTS and earlier.
>>
>> Jamal previously offered some suggestions on this severity
>> classification
>> scheme which I have not yet had time to implement; that will come in a
>> future update.
>>
>>
>> 5. Chat with agent
>>
>> Each bug page includes a chat interface for discussing the bug and
>> its fix
>> with the agent.
>>
>>
>>
>> Based on earlier feedback, the system is not fully public. Only email
>> addresses listed in the MAINTAINERS file are eligible to register, to
>> prevent bugs with potential security impact from being exposed publicly.
>>
>> Jason’s idea of delegating fixes could also be implemented on this
>> platform. This is essentially what my volunteer bug-fixing team and I
>> have
>> been doing over the past six months: anyone interested can pick up an
>> issue
>> and try to fix it.
>> Each subsystem’s maintainers could choose whether to make its issues
>> public. Making them public would also let potential reporters check
>> whether
>> an issue is already known before submitting a new report.
>>
>> Bugs are also categorized by subsystem, so after logging in, maintainers
>> see only the bugs relevant to the modules they maintain.
>>
>>
>> Welcome any suggestions:)  I will continue maintaining this system and
>> adding more features, not only out of personal interest, but also our
>> bug-fixing volunteer team is using it too.
>>
>> We periodically burn tokens and run state-of-the-art models against the
>> full kernel source code, with the goal of finding security
>> vulnerabilities
>> before attackers do. While I am not an expert in the net subsystem and
>> cannot review patches myself at this time, I still hope this platform
>> can
>> be of help to the community.
>>
>> If this system proves genuinely useful, I am happy to transfer project
>> ownership to the Linux Foundation or another neutral host.
>>
>> Going forward, the platform will expose a public API so that other bug
>> finding research teams can submit their findings here for centralized
>> processing. We also plan to ingest syzbot-found bugs to provide them
>> with
>> the same triage workflow.
>>
>> P.S. I have been struggling to come up with a good name for this
>> platform. A
>> few candidates I am considering are Palomar, Tengu, FixArc, and
>> Ephemeris.
>> If anyone has a preference or a better suggestion, I would love to
>> hear it.
>>
>>
>> Current Limitations
>>
>> - For a tracked bug, the system currently only knows that a fix
>> exists; it
>> does not yet distinguish between a patch that has been posted to the
>> mailing list and one that has already been merged.
>>
>> - PoC generation and false-positive verification are not yet
>> supported for
>> driver-related bugs.
>>
>> - Unable to scrape Sashiko/Clashiko review reports that are still
>> under embargo.
>>
>> - Only net subsystem bugs from Sashiko and Claskiko have been
>> imported with
>> a fully automated fix-detection pipeline so far. Bugs from other
>> subsystems
>> are shown but may already be fixed. If other subsystem maintainers are
>> interested, I will prioritize adding support.
>>
>>
>> [1]
>> https://lore.kernel.org/all/20260708092247.4188498-1-yuantan098@gmail.com/
>> [2] Juefei Pu, Xingyu Li, Zhengchuan Liang, et al. "Patch-to-PoC: A
>> Systematic Study of Agentic LLM Systems for Linux Kernel N-Day
>> Reproduction." arXiv:2602.07287, 2026. https://arxiv.org/abs/2602.07287
>>
>>
>> Thanks,
>> Yuan
>
