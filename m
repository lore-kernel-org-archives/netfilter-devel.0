Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F6D1AF0C6;
	Mon, 25 Nov 2024 10:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732531245; cv=none; b=piaAG53XqfZTQL6uq8B2BD8z8SbO20J7UMg0wYgRPV4H3weW1R6rHvUiY0Uot7MKSRTwD6oOW550XxjdZg4W2BGofWX1aoWIyg48UGgStZRtzicw9zTPTJ8HMK74RnVFtjRIu0l2OM+gUXNI5bUBq/km7k0sstbPpgjFpWLhq08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732531245; c=relaxed/simple;
	bh=pFvQUn8ifchQgu497OtoNdnudDuJiDCs60Sx4eZww8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGW9vXcep6/Jci2aTOs5Za70ifvQwnVa0l9oQP2+D3asWtVvQSiQJVnXqO0/anazgZBpA5fl5SH1YGJhkDbr2tlbUB/QCzW76sgGbjKC9mG0Sl6NzTTHhoI7Vjav+lmpIml4+EojBjkHugyB9MZ5Hjvb6Pe8+tmG9cXlChdGb+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tFWW7-0007wJ-6E; Mon, 25 Nov 2024 11:40:31 +0100
Date: Mon, 25 Nov 2024 11:40:31 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: syzbot <syzbot+57bac0866ddd99fe47c0@syzkaller.appspotmail.com>,
	coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] WARNING in nft_socket_init
Message-ID: <20241125104031.GA28648@breakpoint.cc>
References: <67443b01.050a0220.1cc393.006f.GAE@google.com>
 <Z0RRutRfeaWVs63d@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0RRutRfeaWVs63d@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> At quick glance, cgroup maximum depth seems INT_MAX.

The WARN needs to be removed, thats all.
