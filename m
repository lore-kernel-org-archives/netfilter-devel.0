Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E850A1DDC37
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 09:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776246934; cv=none; b=DYVdd7+vWmfroc0FXmgc7hZyF/xtkJ2ZGSpES6yz+NIt8CWKg+H0y/+WVgCD4uYPadP6iHGlsBICwY3HxCgYT6aqiI275bf5W5mnUdgvGyLwgNNCJc312TEfnl6hPZqGG25+T65256paohIfXS3rZpCnDVsVpqCdxhKucf8zZTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776246934; c=relaxed/simple;
	bh=NnOE/jo7PzoGIHhyFyqlI/69A/YCBZh2x347XKVH1MI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lJva2cnyiB2QaAeTPMqHiCZ52tdPxkhpQESueyNowRdIX4uB5FL2qo9q3JFJHzsFDkadBNnyhBS89RTFPtB59MAAXsjP+ZJ1biqelPivJm/6XmrnbcbglHEMaJ8h9gNzi5a4YyI5Kq0/8ucz0AqmX5SHr0DKOiY4/FHqAgZci3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oswYsteU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oswYsteU"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 014AE60177;
	Wed, 15 Apr 2026 11:55:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776246931;
	bh=JaMxTj6ILXESUfmgJz+FNkPvQCKN/A5rJaO7Rk0gKxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oswYsteUN3bJT5c2Ji0kfZHaqWN9EoKo6m4Sj4Y0mygtORawgKfLipipbu0oY1nOe
	 QpnCH1r6r41aS3lcXFILm6TZSLBT+mCBig6qlndj3r5BbhutAMFSK8dlQp10o6c7un
	 vj/XgFCktWdV7pajGafOVMlgEYdrMbj0f3h4ned1UdqyQsimYSij7i3GrBgsf6rUpo
	 aW9GO05Phl9jdiuXgkVv5H/dF7q91f6AEfiDDYjilBij4J4cn/Lah5e2yj6K9/xyln
	 ik3RuGHpX/r7vTPtvV3mfFpN9mJ2GttyJU4myQr9Xkmzo4JkwyjO/J4vVStlqQUKdG
	 p0Z6sOAX1Luaw==
Date: Wed, 15 Apr 2026 11:55:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, coreteam@netfilter.org,
	Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH nf v2] netfilter: nfnetlink_osf: fix divide-by-zero in
 OSF_WSS_MODULO
Message-ID: <ad9gkDM9VFJL_rFU@chamomile>
References: <20260414221401.2809350-1-xmei5@asu.edu>
 <ad9aX5IDPWt3F6OF@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ad9aX5IDPWt3F6OF@chamomile>

On Wed, Apr 15, 2026 at 11:29:06AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Apr 14, 2026 at 03:14:01PM -0700, Xiang Mei wrote:
> > nf_osf_match_one() computes ctx->window % f->wss.val in the
> > OSF_WSS_MODULO branch with no guard for f->wss.val == 0. A
> > CAP_NET_ADMIN user can add such a fingerprint via nfnetlink; a
> > subsequent matching TCP SYN divides by zero and panics the kernel.
> > 
> > Reject the bogus fingerprint in nfnl_osf_add_callback() above the
> > per-option for-loop. f->wss is per-fingerprint, not per-option, so
> > the check must run regardless of f->opt_num (including 0). Also
> > reject wss.wc >= OSF_WSS_MAX; nf_osf_match_one() already treats that
> > as "should not happen".
> > 
> > Crash:
> >  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
> >  RIP: 0010:nf_osf_match_one (net/netfilter/nfnetlink_osf.c:98)
> >  Call Trace:
> >  <IRQ>
> >   nf_osf_match (net/netfilter/nfnetlink_osf.c:220)
> >   xt_osf_match_packet (net/netfilter/xt_osf.c:32)
> >   ipt_do_table (net/ipv4/netfilter/ip_tables.c:348)
> >   nf_hook_slow (net/netfilter/core.c:622)
> >   ip_local_deliver (net/ipv4/ip_input.c:265)
> >   ip_rcv (include/linux/skbuff.h:1162)
> >   __netif_receive_skb_one_core (net/core/dev.c:6181)
> >   process_backlog (net/core/dev.c:6642)
> >   __napi_poll (net/core/dev.c:7710)
> >   net_rx_action (net/core/dev.c:7945)
> >   handle_softirqs (kernel/softirq.c:622)
> > 
> > Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
> > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > Suggested-by: Florian Westphal <fw@strlen.de>
> > Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
> > ---
> > v2: Fix the bug in configure path and correct the fix tag
> > 
> >  net/netfilter/nfnetlink_osf.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
> > index 45d9ad231..70172ca07 100644
> > --- a/net/netfilter/nfnetlink_osf.c
> > +++ b/net/netfilter/nfnetlink_osf.c
> > @@ -320,6 +320,10 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
> >  	if (f->opt_num > ARRAY_SIZE(f->opt))
> >  		return -EINVAL;
> >  
> > +	if (f->wss.wc >= OSF_WSS_MAX ||
> > +	    (f->wss.wc == OSF_WSS_MODULO && f->wss.val == 0))
> > +		return -EINVAL;
> 
> Maybe, more explicit, it is more lengthy but cristal clear:

Not really, this needs to be done out of loop as you do.

I'll take your patch, thanks!
