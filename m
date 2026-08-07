Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C2E422E11;
	Fri,  7 Aug 2026 10:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786099013; cv=none; b=WLK8QaPOg5zxnyohVQcEqyobDiyOpUmRUTbC6tm3pqNhzGuERzpvzEWS3YfLH1YF+GHF6/AQecBF64zTEqOz4XUJ/5OZXW09yu5jaOyXNJdBLx0RH8Kjqt8Qwwrp2M0j3dktzyMxlykilfliJytK4qaX2L59a9sFYlIu2lIUnZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786099013; c=relaxed/simple;
	bh=mHVcEd/eHfexbOmMY7gnN7phPg6C+Y3bub7Sjnfz7jw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z3A8GO/IGTQ+qyJ7on3u5jQOZ1QG48K6lhgiRhMsmo/PchzOzGGLjgDagpmtui2OZhZAGC2O6oxNFmr0uP5Or4aMrB3TsS8HU3iyVkXPy6a7PrpNDXngMT6DqpVsFLqmybQzcA7iEuugYvkKuwVRdOKcbg5DAg+//YLFdb4MLTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cHlCBcxd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cHlCBcxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C79C1F000E9;
	Fri,  7 Aug 2026 10:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786099010;
	bh=gSebSgpK+gBMGRg8uELs+1r5jKnwccYomQ3BCVKWre0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cHlCBcxdTbyWLqO6Wol/6WtVaemImlwOJp/79+naYm9RLswPzK3owhwaor/1vhsY7
	 0M167hORpdIQy9Hktbc1ClNNMFMFdCNcZpe5P9mBnztNUU2SgBhqCzzK3hmsUvSQji
	 pBNyewXGYIkHKnwE3DhE2Vz6n9e4VT1hcdCxi7083K+YMh9maV4bgXUvz6f2kI0BZY
	 UMSY/L4mCzPjUhdxffrZWwzENa2i+q04uiT4a1Og3zPD3bBvQZHQielaXmXer7tkEP
	 o2tqjDusx6BdaFNxf0qe4WpyUEnnZ8R/0uGuzusMu8R8bhdhZ+Kzieubq9y7j2mzea
	 4dM2fh6MmoJnQ==
Date: Fri, 7 Aug 2026 11:36:44 +0100
From: Simon Horman <horms@kernel.org>
To: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Felix Fietkau <nbd@nbd.name>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf-next] net: pass net_device_path_ctx to
 dev_fill_forward_path()
Message-ID: <20260807103644.GJ51943@horms.kernel.org>
References: <20260805-dev_fill_forward_path-ctx-arg-v1-1-f2873d941755@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805-dev_fill_forward_path-ctx-arg-v1-1-f2873d941755@oss.qualcomm.com>

On Wed, Aug 05, 2026 at 10:53:09AM +0200, Lorenzo Bianconi wrote:
> Refactor dev_fill_forward_path() to take a struct net_device_path_ctx
> pointer instead of a (dev, daddr) pair, so the caller can build and
> populate the context up front and keep it after the forward path walk.
> 
> This allows additional fields (e.g. vlan and ether_type) to be carried
> in the context and shared with ndo_fill_forward_path implementations,
> instead of being reconstructed on the stack inside the core helper.
> 
> Update the mtk_ppe_offload, airoha_ppe and nf_flow_table_path callers to
> allocate and fill the context before invoking dev_fill_forward_path().
> The network topology resolution behaviour is unchanged.
> 
> This is a preliminary patch to enable HW flowtable offload for IPv4
> over IPv6 tunnels.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

Reviewed-by: Simon Horman <horms@kernel.org>

