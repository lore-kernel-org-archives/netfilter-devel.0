Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794920219;
	b=hoiBfhDT4jm19agBCyjnbfcVXan6uFFWC5wYteQ2kiuzd6jXTaTaFYTvNySWMDowm/xM
	 tuDIHWe+HY4yOru+W/vJtRnUIW6FardUvUzqIJ5S1PiFeh4NcrNLD5qr7uAZ/ZWClne6g
	 pHUrc7n4Jj2E5cK17HrSv+xRWG4qp29YdfM+x0bS+qHrnDDVAB59daOwjHufyB7CfOfSo
	 Jufv5r9OwPNjg9Id6uVL0dcbY1BAGBrE7o0JYeP/Dh1ecYhOx5Q9Whqq1J6SoDkwxeB0H
	 bj0g7ZulJeyXAx1R9wVt+gEKQXax4mjedpbl3Nk4S3b9yRtobqchyLzYY8ErsRfgxYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794920219;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=OTVVvYxat9orkcdedi+eKMTu2VNYh4nZrH1KaOtguVU=;
	b=jXrM9Y2qbFjAwLRC+i4qYVLgmeAqsAM5mwGaffwNes5pKPh2gXRJuBmrh9VYk0NVJBQj
	 WaJt/JKFXGIsutcwmEcDB6kSDHQP3pen0dtKArT2vDstZKqdvDOwqcXc/U2w6aRHk9Dpz
	 V3SYNgXkCJPI7hWT9uJY8lsE7Ql+U2cet7BY9ww9MmXM1em1NF+mGDI9riXbi8m2sHjy4
	 8v8jy6dc/qbCwx+Uz9fUULHLZGDSutUTT00wW+mNejcDfLygjTY86OPmCJJXgd30qXjwB
	 MXdnNmkjqOHW4qiQZS/auM/zJ0h61KbueIQ2iZoA2ouL84KjhwxxUJdTC7sEqamO0hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=bnAuemer;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4A589606A31C;
	Tue, 17 Nov 2026 12:56:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A589606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=bnAuemer
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794920217;
	bh=OTVVvYxat9orkcdedi+eKMTu2VNYh4nZrH1KaOtguVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bnAuemerWRXRXSGbr01HnF1Pqn4KLiRbAMCVJJEkHBCt+43PNXE2ZPv0HBvIK+c4w
	 T3uLMWBm5o/b01JCcjJOoJEhIVVauEd2Irkc8p1OAYasU4Ir+O+ZlCVJJqLiXHV0aG
	 WTA5SwbHuDxQ8ntTpUt2TuzsgHUHGrryekdJx3gZQCEA+fTZJ1TunXXhyJYNI3XoD3
	 XtnW/hZ3dP88eTKLO6PUmoIZr8F2GycEkLhIH/oLFXVZPPQzWT/Vd+4qZ9cGwqBmZc
	 pLFb+igoik9pR9b/cyL8enJ6eGBogvsI0JVH1Zw6O3urpT0y1v8fKKj8QTtBNEzfZx
	 JMFCHzQe0nBMg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0386260057;
	Tue, 17 Nov 2026 13:56:57 +0100 (CET)
Date: Tue, 17 Nov 2026 13:56:53 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Leonard Lausen <leonard@lausen.nl>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4 0/2] ipv6: Honor suppress_prefixlength in
 fib6_lookup()
Message-ID: <avxPFYfEirXzTup8@chamomile>
References: <20261117110813.9894-2-leonard@lausen.nl>
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
In-Reply-To: <20261117110813.9894-2-leonard@lausen.nl>

On Tue, Nov 17, 2026 at 11:08:10AM +0000, Leonard Lausen wrote:
> This revision removes the cached-exception patch and its PMTU test, as
> requested. The series fixes the nftables regression introduced by
> 1c32b24c234b and leaves dst-based prefix suppression unchanged.

Is this a LLM finding? Or a real issue in production?

> The cached-exception work is deferred to net-next after the
> fib6_lookup() fix is present there. Interface-group suppression also
> remains deferred.
> 
> Patch 1 makes fib6_lookup() honor suppress_prefixlength while preserving
> terminal reject results, including blackhole nexthop objects. Patch 2
> adds six checks to nft_fib.sh using its existing fixture.
> 
> Changes since v3:
> - Drop the cached-exception fix and its PMTU regression case.
> - Remove the PMTU-only gateway and peer setup from the test fixture.
> - Renumber the remaining fix and test patches as a two-patch series.
> 
> V3 review:
> https://lore.kernel.org/netdev/20261117091340.GA581197@shredder/T/#t
> 
> The rebuilt v7.4-rc2-based laptop kernel now contains the v4 series,
> without the deferred cached-exception fix. All six added selftest checks
> pass in normal and eight-second-delayed runs; both full runs exit 0.
> Twelve separate reject-route controls also pass. The changed source
> compiles without warnings and passes 17 focused ASan/UBSan callback
> checks. Automated kernel-log checks were unavailable. Target-net runtime
> and full W=1 config builds remain unchecked.
> 
> OpenAI Codex assisted with investigation, reproduction, implementation,
> tests and descriptions. Prompts asked it to investigate VPN failures,
> simplify the series and address review feedback.
> 
> Leonard Lausen (2):
>   ipv6: Honor suppress_prefixlength in fib6_lookup()
>   selftests: netfilter: cover IPv6 FIB prefix suppression
> 
>  net/ipv6/fib6_rules.c                         |  6 ++
>  .../selftests/net/netfilter/nft_fib.sh        | 90 +++++++++++++++++++
>  2 files changed, 96 insertions(+)
> 
> 
> base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
> -- 
> 2.55.0
> 
