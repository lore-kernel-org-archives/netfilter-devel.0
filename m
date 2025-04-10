Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25061372;
	Thu, 10 Apr 2025 13:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744291055; cv=none; b=qzGy2cfv8JQQ8VtOl8ob6lR9ZtLoN4ErOJVLM9D6g61hWZg5ZiG4eUCw9BsnbBmnOGk/CsuyywCsH12y5Zp2L8xiMlzZbab8IvS8UswdxBaIZrCr+Y7nIlyDwFoseA0dBK7B/0Edm+l57PprZ69UKzWGYKmrV5U7QJfS1d2GwGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744291055; c=relaxed/simple;
	bh=oGJ4GmXx3Y8qppshySpiieF19TJpjQKaRvecWbygU6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hkrQN6vGgiWZBc6Zwe0D2sz942Fkc4WHa85xjEchtFiAz9hbUSw930iV/7/ZTetidDnfgHMOV5btBetf5PRrex9XWjBjDxDhm26/hekrogBTfkH77RhZh3EXtt8HoAtohiO0WHfCZnbkG4NZ//5Edyzq4ZOvahXxplztFgySJ8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u2rmP-0004ks-4G; Thu, 10 Apr 2025 15:17:17 +0200
Date: Thu, 10 Apr 2025 15:17:17 +0200
From: Florian Westphal <fw@strlen.de>
To: lvxiafei <xiafei_xupt@163.com>
Cc: fw@strlen.de, coreteam@netfilter.org, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, kadlec@netfilter.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	pablo@netfilter.org
Subject: Re: [PATCH V3] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <20250410131717.GA14051@breakpoint.cc>
References: <20250409094206.GB17911@breakpoint.cc>
 <20250410130531.17824-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410130531.17824-1-xiafei_xupt@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

lvxiafei <xiafei_xupt@163.com> wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > I suggest to remove nf_conntrack_max as a global variable,
> > make net.nf_conntrack_max use init_net.nf_conntrack_max too internally,
> > so in the init_net both sysctls remain the same.
> 
> The nf_conntrack_max global variable is a system calculated
> value and should not be removed.
> nf_conntrack_max = max_factor * nf_conntrack_htable_size;

Thats the default calculation for the initial sysctl value:

net/netfilter/nf_conntrack_standalone.c:                .data           = &nf_conntrack_max,
net/netfilter/nf_conntrack_standalone.c:                .data           = &nf_conntrack_max,

You can make an initial patch that replaces all occurences of
nf_conntrack_max with cnet->sysctl_conntrack_max

(adding a 'unsigned int sysctl_conntrack_max' to struct
 nf_conntrack_net).

Then, in a second patch, remove the '0444' readonly and redirect
the child netns to use the copy in its own pernet area rather than the
init_net one.
