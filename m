Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FF91FE456;
	Fri, 14 Mar 2025 16:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741970843; cv=none; b=VtqBYvZL/BDLpiR5C3K371oX4kTKUZQueWnVb6dm0y8AirDs1aS6znWRaqiZKie1Gz6VSD3ae8JoUEYIMQFmesGH0EHnGt5H/UxrKWiVJZDkvI5trdqaRDABJoBRnfe9IQAQ3YK4XtYblLBPnBaEC3jiZdrPvGxPlfaiOTup5lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741970843; c=relaxed/simple;
	bh=IeCWrKaDkFGUKK9xyZBHuT2sEoISC44LS+6x+Z6W2ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iQpfjXrVZkwhdSCaIy3Vk+7RtTrMPsqH15WkCMhgo5TnmXGOTp2mtziz+J9ORAnXPVzop9rV1jwuHIko8iEaXu6prXORmvgeP/gN6ac17m2bCzZWkg3Gjhsp/XNyIbHbjjnjUCvtHyBViaxdir2TBSyrRAyCFcgTk6irWh18h/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tt8Bg-0000XF-8A; Fri, 14 Mar 2025 17:47:08 +0100
Date: Fri, 14 Mar 2025 17:47:08 +0100
From: Florian Westphal <fw@strlen.de>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Florian Westphal <fw@strlen.de>, Chenyuan Yang <chenyuan0y@gmail.com>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Initialize ctx to avoid memory allocation error
Message-ID: <20250314164708.GA1542@breakpoint.cc>
References: <20250313195441.515267-1-chenyuan0y@gmail.com>
 <20250313201007.GA26103@breakpoint.cc>
 <42e5bb33-1826-43df-940d-ec80774fc65b@schaufler-ca.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42e5bb33-1826-43df-940d-ec80774fc65b@schaufler-ca.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Casey Schaufler <casey@schaufler-ca.com> wrote:
> If seclen is 0 it implies that there is no security context and that
> the secctx is NULL. How that is handled in the release function is up
> to the LSM. SELinux allocates secctx data, while Smack points to an
> entry in a persistent table.
> 
> > seclen needs to be > 0 or no secinfo is passed to userland,
> > yet the secctx release function is called anyway.
> 
> That is correct. The security module is responsible for handling
> the release of secctx correctly.
> 
> > Should seclen be initialised to -1?  Or we need the change below too?
> 
> No. The security modules handle secctx their own way.

Well, as-is security_release_secctx() can be called with garbage ctx;
seclen is inited to 0, but ctx is not initialized unconditionally.
