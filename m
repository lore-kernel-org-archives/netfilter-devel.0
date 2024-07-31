Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A3314B097;
	Wed, 31 Jul 2024 21:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722462938; cv=none; b=FXlbGbG1KISmM8pIqM2UksxOuQcSkhcHiCmN+thvMFfx0NTr4xEmGOL4d1UH9QFdcAoK4+xY6V73iNON3NoqyctHVskGhJ/JgJMl7LNkLTw1y//RfNj645yxTlMSa1Dki+Qt9T/TwlAz5Z6+IoRzK/sH0xVEbMxXOGxglluGE8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722462938; c=relaxed/simple;
	bh=rRPe7HpzldSzlXtqsNLHYZTRcIJIBEcZKAqoGHyDrqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AKRWq44xxoFe5+5wS9Fb6Y+o0ijmkoY5Wm3k4q7inIe+90hrMExTVasviSLiCULJjequgeG1eyoZX6PkpWXdKmrTrzxk4mKc7TlS4V71aU5uMUPgZznF9YJFLdn/wsncG5vs+S0LR/pPpUeTl077N2sqD4TXeUpJpxg2WEhblPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [2001:8a0:74d4:2501:a64e:31ff:febd:17a4] (port=43386 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sZHIA-00CrjV-H5; Wed, 31 Jul 2024 23:55:33 +0200
Date: Wed, 31 Jul 2024 23:55:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Kuniyuki Iwashima <kuni1840@gmail.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v1 nf 0/2] netfilter: iptables: Fix null-ptr-deref in
 ip6?table_nat_table_init().
Message-ID: <Zqqy0e3R_Z4qnl8S@calendula>
References: <20240725192822.4478-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240725192822.4478-1-kuniyu@amazon.com>
X-Spam-Score: -1.9 (-)

On Thu, Jul 25, 2024 at 12:28:19PM -0700, Kuniyuki Iwashima wrote:
> We had a report that iptables-restore sometimes triggered null-ptr-deref
> at boot time.
> 
> The problem is that iptable_nat_table_init() is exposed to user space too
> early and accesses net->gen->ptr[iptable_nat_net_ops.id] before allocated.
> 
> Patch 1 fixes the issue in iptable_nat, and patch 2 applies the same fix
> to ip6table_nat.

Series applied and PR sent to netdev including these fixes, thanks.
