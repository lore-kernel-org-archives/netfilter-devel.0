Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA47D282F22;
	Thu,  9 Jul 2026 07:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783581570; cv=none; b=s+SaK4FmOAEPFOFENegDfUJnVsrzDbDeZASJ6t/9DAuYMo2UcH0X5jOgIJ+ue/kmhngWNukzoc1005u8OxiXuXP2nQer7h8LP3DoKbcPh9iTJBNFVu6zDNB+chqAHG5iNYT0EBLVTeMjP1bSJpTRnZUeQQRT5Tsp6SKugbqV+VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783581570; c=relaxed/simple;
	bh=DxV8Swk5IwTA1jg0zv6aVGMnrVwjyp8KmNonDaYEjhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o1Jdr16XxGbw1oFBxrYbhTMKhYc/PomWqH1MsoTMjklnCmnR7XWs6uwvYMwbcueULOl77gFyDrC4zK92iC0c3lVudxWkvfOxO4K3a8D8Sj3G6OJhspBKpASMFhqN+g8/d0tYI6a1zflxj88h3tV6lOK6PehsfDHR8Z8WkrRNkmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 73041601F5; Thu, 09 Jul 2026 09:19:26 +0200 (CEST)
Date: Thu, 9 Jul 2026 09:19:26 +0200
From: Florian Westphal <fw@strlen.de>
To: xietangxin <xietangxin@h-partners.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	gaoxingwang <gaoxingwang1@huawei.com>,
	huyizhen <huyizhen2@huawei.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_nat_masquerade: recalculate TCP TS
 offset when port is randomized
Message-ID: <ak9LZE_knlnZJY8r@strlen.de>
References: <20260629093408.3927103-1-xietangxin@h-partners.com>
 <akKN4cywAsFRdefX@strlen.de>
 <0ad60f06-387e-49bc-9e26-3dcebf182cb4@h-partners.com>
 <akUhid7_3iHovivd@strlen.de>
 <3620a5a9-9ced-4825-9bc4-6950be205749@h-partners.com>
 <ak5riPx5d3rSG6MG@strlen.de>
 <e55d6327-78a9-41dc-9627-4414f408774b@h-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e55d6327-78a9-41dc-9627-4414f408774b@h-partners.com>

xietangxin <xietangxin@h-partners.com> wrote:
> Would it be acceptable to a V2 patch that targets the local case?

Sure.
