Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CE3199E94
	for <netfilter-devel@vger.kernel.org>; Sun, 26 Oct 2025 21:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761515940; cv=none; b=csdbKWwebTWex79NwrtAYTCsiChIIYmm90Wl/jU+bDNIAL4z1UK2wMdhVsJZPIQX6mVeVCmPLU3n1LJu83z03BFmycLWO2cKVSLVWDG+kJlpX808VehRI01bMNM0o2Cj2pP3M+khEmJiCC7qrpy7BkRuD5s2K++n5eKnES8vgPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761515940; c=relaxed/simple;
	bh=zAZ5mgYXZeOlSf0GI/zzhGqtA+2J1DPBbA5mKIO1MJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oI4ZpX+z+AoqiLUNr+mM5xrg+hL32HstFwdpFBCepLbaOS5Ptr1DvKS6nYmO7Wr1cvsLBwnmF8NsrfpGrFuZSAVZcLOa+Y4tr5MjzlOl5hjf4IcbvCMFXI51UA9EZepl3HYDQNU/G2fm3zUeyTFJ2mVoV2xk9bH+n9qGW3hsHzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 33C2A603CA; Sun, 26 Oct 2025 22:58:55 +0100 (CET)
Date: Sun, 26 Oct 2025 22:58:54 +0100
From: Florian Westphal <fw@strlen.de>
To: Gyorgy Sarvari <skandigraun@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] tests: shell: fix typo in vmap_timeout test
 script
Message-ID: <aP6ZnvKpyEuvhU5Y@strlen.de>
References: <20251026204107.2438565-1-skandigraun@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251026204107.2438565-1-skandigraun@gmail.com>

Gyorgy Sarvari <skandigraun@gmail.com> wrote:
> While executing the test suite from tests/shell folder, the following error
> is displayed many times:
> 
> tests/shell/testcases/maps/vmap_timeout: line 48: [: : integer expected

Applied, thank you.
