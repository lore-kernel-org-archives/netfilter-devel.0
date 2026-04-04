Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C3E76025
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Apr 2026 09:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775295501; cv=none; b=WhV0Zuw5rIUdds/i0kr03rpjMdPLdDGd3tZ6rxxCLqD2XNOGNfOkhGQJ6QlJfBh2Lb5uDxrn/Cz6idu7kA/XR+0ictB0lVCz7Vd5deWoVBu0cJx3qU+BeBiFg36WJWK4vfx7Lp2TtJMG1bc1056bzvNyA58VzBX/FJifVdYFh/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775295501; c=relaxed/simple;
	bh=64WTY5qYBLVxqjziqcOHo1r4CVt+O6iFrFTi8oJI2Q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nMyOEhCNqk2MIExke01YA0cgRcK4eWroUTHiXmgrdvAh74YO241u7F4K/FZsXX/jdOCMU22t44iFX6QK0jkPlRFwk0LbQzblHgyOOT324bvL9pNSg+BYjiL1z+eAw6L4Kk+uPpmEmVll30badBK2ee/ymSbs6+0rl0+429zwS6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=INmXjaE4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="INmXjaE4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cc6qc5YpbpDZbfXAd0qn6EFfTSZlbkbGff1tp/LS/WI=; b=INmXjaE4IztxpLmIWBULskgTH+
	KHfW3wJ4Keq+4vFvtZeN7PFMqzYVVkAGF7vAlHdgmWLf3/30Gg02zuNHjtLASXFSMWoY7pjQFNPK9
	c1U2sAM4T2uXx9WEtZea1jQVlw7D3NMoBAacv8JGNEK2yuK/mnGG2i+hmrYMuzfTuU7S0XCCAJx/+
	a+9ncZMfuTy/17AgqyHoGtvPfqukcqKsRFDuz7/glh54ZHMnTPrNNzR7il21xCl+gPkTN2hv/D6nT
	+BrYQzodDMjijbxIjTxjdnFYfaFkN8jsZDBeAfR38JQ8IN15zjlAf5nNgV0L9tlIG0oXbbagftEOe
	nUjHogSw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w8xSM-000000000mW-0aIW;
	Sat, 04 Apr 2026 11:38:18 +0200
Date: Sat, 4 Apr 2026 11:38:18 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] arptables: Warn when ignoring '-p' option
Message-ID: <adDcCvFrp3TmzrOf@orbyte.nwl.cc>
References: <20260402145216.32228-1-phil@nwl.cc>
 <ac-b8tqhhnYTSlKT@lemonverbena>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac-b8tqhhnYTSlKT@lemonverbena>

On Fri, Apr 03, 2026 at 12:52:34PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 02, 2026 at 04:52:16PM +0200, Phil Sutter wrote:
> > Legacy arptables has been silently ignoring this flag (plus mandatory
> > argument) since day 1. Retain compatibility to that behaviour but inform
> > users that a part of their rule does nothing.
> > 
> > Since arp is the only family which didn't provide a proto_parse
> > callback, implement one for the sole purpose of printing the warning. As
> > a side-effect, caller no longer has to check callback's existence.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Patch applied, thanks!
