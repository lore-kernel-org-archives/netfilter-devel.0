Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D762F273C
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 10:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752660714; cv=none; b=J1gcjdlCsrqljqOIO8w5Kmp79F1jVZOUT3Xq84qK50lJ2Fghfll9aqwAM2HekvefFvS4TYPnJv+RY57urRxAP7Hs33lwA58zyog3BAM1+sm8e2BSl8QJipDD5A0Kri8mRdvl9C/PcpMbUG3kIDLYF3GoWalp2B37MmQgJ/46/j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752660714; c=relaxed/simple;
	bh=VO2LNeiXPw61ehS8YcLEsj2lHHlBOWCGBMCmmqOKcyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQz+x6/hrokk3guf9fcXtzp1r5uFnmn3YXkEEr2FDTKpB1bBuMvDUuymahXmQkgjMzf6SwkXUxJa/bFPnoOcBHuuZ8cqAlVMjRiuCmIYlTmPfbdWsffuPAX2VRjPRs8e96N/RQ9hCVjz7/rk4/IJAKQXtbnu0CCr5oU4Dm/sX+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DEPemCyT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DEPemCyT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LDOWiWny2tb+9EEbmW9y2rgOKtyYzHRknJMgqYpaE/M=; b=DEPemCyTKP2qlsTO/9n1hQjfLd
	4oD7qLdDi9HRH88I1Oe+j1v9SWNJQopMvi9KIgvODwAHwfaxVoejMbpCuyz1hwLeCyHzWeTmVaUQB
	zAjA6tuQlxOsWoVW7Jqa2UjJmh9oE3JhSPJu3IuIl9Wp9WZ8h4s0t3g4fEcNaEcBZg4LAq2y7ypG1
	HYhnES2h6huaT6diT77UnuxHT2wSKMxFhxM7pYIUKQ/AlWnMNh0XNVIIKnKNukrYkhvc7DojIV120
	nTyF7ZZUabpmlGDs1ZGqosKDzrW0oqyHinZ7gx1/fIvNr0GpvLU1A46znMydK0lDbSSu0Jr0bDxsp
	NU7KTeUA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ubz78-000000001PI-2vtV;
	Wed, 16 Jul 2025 12:11:50 +0200
Date: Wed, 16 Jul 2025 12:11:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH v2] utils: Add helpers for interface name
 wildcards
Message-ID: <aHd65lemE5mkLkKt@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250715151526.14573-1-phil@nwl.cc>
 <aHd0mxVSp_cFcn16@strlen.de>
 <aHd4k3kkCfI2o4NV@orbyte.nwl.cc>
 <aHd5_6m4WgC6--0T@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHd5_6m4WgC6--0T@strlen.de>

On Wed, Jul 16, 2025 at 12:07:59PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Wed, Jul 16, 2025 at 11:44:59AM +0200, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > >  #include <string.h>
> > > >  #include <stdlib.h>
> > > > +#include <libmnl/libmnl.h>
> > > 
> > > Why is this include needed?
> > 
> > Because of:
> > 
> > | In file included from udata.c:9:
> > | ../include/utils.h:88:40: warning: 'struct nlattr' declared inside parameter list will not be visible outside of this definition or declaration
> > |    88 | const char *mnl_attr_get_ifname(struct nlattr *attr);
> > |       |                                        ^~~~~~
> 
> That struct is defined in linux/netlink.h.
> 
> But you can add a foward declaration for this, i.e.:
> 
> struct nlattr;
> 
> As the layout isn't needed for the function declaration.

ACK, will do!
