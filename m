Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1492C11E2;
	Tue, 23 Dec 2025 12:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766493629; cv=none; b=F8919LIYj+pKFG5C3t2I2Q+ShtyDW5kB3XyNxzetGP6t3nEpoO46xyZ1zppo7eIMAGdxrpiLSfzTuVunzQwaCcU9nE1WjTPT1vOwyzfyvWFuHxXpqsYUzvpPRhohgahfJyH65gZ3ZroCUUu3r+L/ojiUb7LboAz5ThFqUnQZwo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766493629; c=relaxed/simple;
	bh=iHZkWUprqi5MDi+sdCv+B6RvA6q+yXVB+agqsq30lvw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DYS0xvJqC6SjJzOyXNUkHOYqbid0f7WZxlB1BuZ7EMB4eC0dAug0LMbfiKaW1vf24XePGEGFS+LdUz3sB3xfvVyX1e14fnlxWvjzOICXJf4NU16613EVb8bU8WtiAVacuMCPMO1IptLl/qbcZm1sffqxfBH1ni5u+m/xe+2vZIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=dsap1GJ1; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="dsap1GJ1"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4dbDsn5wZWz3sb8d;
	Tue, 23 Dec 2025 13:32:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1766493131; x=1768307532; bh=Z72d/b1Axk
	BiRXZajisn1BNLwwoimbxFqXF2IWlBu8k=; b=dsap1GJ1tJ3MKGoWHvug74GYQl
	i0FiGu2hIWQBJqYxF/dSHOspNRmlvxfvK2AL335DU6EfYu5GVr5RfTDLarPBXcJ4
	CQiBij38WLYu9p//KQZpqgRb+7nBL0V6Pmsh5gv1Z26Donf3epMh4FSRfBWRcdLh
	xr781vV1z4JkJcgZE=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id bCBjsIHCtwVJ; Tue, 23 Dec 2025 13:32:11 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4dbDsl1br9z3sb7m;
	Tue, 23 Dec 2025 13:32:10 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 9CFC434316A; Tue, 23 Dec 2025 13:32:10 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 9B66C340D75;
	Tue, 23 Dec 2025 13:32:10 +0100 (CET)
Date: Tue, 23 Dec 2025 13:32:10 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: syzbot <syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com>, 
    coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
    horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
    netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
    pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] possible deadlock in
 nf_tables_dumpreset_obj
In-Reply-To: <aUh_3mVRV8OrGsVo@strlen.de>
Message-ID: <42671512-7b14-57ac-7722-a5739bb59976@blackhole.kfki.hu>
References: <6945f4b4.a70a0220.207337.0121.GAE@google.com> <aUh_3mVRV8OrGsVo@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hi,

On Mon, 22 Dec 2025, Florian Westphal wrote:

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
> 
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

I don't know how calling it could be avoided: userspace commands (ipset + 
iptables checkentry using ipset match/target) are serialized by 
nfnl_subsys_ipset.

Is there a way to force acquiring nlk_cb_mutex-NETFILTER first and then 
nfnl_subsys_ipset when doing a netlink dump?

> Or add a new lock (spinlock?) to protect the 'reset' object info
> instead of using the transaction mutex.
> 
> I haven't given it much thought yet and will likely not
> investigate further for the next two weeks.

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
