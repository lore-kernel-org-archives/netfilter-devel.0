Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD0013F452
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 10:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830573; cv=none; b=p2RT7+aYJ0oubzSBmKtk1t+XhPM6f5mK3nfNhX3cxJVO3hfIPM/higHBbMesdMkkr/3FovHgIZBhC9eA78EXhdBiXlAePQ0YfIoL3KfMdfC75TFXP3KgUu52RzTHFx/hlGeIhuPlH9f+0OWuaJqbaeZ6dDwU9a/I3+LBm0+/SRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830573; c=relaxed/simple;
	bh=0g76PMcTmPQD2tc2RMLt49angOihuJWNEJPR4Zt5FKs=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YkXLu6/rI2gN46uG9gXZNuBmGJBqTWqoXLl+AN6LI+TegMdOSDhVgs+VfrXOythlq6VL+GZtPj9sg9iJK0I+Y6bqhh6T8inCmC0O6cc8YcBl2lAh+pGOhaWWrwGKmixd7rsce7Hay2THnv45llH7uCKic26awgwAWd+PIswL6f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Lv0b7W4w; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Lv0b7W4w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QLFa8FDFoEYIkaCGBA79fdar82MOa7kUKRIWfVg6wwE=; b=Lv0b7W4wKlWZOVJ7NIioFuKTdL
	YcvZdSpnHcLN90CLRcMc9JKZjGyEeel4wmLwN3DDaGh8jbDBDPAd1N33ac9Gr7LPVcpTlrESDf1FA
	8nRyG/V+0AnW0q7+Bn+wbm6VL5NduPHXKBHtWtRAtt7wD/tEZyvZZFHtyl5MrZC9XFaV79X/YdA6c
	Qh6xmE6cBrfpZxZKSDfdh/nIc4PowoNnARASy5S0Fl973qxT5h8Njh8nFpnc4Lu3CYUjMjw7JFEw3
	zfb59dZoXj2d8lgHfaUO1ptLjCPTOR8GR/PIFaRLetsTW87LnfzhreeBThPcxhM1tCpdzeI3m3cr4
	vtPA9pOA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rurTU-000000001Hn-22Ck
	for netfilter-devel@vger.kernel.org;
	Thu, 11 Apr 2024 12:16:08 +0200
Date: Thu, 11 Apr 2024 12:16:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/2] xlate: Improve redundant l4proto match
 avoidance
Message-ID: <Zhe4aMxp_wO8On0C@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20240305171059.12795-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305171059.12795-1-phil@nwl.cc>

On Tue, Mar 05, 2024 at 06:10:58PM +0100, Phil Sutter wrote:
> xtables-translate tries to avoid 'ip protocol'/'meta l4proto' matches if
> following expressions add this as dependency anyway. E.g.:
> 
> | # iptables-translate -A FOO -p tcp -m tcp --dport 22 -j ACCEPT
> | nft 'add rule ip filter FOO tcp dport 22 counter accept'
> 
> This worked by searching protocol name in loaded matches, but that
> approach is flawed as the protocol name and corresponding extension may
> differ ("mobility-header" vs. "mh"). Improve this by searching for all
> names (cached or resolved) for a given protocol number.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
