Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AA51DE4E1;
	Sat, 13 Dec 2025 18:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765652097; cv=none; b=bgM9tomVJi7l2m9V4/wbTIyCyOgpv+arQU+lWo62jw05Ia5DBitnzAbtz9Oa9+OrQmdSXBY936mmQuUbkDuMJdZvzpP23y5MmMnsIe2Nty+bNDZWmhOQ5o0Hs92MNdyQ4q7OgK5rOdqAj27e536ni5Z38zmfTXv1IYNtn7VajLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765652097; c=relaxed/simple;
	bh=DQMXc/7LpFfbhS3pKjholK4C3ph+20JnwFpwL1FQ4Lg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGU3yiVOFD3jxeh9JNoyo9UA1YKKlio3EcxBTE36XA9ZGf/pl18jiC37m6RL4X88padjOibUk+0txnvQrYTZYEjHID7WNVuQoT4BG+vIyDngOt7bMxYsY2Cp9GLCoMAf3VDSjBE6knn6xU7lmuf31J4TE2MzZcM8zqna70qP9JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0B77A60232; Sat, 13 Dec 2025 19:54:53 +0100 (CET)
Date: Sat, 13 Dec 2025 19:54:42 +0100
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
Message-ID: <aT22cheoCSd1JfIM@strlen.de>
References: <693b0fa7.050a0220.4004e.040d.GAE@google.com>
 <20251213080716.27a25928@kernel.org>
 <aT1pyVp3pQRvCjLn@strlen.de>
 <CANn89i+V0XfUMjo5azSAkcr6EKucQFs6fv6mpNeL3rN41SsTzg@mail.gmail.com>
 <aT1sxJHiK1mcrXaE@strlen.de>
 <CANn89iKDFe83G4_bmzPVkKwVwNcxTX1pyjBqoHwrt+rk3A9=dQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKDFe83G4_bmzPVkKwVwNcxTX1pyjBqoHwrt+rk3A9=dQ@mail.gmail.com>

Eric Dumazet <edumazet@google.com> wrote:
> > UDP, but I can't say yet if thats an udp specific issue or not.
> > (the packets are generated via ip_defrag.c).
> 
> skb_release_head_state() does not follow the fraglist. Oh well.
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index a00808f7be6a1b86c595183f8b131996e3d0afcc..f597769d8c206dc063b53938a18edbe9620101d9
> 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1497,7 +1497,9 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
> 
>         DEBUG_NET_WARN_ON_ONCE(!in_softirq());
> 
> -       if (skb->alloc_cpu != smp_processor_id() && !skb_shared(skb)) {
> +       if (skb->alloc_cpu != smp_processor_id() &&
> +           !skb_shared(skb) &&
> +           !skb_has_frag_list(skb)) {
>                 skb_release_head_state(skb);
>                 return skb_attempt_defer_free(skb);

There is also:
skb_attempt_defer_free -> skb_attempt_defer_free

Alternatively we could export skb_defer_free_flush or
kick_defer_list_purge() and call that from nf_conntrack
net exit path.

I will investigate more closely on monday, I still don't
understand why fragments are conntracked in the first place.
