Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D3C380FC4
	for <netfilter-devel@vger.kernel.org>; Sun, 30 Aug 2026 11:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788090958; cv=none; b=Q3X0DvOGjZkfF1x1Kf1fHheWZuoQ98ax2hFNpy7wv448oeRhuT75yEuHB4FSsQqtkEvXZomYNrBnFtCYQK4x5LGdTwHeUqPtVwvwZA0R7/FVWr6W2s0fSBs5PKtqBjRTTb/D8bA5zxogcRfjmmz2wIojmW3qY3FoqHwT2k7H7WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788090958; c=relaxed/simple;
	bh=zmjm2TQIi7ZYcXFvX6kkbUarn5qiJfknxctpJ8rIKrI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OuPbeEUYOhBM7KX7uxbGVBrKNku1b2YnXQWPql9JEnN9VJncLC6r22/jFA1gjLaCFpyIxpKCPwKM5rdLbzg466Zzn8IltxGdU6aUaBQnre0Mb7fPH4VAE/MNPTvQAOE9ut285a1kVgUllGqKvSRslmdpAEqF6vH67lI5Czakg1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s6+bkj1y; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s6+bkj1y"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc1c9879395so1922786a12.1
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Aug 2026 04:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788090956; x=1788695756; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uXAVtdXqT4N3HaypUIR8DYqRj/FnDuduwp3EKXKiO+U=;
        b=s6+bkj1yMu4crPPeSW8sKr0SV8OkTvZKH68rCp5XWuCs4tdGcIQKgrZFQSejdTjg8O
         wMMw5SYpC9OHoq49CTCuaOh8hDpO/2B+wumrtriI0M+Vfg1fo13NpKkx7JzYovmhtnWI
         w0ct4BLYnxpf3rl0PR8AQ3iaPZgixbvNbZp4vI1TajUB2unpgVQMQ+BUOMGheX5Dm2Ue
         Mht8/byj7w1pDIENTDMfQDI13bJCj1AsG9lk9reAa2KHcljAf26d3HCRl3de5I41y5Bg
         emUql6Z5mAvutQtWfEYAkLicaguK5lypowmQzzo7+UHg2pLVKV5Cu/j7tBlBgRgId/Fr
         jz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788090956; x=1788695756;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uXAVtdXqT4N3HaypUIR8DYqRj/FnDuduwp3EKXKiO+U=;
        b=hBNOWorZas0ehkF2JzhjLg1v9Jo6wH6NJUpbXMs31tliWm9rg8Tse4sJ8lPrg+Grsd
         ZaVg8ejMti1SnodIIIbe7SizPyyAiHmjBBwLPmCbJNP9DwNFdVU53vDiz9kkN/YBzKk8
         vV8wJfCaIJPQfliu+KJXc6r1a/aoTDQ7j5VJsF6xkHEJn2ImZmqhk/EWAlw9WUj77LeQ
         8fuoPFQFbPVujXV4hWj5j4j6uzRN4W3bavTFy89VtAz768jjdj3LNqiK33J7G293nN3L
         4V1/PDcafKn8YyEvu2/6ck32bdjoRtFdME8y9xsRpl+q0MabYgAg/gtzjMLSu2XakgOm
         dHAw==
X-Forwarded-Encrypted: i=1; AHgh+RqcdFyczJiUI5Ra0vyzkgmQsdbBEd75KYObKNCGxA9ef5s4HlrCBK2L6JS4P9jlN5Pj/gjaePaPluTHMmFAfGo=@vger.kernel.org
X-Gm-Message-State: AFuF++l7psQaoUpncfkUPX8KNPf3ZTYnAJ/xlNMqISspuK7eNpqR4b1T
	u7ivI8Hc16NYpUh9QyzzKlebWIiW426HaxRvG/WIYR6Y4Z+NCtqv/shK
X-Gm-Gg: AR+sD10rCy4ep83wrtqZZJ3EU1LroKGi7L0m7vZEmkL9EEAAmBbpTne5EC/akyw6uIu
	o6AA+jALhz/d2UOnO6YdU4bHKkmQ/zKzcnS1ygD+SbIwwrYO3W2q4+gpZ37h0e72jRz2bq3vX2K
	7QUz78Ml+rbRp/wlTAEjNslVsM1yNXpPyPEx+Hg6BNSxQgqaCJHYDjn5Ndk1JRlsKcyzkq8STrE
	baUFDUP1rpqfJpt9gQsl5mYZjcQXxWDhupfp9HYn2AOa2pMnu+0+bDPyPKTczH28yXIC5jCozWC
	0fGfXOf3xzN1dYimDLFkI1+Ztq8lTKcleiQhHquz+3PvKe7f1Sf9/jdvAYKLHcQJIKz6issog5J
	/JdXEdrAmXb6szFVaDRzl654JHbCQEneAy3QsNf07+VAeTv6dgVat87qkk/ZyS92Sk1cJrgxhA5
	oBlud1ZFayHwYYQPrTCCQ7MyQYXVYcsiM1CzEgTjLVcVArhX+Yt4sd
X-Received: by 2002:a05:6a21:115:b0:3cd:9f99:3381 with SMTP id adf61e73a8af0-3d262679aa2mr35624073637.0.1788090955588;
        Sun, 30 Aug 2026 04:55:55 -0700 (PDT)
Received: from homebox ([66.75.253.8])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0d1abbdsm19622929c88.2.2026.08.30.04.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 04:55:55 -0700 (PDT)
From: Yuan Tan <yuantan098@gmail.com>
To: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org,
	yuantan098@gmail.com,
	frankw@nebusec.ai,
	jhs@mojatatu.com,
	ksummit@lists.linux.dev,
	kuba@kernel.org,
	pabeni@redhat.com,
	kerneljasonxing@gmail.com,
	roman.gushchin@linux.dev,
	jgg@nvidia.com,
	mchehab+huawei@kernel.org,
	torvalds@linux-foundation.org,
	ben.copeland@linaro.org,
	gregkh@linuxfoundation.org
Subject: [ANNOUNCE] A Syzbot-style Platform for Verifying and Fixing LLM-reported Bugs
Date: Sun, 30 Aug 2026 04:55:45 -0700
Message-ID: <20260830115546.3942129-1-yuantan098@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Hi all,

A month ago, I posted an RFC[1] to the mailing list proposing an automated
platform that validates AI-reported bugs and prepares draft fixes, and
later discussed the idea at the Netdev conference. After further
development, it is finally ready.

While preparing to send this email, I noticed that Roman has since started
a related discussion:
[MAINTAINERS SUMMIT] The place of AI code review in the Linux Kernel process

It turns out this platform already addresses several of the needs raised
there.

The platform is available at:
https://bugtracker.nebusec.ai

It is currently hosted under my company's domain for convenience. I would
prefer to move it to a neutral, community-oriented domain once the project
name is settled.
Access is currently restricted to maintainers whose email addresses are
listed in the Linux kernel MAINTAINERS file.
For now, only bug reports from the net subsystem have been fully imported
and processed.

-------------------------------------------------------------------------

LLM-powered tools such as Sashiko and Claskiko produce a significant number
of false positives. Pre-existing bugs uncovered by these tools are also not
collected in one place and they remain scattered across individual review
reports.

To address this, like syzbot for fuzzer-found bugs, this platform provides
an **automated** tracking layer for AI-reported bugs, but goes further by
generating PoCs, running them in QEMU to produce crash logs, triaging
severity, and drafting patches. This requires no extra effort from
maintainers; instead, it may helps them understand and fix these bugs more
efficiently.


The platform offers the following capabilities:

1. Collect and Deduplicate

The platform ingests bug reports from multiple sources, including Sashiko,
Claskiko, and others. It deduplicates them and monitors mailing lists and
git history to track whether they have been fixed.

It also provides visibility into the Sashiko/Claskiko ingestion queue, so
users can see which reports are waiting to be collected and processed.


2. Verify by generating PoC and running it in QEMU

An agent attempts to generate a proof-of-concept for each bug to determine
whether it is a false positive. According to paper Patch-to-PoC[2] and
follow-up research, GPT-5.4 achieves up to a 95% success rate in generating
PoCs for genuinely exploitable bugs.

This makes PoC generation a strong signal: if a bug has no PoC, it is very
likely a false positive. And even in cases where a real bug is missed, the
difficulty of generating a PoC suggests it is unlikely to be practically
exploitable.


3. Draft Patch

The platform produces a draft patch to give maintainers a starting point
and suggested fix direction. These still require human review. Patches can
be downloaded via b4 am.

These patches are not sent to mailing lists to avoid adding AI-generated
noise.


4. Triage

Based on the PoC, the agent evaluates the conditions required to trigger
the bug, for example, whether it requires a namespace, root privileges, or
can be triggered by an unprivileged user.

Bugs that require root are generally less important, while those reachable
by unprivileged users are more likely to have real security impact.

If a bug can be triggered from namespace, it is still worth
paying attention to.
In particular, a bug should not be considered root-only merely because
triggering it requires CAP_NET_ADMIN in a network namespace. On systems
that allow unprivileged user namespaces, an ordinary user may be able to
create a user namespace, create a network namespace owned by it, and obtain
capabilities such as CAP_NET_ADMIN with respect to that namespace. Such
bugs may therefore still be reachable by an otherwise unprivileged local
user.

For example, this configuration has historically been available by default
on distributions such as Ubuntu 22.04 LTS and earlier.

Jamal previously offered some suggestions on this severity classification
scheme which I have not yet had time to implement; that will come in a
future update.


5. Chat with agent

Each bug page includes a chat interface for discussing the bug and its fix
with the agent.



Based on earlier feedback, the system is not fully public. Only email
addresses listed in the MAINTAINERS file are eligible to register, to
prevent bugs with potential security impact from being exposed publicly.

Jason’s idea of delegating fixes could also be implemented on this
platform. This is essentially what my volunteer bug-fixing team and I have
been doing over the past six months: anyone interested can pick up an issue
and try to fix it. 
Each subsystem’s maintainers could choose whether to make its issues
public. Making them public would also let potential reporters check whether
an issue is already known before submitting a new report.

Bugs are also categorized by subsystem, so after logging in, maintainers
see only the bugs relevant to the modules they maintain.


Welcome any suggestions:)  I will continue maintaining this system and
adding more features, not only out of personal interest, but also our
bug-fixing volunteer team is using it too.

We periodically burn tokens and run state-of-the-art models against the
full kernel source code, with the goal of finding security vulnerabilities
before attackers do. While I am not an expert in the net subsystem and
cannot review patches myself at this time, I still hope this platform can
be of help to the community.

If this system proves genuinely useful, I am happy to transfer project
ownership to the Linux Foundation or another neutral host.

Going forward, the platform will expose a public API so that other bug
finding research teams can submit their findings here for centralized
processing. We also plan to ingest syzbot-found bugs to provide them with
the same triage workflow.

P.S. I have been struggling to come up with a good name for this platform. A
few candidates I am considering are Palomar, Tengu, FixArc, and Ephemeris.
If anyone has a preference or a better suggestion, I would love to hear it.


Current Limitations

- For a tracked bug, the system currently only knows that a fix exists; it
does not yet distinguish between a patch that has been posted to the
mailing list and one that has already been merged.

- PoC generation and false-positive verification are not yet supported for
driver-related bugs.

- Unable to scrape Sashiko/Clashiko review reports that are still under embargo.

- Only net subsystem bugs from Sashiko and Claskiko have been imported with
a fully automated fix-detection pipeline so far. Bugs from other subsystems
are shown but may already be fixed. If other subsystem maintainers are
interested, I will prioritize adding support.


[1] https://lore.kernel.org/all/20260708092247.4188498-1-yuantan098@gmail.com/
[2] Juefei Pu, Xingyu Li, Zhengchuan Liang, et al. "Patch-to-PoC: A
Systematic Study of Agentic LLM Systems for Linux Kernel N-Day
Reproduction." arXiv:2602.07287, 2026. https://arxiv.org/abs/2602.07287


Thanks,
Yuan
