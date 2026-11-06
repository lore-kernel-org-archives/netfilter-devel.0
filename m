Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793976968;
	b=xW6VUMyhUaRQbazt9L8Qk2T44bqeUxVWYMh70dA74E3zj9XNieLplGOnn03u6hc1TkwS
	 877Gc0gYpJQT+qlGGiQ3E3/tvoqjxF/5q9r+iOdJVuc6GTlngYQvpGjYzVq/QfNM+ENht
	 ITFnmMNJPNDVNpkdMD9MQfqM1jnRXnE991ZkoufFIPC8eU0hQji2EGYEIl1hhYxJxCUsN
	 H4+XwgdQCmgArU7NvUWTT50Mws4zxef8eu0OGKGm9YsHXx5B1fln3miPBKfCnAfsDUzDz
	 20e1HJL1gzjMRvX+lo0pdt+rZFBtBuxoOJKM2uNSGMPyL/t4mZlcnGmjZ1+5R0Vo9hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793976968;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=44Kq5PAoWNdUJGo1lbLbuFxYrkrQuyX17K7NNzXNArw=;
	b=kxAEkYCqiqX8fRPlPxxMJ7QDsyWGH3tPSRqgpe3VKPDNm5YZBYy5tH9kVUZtFqBOABkk
	 5WZ3rhetKecSs19CHlBPCaBv97y7OhF65R+RVv7AoBPV20jKAnbXhgOGyO9KaiI3DNww2
	 x2TIB82bQhz+iMRMfuqPWXO0TCoXvYALYHOn6ou46qquUuXR2N7pK9Lzca5QNCx81drgd
	 2YySwME2C7gd/2NjqNWy1+PJue8/yGb8X/Th9nRKZFR1KDDiBQGJCtBA3ZdOz16DpuWwC
	 GpHn5Tly3CljvN8UvgZTC1tTfNTLsyCuznqm2hSYPKZSr77LTPe40GnLTNh4Z26uupA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2805C606A326;
	Fri,  6 Nov 2026 14:56:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2805C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9ECA36060B; Fri, 06 Nov 2026 15:55:58 +0100 (CET)
Date: Fri, 6 Nov 2026 15:55:52 +0100
From: Florian Westphal <fw@strlen.de>
To: Alireza Asgari <alireza@asgari.net>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	kunit-dev <kunit-dev@googlegroups.com>
Subject: Re: [PATCH RFC net 0/3] netfilter: nfnetlink_queue: handle packet ID
 reuse and large gaps
Message-ID: <au3qeEf0LVzO84d3@strlen.de>
References: <20261106-nfqueue-review-v1-0-b6c933f44943@asgari.net>
 <au1difVZWMSV78wV@strlen.de>
 <1a1b040da34.2a9c00de770859.6266910270967560587@asgari.net>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a1b040da34.2a9c00de770859.6266910270967560587@asgari.net>

Alireza Asgari <alireza@asgari.net> wrote:
> Thanks for the review.
> 
> I understand that batch verdicts are intended to be used in strict sequence. The scenarios motivating this RFC did not establish a failure under that usage model, and the evidence presented does not justify the additional epoch and missing-boundary handling.
> 
> I’ll drop the current series. I also understand that the proposed collision disposition being reasonable does not by itself establish a need for the duplicate-ID guard. I would revisit that separately only if I can provide a concrete use case.
> 
> Thanks for taking the time to review it.

If you want to work on something else that is actually a problem, then
you could investigate the mem exhaustion issue.

The current limitation is queue length based, this is very old from
a time when GSO/TSO aggregate skbs did not exist.

Untested idea:

1. compute a memory size limit based off the old NFQA_CFG_QUEUE_MAXLEN:
   sizeof(sk_buff shell structure) + 2048 (half a 4k page).
2. store skb->truesize in the entry struct when queueing.
3. charge the truesize to the queue entry (and uncharge on reinject).
4. in addition to the queue length check, also check if the new
   skb->truesize would bring us over the limit, refuse queueing if thats
   the case.
5. Make sure NFQA_CFG_QUEUE_MAXLEN updates continue to work.

This leaves on major issue: userspace can request 64k queues, so these
limits don't help.

One possible solution:
1. For init netns, no changes.
2. For non-init netns:
   at queue creation time resp. when limit is altered, pre-charge
   the worst case occupancy to kmemcg.

Refuse queue creation if that fails.
Ideally this could be split into several patches to ease review.

Thanks.
