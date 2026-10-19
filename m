Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C28318B9B;
	Mon, 19 Oct 2026 01:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372883; cv=none; b=IstadUOwcOXbBj0AEcWPVy1SJ4sxH/RGjmq+pm3Vlpd75McdJhCZXCBaSqHtrod/iTt0ZIRzgn7B8MMOoAKreqigb9gTIa6WLI0cSIA4duaJ6iNiNsNNocUQGyb8HZoqGiyub9M+ig4sdqZwBskii5N8aWjerKgGn/Jz0Lj55kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372883; c=relaxed/simple;
	bh=NVcMaSCxfwgowDNmogArpsdgt2cMw/9W5Y7T79INjsI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lSYLnFBpn5J8pYz/RotXWmPovhe2u3Ed/mvieFVyJW552RHf9DxLzHI6i+j2hiyJerpO+ksW0XUaKL7MGD3vHmY1Z9UpW/Jh8uCH1Rr/VrBNh5T2ZjwZTE46mPms/zi5yS7dzUkRlXVrTuPisrcp45X9wOtvo6EYUekErOy/z+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jhCf0PDS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jhCf0PDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061681F000C5;
	Mon, 19 Oct 2026 01:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792372882;
	bh=ZpS6rztuZD/3BaQKhTRC6ZBXf8qIWmBhp8++g235x8M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jhCf0PDS6qI1KBl9yEth6+M7rt4NjX/eEoB5keaWa1sJcLPAt7vgeOqURNs4G89bT
	 iBdelcS6Nf5b+y5C6TcemgSinPa20juR6206OqY9IgCHnOOcYkBk00doL4wfbqNETW
	 TzWEU7jZzuE1mD1U8gMI6tRLWXD5OKPObO3Uj4GCJImixe7XyVY0OY6meMBu4clurb
	 SgJy9JZUw+oIfPsSlVMc/FAgzRHjYejK5auAvl0wxkOPMe8E2XWmyOvX4FD4JeFnI+
	 1+7lpTDJ/pR4c5O+tPsFzp6mYfU6hi2q61K84jgbxfF834nEd3NqiMgBI+poQhqP8y
	 FSPDdkSO1SEDg==
Subject: Re: [PATCH net-next 02/15] selftests: netfilter: nft_queue.sh: only
 queue icmp echo request/reply
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Mon, 19 Oct 2026 01:21:21 +0000
Message-ID: <179237288160.3135.9206589655813468272@kernel.org>
In-Reply-To: <20261018005638.1776148-3-pablo@netfilter.org>
References: <20261018005638.1776148-3-pablo@netfilter.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit fixes a reproducible flake in the bridge NFQUEUE
  selftest (about one failure a day in NIPA), but its message has no…

--

selftests: netfilter: nft_queue.sh: only queue icmp echo request/reply

The patch changes the ipv4 nfq rule in load_ruleset() so it only queues
icmp echo request/reply, which the icmpv6 rule already does. ICMP time
exceeded messages left over after the stress test no longer inflate the
bridge queue packet counts.

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

[Severity: Low]
This isn't a bug, but should this have a Fixes: tag?

The flake looks like it started with:

commit 8a2cfe7951f6 ("selftests: nft_queue.sh: add a bridge queue test")

That commit added test_queue_bridge() and called it at the end of the
script, after test_queue_stress():

    test_queue_stress
    ...
    # turns router into a bridge
    test_queue_bridge

It also loaded the existing "ip protocol icmp queue bypass" rule for the
bridge family, and then checked exact counts:

    load_ruleset "bridge" "filter" 10
    test_queue 10 "bridge"

Before that commit, this rule was only loaded for the inet tests. Those
run before the stress test, so the delayed reassembly timeout ICMP errors
were never counted.

8a2cfe7951f6 says it was added ahead of a kernel fix that checks bridge
ports are still valid on reinject. That fix could be picked up for
stable. If the test goes to stable trees without this follow-up, the
bridge test would flake there as well.

Would something like this be worth adding?

Fixes: 8a2cfe7951f6 ("selftests: nft_queue.sh: add a bridge queue test")

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261018005638.1776148-2-pablo%40netfilter.org
