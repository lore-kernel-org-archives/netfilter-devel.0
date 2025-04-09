Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B470226ACB;
	Wed,  9 Apr 2025 16:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744215932; cv=none; b=XYnoFUKKKlx7nCpPFbB7D8mZkRR7bqdRs38uPJ+cQXp+xBJk/Oxl56wrRBwuOpJOHi6AztWl9GKoug/bLRS9MtYaZrGgkmguqpkpJizawXGsnMWIPINLdjKyzA6LbJS2snAdgiOgZFSRgfXV/vy3mKQPuc9vhlttSmOHkrkmZhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744215932; c=relaxed/simple;
	bh=Or8ZyypeIwZJpxaC5/YAmhtdOzEWbnUvN1Hsw/pxgzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rJtPE8gpng+q00aV6Zsny5ewMnezbG92dHNywnbhIxE+zTFs3GYPElzC0rqckPoVSt1uUPFjNxMv2hOSMb0NHPbrIapngcLj2BtyZCLHAd9hKHe0p+ZuyFIs30EfDKu1O8pEj975IBTQEFwbqFFpx1K4dUdfGS1pAYtUoXVIwpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IjAFBKkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IjAFBKkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C16CC4CEE2;
	Wed,  9 Apr 2025 16:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744215932;
	bh=Or8ZyypeIwZJpxaC5/YAmhtdOzEWbnUvN1Hsw/pxgzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IjAFBKkbF6K0ZsrxQKGk6i10sxR6und2qMP+jB4em4QzK2W/iwyFpPxO64JKUTypT
	 eu05VKyUzSf5HCVsvFSs/pcVK0u6L+pamnYVCCN6Hb6usWEjI5HO+OoPQkVERbyTLM
	 LbTp51cPW8vP22NyyeHOr0yojQ5vBaOkRRRZZnwV/PtTU/Gbn2/ZO3NGnyv12viOBo
	 ab1lTSERL8q42o23kT6XZhOtHorZxAvPqfG+UMNfSUheZEyAWUSUS7EMowoVQ0+xMZ
	 TjAn3nXLQO0hq3hGAMh61V9BNOowEPLP9jwA2EkajH4q+frYGbne0pBsBbV/LWxSHo
	 i2NwjluKNf4Bw==
Date: Wed, 9 Apr 2025 09:25:29 -0700
From: Kees Cook <kees@kernel.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v11 nf-next 1/2] net: pppoe: avoid zero-length arrays in
 struct pppoe_hdr
Message-ID: <202504090925.2FB4D65@keescook>
References: <20250408142425.95437-1-ericwouds@gmail.com>
 <20250408142425.95437-2-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408142425.95437-2-ericwouds@gmail.com>

On Tue, Apr 08, 2025 at 04:24:24PM +0200, Eric Woudstra wrote:
> Jakub Kicinski suggested following patch:
> 
> W=1 C=1 GCC build gives us:
> 
> net/bridge/netfilter/nf_conntrack_bridge.c: note: in included file (through
> ../include/linux/if_pppox.h, ../include/uapi/linux/netfilter_bridge.h,
> ../include/linux/netfilter_bridge.h): include/uapi/linux/if_pppox.h:
> 153:29: warning: array of flexible structures
> 
> It doesn't like that hdr has a zero-length array which overlaps proto.
> The kernel code doesn't currently need those arrays.
> 
> PPPoE connection is functional after applying this patch.
> 
> Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
