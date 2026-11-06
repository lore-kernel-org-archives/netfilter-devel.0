Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793940877;
	b=4p4zGlIx0JunKim/ASpUdIw8D/fRxiJagkQDC4eDpiScUsWbdN6AGK0iT62vgXa+C2O8
	 rn2ply5vhOTbrUaT2N3dy3QYNRWnrQq0xPTzhVWqgbSnNoyeMsPrY0xKcXsyCTe3KT5Xe
	 MwQXv2YpOg8Pi6ll3m5ao8jqYenGxxxdeQwwWC/kHXECDazoa9oYmPNlcGDZnppifnyO2
	 LregPriOltLYREBmWx7SH3xzhi0K4jMqWKnVDqJb/M9mcNkqS8mPMHpJ5pFubLIBP8Ew6
	 nzDHJKWLpdJU23OZUmHjOQw0aC5h04v026sEbBBPj5MEtilJQRNhNwHDsT8LsCc7r4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793940877;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=aFtEo7AVor9n5wvSOp0oeze4IpinGPPlnbyoG7+pTWc=;
	b=uCF7EZRc3CQ+aKdAqw2dWyU4kfixLVLR+4e4eQ6krsWAlpEnw+SwlGaW62pvwRiJEYXh
	 emCIURHGAX6jpwOxqi/lw9KsD/Am3h+iirfCJKxidEDjIN2ETTRgBzQQesrE1tQxKVU+D
	 6sFWwFqkVXWjNeJ0NEL8rnWMHi/KRrGOIkX3Zj62NCkA4qrDgHesktDxtCVQzt609lXjo
	 OgkXVE6nY9b/yzs9nSedLqNyG0udEQ9muw7oJOAvhMKKv+ceJjKfJn598h/drIKltx/ql
	 LSzEEKgv+CakeTOq8O1SAag7rMvhwf/SJHqHtUxS6svz8YkDQ5X9kdm5Rl6tDf/r7+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7072B606A31B;
	Fri,  6 Nov 2026 04:54:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7072B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 380246060B; Fri, 06 Nov 2026 05:54:34 +0100 (CET)
Date: Fri, 6 Nov 2026 05:54:33 +0100
From: Florian Westphal <fw@strlen.de>
To: alireza@asgari.net
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	kunit-dev@googlegroups.com
Subject: Re: [PATCH RFC net 0/3] netfilter: nfnetlink_queue: handle packet ID
 reuse and large gaps
Message-ID: <au1difVZWMSV78wV@strlen.de>
References: <20261106-nfqueue-review-v1-0-b6c933f44943@asgari.net>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106-nfqueue-review-v1-0-b6c933f44943@asgari.net>

Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org> wrote:
> This series addresses packet-ID reuse and batch-verdict ordering in
> NFQUEUE. I am posting it as an RFC to discuss the handling of ambiguous
> batch boundaries and the additional sequence state used to resolve them.

-v.  I see 0 bugs here.  Only lots of code churn.

> An old packet can remain queued while newer packets receive individual
> verdicts.

Not really, that would be a userspace bug.  Its not adviseable to do
out-of-order verdicts.  I know some people do that though :-/

> Queue length therefore does not bound the distance between
> pending packet IDs. After a complete 32-bit ID cycle, two pending packets
> can have the same ID, making verdict lookup ambiguous. Even before reuse,
> the signed 32-bit comparison in the batch handler can select the wrong
> FIFO prefix when IDs are separated by half an ID cycle or more.

WTF, whats the point of doing that?

> Patch 1 rejects an incoming duplicate ID before list insertion or userspace
> notification, preserving the existing pending packet. The incoming packet
> follows the existing enqueue-failure policy: drop by default, or accept
> with FAIL_OPEN.

OK, but really... who needs this?

> Patch 2 uses an exact queued boundary to select the FIFO prefix. For a
> boundary no longer queued, it uses a 64-bit queue sequence and a per-entry
> 32-bit epoch to recover issuance order. Ambiguous missing boundaries
> return -ERANGE without changing the queue. The wire format is unchanged,
> but the rejection behavior is userspace-visible. This does not distinguish
> stale verdicts after an ID has been released and reused.

Insane... tons of code added for what?  Batch verdicts are incompatible
with out-of-order verdicts.  I fail to understand why the kernel needs
to become more complex and more complex and more complex.

LLMs make it oh-so-easy but whats left is even more unmaintanable than
the current state.

> I would appreciate feedback on:
> 
>   - Whether -ERANGE with the queue unchanged is the appropriate response
>     for an ambiguous missing batch boundary.
>   - Whether the per-entry epoch and widened queue counter are appropriate
>     for handling boundaries that have already been removed.

Sorry, I have no idea what these patches should accomplish.

>   - Whether the existing drop/FAIL_OPEN policy is the preferred way to
>     handle an incoming packet whose ID is still pending.

That one is fine, even though I would really like to understand what use
case requires holding on to a packet for 2**32 (!) Ids to pass.
