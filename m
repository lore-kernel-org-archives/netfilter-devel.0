Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12CC101E6
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Jul 2024 10:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720865151; cv=none; b=QoaCJvMsAjdXOj5Mf0RXOb/v6I+23mXzu/33B27ntfB3ylkrAXQiDwu6csy1hxyikJ4QTxkgkYMWz0ZAJJXT5HQYPR3Xz3kT+mf7CgTnZghAe2JfPZReiX2q2jtUgoZET/KrHRlKLB66ZAca1GTr8bd+pwvo7hIzAYkqCGXwV50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720865151; c=relaxed/simple;
	bh=rk79BBBZF+vFydURNAcpUC3YqY7grp1DmgLwss6Po5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WV86AjB2NxTZeX6beGEwP2dbhQca8NN8Mf+ssGuLVESs7y3AYsLteH6FEJPLjpBydkBIK2FKRXEJVfz/QWMAvHP7NZcuaTeJcfjsnJWBhho4WXX6QFh79Zt7swVR+dakP8a97a4SnEGmPwSpzjlfJCLZqghu1tLV6yxOPaOQxjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sSZdM-0006lR-2Y; Sat, 13 Jul 2024 12:05:40 +0200
Date: Sat, 13 Jul 2024 12:05:40 +0200
From: Florian Westphal <fw@strlen.de>
To: Harald Welte <laforge@osmocom.org>
Cc: netfilter-devel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH ulogd2] README: update project homepage and mailing list
 addresses
Message-ID: <20240713100540.GA25890@breakpoint.cc>
References: <20240712085516.23982-2-laforge@osmocom.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240712085516.23982-2-laforge@osmocom.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Harald Welte <laforge@osmocom.org> wrote:
> From: Harald Welte <laforge@gnumonks.org>
> 
> The old links were outdated for ages; let's bring the README in sync
> with reality.

Applied, thanks Harald.
