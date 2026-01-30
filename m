Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51375224AE0
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 13:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769778389; cv=none; b=YMEeDVRtjM1yniuajbCzXta3ZMeuOIupQ/Dttf4qU5u7pT9IGeLBQKZTF8Z3CgXvUpYU7FJq2da0ntRY7f7KPRbURlqXb8nnyUkLCbnmME/CUxa2whskucItElZUAffjKJ5W5TaGLe5PCJCUe/vU5kbabCRVQ56vilD+yVKuWyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769778389; c=relaxed/simple;
	bh=74eu7CLQA44s4+4hBRscG9LXCd3mva/UN0q1L5hCU3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K9dUkWsAsr9mL7tOhCnZmFqM4m6CddCNpqYEqM6X5/nDlkmHuNI6gxSY0L4qlmWjfTqaF8ER14BepMlkfwu5lDO2uOKRD495miH+nYZUT8CI+vIQI9/M+asvzysJPMsTpd7u6lm5abjm1qzB7jD+ENSICo0SSn4/bnUXpCfzpw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E55AC60284; Fri, 30 Jan 2026 14:06:24 +0100 (CET)
Date: Fri, 30 Jan 2026 14:06:24 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] tests: shell: Review
 nft-only/0009-needless-bitwise_0
Message-ID: <aXys0GNWBg9NWuq6@strlen.de>
References: <20260129195755.13905-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129195755.13905-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> - Avoid calling host's nft binary, use double-verbose mode with *tables
>   tools instead
> - Update expected payloads to match new byteorder-aware libnftnl output
> - Drop '-x' flag from shell

Thanks, this makes it pass for me again.
