Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719821;
	b=JRvu7zxEB8xYFvaZDNbucTgt1CZvrl0I+1HqxtcrZ8KCLotJYI7n0vfgGsq79HpfMNiA
	 HMwLjLYXwftyxntR7w/G1j4uh6wfReRwWbSqv00O/+V28pWhop6q++yAqDxbN0Zepr4sd
	 uLUtd/9aApkOrRoW26xadI0c0zAfKebeFeTfxv8UN7TJB7ZcG70gMFb5ohA69Sdt85LUF
	 DqdmFygPwXM/VmeRQIfwZsECKiD+hGjqdOcyvnEDYxCWv7oq1FK4BprZwxQ2W7xS3kLy2
	 KeFek7KWzIQEZSACBJgVG5hqPdymSuLb9bXDwPstFnE9vkE9P00NjjMF/Z8WAHImB0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719821;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=wqMUZYGt8/JtXCLQ/OJktfmQmPOAqO+arF6Ph52aKFc=;
	b=R2veC8cL+GNss9f2IFFfNubnUAJr6pIJt1VdyocpU6Oq3xuV8IHij+chhL7jjPHSD0XL
	 4puih06NqEAkiB8dkHIN8WJluMr7+ygJ6Qha7tkkmW+vWfOp46fErRlhoe8bsFv6J6tsq
	 H7tQBjNqjj/g11hZjP6Brn8h6Qu6Zs83DCIs8mItnhqdNwMD6kQi4jz0IEro4jXpyNalY
	 bkLRhtmIf6WEgmYmhDppbJvyBuHfKismKKlB1VWicQEI5kkiHm+y7AEbUKXlAEAO6OmjY
	 JTM5J7niYNWS+8fOYO7l+F9oL7GyK8V8JkAMmiq8Z43Q9G89xe7tIlM2fxsyZIGIong==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hcWXlv+9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83970606A327;
	Tue,  3 Nov 2026 15:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hcWXlv+9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841141F00A1A;
	Tue,  3 Nov 2026 15:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793719821;
	bh=wqMUZYGt8/JtXCLQ/OJktfmQmPOAqO+arF6Ph52aKFc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hcWXlv+9oWPyFioJIa6usTvwkrkRKDynR3Vu9DHd42MtZSKHdt3+cpP26KoV5K2g1
	 vPRneIZHt5iRJwGZycjZcjBZH6qMHiW2oJmsJjEVZ0yEpfKxUALmWhHCJROFakvqUn
	 VFiWDOTLaWLkbUw7LQpc4zPFC1iOFjeUhrMRpu4zjOT2yqum3gI/3a9RzRwEkl4J0X
	 4aTlzW39ke1wCsEOWixGdIHETUhR9rx8sB+Cygb2pLOakzV68Dvd3QK4repYfU+W2T
	 4k6JyxjwNYbDKQXjc5WmxqQ0aEIrtJlHbo64ODNt5wBwx9iIf+Nirl4xIVfteljJbS
	 VmJv4U1hBhdZA==
Message-ID: <2cd43496-dc97-470f-922a-65bcbbb40529@kernel.org>
Date: Tue, 3 Nov 2026 16:30:13 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net 00/15] Netfilter/IPVS fixes for net
Content-Language: fr
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Paolo Abeni <pabeni@redhat.com>, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
References: <20261102005654.532438-1-pablo@netfilter.org>
 <b452b25b-37fd-48ab-a88c-feec6b82e9ec@redhat.com>
 <5dc1159d-e577-442f-a7b2-8d5dcc8cfb01@kernel.org>
 <aunlVk2Cn7ocgANE@chamomile> <aunmABdLpFILZvGt@chamomile>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <aunmABdLpFILZvGt@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Pablo,

On 03/11/2026 14:47, Pablo Neira Ayuso wrote:
> On Tue, Nov 03, 2026 at 02:44:57PM +0100, Pablo Neira Ayuso wrote:
>> On Tue, Nov 03, 2026 at 01:27:30PM +0100, Matthieu Baerts wrote:
>>> Hi Paolo, Pablo,
>>>
>>> On 03/11/2026 13:04, Paolo Abeni wrote:
>>>> On 11/2/26 01:56, Pablo Neira Ayuso wrote:
>>>>> Hi,
>>>>>
>>>>> The following batch contains Netfilter/IPVS fixes for net:
>>>>>
>>>>> 1) Add recursion count to nf_reject infrastructure to prevent stack
>>>>>     overflow, from Fernando F. Mancera.
>>>>>
>>>>> 2) Address a infinite loop in RCU list traversal with the TWOS IPVS
>>>>>     scheduler, from Darong Lu and Julian Anastasov.
>>>>>
>>>>> 3) Use kfree_rcu() to release IPVS parent application to fix UaF,
>>>>>     from Chengfeng Ye.
>>>>>
>>>>> 4) Fix UaF in IPVS netns removal path due to releasing per-net protocol
>>>>>     data too early, from Chengfeng Ye.
>>>>>
>>>>> 5) Fix unbounded growth of stale, unmatchable IPVS connection entries,
>>>>>     from Julian Anastasov.
>>>>>
>>>>> 6) Restrict maximum master conntrack chain depth in ctnetlink,
>>>>>     from Florian Westphal.
>>>>>
>>>>> 7) Preserve recursion count on nfqueue reinjection, from Zihan Xi.
>>>>>
>>>>> 8) Restore GRE timeout in the flowtable, otherwise, WARN_ON_ONCE()
>>>>>     is reachable, from Michail Andreas Michalopoulos.
>>>>>
>>>>> 9) Check non-null gc transaction in nft_rbtree before queuing it for
>>>>>     processing, from Xingyuan Mo.
>>>>>
>>>>> 10) Replace WARN_ON_ONCE() by DEBUG_NET_WARN_ON_ONCE() in
>>>>>      nf_conntrack_bridge which is reachable if the protocol of the tag
>>>>>      of a frame differs from the vlan_protocol of the bridge.
>>>>>      From Laveesh Bansal.
>>>>>
>>>>> 11) Check x_tables target name is non-null before accessing it when
>>>>>      building a new table, from Fernando F. Mancera.
>>>>>
>>>>> 12) Fix out-of-bound memory read in nf_conntrack_sip, from
>>>>>      Joas Antonio Dos Santos.
>>>>>
>>>>> 13) Fix a memleak in nf_tables hardware offload when double deleting
>>>>>      the same rule, in the same batch.
>>>>>
>>>>> 14) Use a mutex in xt_recent netns exit path instead of spinlock,
>>>>>      since proc unregistration might sleep. From Cen Zhang.
>>>>>
>>>>> 15) Zero the nf_nat_range2 struct before filling it up, to avoid
>>>>>      using stale uninitialized stack data to configure NAT with
>>>>>      an esoteric NAT flags combination. From Florian Westphal.
>>>>>
>>>>> Please, pull these changes from:
>>>>>
>>>>>    git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git
>>>>> nf-26-11-02
>>>> I'm sorry, but something went very wrong on the nipa side: the tools did
>>>> not pick this PR. Do you mind repost it verbatim?
>>>
>>> It looks like the patches have not been tested, because of the kdoc
>>> issue on patch 6/15:
>>>
>>> https://netdev-ctrl.bots.linux.dev/logview.html?f=/logs/build/1198360/14931104/kdoc/stdout
>>
>> I routinely run checkpath.pl, I will re-check what happened here.
> 
> Well, here I have a script that contains checkpatch.pl and the
> following call as well:
> 
> $ scripts/kernel-doc -none net/netfilter/nf_conntrack_expect.c
> 
> but it shows nothing here.

NIPA uses "-Wall". With it, we can see the issue:

  $ scripts/kernel-doc -Wall -none net/netfilter/nf_conntrack_expect.c
  Warning: net/netfilter/nf_conntrack_expect.c:311 No description found for return value of 'nf_ct_expect_alloc'
  Warning: net/netfilter/nf_conntrack_expect.c:311 No description found for return value of 'nf_ct_expect_alloc'

(And with -Werror, the script returns a non-zero RC code.)

Cheers,
Matt

