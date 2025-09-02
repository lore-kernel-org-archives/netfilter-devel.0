Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494ED2F5485
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 10:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756810522; cv=none; b=NVNq4Q0PfU7evWVjHA8UGoA53lI1UfWctFgSytnyMVXyEvqxT3xh46DDwdUO2bxqDZI7eNkR2CI0JE8y0d2dLByQ1GENgT7kdoR1WqUBDNIkOWhT6xcG+AosLkONoz5X1wTy7IeAL2gGcfDseDliIPlyuhLPlbESc7ZYNDhJUIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756810522; c=relaxed/simple;
	bh=KFJ5cegFWdL5nJcxf5CFIv2+TwrQJBeBYmrqbZaKuSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oz+olZ3ibplmtR+b0L/Bvs0Qfp4zhK72J/gg1vd9i2BIcK7urwYI52f03rwLpZVVX+ftPttQe0bN/5khgdl5BfmtDy4vHEcseS3A1rWzAU6EY9NxtDRNyTfrS6SnMSi0gbvvdJnU5HzKxni4raL9CzRR2PGc2qUbx/8OFDn2dnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WR5ogwTJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WR5ogwTJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eERcfKeEbu5NvPpE5/fQGoYMIG07bvnGbtqv8d2xL4E=; b=WR5ogwTJNg/T25+sfY6xOXplTr
	AXrD+oAKHQLZ+RvGJwStU1XHdDno9jjVJPY9YVxB6cIonNMvv4iXzXkSg+XqmeLA4+q4JrDoO8TiU
	kuWG+/EcHgr8sVZShMwwgW3+68cVNwDxDN5DQuCajzkBsxxnNzug9gGomaT6TkAHJOtdY9s1rpE4d
	04EEaIFqvLjISLrHU3OP23irZSk2Jm3XXbZOVMplB1V3OGD7rOFHR85JqoIkLUGukc17x8N7d0xhW
	bXcylK8kzhH6YnFKzOE/RZmqNcDVBtwzciyZtygmEd21slz/SEUrdejrMDYA5DWYppWlAfSzsyjh9
	PiswRpaQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utOfP-000000003Eo-0NIH;
	Tue, 02 Sep 2025 12:55:11 +0200
Date: Tue, 2 Sep 2025 12:55:11 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nft] gitignore: ignore "tools/nftables.service"
Message-ID: <aLbND44WYV7ju0Gx@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20250902100342.4126-1-fmancera@suse.de>
 <aLbLe9Z0ALPW_pdh@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLbLe9Z0ALPW_pdh@strlen.de>

On Tue, Sep 02, 2025 at 12:48:35PM +0200, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > The created nftables.service file in tools directory should not be
> > tracked by Git.
> 
> ACK, but there is already a patch from Phil in the patchwork backlog.
> 
> Phil, please apply your patch to ignore this file, thanks!

Sorry for "hiding" such trivial fixes in series worth reviewing. I'll
push the first two patches from this series:

https://lore.kernel.org/netfilter-devel/20250829142513.4608-1-phil@nwl.cc/

Cheers, Phil
