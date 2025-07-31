Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAAD285C91
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2025 11:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753960751; cv=none; b=X/BDLvcGWp8AMT6DngrZyeCCeZYAu2ynenlVHre1tIc7TJVJO+CzWn88geO+XXFNb6xdpDChBqc0m84O/iSUvD47+QlnWRzAze/IsVVcOwV3eCFVKxSqvrmEVVBo9p5t5NwXIDp1eQprE6iLNScuVR0sDTp9ow7Pp+ivbii18PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753960751; c=relaxed/simple;
	bh=/HXwp8zKwJ6TPusYr3pw7AHiIkSFkn/Nn8Bd7vZg5R4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cd4Qid5jTPH43JMlNwFUcZnpHpIZBA0riiWcJ6rw0k3zO+83MymcC0RUef9YI3eCpnTrqHtHFDQBtIFMj/SH3XNAFSxyUX8lsKAjZPfprHn+pKBwbzl7OULuo9JXmXu1GUnVG+gsKs4IjoyCPYg7md6lxD9hD1WLfEX+OKPU9vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XB/8ryZZ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XB/8ryZZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XB/8ryZZ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XB/8ryZZ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E94DF60254; Thu, 31 Jul 2025 13:19:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753960744;
	bh=/HXwp8zKwJ6TPusYr3pw7AHiIkSFkn/Nn8Bd7vZg5R4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XB/8ryZZYQz3vvE+pl7cByr1/xRP1dldG7GTChMamE7w7+Yb2yU7VbomOh4YypbfB
	 h/Lb5Vbm3x0W1yw2i/ZJ8B611hrfdcbHYhbfc5ICYrXTH0vSh8pQudGHFGlaLYfD23
	 z81g+xoGG842PaVsQz0uC4ExcgoGooY8fGBjwKCvO2QitYvSM+JsZUApA3kau4bAdY
	 xsxDn4brDGQoxtU2BKqNfw7bm7vp7zXlkWuDITPyOa02liz3OOQ0rCmGW2otJQSULa
	 Rury0/RxbvAHrOlxtooSLOkiTo1pfkEjYaFEcQJVQQH5M1EiRt6tMZL0892ybM/LQe
	 AXDipqM7Pg5XA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2482560254;
	Thu, 31 Jul 2025 13:19:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753960744;
	bh=/HXwp8zKwJ6TPusYr3pw7AHiIkSFkn/Nn8Bd7vZg5R4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XB/8ryZZYQz3vvE+pl7cByr1/xRP1dldG7GTChMamE7w7+Yb2yU7VbomOh4YypbfB
	 h/Lb5Vbm3x0W1yw2i/ZJ8B611hrfdcbHYhbfc5ICYrXTH0vSh8pQudGHFGlaLYfD23
	 z81g+xoGG842PaVsQz0uC4ExcgoGooY8fGBjwKCvO2QitYvSM+JsZUApA3kau4bAdY
	 xsxDn4brDGQoxtU2BKqNfw7bm7vp7zXlkWuDITPyOa02liz3OOQ0rCmGW2otJQSULa
	 Rury0/RxbvAHrOlxtooSLOkiTo1pfkEjYaFEcQJVQQH5M1EiRt6tMZL0892ybM/LQe
	 AXDipqM7Pg5XA==
Date: Thu, 31 Jul 2025 13:19:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 0/3] evaluate: Fix for 'meta hour' ranges spanning
 date boundaries
Message-ID: <aItRJdZK_t9e_oVO@calendula>
References: <20250730222536.786-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250730222536.786-1-phil@nwl.cc>

On Thu, Jul 31, 2025 at 12:25:33AM +0200, Phil Sutter wrote:
> Kernel's timezone is UTC, so 'meta hour' returns seconds since UTC start
> of day. To mach against this, user space has to convert the RHS value
> given in local timezone into UTC. With ranges (e.g. 9:00-17:00),
> depending on the local timezone, these may span midnight in UTC (e.g.
> 23:00-7:00) and thus need to be converted into a proper range again
> (e.g. 7:00-23:00, inverted). Since nftables commit 347039f64509e ("src:
> add symbol range expression to further compact intervals"), this
> conversion was broken.

Thanks for fixing my bugs.

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
