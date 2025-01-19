Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74F2BA27;
	Sun, 19 Jan 2025 01:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737248759; cv=none; b=sls33rjZUYT6CDG1/U2YANl8tBWu4nGSfEBQb6f+Tbra6+15FG47Qkgd3Zx7Ytrhog8BJHWWhqCAfEm8VAMGAbtQnABpE8e6u2rvHKQ2hQRW+ZL/cPnOYF0EWyCLi7YhlkRP0Y+vrFAZlFpKRlTp6Kp9sczNbbxaa+XN68vdsyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737248759; c=relaxed/simple;
	bh=vRRlsD9TmN8rxirfApX/K5soEYyvXnGxyUL7tGwgxco=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e0+1q/W/Zz6DIhFPCgjFW1wW4ds2rKJpvZo+8JnWZC4t5p1OP/ijfTi7XteieeMKMWRhhtgFR1IQCr34759NtAYO7v6hmT0vY9J8TBj5juVMi9qufmzg1X/ett59ma6XyyPRsdxZFOqFgJYzOLGzRcqGhIC3rSWDhwtUv4ckedY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LUTEudmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LUTEudmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28F9C4CED1;
	Sun, 19 Jan 2025 01:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737248759;
	bh=vRRlsD9TmN8rxirfApX/K5soEYyvXnGxyUL7tGwgxco=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LUTEudmE+1J9Lg1N3qLdK+f4Sf/zdixF9Uc6ZrdJ0QXj9aq+LOEFtRztBfgfCyg43
	 lrx/21Bz/0WPeDuLa2GRuqSdoLADtuRKvh5Fkp2WuPHdsoPTMAZ28DSQxdIzYBTcpS
	 ZFvr+3Ol/bKRR60kbub4QwZacIlTUv95hb9L0HHLzn/bU4im+7Ik2+vB0drWK+kB1o
	 Mo65eGUUmgBBK5OWfTBumtBmBY0wURvLMovFE+wbZ+HE0qaDrTxnXNfhIM9OZGUZYx
	 cMUjQ1MPEK/H3Hf71/ingiMGConP3xgFXhSZBDMn2JjZaPM98BIpNxWNE8fik4boJJ
	 hJOWLOvPBcopw==
Date: Sat, 18 Jan 2025 17:05:57 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de
Subject: Re: [PATCH net-next 12/14] netfilter: conntrack: rework offload
 nf_conn timeout extension logic
Message-ID: <20250118170557.69238151@kernel.org>
In-Reply-To: <20250116171902.1783620-13-pablo@netfilter.org>
References: <20250116171902.1783620-1-pablo@netfilter.org>
	<20250116171902.1783620-13-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jan 2025 18:19:00 +0100 Pablo Neira Ayuso wrote:
> +/**
> + * nf_flow_table_tcp_timeout() - new timeout of offloaded tcp entry
> + * @ct:		Flowtable offloaded tcp ct
> + *
> + * Return number of seconds when ct entry should expire.
> + */
> +static u32 nf_flow_table_tcp_timeout(const struct nf_conn *ct)

FWIW kernel-doc -Wall wants a : after the word Return:

net/netfilter/nf_flow_table_core.c:435: warning: No description found for return value of 'nf_flow_table_tcp_timeout'
