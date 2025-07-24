Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0247E23C8A4;
	Thu, 24 Jul 2025 23:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753401341; cv=none; b=kzMC0WVSLR1Catc0fpZFJhXejcfMXoO1SRcr/OjrxvKUD+HBu5jwOzblymQhaMCNaqrocLieM3Ow6JyW/q6l2k/pJWA0njs5b7nZ8J3L6ntk4ErQRrMqJAUtzPZf5Engl9Fgdpqr2y7Z3NyyAN8n/cwFmNQ5X/AI5HXQOI/s/kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753401341; c=relaxed/simple;
	bh=B8/xWsVXmLVaoRd2gJdOohJQeynBFS1JDH0og+AClgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RG4VIl5OKVbo5t8MCLBSFem0UN1u0bsfR0QP1M0sDSK4dCxus7jBWFx9/6oaMoxB0Ysh+Rd7OEpseKLCPx2rmbjpmDN0aB0W9Nyj9V8txiWKrOgD0NNS0MRPVgWcvVlsOuI/u4zcBbfy5POtXLgl6XYhfIz7ZCOnu2CEpLXoZQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B0999602B2; Fri, 25 Jul 2025 01:55:33 +0200 (CEST)
Date: Fri, 25 Jul 2025 01:55:33 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: lvxiafei <xiafei_xupt@163.com>, coreteam@netfilter.org,
	davem@davemloft.net, edumazet@google.com, horms@kernel.org,
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH V2] netfilter: nf_conntrack: table full detailed log
Message-ID: <aILH9Z_C3V7BH6of@strlen.de>
References: <20250508081313.57914-1-xiafei_xupt@163.com>
 <20250522091954.47067-1-xiafei_xupt@163.com>
 <aIA0kYa1oi6YPQX8@calendula>
 <aIJQqacIH7jAzoEa@strlen.de>
 <aILC8COcZTQsj6sG@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aILC8COcZTQsj6sG@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I was thinking, does the packet logging exposes already the
> net->ns.inum? IIUC the goal is to find what netns is dropping what
> packet and the reason for the packet drop, not only in this case but
> in every case, to ease finding the needle in the stack. If so, then it
> probably makes sense to consolidate this around nf_log()
> infrastructure.

No, it doesn't.  It also depends on the backend:
for syslog, nothing will be logged unless nf_log_all_netns sysctl is
enabled.

For nflog, it is logged, to the relevant namespaces ulogd, or not in
case that netns doesn't have ulogd running.

For syslog one could extend nf_log_dump_packet_common() but I'm not sure
how forgiving existing log parsers are when this gets additional
field.

Also, would (in case we use this for the "table full" condition), should
this log unconditionally or does it need a new sysctl?

Does it need auto-ratelimit (probably yes, its called during packet
flood so we dont want to flood syslog/ulog)?

> Anyway, maybe I'm overdoing, I'll be fine with this approach if you
> consider it good enough to improve the situation.

I think its better than current state of affairs since it at least
allows to figure out which netns is experiencing this.
