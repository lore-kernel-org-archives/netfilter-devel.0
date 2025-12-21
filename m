Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592C679CD;
	Sun, 21 Dec 2025 23:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766359026; cv=none; b=mKYdT9jpZntuLqFvWs8doxBhByPQoU/gcIt1fAxWn1HwBTfeqMTavbpB3/ZJE34jWESvoJTlaO2tkJDVn8wzULxeXl0vgehTZp5da9OLRXJpRT7ewXXYKLMDMvXuJ0no8dR7/SA+4T8su3MMSVBEA15j0mbIunOnATXE/QkYu78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766359026; c=relaxed/simple;
	bh=pctbItDhMOB3TrNfizjEUa/ruzGbne5d6/0htwIF0E8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=etAyF1OTfFq0LHMFZjbYBAsBqlCctbUKpaCethE+bf/MTQYeibtS20OpxAov7ZHtiFc6ShY497RPXBXdx5bMDssdzmj7S3EUa+N/cqwj6/69w8RwHI9FG3HUudjQ7Ma5XqlrERqy7JiYyRT9KFz2vTfulKFb194is9x5CPUmTgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0858E60218; Mon, 22 Dec 2025 00:16:53 +0100 (CET)
Date: Mon, 22 Dec 2025 00:16:53 +0100
From: Florian Westphal <fw@strlen.de>
To: syzbot <syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] possible deadlock in
 nf_tables_dumpreset_obj
Message-ID: <aUh_3mVRV8OrGsVo@strlen.de>
References: <6945f4b4.a70a0220.207337.0121.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6945f4b4.a70a0220.207337.0121.GAE@google.com>

syzbot <syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com> wrote:
> syz.3.970/9330 is trying to acquire lock:
> ffff888012d4ccd8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_dumpreset_obj+0x6f/0xa0 net/netfilter/nf_tables_api.c:8491
> 
> but task is already holding lock:
> ffff88802bce36f0 (nlk_cb_mutex-NETFILTER){+.+.}-{4:4}, at: __netlink_dump_start+0x150/0x990 net/netlink/af_netlink.c:2404
> 
> which lock already depends on the new lock.

I think this is a real bug:

CPU0: 'nft reset'.
CPU1: 'ipset list' (anything in ipset doing a netlink dump op)
CPU2: 'iptables-nft -A ... -m set ...'

... can result in:

CPU0                    CPU1                            CPU2
----                    ----                            ----
lock(nlk_cb_mutex-NETFILTER);
                        lock(nfnl_subsys_ipset);
                                                       lock(&nft_net->commit_mutex);
                        lock(nlk_cb_mutex-NETFILTER);
                                                       lock(nfnl_subsys_ipset);
lock(&nft_net->commit_mutex);

CPU0 is waiting for CPU2 to release transaction mutex.
CPU1 is waiting for CPU0 to release the netlink dump mutex
CPU2 is waiting for CPU1 to release the ipset subsys mutex

This bug was added when 'nft reset' started to grab the transaction
mutex from the dump callback path in nf_tables.

Not yet sure how to avoid it.
Maybe we could get rid of 'lock(nfnl_subsys_ipset);'
from the xt_set module call paths.

Or add a new lock (spinlock?) to protect the 'reset' object info
instead of using the transaction mutex.

I haven't given it much thought yet and will likely not
investigate further for the next two weeks.
