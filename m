Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8265CA6F
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2026 00:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791506384; cv=none; b=McEPCl+MRBLidTSyOJqfvRuIH7CJ/vzx577QVu3eAiBi9xaqhKBZCZEeEfmEHJb7SZMR6SE3FfsaeiacrWYsshWSfdhJnVd6zCWeZ3WS7gqbgLt6Jy65dMviEhWL+EM8AII7DClgMPPlMbaCORzDrxmIXcsk5T4FaO8gtMwn3Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791506384; c=relaxed/simple;
	bh=SnUVwcmbBFmk5IFz63CCHvk3NXX4N+OMCX4ckfy9jww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dyqHkmHNU+T7CTesNrHIVmOTAv3ambP7QpQ91tWjs+KLbeUc03+GKsd7/Xc4YcSGQMR5GzaibM1CdBo3Z7u2Qujbu7R47BCumEW3KrCE88Z9JQU5uiQTwsmnlTTdh+WSvdnbf/0ibgVD2ZofzmQCgT8dwesZ6CYfcl4WAJAOP2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A6ECB6058A; Fri, 09 Oct 2026 02:39:40 +0200 (CEST)
Date: Fri, 9 Oct 2026 02:39:38 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH nf v3] netfilter: disable br_netfilter in user namespaces
Message-ID: <asg3yr9V-fUHjN8S@strlen.de>
References: <20260831151107.25269-1-fw@strlen.de>
 <asg3R0zgnLUICy5w@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asg3R0zgnLUICy5w@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > brnf_init_net can no longer depend on CONFIG_SYSCTL, else such builds
> > never disable support in user namespaces.
> 
> I pick up late on this, given it is late in the -rc, I'd suggest to
> take this through nf-next.
> 
> Let me know, thanks.

Sure! nf-next is fine.
