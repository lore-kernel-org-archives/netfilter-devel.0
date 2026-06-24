Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39C835BDDB;
	Wed, 24 Jun 2026 21:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782334830; cv=none; b=ruea8zSZMkhzajwXtHPMPLGBi8w3Ry0mYFGuRJHIcaQZzXr5v9cvw2uMHyjMG2WvEJWE9BwKAd3kOgwjyIWaqQdPemQDIk0saFUsByR2Q5mvJwCxRWJIUu27/zw0esirHgF4b2dWpow4rq1O4BvezReDr8tvuFSYlNQ12BpKR8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782334830; c=relaxed/simple;
	bh=dPgf/IJ9qzzwy8zDMuHuLckZCQqxfojfxbU/z3DkVA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TJji1i49HW+3xQIfnmtqOn3khByuqd3d7arIaoTroLMqShVAURU4PdAJ78Mu/QaawzbDBWlBSJtdVk5p40148Hw01jhL5rrKD1z/aqUcpVRtI/9S/2x/YPEATf+48JTpyebQhrD5hK8JienxOykOa1+Bcpvyn58oflphVuPtX6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0FE6E602A9; Wed, 24 Jun 2026 23:00:27 +0200 (CEST)
Date: Wed, 24 Jun 2026 23:00:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Carlos Grillet <carlos@carlosgrillet.me>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/4] netfilter: nf_conntrack_sane: replace
 u_int16_t with u16
Message-ID: <ajxFah1khNl5brEl@strlen.de>
References: <20260624184036.71051-1-carlos@carlosgrillet.me>
 <20260624184036.71051-2-carlos@carlosgrillet.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624184036.71051-2-carlos@carlosgrillet.me>

Carlos Grillet <carlos@carlosgrillet.me> wrote:
> Use preferred kernel integer type u16 instead of the POSIX u_int16_t
> variant.
> 
> No functional change.
> 
> Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
> ---
>  net/netfilter/nf_conntrack_sane.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
> index 39085acf7a71..130b3e68090e 100644
> --- a/net/netfilter/nf_conntrack_sane.c
> +++ b/net/netfilter/nf_conntrack_sane.c
> @@ -35,7 +35,7 @@ MODULE_DESCRIPTION("SANE connection tracking helper");
>  MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
>  
>  #define MAX_PORTS 8
> -static u_int16_t ports[MAX_PORTS];
> +static u16 ports[MAX_PORTS];

These port variables are useless and will be removed soon.
