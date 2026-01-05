Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689223277B8;
	Mon,  5 Jan 2026 09:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767604507; cv=none; b=MJYLqZTGg9NddGAu14wmB7y51Xq4B8saVWp/FknGNWRFa/DZnqIeEg7E8MDALW0DQeD2uSCTrj3weeqd2U1VkYKunYPiyDKi9FBLjKBi7/yP7jT+G43iUTI7ktz7Lh3kz4c20vNMr7ktuGgQKA9EbS+/iHQlrRq5jDnFBEWciko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767604507; c=relaxed/simple;
	bh=5xeBDXm0mn/Rr32z+Kky0hj3jinq3o9nItTJbx4ulGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IZSVcaB8Z5H9+XxLcZRV13Eyy5X/McBpl5eei1oXDUXI7ln+wdGLilGvkaj02are8NObSIHIJX0D/EShg/BaMNMTVutHoBANNE4RFpBaqJAJ0zUgaRftI6K/SQy7sZEZcXroxMecgkew/uQc3GjfTmvofhWma3abZOSgXn5PcEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CEED660351; Mon, 05 Jan 2026 10:15:00 +0100 (CET)
Date: Mon, 5 Jan 2026 10:15:00 +0100
From: Florian Westphal <fw@strlen.de>
To: syzbot <syzbot+ee287f5effa60050d9ac@syzkaller.appspotmail.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] possible deadlock in
 nf_tables_dumpreset_rules
Message-ID: <aVuBFErrvyjKv0v5@strlen.de>
References: <695b76dc.050a0220.1c9965.0029.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <695b76dc.050a0220.1c9965.0029.GAE@google.com>

syzbot <syzbot+ee287f5effa60050d9ac@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    54e82e93ca93 Merge tag 'core_urgent_for_v6.19_rc4' of git:..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10b1ee22580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8bfa57a8c0ab3aa8
> dashboard link: https://syzkaller.appspot.com/bug?extid=ee287f5effa60050d9ac
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-54e82e93.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/c7af41d4f0f4/vmlinux-54e82e93.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/02aa2250dd4f/bzImage-54e82e93.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ee287f5effa60050d9ac@syzkaller.appspotmail.com
> 
> netlink: 48 bytes leftover after parsing attributes in process `syz.8.6539'.
> ======================================================
> WARNING: possible circular locking dependency detected
> syzkaller #0 Tainted: G             L     
> ------------------------------------------------------
> syz.8.6539/2008 is trying to acquire lock:
> ffff888052e32cd8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_dumpreset_rules+0x6f/0xa0 net/netfilter/nf_tables_api.c:3913
> 
> but task is already holding lock:
> ffff888025cb16f0 (nlk_cb_mutex-NETFILTER){+.+.}-{4:4}, at: __netlink_dump_start+0x150/0x990 net/netlink/af_netlink.c:2404
 
> which lock already depends on the new lock.

#syz dup: possible deadlock in nf_tables_dumpreset_obj
