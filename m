Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13FD1B4242
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 01:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753149294; cv=none; b=pK4JSX8p/RBy/H4BS+/7CCHTEL7YMTE6d/rXgPZASipE37iVKRRk4sDnsPXG562RkhmzzP+iJZ3NL9YrY/QiTTLh4IDzwT2hCYGQvT9GlWcsgd4L3KC+VCIoX5ci0iW9xCH9JSfbk3bnwiWZ8tNKLCwGRZIGnLTjE08g6VlpI9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753149294; c=relaxed/simple;
	bh=i3alvxHOj9f40ru65YD0fxX4F1lJ20Mnm6woZ0HPriQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CV8YqdpzRrNGuTRXmlNQnI21bU67e3R9E1T1voUXmw9wFb2TdDxTt11jFfEfEHZ+rGlag6rNFLooY+PqqmjxyvVpijSix/F3mxd4BngqXz0lb5+bT+szCQPFUhC1F1dQdfsynQkj+txdCcAqgY7gHMK3b3jgqckG9McU85yHlFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=V17KMkSd; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=V17KMkSd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="V17KMkSd";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="V17KMkSd"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F12B960286; Tue, 22 Jul 2025 03:54:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753149289;
	bh=v3CPnHFNsVU8CeQAQCSSQfzBpitJJhYiuZuM5b5Db3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V17KMkSdSm1lcR5fx7Xn2HGZSi3efh1OOQOFL690vhPy2Y62wuLxIwmD5StoTSn5u
	 i+6vB/PbaVtnGw3AouvI+W96USPeH2RDwaX1nsGmsoelTX4NINdgwWISKr3+NL9/eR
	 vBLKeUeztQkO5zvDtg/U5tcyeQqej1Qdf7FJzdYG/BFR99L4dRbaqih8ItutPCsHyt
	 TWe1NV0FRbD4oYIaRT8hgVPJ3iPM19Zmc83HZGGtPfsu6YyhOiLI3YZdCMbLHGhayi
	 +mic/2b4ScugDKsr8jsDS4xbZoPY+ag3x5aP2lBxE+4tzhOTmNktE8pND4RNBW6Cku
	 xrx3vmuwcnJqQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 483FE60283;
	Tue, 22 Jul 2025 03:54:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753149289;
	bh=v3CPnHFNsVU8CeQAQCSSQfzBpitJJhYiuZuM5b5Db3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V17KMkSdSm1lcR5fx7Xn2HGZSi3efh1OOQOFL690vhPy2Y62wuLxIwmD5StoTSn5u
	 i+6vB/PbaVtnGw3AouvI+W96USPeH2RDwaX1nsGmsoelTX4NINdgwWISKr3+NL9/eR
	 vBLKeUeztQkO5zvDtg/U5tcyeQqej1Qdf7FJzdYG/BFR99L4dRbaqih8ItutPCsHyt
	 TWe1NV0FRbD4oYIaRT8hgVPJ3iPM19Zmc83HZGGtPfsu6YyhOiLI3YZdCMbLHGhayi
	 +mic/2b4ScugDKsr8jsDS4xbZoPY+ag3x5aP2lBxE+4tzhOTmNktE8pND4RNBW6Cku
	 xrx3vmuwcnJqQ==
Date: Tue, 22 Jul 2025 03:54:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] parser_json: fix assert due to empty interface name
Message-ID: <aH7vZQHI9PgGe4lM@calendula>
References: <20250721113607.11522-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250721113607.11522-1-fw@strlen.de>

On Mon, Jul 21, 2025 at 01:36:03PM +0200, Florian Westphal wrote:
> Before:
> nft: src/mnl.c:744: nft_dev_add: Assertion `ifname_len > 0' failed.
> 
> After:
> internal:0:0-0: Error: empty interface name
> 
> Bison checks this upfront, do same in json.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
