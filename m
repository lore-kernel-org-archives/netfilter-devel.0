Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E071DA52
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2024 23:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709938937; cv=none; b=bIYPQLNLEwV8EP91PK/ZNKzfrd34wHv7b3jD7bsaRsoPf4/+TvHABJIrQO2IA1U+rSCecmiJWqoa+d2rtf3NeGClB7tJVXvk4y3yDawJ8tDxHZAZ/YMBUtKH3+jEZ1Sd8hrQQzZeAoZvmS8d8ITXAbXeYETYQ3q8PWctGQFFk1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709938937; c=relaxed/simple;
	bh=S4FtNcfgq1ha3rjde75oaynXlo3yhg3uaWTkYwDACAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L5u3H/1ZXCllxhYoRFZlUZY+eTGtX7RxX/uaCkfGYXr3TnJ1daPSA9lHUFHXlCB3jgthhMSi+nhGBJ5aR33eNpXLIS+HVY6OoT7VrOJ0zPKyxxQjo2dABJGo1sJ5/c3mqJ0Tsg6xOhcMSfPuOjI4nXf8VBbBPi0+y4QITOzznJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FZoxwFu4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FZoxwFu4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=S4FtNcfgq1ha3rjde75oaynXlo3yhg3uaWTkYwDACAQ=; b=FZoxwFu4+eCTiVlCDqGzrqYHdr
	0REcN3fufPd1711ly1jh8Y1VjHTs49enTF31naxHno0jG1GS6K8ymr8ajirleOufz7UvfNtTWf2LZ
	YTV/2I8IiDSow+EtcElqm0Nz+jrKBTijHPpu85RYkE3U6P0NrkqjwJmW8nYiSUp52nQE7o6O7LGuj
	KDE9rkA4MUNa6Y/jp2iFA2TMv4eBMyQKNn55fm7achdXIrBE2BCJGv/uDGTcMUPIcrToiZS/H2mwJ
	e/79BpCyqlNEW95VLsuQGhJjQtzLjsYQpL8l+e0O5zvlFq8JDkySlbbp+AYC/mTvL9w8K4iZH+v5C
	HHZupt2Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rijE5-000000003kf-2QAf;
	Sat, 09 Mar 2024 00:02:05 +0100
Date: Sat, 9 Mar 2024 00:02:05 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH v2 xtables] extensions: xt_TPROXY: add txlate support
Message-ID: <ZeuY7c4NweKAtHwg@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
References: <20240308142431.7960-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240308142431.7960-1-fw@strlen.de>

On Fri, Mar 08, 2024 at 03:24:28PM +0100, Florian Westphal wrote:
> Signed-off-by: Florian Westphal <fw@strlen.de>

Patch applied, thanks!
