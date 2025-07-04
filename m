Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D1A328AE2
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 08:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751617887; cv=none; b=HTCqWykingdE7wdKXDD+fY9DajzFwOBSHZybzqssRTXPsWTOKZ3gFn6lLjDUnTrOQOvHuMaKSJddoJkLSLrEVJcLdM+lrEbiv1cCZf02aTRSKgTZVcO+G3XAkL5dPtmAA+lNsu/05tAgKloVqlZU8FH3CpCI2Ke9l4RxU3IGJL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751617887; c=relaxed/simple;
	bh=kv4tiW5RZjBcw/j+a1RwbQWSVOI5GIopRipiF0l+pKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E6xypLCDpx8GlY7CWq7c2ThlIRFizLII0dIvFuKogg2XPA2UfdJSePIfpE6/BhCsPCpU5wvxOq19SK2c6VJ022cCMn/Ob8Yh8cKvJtrbDxSojWGZ2Ty8P597DEOlwdMW5LYz5PvWtVFJqbqIqmMINswAjTxfd6I4+RqKN8QSO6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5EB6260FF1; Fri,  4 Jul 2025 10:31:22 +0200 (CEST)
Date: Fri, 4 Jul 2025 10:31:21 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] extensions: sctp: Translate bare '-m sctp' match
Message-ID: <aGeRWYyd9clH9-A_@strlen.de>
References: <20250702144741.2689-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250702144741.2689-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Just like with TCP and UDP protocol matches, emit a simple 'meta
> l4proto' match if no specific header detail is to be matched.
> 
> Note that plain '-m sctp' should be a NOP in kernel, but '-p sctp -m
> sctp' is not and the translation is deferred to the extension in that
> case. Keep things stu^Wsimple and translate unconditionally.

Reviewed-by: Florian Westphal <fw@strlen.de>
