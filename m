Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027BE134B2;
	Tue,  6 Feb 2024 18:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707244326; cv=none; b=kWtbPNZAI3sphRtjjTJusBMZZWh03iLcnqDYiEokdYsET2vUsAExQwkw0LEBn0rpPbCKJbPru3+l5AwIH1ZcBHkl+IBPDByWEq9QJ6gYnLgKv7GaTf4btmUeAZxAeGQMBvgrPqwtbVaJ04ph5ZH/f6RJWoS1Pc8uFuhSl/352oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707244326; c=relaxed/simple;
	bh=A97uWv1RBCJpMciqRnjrvJ8jEVXJiG2KSp4a26Ujt3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MgQA50nYasFs2/5ejmpbhnkAsttxGRdw8BDgvWI3qylxTl+/wSKh4NjYY5yRDBDcackoAjlDYXeqGSLpKYCZIZNb5vcA5OWkK+y6j0Es7OJy/Ou8rzYhuR1LozVHp7ADN/XA9AZOGICljGSdO4WebAxUU6c0PO7szqebqFd+jNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KWqPyrqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KWqPyrqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D73C433C7;
	Tue,  6 Feb 2024 18:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707244325;
	bh=A97uWv1RBCJpMciqRnjrvJ8jEVXJiG2KSp4a26Ujt3o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KWqPyrqjib+CVoTNnIvW4r/vZVi3INHpKdxE/6yWrIgjviikyOwbQxWB5hMCh2s9J
	 cQr9ua0aWcJwJ6Wacl56SLjNE9Zko6ReyUyoq/a083KGygC/2Hgd/nREqIr89h+/Mq
	 wAR3hET8JkE4PD9K/EavWv8Ob6a/3dWN9dKGyJB6oEsj/8s7y7mCsZXmGOghVsfDiJ
	 6PnV/bOoHsS7YDVHoiBJsVz3DNZIxdd1QIJoR0+4FPq4US5rAeJKQygaIvpP+7Oy++
	 XAZuNXvquhhrX9172xNNjcIwcGBd4U1CMllaLJCc9RGVuRt7/gocFfth1W/IMdwqPr
	 QPHEByLQ0mZ2A==
Message-ID: <7a1014ee-7e1d-4be4-bab2-07ddde8a84b7@kernel.org>
Date: Tue, 6 Feb 2024 19:31:44 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [netfilter-core] [ANN] net-next is OPEN
Content-Language: en-GB, fr-BE
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, netdev@vger.kernel.org,
 David Ahern <dsahern@kernel.org>, coreteam@netfilter.org,
 netdev-driver-reviewers@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
 netfilter-devel@vger.kernel.org
References: <20240122091612.3f1a3e3d@kernel.org> <Za98C_rCH8iO_yaK@Laptop-X1>
 <20240123072010.7be8fb83@kernel.org>
 <d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
 <65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
 <20240124082255.7c8f7c55@kernel.org> <20240124090123.32672a5b@kernel.org>
 <26616300-dc28-47d1-88bb-1c7247d1699d@kernel.org>
 <ZbFiixyMFpQnxzCH@calendula>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <ZbFiixyMFpQnxzCH@calendula>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Pablo,

Thank you for your reply!

On 24/01/2024 20:18, Pablo Neira Ayuso wrote:
> On Wed, Jan 24, 2024 at 06:35:14PM +0000, Matthieu Baerts wrote:
>> Hello,
>>
>> 24 Jan 2024 17:01:24 Jakub Kicinski <kuba@kernel.org>:
>>
>>> On Wed, 24 Jan 2024 08:22:55 -0800 Jakub Kicinski wrote:
>>>>> Going through the failing ksft-net series on
>>>>> https://netdev.bots.linux.dev/status.html, all the tests I'm
>>>>> responsible seem to be passing. 
>>>>
>>>> Here's a more handy link filtered down to failures (clicking on
>>>> the test counts links here):
>>>>
>>>> https://netdev.bots.linux.dev/contest.html?branch=net-next-2024-01-24--15-00&executor=vmksft-net-mp&pass=0
>>>>
>>>> I have been attributing the udpg[rs]o and timestamp tests to you,
>>>> but I haven't actually checked.. are they not yours? :)
>>>
>>> Ah, BTW, a major source of failures seems to be that iptables is
>>> mapping to nftables on the executor. And either nftables doesn't
>>> support the functionality the tests expect or we're missing configs :(
>>> E.g. the TTL module.
>>
>> I don't know if it is the same issue, but for MPTCP, we use
>> 'iptables-legacy' if available.
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=0c4cd3f86a400
> 
> I'd suggest you do the other way around, first check if iptables-nft
> is available, otherwise fall back to iptables-nft
> 
> commit refers to 5.15 already have iptables-nft support, it should
> work out of the box.

Good point, I understand it sounds better to use 'iptables-nft' in new
kselftests. I should have added a bit of background and not just a link
to this commit: at that time (around ~v6.4), we didn't need to force
using 'iptables-legacy' on -net or net-next tree. But we needed that
when testing kernels <= v5.15.

When validating (old) stable kernels, the recommended practice is
apparently [1] to use the kselftests from the last stable version, e.g.
using the kselftests from v6.7.4 when validating kernel v5.15.148. The
kselftests are then supposed to support older kernels, e.g. by skipping
some parts if a feature is not available. I didn't know about that
before, and I don't know if all kselftests devs know about that.

I don't think that's easy to support old kernels, especially in the
networking area, where some features/behaviours are not directly exposed
to the userspace. Some MPTCP kselftests have to look at /proc/kallsyms
or use other (ugly?) workarounds [2] to predict what we are supposed to
have, depending on the kernel that is being used. But something has to
be done, not to have big kselftests, with many different subtests,
always marked as "failed" when validating new stable releases.

Back to the modification to use 'iptables-legacy', maybe a kernel config
was missing, but the same kselftest, with the same list of kconfig to
add, was not working with the v5.15 kernel, while everything was OK with
a v6.4 one. With 'iptables-legacy', the test was running fine on both. I
will check if maybe an old kconfig option was not missing.

[1] https://lore.kernel.org/stable/ZAG8dla274kYfxoK@kroah.com/
[2]
https://lore.kernel.org/netdev/20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-0-2896fe2ee8a3@tessares.net

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.
