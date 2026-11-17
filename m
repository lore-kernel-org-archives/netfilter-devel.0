Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911193;
	b=Z8BBQwOEGP+iqCEy0bA3bzDk3n9S5o1SL0rdk/683LzeVnJhLcI66J00ZAM3ik4GNeY2
	 Air0a2CwN90Ww42ygq97oOkYSN+bhcBddl1WYgYpfgXmjyd5gYkemG0KsbubZFRyLi9ER
	 pkBx29T8qiZlWCNVyCnmQtvpYXzEh+LOSfQ8eXFmuXovK63UZ98T6riAwu5W1MqivapqJ
	 HbznV8f1NJeZXOwobac0BMdfV+/LaiqmpjPtguP/TiihDSeyflQzc33P/UU7hsoa9dVL+
	 bW4Dx5B+1+MRa11FnFEGM3LRLz6RklI3K5yTMr/RZcg8I6btP/PwyyY4BpYfO4UpOJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911193;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=Vm8fCUb0PTrPZmrMT6GsSOC21f5tCtSd3vKAbkklXKs=;
	b=vnwY6gKUI4xicfiAs1EKhd8IZYVCCpemgVzTXfbSrvyD1rg4mN2BbrSvjXft4A8DGfYc
	 BFCFiKbkYW3O97z8ZwQkwUjvmUGKSkr5s/ZWf2qKEX6wFAUpSWfP294K1JOJZaXh0KpkK
	 4w9ct3+/eE3k0lT8+KbrUR2/9HDelmnNKAr9JoGPqjuzsckgBdbQTP/8t44xi8nYOekXP
	 Q344emwOC48q0EOfggPezJLF0n7JFFwTtSDZnpvl1SvwTr+xoTZvSDYyVL8KbjcfouSa5
	 I6ZyIcV4QuvqZKZWJarwYyuj4ftFu7ZOc3gQs4rYHcGpc2tgt1zLohavhu5Tmc0wHCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=pfmdCEUk;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 652F6606A31C;
	Tue, 17 Nov 2026 10:26:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 652F6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=pfmdCEUk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794911189;
	bh=Vm8fCUb0PTrPZmrMT6GsSOC21f5tCtSd3vKAbkklXKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pfmdCEUkrydiCr1SRy9k8UNTOm6curUNlAmaQWXlJcwx7+ORxZyokfAQjJkc+zyNt
	 agTFDPrOfCqnQsXx3RcmxV8W0PgP5NksJjVQSAZ9J+hXCJJ98iaLtNNs+tTWgesThJ
	 SyzRvzCELIAY2miE69lG9ZKfFuWeXDNxvGwkUUt7hsnnDzPeGbvyGSz2BM3gmsPoXK
	 ec5X8G5W09CiEnqqnybHG3RPvPwiCBeWyHsKBCEBxQvviSUezqdIkg/Opf/zmfzOnH
	 sNQqJcIJhsZeV606iuRhEFnMo79lQEiRAZKay5eayt79He0CC6n4xDot4BCZg7WFB5
	 xqrqPqRufbJIw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B257060076;
	Tue, 17 Nov 2026 11:26:29 +0100 (CET)
Date: Tue, 17 Nov 2026 11:26:27 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev-bot+sashiko@kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/13] netfilter: flowtable: do not hw offload
 flows in teardown state
Message-ID: <avwr00Q8q5PK1YNZ@chamomile>
References: <20261116001612.2806263-2-pablo@netfilter.org>
 <179487496421.3136.13242797618262399074@kernel.org>
 <9ead5297-c706-49d7-8226-99955d81ccae@redhat.com>
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
In-Reply-To: <9ead5297-c706-49d7-8226-99955d81ccae@redhat.com>

On Tue, Nov 17, 2026 at 10:40:48AM +0100, Paolo Abeni wrote:
> On 11/17/26 01:22, netdev-bot+sashiko@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 2 potential
> > issue(s) to consider.
> > 
> > Critical: 0 · High: 1 · Medium: 0 · Low: 1
> > 
> > If you believe none of the issues are legitimate, please reply to each
> > issue of Medium severity or higher and explain why the AI is wrong.
> > If any of them are legitimate and you plan to respin, please let patchwork
> > know by including "pw-bot: cr" as a separate line at the end of your reply
> > (one such reply per series is enough).
> > 
> > - [High] The fix is incomplete.
> I understand from discussion on v1 that the above is understood and will be
> addressed as follow-up. The same for the mid issues in patch 2/13 and 3/13.
> @Pablo can you please confirm the above?

Confirmed. We'd prefer to address one thing at a time,

- The CLOSING state logic needs a review, 1/13 is focusing on the TEARDOWN
  state specifically.
- Regarding 2/13, more existing drivers need updates. Currently this
  update to retrieve stats when the flow entry is deleted is a no-op
  for nfp and mlx5 because these drivers are ignoring the stats object
  in the delete path. No harm, just those need to be updated.
  There is also a remark on different lastused type (u32 jiffies vs.
  u64 in drivers).
- The issue described in 3/13 in also a pre-existing issue, ie.
  conntrack -D or -F is also missing pending (non-accumulated) stats
  in hw.

I consider these are a pre-existing issues.
