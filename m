Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB36C502AC
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2024 11:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712921257; cv=none; b=uiciWmZN3oYarSVtGOnLXw/ugKHpPF/3EQU1I+TbzWFzJosRGIPMqUreW2dxhA965a4dYB6Kpo7E9gDByRD1VPDlVUSBP3O7o8j4d83YeaIAnLJzPj66v6MLBAQ/glg5wgB4C6c6WBk+IzRvQ3qK6ycEBBiWfkcjGnW8OzrfDk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712921257; c=relaxed/simple;
	bh=02DEftBNbNFldPkRKycVO+56rcu7v9MHfzL0UfWWuEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPHcc8G5niR2AelMhQi4/bXRCmE7q/4xsIpgmaIVmpcMWaX3vZXVx2E/byFOY7FOVE3XYTF2zAeUk/TIK69X4QkcLpC139oYBbbcElYC3oiXjZlUHZhnzGtqUL5c/SXKVYebYSn+MjUdNMl11qIqVNUc1EeV/z72jgUughCcl+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=QEOXj81y; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="QEOXj81y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gH7QPavz2HJuExUH6fgHzS9CSOL6SZs52PHremLiLUU=; b=QEOXj81yShF3FzJwkMm4948tBQ
	e2AElOAHsXnyUpM7HqoDLbAn+vyad1SgxVKSm3EpGGmlJ+eqbb2EFjVgp7U0kZrdsehMWpc5E3aLl
	x4D/Z7jLB9RoRh/KHnP16JYhJDwheYRON0PTioOUJqBphqBeC1dQaLi292DxnOkHODrRQqAvjtzTL
	FYngxd6qj+K8AQ8iD8EawgFxlZYmpCMX+21ZltZTnUCFA/CI6JEUDqf4+JaShZVRAu3DXRBGApsUq
	kUXzt/gnCgSOdf+O2JNBtSZW05Cu8JABNQQKV0RdRob3L93eZYeH+eiZphyY4G4GcKyNhziPulXjZ
	KM9rTraA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rvF41-000000003L1-41ZL;
	Fri, 12 Apr 2024 13:27:25 +0200
Date: Fri, 12 Apr 2024 13:27:25 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Quentin Deslandes <qde@naccy.de>
Subject: Re: [nft PATCH v2 1/2] doc: nft.8: Two minor synopsis fixups
Message-ID: <ZhkanVAuKQmdolkd@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Quentin Deslandes <qde@naccy.de>
References: <20240326132651.21274-1-phil@nwl.cc>
 <20240326132651.21274-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326132651.21274-2-phil@nwl.cc>

On Tue, Mar 26, 2024 at 02:26:50PM +0100, Phil Sutter wrote:
> The curly braces in 'add table' are to be put literally, so need to be
> bold. Also, they are optional unless either one (or both) of 'comment'
> and 'flags' are specified.
> 
> The 'add chain' synopsis contained a stray tick, messing up the
> following markup.
> 
> Fixes: 7fd67ce121f86 ("doc: fix synopsis of named counter, quota and ct {helper,timeout,expect}")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied, will respin the second one.
