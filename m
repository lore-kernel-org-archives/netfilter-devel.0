Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E838F1B143B;
	Thu, 29 Aug 2024 16:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724948735; cv=none; b=XW80MMyq2OFVxpsCiOkQiYu32D7lWmvY050XDM78vohPczuMIr23AII9n1LbFIHVNm7HJzVzV1ZcvVewAEQKljCYFggzWYwl6FlsC5bjNBoID9OUBno6UNTGB0JqnjkwYr55jOan+ubmgcggFz8f96C+O46Ms3ryAL3rRrFfHsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724948735; c=relaxed/simple;
	bh=YM4DQfPpLsmiU6CjPuKer6M8z+A1D8uI7+0DbyWmmV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJ3RrzI4WFgYE9v8adzM6GjH/kXo6mEZ6kxa6RLQH1FywsrLpMzhguT40nejuHfS1Ru4JuGtwY66VLKRTSLyu41RkXV0aA9uTRQlg/eOyUGC7wOY3VNAHtiOEjTqXbN0aHuj43vavQDIV+SkJ+lQNRMVwtm4Aq+EpWIGFrVlvUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sjhxQ-000582-Ia; Thu, 29 Aug 2024 18:25:12 +0200
Date: Thu, 29 Aug 2024 18:25:12 +0200
From: Florian Westphal <fw@strlen.de>
To: Breno Leitao <leitao@debian.org>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	David Ahern <dsahern@kernel.org>, rbc@meta.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	"open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH nf-next v4 1/2] netfilter: Make IP6_NF_IPTABLES_LEGACY
 selectable
Message-ID: <20240829162512.GA14214@breakpoint.cc>
References: <20240829161656.832208-1-leitao@debian.org>
 <20240829161656.832208-2-leitao@debian.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829161656.832208-2-leitao@debian.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Breno Leitao <leitao@debian.org> wrote:
> This option makes IP6_NF_IPTABLES_LEGACY user selectable, giving
> users the option to configure iptables without enabling any other
> config.

I don't get it.

IP(6)_NF_IPTABLES_LEGACY without iptable_filter, mangle etc.
is useless, rules get attached to basechains that get registered
by the iptable_{mangle,filter,nat,...} modules, i.e. those that
"select IP(6)_NF_IPTABLES_LEGACY".

The old get/setsockopt UAPI is useless without them, iptables -L, -A,
etc. won't work.

What am I missing?

I'm fine with this because this is needed anyway to allow
disabling the get/setsockopt api (needs the 'depends on' changes
though) later, but this change is a mystery to me.
