Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D6E823DD;
	Thu, 15 Jan 2026 00:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768438230; cv=none; b=EP/YcLuuFyZ6XPPP7dd6N/DDBY0L5E1P92h1e/NMnSkTYnXSJsQpP4j57oUBUV3ehoVVJ9S25fGb/+2LlNze+R7oDIrcSdx1alh2IRUraiZlf53DnP9g6tQKmfEWPYSwskvOAJsbc1f3tI3MLNQ7oDh3wUEapfj9/x3qgf57Arg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768438230; c=relaxed/simple;
	bh=eStBNHuVJZd7KYXzKYXzSWhNPxCmIuWJ7ALR3h/3iMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWuLM1onK8xXkdi6hYZsZ+Rinjl6eFEELvFsOOTqkPUIH70Sp0KATL23IFKiclKqRN3pmxJHKgXjMmC7f9srZJk3v3SH5L+kseu3JOwcveirQNuzJJ5QmOCQcyllxG6TamZpudJ8EkyDOr1+T+XrUUu3NQXnTO5UGqsJW2bm49A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DjtiFM8D; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DjtiFM8D"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id AFE4660263;
	Thu, 15 Jan 2026 01:50:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1768438218;
	bh=ZSUGdC+7ex0KbqRn0EFf2AX2oFFhNydU4GocpO15CEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DjtiFM8DHK4bYIaLPuGUP32lbthPFW5apPnQn5pVr/mLuDt6YNp/uQ312Yggt7tsW
	 kYmNbdc6sXpcCC4rLhdUl5y0UCd1vnylMJ8zkD3UQoOhJ2xZoD/gWwwB2Z7KdwKCg5
	 o+soF5WGCm6zQYmbRvlDz/RekwfIbyXEplMzFHrGQPWziYcXe6durrL0v2s/fa9M6Y
	 aNZlYJ3cJ924j/vh3BZFEEfU6O3mYLTr73l3i5Rsh5cb5Iz1ystX/UriBMP7sS756k
	 b1gvO5OPSnrEN0mnP/F4KhYjlOydLOjbyrkeHzA2PQhw587a4b4UyDX4x7EUrn6ILx
	 kWuvFdfs/0o3w==
Date: Thu, 15 Jan 2026 01:50:16 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH v5] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
Message-ID: <aWg5yCcSrLZka854@chamomile>
References: <20251122003720.16724-1-scott_mitchell@apple.com>
 <aWWQ-ooAmTIEhdHO@chamomile>
 <CAFn2buDeCxJp3OHDifc5yX0pQndmLCKc=PShT+6Jq3-uy8C-OA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFn2buDeCxJp3OHDifc5yX0pQndmLCKc=PShT+6Jq3-uy8C-OA@mail.gmail.com>

Hi Scott,

On Tue, Jan 13, 2026 at 08:32:56PM -0500, Scott Mitchell wrote:
> > > +     NFQA_CFG_HASH_SIZE,             /* __u32 hash table size (rounded to power of 2) */
> >
> > This should use the rhashtable implementation, I don't find a good
> > reason why this is not used in first place for this enhancement.
> 
> Thank you for the review! I can make the changes. Before implementing,
> I have a few questions to ensure I understand the preferred approach:
> 
> 1. For the "perns" allocation comment - which approach did you have in mind:
>   a) Shared rhashtable in nfnl_queue_net (initialized in
> nfnl_queue_net_init) with key={queue_num, packet_id}
>   b) Per-instance rhashtable in nfqnl_instance, with lock refactoring
> so initialization happens outside rcu_read_lock

Yes, but...

Florian suggests a single rhashtable for all netns should be good
enough, you only have to include net_hash_mix(net) in the hash.

> 2. The lock refactoring (GFP_ATOMIC → GFP_KERNEL) is independent of
> the hash structure choice, correct? We could fix that separately?

No lock refactoring anymore since rhashtable would be initialized only
once for all netns, as Florian suggests.

> 3. Can you help me understand the trade-offs you considered for
> rhashtable vs hlist_head? Removing the API makes sense, and I want to
> better understand how to weigh that against runtime overhead (RCU,
> locks, atomic ops) for future design decisions.

Your approach consumes ~1Mbyte per queue instance, and we could end
up with 64k queues per-netns.

This is exposed to unprivileged containers, this allows userspace
to deplete the atomic reserves since GFP_ATOMIC is toggled, and...
there is no GFP_ATOMIC_ACCOUNT flag, then accounting does not apply in
this case.

While rhashtable a bit heavyweight, it should consume a lot less
memory and users does not have to do any hashtable bucket tunning.

> I'll use a custom hashfn to preserve the current mask-based hashing
> for the incrementing IDs.

OK.

Thanks.
