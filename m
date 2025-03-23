Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0883EF510;
	Sun, 23 Mar 2025 16:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742748488; cv=none; b=LkNFg1apeKwiaootVzZHLmSXN+Ldt8hETYGN8zLhsX2mdkrRb377rqFICk2PPEQFQqD2fEZNvkCrtY3DomUteamNqL+gve5O3Af249lEtENKh+ccw/Vo8pDAYfh0pxRKrvTO2XQJDH5+Njz5BTRSBwnFwm84vawi8gfya65sKH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742748488; c=relaxed/simple;
	bh=NEy6S0p5xzIfy6ODr1lpmVmlv6zgmNVtot/sei4opx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rUkFK2z/yQYqecDfXNPc3yEr965SJkAVKcKTiEw6+wbfcTNPgdDoKoTjD0Y3VP28Sum+DsKbnnItkxBzvg43e2PacGbPusHVLkno/oAynJwTabfjwoEeT8U1VzzNNdXPR0Z4ncg+MdybEAlEho+1KIVeELtWYCaZOSGZnESiri0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o9Tn8Cbp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o9Tn8Cbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519BBC4CEE2;
	Sun, 23 Mar 2025 16:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742748486;
	bh=NEy6S0p5xzIfy6ODr1lpmVmlv6zgmNVtot/sei4opx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o9Tn8CbpqNwKSsIdobFS00lNUgLtMSC6ZjE/0//uCGvnE9NY3xf4iF9fmkLXxjVwz
	 7sQcyfN9Vu4CyGSgjSDAxtk4UpSU4A1N2XM5Fx3EUAjMODnecPaZ6KdRJ+dtYMsfYt
	 wCnGiLKYGio4S+wENJcETL5x947S9jSTPp/BudWtNU5kO3Plce8XSkoXN5iDu0PUBp
	 6/Ubzbb8ABqMRqxLoFZ4CT0DU35Wto6KE4pJDFg1S4HRPBWBeZoSIoNkIST401gjX6
	 LWbPskvt//DXxfTSa7BM9Ih7TLe43DOAx0SM+vil6PeB/wxNL8R2cAGJbo7bkn3/mQ
	 /Njwiv6/YdojA==
Date: Sun, 23 Mar 2025 16:48:00 +0000
From: Simon Horman <horms@kernel.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, linux-hardening@vger.kernel.org,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH v10 nf-next 1/3] net: pppoe: avoid zero-length arrays in
 struct pppoe_hdr
Message-ID: <20250323164800.GR892515@horms.kernel.org>
References: <20250315195910.17659-1-ericwouds@gmail.com>
 <20250315195910.17659-2-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250315195910.17659-2-ericwouds@gmail.com>

On Sat, Mar 15, 2025 at 08:59:08PM +0100, Eric Woudstra wrote:
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
> 
> ---
> 
> Split from patch-set: bridge-fastpath and related improvements v9
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>

Hi Eric,

Perhaps this is due to tooling, but your Signed-off-by line should
appear immediately after the Reviewed-by line. No blank line in between.

And, in particular, the Signed-off-by line should appear above the (first)
scissors ("---"), as if git am is used to apply your patch then the
commit message will be truncated at that point. Which results
in a commit with no signed-off-by line.

FWIIW, putting the note about splitting the patch-set below the scissors
looks good to me.

...
