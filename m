Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB49713959D;
	Mon, 22 Dec 2025 09:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766395333; cv=none; b=CWBrPCbSE8o7z5DDdaAO2UzKuZ/sAQltkkQAP6T/J0T2cXwNfF/uNhjnWNwn39850MAQrMPmFRfmqpkaKfJUSac8Z0KSW1NMahTfR23Tkj7qrhgv++nQspYwcqz0AFFbtc1YhezMUaCAxhkgzJsXIzW1RskF4Y6gj/15CdkEA7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766395333; c=relaxed/simple;
	bh=v1EYkBRsBpJjxKhwYyzdpeuhUom9rWY/UrpMKpWCNi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SK3Yh+aksr/vXnNaDFfAIcKnde5NKug7kQ1JSvcWC8YdCR7+GGXZ42OsoDYxgPKO7Mg2o6xKMczz2s3PcZ6joh+8zfvWSCCFBjBFKdNcxjqDQLL7DjFaG+DimOlTWcc/VQ7VCz9z7sZVJQkf5lrfsqlXYDc5DDySxJD1H6YR2ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eiu6jdbg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eiu6jdbg"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9A51A60251;
	Mon, 22 Dec 2025 10:22:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1766395321;
	bh=rdu1D57wAQi3ZdLkda8em9q9mtPZF8NA3WQHzdvVqH0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eiu6jdbgqvk4uYwvec+qMey0kZzq9Y81dXqKggGjICJsUYP4AU4OQps1fpIa7ZJSZ
	 OmYxYVFQeJZ30aUPUiGo84JQIPFAdZ2AzcHKb84Pq1+ZNeE+sQq9nXnxsD3edKp2U5
	 uFaV8OUQZmwHvASeHLIj07qXhZdrXVI/WfjFyvSHiK+N1EzhMoO1GFGV2cvg9/r5us
	 vuyB20XcMdLhK6izUuk5gjzuM38NY7U6iKijUn5Zkxn/tkXViIDsMBkbozhzy6O1M5
	 Mt6kJUWq8GCdY3RbX7fFOav8L/eNml2Qt/C74QGTReSnMtUIfgGJgsOtK6e1eF91MT
	 Nr7wJe0CBl7TQ==
Date: Mon, 22 Dec 2025 10:21:58 +0100
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
Message-ID: <aUkNtgPyic8_fBd5@chamomile>
References: <6945f4b4.a70a0220.207337.0121.GAE@google.com>
 <aUh_3mVRV8OrGsVo@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aUh_3mVRV8OrGsVo@strlen.de>

On Mon, Dec 22, 2025 at 12:16:53AM +0100, Florian Westphal wrote:
> syzbot <syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com> wrote:
> > syz.3.970/9330 is trying to acquire lock:
> > ffff888012d4ccd8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_dumpreset_obj+0x6f/0xa0 net/netfilter/nf_tables_api.c:8491
> > 
> > but task is already holding lock:
> > ffff88802bce36f0 (nlk_cb_mutex-NETFILTER){+.+.}-{4:4}, at: __netlink_dump_start+0x150/0x990 net/netlink/af_netlink.c:2404
> > 
> > which lock already depends on the new lock.
> 
> I think this is a real bug:

Yes, I think so too, it was a bad idea to use the commit_mutex for this.

> CPU0: 'nft reset'.
> CPU1: 'ipset list' (anything in ipset doing a netlink dump op)
> CPU2: 'iptables-nft -A ... -m set ...'
> 
> ... can result in:
> 
> CPU0                    CPU1                            CPU2
> ----                    ----                            ----
> lock(nlk_cb_mutex-NETFILTER);
>                         lock(nfnl_subsys_ipset);
>                                                        lock(&nft_net->commit_mutex);
>                         lock(nlk_cb_mutex-NETFILTER);
>                                                        lock(nfnl_subsys_ipset);
> lock(&nft_net->commit_mutex);
> 
> CPU0 is waiting for CPU2 to release transaction mutex.
> CPU1 is waiting for CPU0 to release the netlink dump mutex
> CPU2 is waiting for CPU1 to release the ipset subsys mutex
> 
> This bug was added when 'nft reset' started to grab the transaction
> mutex from the dump callback path in nf_tables.
> 
> Not yet sure how to avoid it.
> Maybe we could get rid of 'lock(nfnl_subsys_ipset);'
> from the xt_set module call paths.
> 
> Or add a new lock (spinlock?) to protect the 'reset' object info
> instead of using the transaction mutex.
> 
> I haven't given it much thought yet and will likely not
> investigate further for the next two weeks.


