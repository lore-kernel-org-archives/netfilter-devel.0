Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF17383
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 23:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730847814; cv=none; b=MgJbMzunEyupgUNVaZccagB961ufUztWKz0348jlg6MaChjVeKMRM32QMhXP8LbCnMsOkIQ25aG/+zERo6eP5ME8SNXqiGfc3ec/vup/yrSpO0xrIBzR90xurILDedvCdl++FbEMNwud+zTtxl8oy1gERAtwSwBqzaqj3Tsnns8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730847814; c=relaxed/simple;
	bh=8yUY2S+aWTp++2vzfrc/X6k5H7Ds+Vd50NgIhupwp30=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G+uAyeCwSQllmqR2TRyaDDzEyS/+BgdN7fWkwVJwAawzEMfB4I96QTiXOLHtMPOP0uYAPd11I4wYuY3ayyd15Aa0oD93sR4IMpaOUtWmktqwQkYe12j6qKRRCEM+YMMVS1cun72HS4Gu+/IZsEr+jgbk/jjZkhhjc95G8sBvqJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=D0tMGufq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="D0tMGufq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vA4X99goQUy3vRUeddtS/NK9t2ZsHmDPndDwwoKQtIg=; b=D0tMGufqay6ec8g9LdeHK+E4xh
	ypD58lyzgTl9u0HU/bWACyD2Wp3R/dKgOLLfVSYeWCGjvbMBIRzXTKnZToF5gDXfb6rrsSyap2UJq
	WT2oMZwE7zAYG0/Nz3hG6lBmJRYyPTdxFAaMfskAK8ejDBIz8wB5tz8Q2j+M2Z4TCX+NMU9HVyYSt
	MrgSJRRohc0mwbB57lXk+AG3PfijRlWhJSM83cFBG2V7sEVPdELT+Vvc6eCbscTprFyaG6XkY9PoC
	HaiPYkSqxpVs5qUan5Ji1up6bEgtgXpj3CE9AFKtGGgE3YfyJQ/sFNeOymmXaxV38yz9aJqw47wIm
	b7eqiz+g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8SaB-000000005LV-0whX
	for netfilter-devel@vger.kernel.org;
	Wed, 06 Nov 2024 00:03:31 +0100
Date: Wed, 6 Nov 2024 00:03:31 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/3] ebtables: Clone extensions before modifying
 them
Message-ID: <ZyqkQ9cItcITsgYy@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20241105203543.10545-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105203543.10545-1-phil@nwl.cc>

On Tue, Nov 05, 2024 at 09:35:41PM +0100, Phil Sutter wrote:
> Upon identifying an extension option, ebt_command_default() would have
> the extension parse the option prior to creating a copy for attaching to
> the iptables_command_state object. After copying, the (modified)
> initial extension's data was cleared.
> 
> This somewhat awkward process breaks with among match which increases
> match_size if needed (but never reduces it). This change is not undone,
> hence leaks into following instances. This in turn is problematic with
> ebtables-restore only (as multiple rules are parsed) and specifically
> when deleting rules as the potentially over-sized match_size won't match
> the one parsed from the kernel.
> 
> A workaround would be to make bramong_parse() realloc the match also if
> new size is smaller than the old one. This patch attempts a proper fix
> though, by making ebt_command_default() copy the extension first and
> parsing the option into the copy afterwards.
> 
> No Fixes tag: Prior to commit 24bb57d3f52ac ("ebtables: Support for
> guided option parser"), ebtables relied upon the extension's parser
> return code instead of checking option_offset, so copying the extension
> opportunistically wasn't feasible.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
