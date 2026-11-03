Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793673535;
	b=4gTfWUcjY7wiC74Lt34XpK31MYXGZwW9DWW1UBX8QtSP3ISCN9KA+LfH5aqTK0jxv5WK
	 YizEywQFPyw/UfUhyzzQvWp4cfxL3+JqCnm5tOvD6jpg6Df0c3y6RVNUwmZMg8albwHS7
	 ZjqgR/YKmToMUpx5Sw3QT65fFPF2R+UxFXrF8MHYhRg5Kvga1nTyyW56sqf8XnTV7kr6r
	 NPgQn/WYUTJalYAp+f0qG9xDlEN/4CaldGPObdN7SE8n9Evh6I9Sd8M0dGPmVUQgY3IwG
	 c/nWzWNUOnvD3fOOgpg5C5Xf47OjUuHKrDn/v8dLfSACvWzUu38TIvWTQKUUZzg7IQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793673535;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=TN2SY+XQuLAGFjbX+RbezYmnQEjGJgVOvTaz5eosea4=;
	b=Kkavp8s1603zDX/6TPX4jwWZ5ScWQL3lAeD/6r8eEMgk8u32/2YH9qikqJkV0BUe0dG7
	 SccTuD2MeEuw7T3LKAUfS1DZ59hT4F/umvVDPSyRCKLSo2IZ6/qOIjTSw/70U4EXAJHkv
	 g5xpYOG8zeOL4jGHEOiltpQCGys4z9yPN9ugC9m1prT6Sd5/vjIOdf3vvCj3r1sAyfYJr
	 nXI41c7E8mDkSABNZ3IQxXScPVmMnEtwV1jw0uKtlgLLLgd46VrFLvsXvLccT1yTcU8lj
	 ZylVsmgobF+90bJ9P2O7LNPWN7Rb3u8ysL5ea6SQodlikipwopdmT2y3/csY+41hz0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=NRcYpaC1;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3B7CE606A327;
	Tue,  3 Nov 2026 02:38:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B7CE606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=NRcYpaC1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793673531;
	bh=TN2SY+XQuLAGFjbX+RbezYmnQEjGJgVOvTaz5eosea4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NRcYpaC1GOTisuAxhZ6NNwgbD6DtvFqxJcv3GaGqve515uCmdumullbCdwNS4oRGF
	 lnGEjQovZ+8jNRT0cyumU8cch+D+Kv4LS7LeZFQcLOhcjuIAo2NQeWPlwv8JHcC7IE
	 Ch7px3vOCEvAMtHoxSQVRs/3N1PwA6v3qqQOwpX4Jm5qur0kWIGxljAXJRNSyT0Xza
	 kvgTfuMmtdbpdUWcCc2zoxpxOogV5N54m5t2YaFQkwiBOz/4gojgRQaF9/DdyPLQ8B
	 ATvneEPND4QJGNtnLcZGk9Xwm32spmalXHt7DNxa5PRTZY58YhTIptrysilNCIpUiC
	 lNBbZMWWYWhlw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5F94460054;
	Tue,  3 Nov 2026 03:38:51 +0100 (CET)
Date: Tue, 3 Nov 2026 03:38:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Joas Antonio <joasantonio108@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: do not pair an expired
 start with another interval's end
Message-ID: <aulJOKf7dIxP9mJU@chamomile>
References: <20261031-b4-nft-rbtree-gc-v1-1-51d087c187a6@gmail.com>
 <auYpCzdrOsoWr84Z@chamomile>
 <auYqSpBFtC0nTDDd@chamomile>
 <CAOCBhwHSe7M39Bq6mYuai=gLcq4nfTC2Z5+nm55EUJmpFmRsQg@mail.gmail.com>
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
In-Reply-To: <CAOCBhwHSe7M39Bq6mYuai=gLcq4nfTC2Z5+nm55EUJmpFmRsQg@mail.gmail.com>

On Sat, Oct 31, 2026 at 02:55:55PM -0300, Joas Antonio wrote:
> Hi Pablo,
> 
> Sorry, the description was too terse. Answering both mails here.
> 
> There is no memory safety issue, and I should have said so explicitly.
> It is a correctness problem: after GC the set no longer holds what was
> committed, and the packet path matches keys that were never added.
> 
> Exact sequence, raw nfnetlink. The set has NFT_SET_INTERVAL |
> NFT_SET_TIMEOUT, an ipv4_addr key, no default timeout, and
> NFTA_SET_GC_INTERVAL = 3600000, so the commit-time scan does not run and
> only the insertion path is involved.
> 
> Batch 1 (NEWSETELEM): start 10 with a 50ms timeout, end 20 with no
> timeout, start 30 and end 40 with no timeout. Only start 10 expires;
> [30,40) is permanent.
> 
> Wait 200ms.
> 
> Batch 2: DELSETELEM of end 20 only, then NEWSETELEM of [12,13). This is
> not something nft(8) generates, but the kernel accepts it. Inserting 12
> runs nft_rbtree_gc_elem() on the expired start 10. The walk skips end
> 20 because it is being deleted in this transaction, passes start 30 and
> takes end 40 as the end of 10. 10 and 40 are removed, and start 30 is
> left without an end.
> 
> At commit, nft_rbtree_commit() turns 30 into an interval with ->from =
> 30 and ->to = NULL, and nft_array_lookup_cmp() treats ->to == NULL as
> open-ended. So nft_rbtree_lookup() matches every key >= 30, while
> userspace believes the set holds only [30,40). Reading back with
> GETSETELEM, which uses the same array: without the patch 45 is found,
> end 40 is gone and deleting [30,40) fails with ENOENT; with the patch
> 45 is not found, 40 is present and the delete succeeds.
> 
> To be fair about the limits: the only trigger I have is crafted
> nfnetlink from whoever already owns the ruleset (CAP_NET_ADMIN in that
> netns), so it does not cross a privilege boundary, and I have not found
> an nft(8) command sequence that reaches the insertion-path case.

Ok, then you confirm such sequence makes no sense for nft(8) command.

> The commit-path case (nft_rbtree_gc_scan() not clearing rbe_end)
> uses a different sequence without the lone end delete; I can send it
> in the same detail if useful.
> 
> If you consider sets built from such batches unsupported, I think the
> better fix is to reject deleting a lone interval end element, and I can
> send that instead; or drop this if it is not worth the churn.

While it would be good if this interface could be tighten in the
future to reject nonsense, I think it is not worth the churn at this
stage.
