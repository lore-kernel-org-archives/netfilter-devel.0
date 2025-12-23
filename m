Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F9033BBD6;
	Tue, 23 Dec 2025 13:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766495646; cv=none; b=jwnO+Ztn7rPr+EtdZmJYz2H62RvbDfM0z78UpOgDpwhU6v0ax8sg40Sq7604Iyo2UvOWue1hPZfzA+eGFwk3KMPikfG/5lvP3cn468VFW8PtKMtiDHhqH/8veqhtwZwuDUmXSPCfi8G0S+ioP7OA2unzWXBpYiCxXYuC2cHmXCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766495646; c=relaxed/simple;
	bh=hS8kXEmYmQArsjWlIRfSfrDbryDPz1WJh91lLwd7sLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3OO3zjWqxYXEwbNsrLumAqA2WXBvWuMaM6INoqsjOPP1Hu8NxoFDKb4Ul4qgg5ju9wO1l4C9oQfeXqt1BC5soMxALOZkueO5W6jBI7rjI0M7y8iaP9Qr21RxqbJlyoCXmvQzWwXSyLR0lu4NzWbqLWCge1zA2dfdSadcEMBvaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 96134604A3; Tue, 23 Dec 2025 14:14:01 +0100 (CET)
Date: Tue, 23 Dec 2025 14:14:00 +0100
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: syzbot <syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com>,
	coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, pablo@netfilter.org, phil@nwl.cc,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] possible deadlock in
 nf_tables_dumpreset_obj
Message-ID: <aUqVmHOvUe0KTFWB@strlen.de>
References: <6945f4b4.a70a0220.207337.0121.GAE@google.com>
 <aUh_3mVRV8OrGsVo@strlen.de>
 <42671512-7b14-57ac-7722-a5739bb59976@blackhole.kfki.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42671512-7b14-57ac-7722-a5739bb59976@blackhole.kfki.hu>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > Not yet sure how to avoid it.
> > Maybe we could get rid of 'lock(nfnl_subsys_ipset);'
> > from the xt_set module call paths.
> 
> I don't know how calling it could be avoided: userspace commands (ipset +
> iptables checkentry using ipset match/target) are serialized by
> nfnl_subsys_ipset.

Ok, thanks Jozsef.  In that case its much simpler to leave ipset
alone and add a new reset serialization mutex in nf_tables.
