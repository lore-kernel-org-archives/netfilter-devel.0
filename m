Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F2A1B81B3;
	Fri, 30 Aug 2024 18:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725041937; cv=none; b=Cp3SijqvXXRnR7iU4UQXPwtS/Jmss0jyw9kj0pZZqlgvQ1tE3Jf26kpPjAom/9gI16aHKQPGoogEMeUvHFnh4JvL809Pos6p8D/aKDmPuNZwfEV3hG5Bfpgxy/w8gCWD/y503uaYHmqoMoP9VCvnyXaqKaL5Kjwm8D//7EUsGhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725041937; c=relaxed/simple;
	bh=ndMxz9smi89g9vUWHsG7/pVoH9KEAp/0C+C97/k6+4I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejZj+3nA1gmovfOV0TaAuwr7n/1G1lqaFcY6iDMN2p9yCCqMh4MqvZQJvkdDZGUDQgAapjno/NzXXs8B7j7NRM09u/S/QPHh1BCMhwkd5F/cYUaZomWBga6KefACZWpeCqoctaCNQZKVRms472Yj2Sc4BR8D34OughpXT9r1HBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ns6yVLA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ns6yVLA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594DFC4CEC2;
	Fri, 30 Aug 2024 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725041936;
	bh=ndMxz9smi89g9vUWHsG7/pVoH9KEAp/0C+C97/k6+4I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ns6yVLA+R8LKyuI9RiuCM4wsgWsdk6GTlLLuAkHvcU5cd6dZ7xOqGZ720vocbqkwc
	 DBMkHmLuZGOIcIsnCT1nE8ocArXLI/hB+VKTLM9gpes0nttYtv/2zosMNlkPPo+6nQ
	 woVefq/1XqIjuvQDJtP97CzoDRMbR7hUJeUPdyPjodCtZ/0ua33+BHAL/jhJJidXhy
	 BRkCReb0lq/SgblDKqeV3pDsbDy5NItCKgjxW+M+WufOQwDe/WUweTJP2vFQsjxQm+
	 dJFeNY0isR8elPCIv4RsB0womcmmklX19U4KE0YSQgp5Z8zMIB4JyN3R//zpKmr5i2
	 3u/sDD0RJ2bJA==
Date: Fri, 30 Aug 2024 11:18:55 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, rbc@meta.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v4 0/2] netfilter: Make IP_NF_IPTABLES_LEGACY
 selectable
Message-ID: <20240830111855.7d04cd3a@kernel.org>
In-Reply-To: <20240829161656.832208-1-leitao@debian.org>
References: <20240829161656.832208-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 29 Aug 2024 09:16:53 -0700 Breno Leitao wrote:
> These two patches make IP_NF_IPTABLES_LEGACY and IP6_NF_IPTABLES_LEGACY
> Kconfigs user selectable, avoiding creating an extra dependency by
> enabling some other config that would select IP{6}_NF_IPTABLES_LEGACY.

FWIW I can confirm this version causes no disturbances to known CIs.
-- 
pw-bot: au
