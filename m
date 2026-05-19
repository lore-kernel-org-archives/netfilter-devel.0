Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91340367B81
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 19:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779218457; cv=none; b=UXdy2JXLZdoTylAcDUawHvZvYL7y4sXO0/KVk+ad+cnSycpzxb1gkT5241cBDRDyw1uSkS0QpR3+vSOJsTmP//32490HWQ2im8y95NqgqGquBhGWCmLri62YjwmchD9MiO9nx0V6L0WtkqjCNTG3pc761P9dvY5PPN5OEBt2AtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779218457; c=relaxed/simple;
	bh=q9DYd/7zDHyfVT1N+wSqSyDNoNEv2L+DrrYO9vPwWzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZHw4ENWu/TGAvmUEJcl+DQhxfiX/TChFeHqH8w34o1tcXIQHUp3mpU4ZpYU34Lp6DvdP+wveLXX/WI6gOEmFYbxsb20OzMsOCIk4wvC/gN1GmAZA5lLxfinXIrRcisxqPLH/iZyxMGgraXQdSBL7yF+sNpxkW+WzWdQDDFu5NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6C71A607BD; Tue, 19 May 2026 21:20:53 +0200 (CEST)
Date: Tue, 19 May 2026 21:20:52 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, bridge@lists.linux.dev,
	pablo@netfilter.org, phil@nwl.cc, razor@blackwall.org,
	idosch@nvidia.com, stephen@networkplumber.org,
	sw@simonwunderlich.de, davem@davemloft.net, yuantan098@gmail.com,
	yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn,
	royenheart@gmail.com
Subject: Re: [PATCH nf 1/1] bridge: br_netfilter: give fake rtable its own
 lifetime
Message-ID: <agy4FOL639LtWbU5@strlen.de>
References: <cover.1778687139.git.royenheart@gmail.com>
 <783d76ac83917b7302c1ec647794bd773bb1875a.1778687139.git.royenheart@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <783d76ac83917b7302c1ec647794bd773bb1875a.1778687139.git.royenheart@gmail.com>

Ren Wei <n05ec@lzu.edu.cn> wrote:
> From: Haoze Xie <royenheart@gmail.com>
> 
> The bridge netfilter fake rtable is currently embedded in struct
> net_bridge even though packets can keep using it after bridge teardown.

How?  Please elaborate a bit, it is unexpected.

> Give the fake rtable its own allocated lifetime and make
> bridge_parent_rtable() return a referenced dst. This way the bridge and
> any packets that still carry the fake dst each hold their own reference,
> so bridge teardown no longer leaves a dangling fake dst behind.

If we have to do this it would be better to move this kludge into
br_netfilter.c completely and get rid of the fake rtable hack in bridge
for good.

Please also see various AI comments at
https://sashiko.dev/#/patchset/783d76ac83917b7302c1ec647794bd773bb1875a.1778687139.git.royenheart%40gmail.com

[ I would like to zap bridge_netfilter but it seems its too popular ... ]
