Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2836EB5D;
	Thu, 25 Jan 2024 17:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706203832; cv=none; b=g8izpSh7PJXiv7uPvDBiOSoYCi/plMU8LKR2GgXBPjxx76HavTuBA/HU+83b6PYG3r/es9sKAFQ8DxH1pHWWYVEe1mJqCesCyVwK8T9GHQgNug+Vt7JIhfPcvGJjRNMKdZeX7ktPjJiL9XKj66b9hl/2qBbrO8xsZJlDRBOP6/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706203832; c=relaxed/simple;
	bh=sxao1mMAR/lachUSI6p4a5rorm1U/xZcUATSUQ2sBAA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fnwIJ7t/3q3ZrZY2QQZVR2TQATcU5zfsU9UcUlnUifSgJaeVe/90HFm0gbJrquaASMsjqA/Pv5QiTzxs7IIvw2R0b28z7FOsthB7blpeswI2KepijblP51EeIy/VxJOQ9Uq6fIZtcUp1Mu1VduDdhBHNtH+yB54g6ESC2nkMvho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t8CnpT0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t8CnpT0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE6BC433C7;
	Thu, 25 Jan 2024 17:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706203831;
	bh=sxao1mMAR/lachUSI6p4a5rorm1U/xZcUATSUQ2sBAA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t8CnpT0lv8FfBlYxTreAwclfTmAc8Y+T4M2Zsd/MTx+CtPDNjt63B0W4+FZCIqdUG
	 898h79YFchGCBmBEA7pEcAUySwFkzqz2KhhDK1TGoR2R0m3o6/btP7ij62WJQTWxCg
	 5i7H/tLbSSdzGmBuKtzsbSPs9+V12oI977pA5paDvNuxY8GricyIbaDfdK2s4jt+Qh
	 9cN8ZRjNvSklSgiNRO99/5PfBOjT8Y3wp4y6pYLe+KckCH77/8RPiV8CD3U8HahsHg
	 g4gEdS2l1s6W0EjkPegZWZV67F+YDxtkUvFJfqQ5yS1lMm/t1CgLBAgAOzg/OYQUq7
	 ABiuCedDrLMWg==
Date: Thu, 25 Jan 2024 09:30:30 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
 coreteam@netfilter.org, "netdev-driver-reviewers@vger.kernel.org"
 <netdev-driver-reviewers@vger.kernel.org>, Hangbin Liu
 <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [ANN] net-next is OPEN
Message-ID: <20240125093030.1ced969e@kernel.org>
In-Reply-To: <20240125085211.GE31645@breakpoint.cc>
References: <20240123072010.7be8fb83@kernel.org>
	<d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
	<65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
	<20240124082255.7c8f7c55@kernel.org>
	<20240124090123.32672a5b@kernel.org>
	<ZbFiF2HzyWHAyH00@calendula>
	<20240124114057.1ca95198@kernel.org>
	<ZbFsyEfMRt8S+ef1@calendula>
	<20240124121343.6ce76eff@kernel.org>
	<20240124210724.2b0e08ff@kernel.org>
	<20240125085211.GE31645@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Jan 2024 09:52:11 +0100 Florian Westphal wrote:
> > NFT_COMPAT fixed a lot! One remaining warning comes from using 
> > -m length. Which NFT config do we need for that one?  
> 
> CONFIG_NETFILTER_XT_MATCH_LENGTH=m|y

Thank you, that seems to solve the remaining problem!
