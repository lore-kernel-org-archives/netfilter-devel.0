Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372022;
	b=eRjoB1zuyBlmZzDZ4rV8PNy3e5rz3DNrfoz2yU/WheGkaihK9pI8WPNohtOzQSRYVyMW
	 YormbJ3nPjwWpxl6zxk8oBZt842uzSw6QHMPQXXm/5htDyfXPr8qZCFpkRjZ9tG6uyQAE
	 x4dHYwdhy+DUBgg2An1Eng/jB4O8XjRj6TRYGXHEJJOppKCjGm/+BGyfx+/9cqmqZPxtw
	 wk59wXuz3vFO3H0YHHC3pCKvxDsbYh7O9YXs6lWTyv1llHOZiMCNiCbE908iyvMlpWLbs
	 axhTZ2C6wz+vPvQBAsmjQ5dbGtsIQqdDO/NsiQuzU/KV9TnL8niHv/Mvf6wVrhjObpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372022;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Uj3aZp1Sh/cwIkyUV/OOG+zN5YNNRdMczY6NKNgx8m4=;
	b=oWXSKR+F2dazSFT+bH6wR2mACFWoQAt7HYnajK3cJ13kAchWfnCKeKO1BOHGWW8++J7e
	 +n0owTwrJpzpbTwchsV1viRS8uzknqSZGAmWDw/xvC5GH3mOjisKXEaYNm61CuaJ8fzTP
	 sBa5s3N3utVrahGJOIzAzXwJ5o5YauZKnr2hezZXgBo/sWQLogzUkPSYOtba5NDpVGy/C
	 LAo1KzOM5vo5aGMbuaOxyZnOa7hF1dNZrTy56vwqvQwXNzigs6Itvr7Mv0GtJgJ9Gy4Vh
	 aqhXNSiPMTWlgX7HIyv8+VHQvkf2qOMjHoZHwC/MvTgvEYeTozkYl8qdu5Oth6riCHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6367A606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 14:53:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6367A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CE6AD609D0; Fri, 30 Oct 2026 15:53:38 +0100 (CET)
Date: Fri, 30 Oct 2026 15:53:38 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc, VEGA <vega@nebusec.ai>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: keep socket ownership
 when expanding skb
Message-ID: <auSvco0w7wKkuyE9@strlen.de>
References: <20261030135750.4452-1-fmancera@suse.de>
 <auSrTEnc8tibSGs2@strlen.de>
 <17f1cf11-ae17-46f6-a8a0-a23644411ab0@suse.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17f1cf11-ae17-46f6-a8a0-a23644411ab0@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 10/30/26 3:35 PM, Florian Westphal wrote:
> > Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> >> nfqnl_mangle() replaces the skb with skb_copy_expand() when a verdict
> >> grows a packet beyond its tailroom. skb_copy_expand() does not copy
> >> skb->sk, so the replacement is unowned and freeing the original drops
> >> its socket memory charge.
> >>
> >> The expanded packet is no longer associated with the process that sent
> >> it. Therefore xt_owner or xt_cgroup and other socket based matches in
> >> later rules no longer matches and a later NFQUEUE reports no uid/gid. In
> >> addition, the expanded packet's memory is not counted towards the
> >> sender's SO_SNDBUF limit, so the sender can keep producing them while
> >> they sit in a queue.
> > 
> > A proper fix requires wmem/truesize fixups and will have to deal with
> > wmem-accounted vs. non-wmem accounted.
> > 
> > I dont think its worth fixing this, there are many other ways to
> > get OOM when you have CAP_NET_ADMIN.
> 
> That is fair but the keeping ownership of the skb seems worth it for 
> other uses too? Anyway, I don't think the OOM aspect is too relevant.

I don't think many people to packet payload rewrite for locally
originating packets.

> This is just fixing a combination of queue + other matches. I can also 
> drop the memory aspect of it from the commit and keep the combination thing.

I think that problem isn't too serious in practice, LLM is overselling.

You just need to structure the ruleset so that the nfqueue stuff comes
after the sk identity checks :-)

> But yeah, we can just ignore it. There are many combinations that are 
> problematic anyway (?)
>
> What do you think?

If you think its worth doing, then by all means, go for it!
