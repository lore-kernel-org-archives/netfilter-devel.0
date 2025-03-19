Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CE019DF99
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 15:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742396525; cv=none; b=Shk3l/HNeb2YX04IaZAIPUmWxm4ddzl/ETw0P9POjTEL4hAUXHyBvbl+CglAbnuSWYKUjOAhTJUb9deKwm/S3Bw46k7Z1FWiukrQjIigs1HKY+z0aMpMWjdgf2+nLKtLrhnCzoHAPSL3n9ZsvMKyYt7LMPdflFKyb3xUXJwtOE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742396525; c=relaxed/simple;
	bh=e1FGPDYXkoDPNER0lAKOBuaDWKqAWw5Wj4ygF7GV0Io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ny2funfRrFt7IOzA9uAbfkkNpzqIINotR1REf9WH80btfT2Azot0ukVk/4rSWD8SyjhlozQjSUam78fKp0lM39Tbnnu909pxAG0ZqiPdVeUQPnH63br2GyOBfI7PT0TPVP545c1dYn3ulW0GP1NpilusgAgUJuJV3997LF75YeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tuuvZ-00015F-Ox; Wed, 19 Mar 2025 16:01:53 +0100
Date: Wed, 19 Mar 2025 16:01:53 +0100
From: Florian Westphal <fw@strlen.de>
To: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl] expr: ct: print key name of id field
Message-ID: <20250319150153.GA3991@breakpoint.cc>
References: <20250319142927.124941-1-dzq.aishenghu0@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319142927.124941-1-dzq.aishenghu0@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Zhongqiu Duan <dzq.aishenghu0@gmail.com> wrote:
>  static const char *ctkey2str(uint32_t ctkey)
>  {
> -	if (ctkey >= NFT_CT_MAX)
> +	if (ctkey > NFT_CT_MAX)

Indeed, NFT_CT_MAX is last valid index.
Applied, thanks.
