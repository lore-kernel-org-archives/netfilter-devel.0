Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151A130E0F2;
	Fri, 22 Aug 2025 14:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755874050; cv=none; b=cfZkyY6hqMlcgKCmxOJx0I9QQBlDm/QzSbhXyMcysW7HFlIUtjMEd7kF70tCYWznIeEgmUAij7EZOPEXWlcey/+XHDi1jflEs4w8QP9TsXhEqNAb/Llr+vseD4zIKN+5UxP493Hrm/Scm0V3OVxwllzMUhDNg53DcU+hAvFv5dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755874050; c=relaxed/simple;
	bh=wKNI6RveS+eUCF19EV1LKOh2J2GXzBq/8dHhdjIJcvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vwa4mH94Ccm1n84YCiqakExFGGWCsE80VZwu7KawXSNIR3fLpvoWIV433vG7Cmb9J3C/wiaCvoZ4+oqH0rAWXHkf03W5/wGdeLUoa04PvX2sKUVJ21y2EcKSO1VnR+JyY1vetC0a8q2ZmgCjjOmQbHJak//VwlQ8iOuv4T6bytY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A39B56032B; Fri, 22 Aug 2025 16:47:25 +0200 (CEST)
Date: Fri, 22 Aug 2025 16:47:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Wang Liang <wangliang74@huawei.com>, pablo@netfilter.org,
	kadlec@netfilter.org, razor@blackwall.org, idosch@nvidia.com,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, yuehaibing@huawei.com, zhangchangzhong@huawei.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] netfilter: br_netfilter: do not check confirmed
 bit in br_nf_local_in() after confirm
Message-ID: <aKiC_fDXK0Ln7-oM@strlen.de>
References: <20250822035219.3047748-1-wangliang74@huawei.com>
 <aKghV0FQDXa0qodb@strlen.de>
 <20250822071330.4168f0db@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822071330.4168f0db@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> Unrelated, but while I have you -- nft_flowtable.sh is one of the most
> flake-atious test for netdev CI currently :( Could you TAL whenever you
> have some spare cycles?

I'll look into it on monday.
