Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF8718DF87;
	Tue, 20 Aug 2024 11:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724153158; cv=none; b=AjA12q+PrBFl/Du9Fg92waKn4dKokJUm1jnEk/mQvRZJ0JyUN6BXGWSrfpp3csBZUletYzykKFf9f9gwP567mXen2fwVsag76Dke2+d3svE31oPnDBa1zwITVRDDG5oeYTug/jRKj9klk+rkxLvnP3YHWIQmI/uc4gFeMSwvN0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724153158; c=relaxed/simple;
	bh=C8IWIjPI+wjOrw9YFrS6vwMUTZfiiFFhVUE5yus8p/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/jtP7vsW//8rcWAEESHDe+L//6feUdOSgCYN08QH89B4pVp3HG5c+W2E0wzXWBiXccfuEILxgFZt4vKbWUWe1mtvUN7dn9tNCisz8oYpkkLfL3IO8BfnYL0TarshXZ5EL80jJAYrU7AreoXn+vvTAphQgOrVn03LZeCRiosiOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=45748 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sgMzc-006kpT-4Q; Tue, 20 Aug 2024 13:25:42 +0200
Date: Tue, 20 Aug 2024 13:25:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Roman Smirnov <r.smirnov@omp.ru>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Karina Yankevich <k.yankevich@omp.ru>, lvc-project@linuxtesting.org
Subject: Re: [PATCH] netfilter: nfnetlink_log: remove unnecessary check in
 __build_packet_message()
Message-ID: <ZsR9Mr3REnkE3wPn@calendula>
References: <20240809074035.11078-1-r.smirnov@omp.ru>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240809074035.11078-1-r.smirnov@omp.ru>
X-Spam-Score: -1.9 (-)

On Fri, Aug 09, 2024 at 10:40:35AM +0300, Roman Smirnov wrote:
> skb->dev is always non-NULL, the check is unnecessary.

Same check exists in nfnetlink_queue, these two codebases have many
similarities.

I cannot think of any scenario where skb->dev is NULL in any of the
existing hooks.
