Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
	by smtp.subspace.kernel.org (Postfix) with SMTP id C7CA21B3754
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2024 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.131.102.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718904591; cv=none; b=SRhPDB7mtnjUgPygrU2TjocvR251TuycZo/GzRpg/A6cOf2SCYAMuXsNHtR9+J4ZAtEcQkM6ojGQs9J4KSbNrPB2C34FL5uc76KFFgqcXLE/AHy+XONk7qPPTOWxQ0q6TFBQKKcj1HTQQ1LV11teZPxffZWaDaY08QGZv/teN5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718904591; c=relaxed/simple;
	bh=HSV+mjGe9U1QjnuLWkIZr8nQXJh3Rx93/FTUhxTQ+94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U4U3Mm4w5HuT4pRRtfzWCMv+U0JLZhm4RFn7F0aPWztyCdHFK8CrOPZZazEZQZ1J+QQoKBDCmCpkmmpmsWbbhdXsaKZyxUSHI5dDZEhe6BoD+q7bdQlPMGGsGN6ZXDzn008d51UkqVJi0aczJ7PuhhLS28UHuMtoyUN64/30C+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu; spf=pass smtp.mailfrom=netrider.rowland.org; arc=none smtp.client-ip=192.131.102.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netrider.rowland.org
Received: (qmail 506493 invoked by uid 1000); 20 Jun 2024 13:29:42 -0400
Date: Thu, 20 Jun 2024 13:29:42 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: syzbot <syzbot+696cffe71c444e4a2dd8@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
  kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
  linux-usb@vger.kernel.org, netdev@vger.kernel.org,
  netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org,
  syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] [usb?] INFO: rcu detected stall in NF_HOOK
Message-ID: <24f0d918-efba-414c-8328-c0ed240e67b2@rowland.harvard.edu>
References: <000000000000c63a8e061b556ea6@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000c63a8e061b556ea6@google.com>

On Thu, Jun 20, 2024 at 10:13:24AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10341146980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fa0ce06dcc735711
> dashboard link: https://syzkaller.appspot.com/bug?extid=696cffe71c444e4a2dd8
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e8bfee980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12d3d851980000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/93525a95fe83/disk-2ccbdf43.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/b9b895227ea2/vmlinux-2ccbdf43.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e825248a8e73/bzImage-2ccbdf43.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+696cffe71c444e4a2dd8@syzkaller.appspotmail.com
> 
> rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P45
>  1-....
>  } 2688 jiffies s: 1349 root: 0x2/T
> rcu: blocking rcu_node structures (internal RCU debug):
> 
> Sending NMI from CPU 0 to CPUs 1:
> cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
> cdc_wdm 3-1:1.0: nonzero urb status received: -71
> cdc_wdm 3-1:1.0: wdm_int_callback - 0 bytes
> cdc_wdm 3-1:1.0: nonzero urb status received: -71

#syz dup: [syzbot] [usb?] INFO: rcu detected stall in raw_ioctl

Alan Stern
