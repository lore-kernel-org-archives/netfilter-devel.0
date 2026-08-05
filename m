Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B58B3E49D2;
	Wed,  5 Aug 2026 07:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785915771; cv=none; b=YGzxR6M+2rIlIYbSZ8elLdb9Tqos/+hfU4Jb2gRN618su7uToj43ZaN1WvcNXrzinUsvKmm+lMdF6drxL6oVLe5GGipHFsU9Z+FILFJI1FbtoJMVUpAEaGNtES5yAXK6a9AopPwT7kVPE2uHicu4PP+miFbQtq0nHYJnOy0bqbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785915771; c=relaxed/simple;
	bh=mWtBFzH3FIoOsCo2nbqTqqyxxTKB31hIDXhabvSj3mk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SXq+aJsYROUKdNOYnFAzZb39hchel5p0eoLwBOV+AeTBLuVHjy+OAjGEUIALgch8UDAQxWbyNmD7DDPs7hxTM4U1buSJWZq5AufhIfLhao/4IDqLNyXZRrJdN6tWyzS2L5dwPiOhHzb+BFfy7my88M7nG9HuBy+u4puOacaxJEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 32EAE6021A; Wed, 05 Aug 2026 09:42:47 +0200 (CEST)
Date: Wed, 5 Aug 2026 09:42:46 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net 00/10] Netfilter/IPVS fixes for net
Message-ID: <anLpdrji2VmzWER6@strlen.de>
References: <20260731151806.849724-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731151806.849724-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
Pablo, I am sorry for taking a shit on your doorstep.

I can't help it; the patches passed tests here and did not raise
any alarms here, especially because its prep work for large conversion
to rhashtable.

I therefore have no advice -- I don't know what to do to make progress.

Or, netdev maintainers accept this PR and we can handle this in
followups.

This would be my preferred choice, many of the points raised are valid,
but its either inconventient to address everything in one
patch (1000 lines changed syndrome), or the series would easily go past
20 patches mark.
