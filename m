Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13133BBC5;
	Sun, 26 Jan 2025 13:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737898648; cv=none; b=RP6Uf2O1eubho4lPi5IW7HutYbco79zsvL53a3QRa6P0rfbx/qSp9y3zxlE2hFpQvhsx8jFLRT9QQp7RKXzLZScjGaxraMCJrDiAF2YIOLYZVqlnq1cwgaJCnAyGFk5e+80mb5Kclcy/1IgDjRWmvhNCnwxjejk4trHWiNjlils=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737898648; c=relaxed/simple;
	bh=jmX9qjtdejM5AbQg8S3OKl7A36oBM+xjPWHmrFTFZyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLIO/qMXWsMt2ata0ReUYiZwWU2AShM81XHBqObfAZj4Ll+a3+buoHvlY3oR7S02zaIgk9888yKd3eSXYV/d7aomMjqdr2LSfcU2+7ZJVQD/4FS62IDpRaHNB3CVh94YIT2cwns+GVmvIRwAarLN9msn6rgxLLIuKI5OekewpHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tc2p9-0001F2-Qi; Sun, 26 Jan 2025 14:37:15 +0100
Date: Sun, 26 Jan 2025 14:37:15 +0100
From: Florian Westphal <fw@strlen.de>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: xt_hashlimit: replace vmalloc calls
 with kvmalloc
Message-ID: <20250126133715.GA3073@breakpoint.cc>
References: <20250126131924.2656-1-kirjanov@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250126131924.2656-1-kirjanov@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Denis Kirjanov <kirjanov@gmail.com> wrote:
> Replace vmalloc allocations with kvmalloc since
> kvmalloc is more flexible in memory allocation

Reviewed-by: Florian Westphal <fw@strlen.de>
