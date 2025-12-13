Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C8014B08A;
	Sat, 13 Dec 2025 13:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765632468; cv=none; b=O3KReTmjq4ZaYMBiwb5aZriDwzCRZlObrm1Oug3RQmoTKyvzgwBeILAvO6cta3lXdZ6qS6Xzwe31nmrzJGXOHm6uhgcu88SiMykvMYdRyHvscXtvaGGDvmRlsImSTsS11hsG8ySwHKFPLi1vTdkAExCOpQswmyskpHi74M3jPws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765632468; c=relaxed/simple;
	bh=bBD3+L9GuI5moIHedesNtRaN7yxo4+CKPjIrxItCzYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6Chh0XTzUfNWmWWZCKmfkmvuADfZoxOjRIeTvAlgJBwA79Y637e14CVkU/OUojfPbW0ns5I5HFPypdic9AzAg8k/vInPbEQNdipzK2ckQydWT5FrLeyqrho/EiSSckBi8O3JGjHQxSNpuW4dvCIJSsmCnKRT75a1iwoZgtIudc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A3A9160332; Sat, 13 Dec 2025 14:27:37 +0100 (CET)
Date: Sat, 13 Dec 2025 14:27:37 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: syzbot <syzbot+4393c47753b7808dac7d@syzkaller.appspotmail.com>,
	coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kadlec@netfilter.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] WARNING in nf_conntrack_cleanup_net_list
Message-ID: <aT1pyVp3pQRvCjLn@strlen.de>
References: <693b0fa7.050a0220.4004e.040d.GAE@google.com>
 <20251213080716.27a25928@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251213080716.27a25928@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 11 Dec 2025 10:38:31 -0800 syzbot wrote:
> > ------------[ cut here ]------------
> > conntrack cleanup blocked for 60s
> > WARNING: net/netfilter/nf_conntrack_core.c:2512 at
> 
> Yes, I was about to comment on the patch which added the warning..
> 
> There is still a leak somewhere. Running ip_defrag.sh and then load /
> unload ipvlan repros this (modprobe ipvlan is a quick check if the
> cleanup thread is wedged, if it is modprobe will hang, if it isn't
> run ip_defrag.sh, again etc).
> 
> I looked around last night but couldn't find an skb stuck anywhere.
> The nf_conntrack_net->count was == 1

Its caused skb skb fraglist skbs that still hold nf_conn references
on the softnet data defer lists.

setting net.core.skb_defer_max=0 makes the hang disappear for me.
