Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B6B1946B
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 20:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728765502; cv=none; b=jQb51S8S/1y605CD+AK3dcTehoUo0L8gkTBclSLP41bTxvsUxM2MJ0xsjMt0VQ+HeuB6QrTEz2Hoxv0NILAGwPoa4Hs7EbKngXiOFgRbM02FaYSttRAHx+bJHIJ3Y1li9WjrUVH8lfvlmfGrpFnx/Z02PnhdfWayOPANinojQuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728765502; c=relaxed/simple;
	bh=kXqltlst689AQPuAE1FdYZDaI1aQKCu6yZIb9K/unN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l9zC+hUE7ecxbzluvGiIk0ra0bw76kP4MgwREBsi1EvB58W5wh/U4GG2VPxIepKxCl4ijnwoVpWerAnq1AvwakiyNAtpn51O6Whtoluo9EsdXa4VVehYvivWSMthcvk9iZtBz1WVeMc0JMMCZ6da06s3XX9rhamP2wSXar8YMOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1szisS-000861-Sz; Sat, 12 Oct 2024 22:38:16 +0200
Date: Sat, 12 Oct 2024 22:38:16 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: use skb_drop_reason in more places
Message-ID: <20241012203816.GA31099@breakpoint.cc>
References: <20241002155550.15016-1-fw@strlen.de>
 <ZwqDI5JcQi5fMa46@calendula>
 <20241012144216.GA21920@breakpoint.cc>
 <ZwqY8Rm74MO_UMM8@calendula>
 <20241012155448.GB21920@breakpoint.cc>
 <Zwqnvy78DX0Mi_us@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zwqnvy78DX0Mi_us@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I did not yet add new enum values or a dedicated nf namespace
> > (enum skb_drop_reason_subsys), because I did not see a reason and
> > wasn't sure if we'd need sub-subsystems (nf_tables, conntrack, nat,
> > whatever).
> 
> Does this mean values exposed through tracing infrastructure can
> change or these are part of uapi?

The enum has had values added (not just appended), so its not considered
uapi.

> From what I read from you, I
> understand it is possible to change SKB_DROP_REASON_NETFILTER_DROP to
> a more specific sub-subsystem tag in the future without issues.

Thats correct.

> > If you like, I can add NF_FREE_SKB(skb, errno) and rework this
> > set to use that?
> 
> Not strong about this. I was exploring if it should be possible to
> remove (repetitive) information in the code that can be assumed to be
> implicit, I still like the word "REASON" in the macro for grepping.

Yes, common name is good.

> I think we can just move on with this series as-is if you prefer and
> add new macros incrementally to refine.

I think we can refine later if there are use-cases for that.
