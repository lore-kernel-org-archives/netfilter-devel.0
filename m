Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D238645198A;
	Mon, 12 Oct 2026 08:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791795154; cv=none; b=eyTg0wohgPpwYUsknh41MO614RJJ+lL+XOVWd88ZdFFlTyFi+MnKKxoB9tPDpNthfy7kbao/iOWVmCZ9KySLx9nCB1ok+Yxk4Wc/dIxlTz3SuvCXtTzUGX2Go5/+Ovo3pL39zQ2zOa4Su/SGitMvri35zWYaDSPwvRDC18u//jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791795154; c=relaxed/simple;
	bh=G0TvSqZWMzuaHQkc4LLKgNtXBuK7C/XR62simfDeyGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u67RMDspwMPlQG5sar8Nb4wUfBDJrcz3ZZypG9+UGXKv1Dx8cVKotk6Z4VKAsMLAY4c0NurDMw6EH3vlDnphnCUth5zflqS1cHGrZ8owcn5/2D+srHtT8cxynSxqbxM3XIqwYeW4UCXrBsT7yCi2OmyS2Z7BjdMb3iH3+TL9rS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 62A4F47F91;
	Mon, 12 Oct 2026 10:52:29 +0200 (CEST)
Date: Mon, 12 Oct 2026 10:52:27 +0200
From: Gabriel Goller <g.goller@proxmox.com>
To: netdev-bot+sinfo@kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, bridge@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH net-next] netfilter: bridge: refragment reassembled
 packets passed up
Message-ID: <asyew3iKfV_yEX-e@luna.proxmox.com>
References: <20261009150246.443127-1-g.goller@proxmox.com>
 <179155828067.2527009.9838753386350423335@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <179155828067.2527009.9838753386350423335@kernel.org>
User-Agent: NeoMutt/20260504
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1791795148774

On 09.10.2026 15:04, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
> 
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
> 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.

The issue was hit in production when bigger udp packets get ip-fragmented
and then hit a bridge with conntrack enabled. The bridge then reassembles the
packets for conntrack, but doesn't fragment them again (pass up instead of
forward, LOCAL_IN instead of POST_ROUTING hook), so they are dropped at the next
bridge because of the mtu.

