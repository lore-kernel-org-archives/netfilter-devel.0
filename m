Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A852D80BEE
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 12:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722083629; cv=none; b=KMhHcjDt8Gw9k9WgnBCl4FjoHF44aRDmf3nBbEFbyjEwL0wL1XFSpXG///VA7anOaVzCDKTtwIUQa8g48jnWJH91NffX+Ux+MSDFQUcTjSGGbltu8Kn8XEIHSGyKACgrgt+Ox4x3E31Icx2yMqia/9X7vGa+8rfEwf7JhnymerY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722083629; c=relaxed/simple;
	bh=qqFAT8K+GyCpVR2ShjmSmvAHkWX/wBGiHbr/PlaFLoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A44HVfKwaT6w+Cnc7JWoIoD3f6eVLjCaJzUntRjryuO+5j6BEkSjnyQkfYo2loTDNbyLyS31cxS30jnOaTvFtEqQHpVh2ZSfstLgeQfGAgKQ4LDuqafUFZWart+WLy2gsGdJdv4vPfu2SYxmjb97Q0tI9ksW8rS2Ynv/zACGCWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=A6zSW6Lg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="A6zSW6Lg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pIoi8DQWnn8s79iseQ47LEoHLCTRL6zS9hxFmncjbxw=; b=A6zSW6Lg359ceKnvn9zn6Oh0W7
	9mAr1rwL9y5VjVwtlHSyx5jHWdrK2sWWUg/pXyrWd3Nmw9TM6aFM/DuFtv649hNNcGGR+N1uhM5bB
	5tt01OufclSb5QlJPDUeYhzK+QdYBqJ4wn/W9ltM8BUg28iVpYzsnCGUBB2KKSIjsmAcCYijJdWRH
	DsjFv92kdIfZzBriED8TKoyS7wkEHXl41O2mGKy7+fXhiHne5FjFwcphBbEUM6YrF3uK1dgkJ+/NY
	TCwTQwpzH7YJsvCAuiCkazzw84wGs2lGAV4MS4FfhTOPrs8mi3lTETMkOAcL6fuVig4B/ezxmChw9
	l5QQ1dhQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXgcD-000000002qP-2UO4;
	Sat, 27 Jul 2024 14:33:37 +0200
Date: Sat, 27 Jul 2024 14:33:37 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH 0/8] Fix xtables-monitor rule printing,
 partially RFC
Message-ID: <ZqTpIS44pyYLTk-p@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
References: <20240716122805.22331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240716122805.22331-1-phil@nwl.cc>

On Tue, Jul 16, 2024 at 02:27:57PM +0200, Phil Sutter wrote:
> The patches in this series progress from fixes to features, and for the
> last two I'm not sure they are acceptable as-is: Patch 7 is not entirely
> complete, one should follow-up printing ebtables policy rules like
> builtin chain policies in traces but it requires quite some code churn.
> Patch 8 changes output of both events and traces, thus might break
> existing scripts parsing xtables-monitor output.
> 
> Phil Sutter (8):
>   xtables-monitor: Proper re-init for rule's family
>   xtables-monitor: Flush stdout after all lines of output
>   xtables-monitor: Align builtin chain and table output
>   xtables-monitor: Support arptables chain events
>   tests: shell: New xtables-monitor test
>   xtables-monitor: Fix for ebtables rule events
>   xtables-monitor: Ignore ebtables policy rules unless tracing
>   xtables-monitor: Print commands instead of -4/-6/-0 flags

Series applied.
