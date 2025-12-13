Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA5313C3F2;
	Sat, 13 Dec 2025 13:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765633225; cv=none; b=X3YL9kVXtda+BmwiSQC2LyU+9mWWU2Jhj0PNDUhC9aYQeOryxlxPNJ5ofUNt57TSOYwcehPQOVGTYwtVKYQoTm4eUhYCcL/alVeU2qamQBadUfZtVPFIg5ChnfBykAliLa8iZuiZ/AYaC3CexRBIr1YC0X6JDvkG7cZdBauYHPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765633225; c=relaxed/simple;
	bh=i32LLvR+fXWr9Riefn4xCKfBRRvwZb5rnKFx69TXuXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B7nLAhYBBlkAyNwzdetV7nyDuMnsaslprVCscui/RzhQndw+4cOgvoMmAYzhI4VOHW0SHpMWoAyRvybwQNKfAWQg6//jlq2A86hLJ8AstEouFuu2yMurRrDlXZ1Dq4qxZ9a5R6W6qe+af8Ncv7NLeaFBbD5eDJ8ZM5bdECYI8qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AE63960366; Sat, 13 Dec 2025 14:40:20 +0100 (CET)
Date: Sat, 13 Dec 2025 14:40:20 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	syzbot <syzbot+4393c47753b7808dac7d@syzkaller.appspotmail.com>,
	coreteam@netfilter.org, davem@davemloft.net, horms@kernel.org,
	kadlec@netfilter.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, pablo@netfilter.org, phil@nwl.cc,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] WARNING in nf_conntrack_cleanup_net_list
Message-ID: <aT1sxJHiK1mcrXaE@strlen.de>
References: <693b0fa7.050a0220.4004e.040d.GAE@google.com>
 <20251213080716.27a25928@kernel.org>
 <aT1pyVp3pQRvCjLn@strlen.de>
 <CANn89i+V0XfUMjo5azSAkcr6EKucQFs6fv6mpNeL3rN41SsTzg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+V0XfUMjo5azSAkcr6EKucQFs6fv6mpNeL3rN41SsTzg@mail.gmail.com>

Eric Dumazet <edumazet@google.com> wrote:
> > > I looked around last night but couldn't find an skb stuck anywhere.
> > > The nf_conntrack_net->count was == 1
> >
> > Its caused skb skb fraglist skbs that still hold nf_conn references
> > on the softnet data defer lists.
> >
> > setting net.core.skb_defer_max=0 makes the hang disappear for me.
> 
> What kind of packets ? TCP ones ?

UDP, but I can't say yet if thats an udp specific issue or not.
(the packets are generated via ip_defrag.c).
