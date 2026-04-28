Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326C039891F;
	Tue, 28 Apr 2026 11:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777374047; cv=none; b=o1ndADAR/+BanQJXqtMOvnYjek+0dli5O3ORHHCCPi1Ot9iNRWTNAYTAykwD0toWEA3JQkRK5kTveB0c/0EjRIIbSmGvZL0K5/y+sQ3wpLfg4KndJpCumn6hqQ+5Vy7LUfSxTwXHdkyam4yUqzdqQpSYLejy1jE7BYhjtf5KHaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777374047; c=relaxed/simple;
	bh=Uefk//Or6MWKb4FY2PvkClVl4kqx5cq6unjXrhiqhsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DAh2tnVYN16AT6AQMI9qk7mm6h8xFQtlYFVmH478Vdky0DZn0VVegq0dx/IZBefHm1E0a4tb7UixRRhUeLF9KCByc4a74f/pbRDiugUO6HGvGdnLSwVHXmgGXMKfz53LGiCVYX/Jam5mYwFKD2ZG9/4X/x7ErINqroij+Ce6q3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aETsHw7m; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aETsHw7m"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 59149600B5;
	Tue, 28 Apr 2026 13:00:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777374043;
	bh=dwn6CWlk95VWnSN849r13HbnQotK1IIZo/b3BQl5OCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aETsHw7mV+swGUDWBtiHGigJxGgYrppmYq5SfOK5rmn1gzT4yB4LVcZD6NZ96HLAy
	 L08AMwMNL4NhEgbDzyGCPNV1h8rNbHF2rOCdEvbMCiwiL9RqBKIEuYfEdltX7p4XY9
	 Zq702P9rLqNK/x+Q+aQUhsrmvYb+Rr5dNbCX1P2ud2hF2gtvh+ptLgMEkLj9lUUL9E
	 tAfDOTqsO/ko3sgo33XJoClf1Xgi3CHmzAPxGi5e5dJCnuN9WRO5rfc6LBvMTljGst
	 JgfGsAYo2AZVSS3nteHw7cg8nLCXpHtduP5mD47FTKduavxW1efvdqyrG4t1LtPzj2
	 MKU4DUKHWk7Zg==
Date: Tue, 28 Apr 2026 13:00:40 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, edumazet@google.com,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org
Subject: Re: [PATCH net] neighbour: neigh_xmit needs to release skb on
 -EAFNOSUPPORT
Message-ID: <afCTWAZ7yl7L9pM8@chamomile>
References: <20260428102052.53637-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260428102052.53637-1-pablo@netfilter.org>

On Tue, Apr 28, 2026 at 12:20:52PM +0200, Pablo Neira Ayuso wrote:
> Sashiko reports:
> 
> "... if the target neighbor table is NULL (for example, for
> NEIGH_ND_TABLE when IPv6 is disabled), the code takes the out_unlock
> path and bypasses the out_kfree_skb cleanup"
> 
> Fix this skb memleak by releasing the skb in case of -EAFNOSUPPORT.

Please, withdraw.

Florian Westphal already posted a similar fix that is already in
net.git

Thanks.

> Fixes: f8f2eb9de69a ("neighbour: add RCU protection to neigh_tables[]")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
