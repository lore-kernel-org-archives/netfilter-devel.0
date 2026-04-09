Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4D73D646A;
	Thu,  9 Apr 2026 13:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775742768; cv=none; b=Q38ul4KHsJzl4oSihY0zisC0ZWsQ4MdzIEg1nFaeGihCCK544U6w/kSXW0x57DjJ8xs2n1Ln8ndIz8at5IVHO08nYdA1AZB5JT/B8oKwwb9PdG00TnbZlhgfM01mNUpK2q24yniHQZv76IIN7Q4x4NYHgtXiwsAcbt5zrUVpt8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775742768; c=relaxed/simple;
	bh=22bWjfBPSJNqnW3obSFGY+DfmkXrKL/eqvH4q6bKYtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jm/vaDli/YK3OGSnS7pPI1IBtXt+QEIqnqTec0UGki59L0GP6I87nXQGNzR6aSZBjPopzK9fHMvmboIp+wcSoqz1onXeR8Jlqb+Buc6h+g4gMb5kdItlnK14aAo0xuZpM+F8n6bWfemvG6NXqCGgIEb+LlcAsKjow/ciuA7jESM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NdyAj/K3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NdyAj/K3"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 23EDC60179;
	Thu,  9 Apr 2026 15:52:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775742764;
	bh=24hA1l9NAmNo3LU0r4Q8hfjssSJC6vwBl2Dt0Dwe1A4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NdyAj/K3A2fPx/giXVVKQfyeH1WrYGjmd5lMbaoH1QqoyrngAHcQzJ3fRY/9OoY1A
	 NjZ6OQLJnbvbkIOfUfmcyapser63R/ikzngMBy2uW/5y45Zh3PNUUcVWIyhtNJdlIO
	 BDcFCa5yWR1P01MYbLfQgaBmyr49Ai8Iz9nPqwuuw5ARrwxQ6LhMv+FCWUtQX8zSrr
	 aSY7vcjWtGcJ/BCtwkDNumkVzR7KzNlcAyi9gPan7X+vn0zG4aXjXkcDin0MeXZe6+
	 ZCGJSK4iUmtZMnfkXlRBA1texNhTbl4s2z7GndweiSlFXJfrHzWsBco+zErMdXGCP+
	 RDDEAuVznrUMg==
Date: Thu, 9 Apr 2026 15:52:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Simon Horman <horms@kernel.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH RFC net-next 0/4] improve hw flow offload byte accounting
Message-ID: <adevKeasLkEB5zZ4@chamomile>
References: <cover.1775739840.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1775739840.git.daniel@makrotopia.org>

On Thu, Apr 09, 2026 at 02:07:22PM +0100, Daniel Golle wrote:
> Hardware flow counters report raw byte counts whose semantics
> vary by vendor -- some count ingress L2 frames, others egress
> L2, others L3. The nf_flow_table framework currently passes
> these bytes straight to conntrack without conversion, and
> sub-interfaces (VLAN, PPPoE) that are bypassed by hw offload
> never see any counter updates at all.

I see, but that is part of the feature itself? Why pretend that these
interface are really seeing traffic while they don't. This aspiration
of trying to do all hardware offload fully transparent (when it is not
the case, not mentioning semantic changes in how packet handling is
done compared to the software plane) does not sound convincing to me.

On top of this, this issue also exists in the software plane: Devices
that are bypasses do not get their counters bumped.

Maybe if this is really a requirement, then this should address the
issue for software too, but is it worth the effort to add
infrastructure for this purpose?

> This series lets drivers declare what their counters represent,
> so the framework can normalize to L3 for conntrack and
> propagate per-layer stats to encap sub-interfaces.
> 
> Questions:
>  - Sub-interface stats accesses vlan_dev_priv() directly --
>    should there be a generic netdev callback instead?
>  - Are there hw offload drivers whose counters do not fit the
>    ingress-L2 / egress-L2 / L3 model?
> 
> Daniel Golle (4):
>   net: flow_offload: let drivers report byte counter semantics
>   nf_flow_table: track sub-interface and bridge ifindex in flow tuple
>   nf_flow_table: convert hw byte counts and update sub-interface stats
>   net: ethernet: mtk_eth_soc: report INGRESS_L2 byte_type in flow stats
> 
>  .../net/ethernet/mediatek/mtk_ppe_offload.c   |   1 +
>  include/net/flow_offload.h                    |   7 +
>  include/net/netfilter/nf_flow_table.h         |   5 +
>  net/netfilter/nf_flow_table_core.c            |   2 +
>  net/netfilter/nf_flow_table_offload.c         | 174 +++++++++++++++++-
>  net/netfilter/nf_flow_table_path.c            |   8 +
>  6 files changed, 195 insertions(+), 2 deletions(-)
> 
> -- 
> 2.53.0
