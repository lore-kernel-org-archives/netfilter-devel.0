Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9F213F434;
	Fri, 14 Mar 2025 20:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741984251; cv=none; b=WRzvkbcrgAQj/YzhOqdfo8R/0LqfyU05dXRb3jEKS9cGtt6Yodnrot0HrtTW4K1cSf02awpTAi6tGSXbIzYk8ijO5iAo4BswtVXTiopV2p5yPsZaq5kJ8gJ/zNMB44t0Yeto7v0CZkJSiaRDThCjRxuvCxlTKUGqPuncxUudjIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741984251; c=relaxed/simple;
	bh=Tii/5aumfduXSEdnRqXO0mOnfa7wjOsTzQjQODor4tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mgDACV7l+L/5id1gEGvwix/y7AeR4MLs5Yv4oH5VeqJZ4Ei8T9JOmCzS3ILWhO5snTUXype98iFDaN0GWXgP7zKFgAwuPlh4cu9GDorh1W2dFJFq1i6VANGMtoBIKqfMfLkr9eIgRTLl5U6oXMzl3AaFCzwjO4eN5NafpheRyfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1ttBg4-0002Ur-RK; Fri, 14 Mar 2025 21:30:44 +0100
Date: Fri, 14 Mar 2025 21:30:44 +0100
From: Florian Westphal <fw@strlen.de>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Florian Westphal <fw@strlen.de>, Chenyuan Yang <chenyuan0y@gmail.com>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Initialize ctx to avoid memory allocation error
Message-ID: <20250314203044.GA9537@breakpoint.cc>
References: <20250313195441.515267-1-chenyuan0y@gmail.com>
 <20250313201007.GA26103@breakpoint.cc>
 <42e5bb33-1826-43df-940d-ec80774fc65b@schaufler-ca.com>
 <20250314164708.GA1542@breakpoint.cc>
 <d2019823-4500-499a-8368-76c50a582f47@schaufler-ca.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2019823-4500-499a-8368-76c50a582f47@schaufler-ca.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>> seclen needs to be > 0 or no secinfo is passed to userland,
> >>> yet the secctx release function is called anyway.
> >> That is correct. The security module is responsible for handling
> >> the release of secctx correctly.
> >>
> >>> Should seclen be initialised to -1?  Or we need the change below too?
> >> No. The security modules handle secctx their own way.
> > Well, as-is security_release_secctx() can be called with garbage ctx;
> > seclen is inited to 0, but ctx is not initialized unconditionally.
> 
> Which isn't an issue for any existing security module.

The splat quoted in
35fcac7a7c25 ("audit: Initialize lsmctx to avoid memory allocation error")

seems to disagree.  I see no difference to what nfnetlink_queue is
doing.
