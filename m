Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D81C23816E;
	Mon,  7 Apr 2025 11:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744023892; cv=none; b=O7aI+MicX9eDPlpUpbGHDfO7RfbjehzLOpnmg9hRPw9LDEJHgGH54BT7tXjyqUVFdjwlslzvZWT35bRWMA/3KuQPtEeOZjOhr5Pg+8JFVa3kVklgDbcq8dwzEGGCNfTzWBnQGlUjPU0YUzT0gZM8nU+0IXJEWa6pTwjFxLD1bVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744023892; c=relaxed/simple;
	bh=uVe+27Fbkboe9GyFp5PvTPiAjmTC4NE/kPRGr/Qrozg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Qis5KNerPel9E7Pzw4EKuNXIfRY+nxPOBjfpt3aYRA1/mF1dOrdyLHTjw41ddoLjtU+/CDoDMr8C3Jp5iojCyxdeAqr/En/uFHnY6/mu8oNhUcIT4wf8IEgm78k7GWPjLAzsQs1vHvBeLUM54xKA8M3xQuCwXlYJMJHdxCbSdnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 56DA0100383FE0; Mon,  7 Apr 2025 12:56:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 568651101311E4;
	Mon,  7 Apr 2025 12:56:33 +0200 (CEST)
Date: Mon, 7 Apr 2025 12:56:33 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Florian Westphal <fw@strlen.de>
cc: lvxiafei <xiafei_xupt@163.com>, "David S. Miller" <davem@davemloft.net>, 
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
    Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
    Pablo Neira Ayuso <pablo@netfilter.org>, 
    Jozsef Kadlecsik <kadlec@netfilter.org>, lvxiafei <lvxiafei@sensetime.com>, 
    netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
In-Reply-To: <20250407101352.GA10818@breakpoint.cc>
Message-ID: <66ror6q2-7pq2-os23-rq8r-8426ppr6pnps@vanv.qr>
References: <20250407095052.49526-1-xiafei_xupt@163.com> <20250407101352.GA10818@breakpoint.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Monday 2025-04-07 12:13, Florian Westphal wrote:
>lvxiafei <xiafei_xupt@163.com> wrote:
>> The modification of nf_conntrack_max in one netns
>> should not affect the value in another one.
>
>nf_conntrack_max can only be changed in init_net.
>
>Given the check isn't removed:
>   /* Don't allow non-init_net ns to alter global sysctls */
>   if (!net_eq(&init_net, net)) {
>       table[NF_SYSCTL_CT_MAX].mode = 0444;
>
>... this patch seems untested?
>
>But, removing this check would allow any netns to consume
>arbitrary amount of kernel memory.
>
>How do you prevent this?

By inheriting an implicit limit from the parent namespace somehow.
For example, even if you set the kernel.pid_max sysctl in the initial
namespace to something like 9999, subordinate namespace have
kernel.pid_max=4million again, but nevertheless are unable to use
more than 9999 PIDs. Or so documentation the documentation
from commit d385c8bceb14665e935419334aa3d3fac2f10456 tells me
(I did not try to create so many processes by myself).

A similar logic would have to be applied for netfilter sysctls
if they are made modifiable in subordinate namespaces.
