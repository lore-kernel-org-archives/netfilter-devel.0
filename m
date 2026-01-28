Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09601364E8D
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769612703; cv=none; b=DCEzwvGaTe80+Avn4mNoUfUpiltzMEtAFzrRPmZo/ZPDRm+Gjxxb7eB6m86VJoCTaEJqw14hW5tS8HQXrHMVREjAlG7uk7yO+ZIZhuUD5FKFBYmJyjnavLZMP6ZTuPdOhE1ap/y8l94E7StddLVhkirmdPo04fLLM4WzB+7S2Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769612703; c=relaxed/simple;
	bh=LAIO9mCyI080WEJOvDLj91cTb5HrrPCEVPvGi7wr76w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VDBTjPJw+TE12lorKkIDa+lXhSgC1uijEsBEYCf9lES8wLkiPbySpapyNAypAs7E6k583OrB3h8zMrUM0D3KkxSLHyXr41ah9uVPf6C2+IC/nqIjdW94GUQ3oO1WPVY307NsFkL6W7IcD3NWiQYmIR7xP3abl4rk3Rx9D4ORn/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7D15560516; Wed, 28 Jan 2026 16:04:49 +0100 (CET)
Date: Wed, 28 Jan 2026 16:04:50 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Arnout Engelen <arnout@bzzt.net>,
	Philipp Bartsch <phil@grmr.de>, Jeremy Sowden <jeremy@azazel.net>
Subject: Re: [nft PATCH] configure: Generate BUILD_STAMP at configure time
Message-ID: <aXolklEKen87S_VG@strlen.de>
References: <20260128145251.26767-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128145251.26767-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Several flaws were identified with the previous approach at generating
> the build timestamp during compilation:
> 
> - Recursive expansion of the BUILD_STAMP make variable caused changing
>   values upon each gcc call
> - Partial recompiling could also lead to changing BUILD_STAMP values in
>   objects
> 
> While it is possible to work around the above issues using simple
> expansion and a mandatorily recompiled source file holding the values,
> generating the stamp at configure time is a much simpler solution and
> deemed sufficient enough for the purpose.

Acked-by: Florian Westphal <fw@strlen.de>
