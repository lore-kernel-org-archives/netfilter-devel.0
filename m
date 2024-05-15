Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F7464CFC;
	Wed, 15 May 2024 14:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715782234; cv=none; b=Zpeu42g1rQ9kdKQ44vt09h5rHduarl03YO8BZ0OfAU7I5gysU3oD3qxBK+mWS0fy7eAxe/EoRarXx2yNDo4qvKHl3KhpGcBiD2kDST65Gm/WlnPOu65kI6wKMv4a4kBfK9dke5R0bi63u8RMwS9NbGZc2AlbpjaSpspZ28uKYqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715782234; c=relaxed/simple;
	bh=BGNQ6xXoiG1dKo4GOy4V1WhrIbH80VwCwy6F0kxPM6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NuZv3ex3H+BQcw3tgbejDpAUADAktE70zrD5uamzm8XYbUaYc7gAcMC7HVyR6pNlu3K3ub4JTpTu+LqlcRIKXbH2CFnn9obMCqJaZZ68Dk1c24fXvqVTVJ7mhwI/Cdq81iss/IEb0oXhNkp77W85TBRBBytNAeEk3oKt4Omckyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s7FKp-0001g5-R0; Wed, 15 May 2024 16:10:23 +0200
Date: Wed, 15 May 2024 16:10:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] netfilter: nfnetlink_queue: acquire rcu_read_lock()
 in instance_destroy_rcu()
Message-ID: <20240515141023.GE13678@breakpoint.cc>
References: <20240515132339.3346267-1-edumazet@google.com>
 <20240515132738.GD13678@breakpoint.cc>
 <CANn89iJUMN6VOkhLi__EH2VxMF1XatEn2x-n=0tLQ1+Bk3u+GQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJUMN6VOkhLi__EH2VxMF1XatEn2x-n=0tLQ1+Bk3u+GQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Eric Dumazet <edumazet@google.com> wrote:
> > If you prefer Erics patch thats absolutely fine with me, I'll rebase in
> > that case to keep the selftest around.
> 
> I missed your patch, otherwise I would have done nothing ;)
> 
> I saw the recent changes about nf_reinject() and tried to have a patch
> that would be easily backported without conflicts.

Right, makes sense from that pov.
I think its fine to apply the patch in this case, I'll followup later.

Thus:
Acked-by: Florian Westphal <fw@strlen.de>

> Do you think the splat is caused by recent changes, or is it simply
> syzbot getting smarter ?

Its old bug, AFAICS your Fixes tag is correct.

1. Userspace prog needs to subscribe to queue x
2. iptables/nftables rule needs to send packets to queue x
3. actual packets that match that have to be sent
4. Userspace program needs to exit while at least one packet
   is queued

Amazing that syzbot managed to hit all 4 checkboxes :)

