Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A05461CD208;
	Fri,  3 Jan 2025 11:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735904914; cv=none; b=PNtwT02XIVkRdnFI5nG0G1ITwBU7z60tAGxuh/wQ3CXLvllLsC6oJfOcu+0A9yIdvtkFTgrMfBpjREQwtgjwHEZL/JYF89ZhjFUtJMUE3RfHBLSJt+nw/3ZC9n18uYiUv6GNBZfss2m4HcDzJxhF9rdstFk9oyZucPir46tG79c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735904914; c=relaxed/simple;
	bh=2qdYquq9sWk4njzH9KHYOht/ZVDIo1arVcbVs15zF8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dZU3whrv4W7YBWQnHFf7QAM24wp0mq9p1YeptxE8JATnrk9/bYpVfBCEW1km9qfkphxyJfYosABqYP6Y51EKFgEymFSxu21/pV1HoShp7WUF6lciRtDIDvhO/CEXYNHNRTLTlqLLPGCEzNiy2C2FIpW1v5zCD7Wjj7+xr24Csww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
X-Spam-Level: 
Date: Fri, 3 Jan 2025 12:48:22 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Dumazet <edumazet@google.com>
Cc: syzbot <syzbot+013daa7966d4340a8b8f@syzkaller.appspotmail.com>,
	coreteam@netfilter.org, davem@davemloft.net, horms@kernel.org,
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] INFO: task hung in htable_put (2)
Message-ID: <Z3fOdnotJMKWjCNe@calendula>
References: <6742badd.050a0220.1cc393.0034.GAE@google.com>
 <CANn89iJbfy890gJuqAU-tY76ZSGS0W130KO7=9jvtHYUVzdSmQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iJbfy890gJuqAU-tY76ZSGS0W130KO7=9jvtHYUVzdSmQ@mail.gmail.com>

Hi Eric,

On Fri, Jan 03, 2025 at 10:52:54AM +0100, Eric Dumazet wrote:
> On Sun, Nov 24, 2024 at 6:34 AM syzbot
> <syzbot+013daa7966d4340a8b8f@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    cfaaa7d010d1 Merge tag 'net-6.12-rc8' of git://git.kernel...
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13fd6b5f980000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aeec8c0b2e420c
> > dashboard link: https://syzkaller.appspot.com/bug?extid=013daa7966d4340a8b8f
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> >
[...]
> I do not think I got any feedback from
> https://lore.kernel.org/netdev/20241206113839.3421469-1-edumazet@google.com/T/
> 
> Should  I repost this patch ?

No need to, I will add this to nf-next now as you requested.

Thanks.
