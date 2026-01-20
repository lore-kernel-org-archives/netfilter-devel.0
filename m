Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C787E3A8FE3
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 20:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768939919; cv=none; b=YwrdmvbGUbL+UtkXDqv/45Z6joyHC98W9l5babAn+AdXqg3j/7Uc87MqOlRBIF3dCWbxGUKXg3GQC47JY0axpHNwVYs6wN9L7l5UOza/pn9T+KJKj3nWLgWWahJhTThvHD90F/lpI+msDFEEajVtRLa2DhdVGY0ogXhQzHirT+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768939919; c=relaxed/simple;
	bh=fDcTepmflS5+eHfMycsW3q56ZTARuHLJVA5HKsLJvPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h/IXYgXaAJC0aVMIyO0aYkHRBszdp74v+u9/UsUL/dzHhFy+8fu4TycU1LhFlG4bt8lUOW+P2pCboGbuiuVcSlk/4s/9GSTKaXS3odI9jpdpVXS5AFi+GK8wdkc+BtG0eUX823A1xRFGorHLEHozsh3GtzhXBh8X8Xg91KEbObA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pOZeO9Fa; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pOZeO9Fa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=E6Y/rdstVWVrhKijkoHZ6CFybdAn2MfgXvgAnrPx3S4=; b=pOZeO9FanZuvDXxqEK5I+pT/r9
	ltwZulkiiEk4OKy6VTg7u8eGkymKUv882jteAk5DvmESN4mL4hP3VhCpMAKSyrBcA7krU786YjfQX
	KmztD1oroZsqtYIptFvDdMWXWZMHJDg15czGvHWRocsfSRumk9eoSCQqdXNKl8TGlz2PiZbdYEbDn
	NMXEhzuld6r7hFJ3gptdwLmeHr+RqtUQk+C6u80XS12j30pvT3CleH4HNo+r2ynIqCwDBj3dU3Ya5
	h+x59YU7xN2ryIDPYHbwryKcApMtuo6qrEH1m7dpKbe+no0UqQPSSZ0xhuLk/s1SeBPoG7k9LNMHM
	Gp/TCmuw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1viI4w-000000006dE-1jaq;
	Tue, 20 Jan 2026 21:11:54 +0100
Date: Tue, 20 Jan 2026 21:11:54 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser: move qualified meta expression parsing to
 flex/bison
Message-ID: <aW_himZ45y5I1vtf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260120191319.21383-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120191319.21383-1-fw@strlen.de>

On Tue, Jan 20, 2026 at 08:13:16PM +0100, Florian Westphal wrote:
> The meta keyword currently accepts 'STRING' arguments.
> This was originally done to avoid pollution the global token namespace.
> 
> However, nowadays we do have flex scopes to avoid this.
> Add the tokens currently handled implciitly via STRING within
> META flex scope.
> 
> SECPATH is a compatibility alias, map this to IPSEC token.
> IBRPORT/OBRPORT are also compatibility aliases, remove those tokens
> and handle this directly in scanner.l.
> 
> This also avoids nft from printing tokens in help texts that are only
> there for compatibility with old rulesets.
> 
> meta_key_parse() is retained for json input parser.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Phil Sutter <phil@nwl.cc>
