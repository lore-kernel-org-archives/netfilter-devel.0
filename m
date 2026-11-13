Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539834;
	b=AhU5QAV+rj8MZN3ML2ohVRxFq9yGEWwkX2VhL3wGzjp3KcRevbBZQgJqyJi7kJCRymkM
	 nJOv9t8Q98TQzKCCg8L4+Dh59ZaqN3aQU0MVYu7UoRhI2IwEqfmM+M8Y9W/kJjgJ0n2EP
	 mApo/a8oTyKP103FJQv9i+N+ghIvLUkxV+Zv3ii3h0b5dQx1fjtfmKnssXf+VHKpX/1iE
	 iIX3B6YeYAWTWNLj3dktlRk898n+BT5Gyw3CFHxt0lRFQq91/N+Xn3X8vJYPupna366Qw
	 wZtznbIbMXzm4uz9j/zMzDk8854UYJlucBktAgUG9XqgFbO2yrtfe3NJ9tKg3n0R22A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539834;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=VLT/rjbsmOQJChtKGwvIto5NY2ZFLU1ESdNoEdyOEss=;
	b=RzpnAtx4hko2FVTFTTUnmqcAYWmWBor6BEtvlPBc4vZ9GkmQZWTF3DUct2HsQkXKrZ3s
	 YN2ph1fKZJBPcAUlhpb1qMf1ZxR2oFmyUarD83nDPRN2CYAZPocNYo2VL+eUw8GOjz7Sn
	 JMFpAjvYyVA3J3iBJQh7rZiPBU1o03+sBR/I//ZfhVdlcsp62wcaNC6BnBTF2I96V7tTr
	 pHr7evYJdXvBsnreCqyCzSIJEMDUbfmNhxZlH4L6E6eYR223NznxIVggkrVDKry1xGR9m
	 JPwTpDbhtCmO3gRrAkKrD5XWF3TIg1N+vyxjQLTWRkbLeHtHQzwtJdIOJyBJW93DOBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=q2QbflTG;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 24DCB606A31C;
	Fri, 13 Nov 2026 03:17:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24DCB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=q2QbflTG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539832;
	bh=VLT/rjbsmOQJChtKGwvIto5NY2ZFLU1ESdNoEdyOEss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q2QbflTGYs7LWmAx0vsNdSaZzi2edBaboE/uuYB3RQKEjRuAF+oPnv0Ujjj6tSSLq
	 nl9s6Ci+cGEEDgaSsMiE8rB43Tn0R4eyRcuuEeK991ANqkVcKvSBJi7YCrpsK6QXsy
	 +vy+2rhIsYtgtP3QNOn+HaDUptP6vsTCcVs7LOI7CuMFKlQGUBXopidQIzj2HkJ5Tb
	 sagtsgYd9ATQAExIh4Dd2iE5nwHDQAXaHlAAJV4fmuHYM1Ylph4Vu3vydZG9sz0gvZ
	 UoJ1Z5PJLzoUlFl3ompNz+1v6KNXvifI86AJqGbe4XA0YkSMQ+nJIPkiVZTHueh5cR
	 F+lzbbDLrdmoQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E23E460055;
	Fri, 13 Nov 2026 04:17:11 +0100 (CET)
Date: Fri, 13 Nov 2026 04:17:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sinfo@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 01/15] ipvs: avoid out-of-bounds write in
 ip_vs_nat_icmp_v6
Message-ID: <avaBNHMRfHHcvQG0@chamomile>
References: <20261113011447.2357709-1-pablo@netfilter.org>
 <20261113011447.2357709-2-pablo@netfilter.org>
 <179453261966.2168702.2891153493137589697@kernel.org>
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
In-Reply-To: <179453261966.2168702.2891153493137589697@kernel.org>

On Fri, Nov 13, 2026 at 01:16:59AM +0000, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.

This is a PR, there is a mix of patches coming from different
sources but...

>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by LLM and not proven at runtime). If it was triggered
>    please include the symptoms, like the stack trace or kernel messages.

... these are mostly LLM findings.

> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
> 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.
