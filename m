Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD9C8287E;
	Mon, 22 Dec 2025 09:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766395863; cv=none; b=moY4pgpKlXmhMkEAdmhMf1B7B6eYt9qyvwXuHR1LAeOo//AdI2eIn9LCNmT99eEEdrqSDU1p2IDr5uPOODd+2nw8o1agGVeAo3Po4UOBWJpvexYoc+aNyiRIj4gTm69svchj70f563XRoW7hNdyotTjk8FkVaH+GXsurDwJRSF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766395863; c=relaxed/simple;
	bh=3OO+3ZPR19k/mVRyA0dejoWRH4Phos7oIP4vf/OLsvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gcmSIL7u0KPdv67fHzAzTNXAhfDYvaQHxXtO7y4Sn6ELupDnlqn2crtpUhSvwZqP3NvWrJ5M7c1nKzVA7wGe6B08fCG+P9a1U2IEbBr/dHdxO4k5EhA1Cveyng4bybUZettcZdUPOfVL1AyG//aZMt4WrSZslGeaLgiHd73V3v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=H40IQNVz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="H40IQNVz"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7CAC960264;
	Mon, 22 Dec 2025 10:30:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1766395858;
	bh=IHoo/OWsZqDGI30RmZhtzHVe2nfVCkr0l/qihTNP570=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H40IQNVzdVRjhKnN2Zhc9XUIcNpUWcHHho4Dd4Y2vZwDMcxQ98INFintcCjmm/sNp
	 5UTAuhw8GUD97PQcTIH4LPNCzeJ6tbaEmvCoRVf61MTjNrHyA1C8FFLEttwdKRTsde
	 ZaRln6DRB4ENvknOkhZf5XRNDWmVFkNbt2fTl6Hdd9lix4K/wugMA7tHQipXd875YN
	 CIFhAd6ziB+2Wtt9WiPsQq5kViEoTmRt9uvN8Xxf3dC6wFqWIBXv47fKlbpadGC22t
	 iZYJMR7quDo2zw951a/OTiX/db24Id7EsrDgeEhstNHKtHFZ/bLClZFa/yWOaKKf1/
	 wxyYxVd81eLyQ==
Date: Mon, 22 Dec 2025 10:30:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: syzbot <syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com>,
	coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, phil@nwl.cc,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] possible deadlock in
 nf_tables_dumpreset_obj
Message-ID: <aUkPz0extqKuB7Bl@chamomile>
References: <6945f4b4.a70a0220.207337.0121.GAE@google.com>
 <aUh_3mVRV8OrGsVo@strlen.de>
 <aUkNtgPyic8_fBd5@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aUkNtgPyic8_fBd5@chamomile>

Sorry, I pressed sent too fast... see below.

On Mon, Dec 22, 2025 at 10:22:02AM +0100, Pablo Neira Ayuso wrote:
> On Mon, Dec 22, 2025 at 12:16:53AM +0100, Florian Westphal wrote:
> > syzbot <syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com> wrote:
> > > syz.3.970/9330 is trying to acquire lock:
> > > ffff888012d4ccd8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_dumpreset_obj+0x6f/0xa0 net/netfilter/nf_tables_api.c:8491
> > > 
> > > but task is already holding lock:
> > > ffff88802bce36f0 (nlk_cb_mutex-NETFILTER){+.+.}-{4:4}, at: __netlink_dump_start+0x150/0x990 net/netlink/af_netlink.c:2404
> > > 
> > > which lock already depends on the new lock.
> > 
> > I think this is a real bug:
> 
> Yes, I think so too, it was a bad idea to use the commit_mutex for this.
> 
> > CPU0: 'nft reset'.
> > CPU1: 'ipset list' (anything in ipset doing a netlink dump op)
> > CPU2: 'iptables-nft -A ... -m set ...'
> > 
> > ... can result in:
> > 
> > CPU0                    CPU1                            CPU2
> > ----                    ----                            ----
> > lock(nlk_cb_mutex-NETFILTER);
> >                         lock(nfnl_subsys_ipset);
> >                                                        lock(&nft_net->commit_mutex);
> >                         lock(nlk_cb_mutex-NETFILTER);
> >                                                        lock(nfnl_subsys_ipset);
> > lock(&nft_net->commit_mutex);

Would it work to use a separated mutex for reset itself?

> > CPU0 is waiting for CPU2 to release transaction mutex.
> > CPU1 is waiting for CPU0 to release the netlink dump mutex
> > CPU2 is waiting for CPU1 to release the ipset subsys mutex
> > 
> > This bug was added when 'nft reset' started to grab the transaction
> > mutex from the dump callback path in nf_tables.
> > 
> > Not yet sure how to avoid it.
> > Maybe we could get rid of 'lock(nfnl_subsys_ipset);'
> > from the xt_set module call paths.
> > 
> > Or add a new lock (spinlock?) to protect the 'reset' object info
> > instead of using the transaction mutex.
> > 
> > I haven't given it much thought yet and will likely not
> > investigate further for the next two weeks.
> 
> 
