Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1191D1FC8
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 11:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776164509; cv=none; b=Xk6rOIsfe+j7yPsj0OvSt5rzM5EuFldTjwaOYQCV6qjyFG81AgNfxwxAxyqEoo4kXsRyo8j67nNxZWHyKbTEL0B3P3IWfK6wsmSN0eOdZw7wIX+tpza5NLQZ40bdgF/7Ay8x5Cnn9UHrRcJRbK2pNdQklj+N7co//upzfrXagB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776164509; c=relaxed/simple;
	bh=T7VDJVh2O0J+Y2tZm1NJ0ilmYH+PI4oHbOMAF0xcgaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eDzv0VrNUI4WvQRUaI9pyheIW5BNVPijbgVuHwE+JKA8pu33YooeTDEF/wj1gz7/50TCGm9C7Qiuek0lnQNWFvaU6sySEo3gCn8SFw4vYdbkIHSOTHNBxqr+2BZ1gUzdpOi0BOvY99ZaGWxvCZQemDDLkNHqpY9QLbK30EX1eLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=t6cTpEa2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="t6cTpEa2"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 85D1B6029D;
	Tue, 14 Apr 2026 13:01:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776164504;
	bh=O7NY5SMDmUQsmmP/GFz1mPR9K95WBtcjGq5R6S6F5dg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t6cTpEa2+PWDpqEUr6zhmd+6dEbyAAXNeobrCG8aYmfCNNhpAp0YQAPFpUQ2/eMx3
	 fzsc8RiRiZBDfMSCeUpaONqjgFl9EgRYEanlC2XYDg3AJ5JD2rD8Q0fVsudzaXYv99
	 8/BlacpiM87m5R2A5K3pGRowjxenFe/d32Rv0EeLtVd1aDsZnC5OBBzEGMPfBOa9L3
	 i3AdbwT+Quqs5tEYo7cQjeNPMbk8bXwXhJzrTALHiLp5Wg+F44MlJLDO8Y2ktpMSOj
	 uxkHf3MqJbErKa2/x3jq2cP24POXuBE7kg7R8VzPdtBV2/WWWn/6LVfVeKJttz5SiT
	 k3bTj+WVi3IuA==
Date: Tue, 14 Apr 2026 13:01:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Xiang Mei <xmei5@asu.edu>, netfilter-devel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>, coreteam@netfilter.org,
	Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH nf] netfilter: nfnetlink_osf: fix divide-by-zero in
 OSF_WSS_MODULO
Message-ID: <ad4elUEYrkQ18iX8@chamomile>
References: <20260410204843.64259-1-xmei5@asu.edu>
 <adqx_IBgoyAMIJ5I@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <adqx_IBgoyAMIJ5I@strlen.de>

On Sat, Apr 11, 2026 at 10:41:32PM +0200, Florian Westphal wrote:
> Xiang Mei <xmei5@asu.edu> wrote:
> > The OSF_WSS_MODULO branch in nf_osf_match_one() performs:
> > 
> >   ctx->window % f->wss.val
> > 
> > without guarding against f->wss.val == 0.  A user with CAP_NET_ADMIN
> > can add an OSF fingerprint with wss.wc = OSF_WSS_MODULO and wss.val = 0
> > via nfnetlink.  When a matching TCP SYN packet arrives, the kernel
> > executes a division by zero and panics.
> > 
> > The OSF_WSS_PLAIN case already treats val == 0 as a wildcard (match
> > everything).  Apply the same semantics to OSF_WSS_MODULO: if val is 0,
> > any window value matches rather than dividing by zero.
> > 
> > Crash:
> >  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
> >  RIP: 0010:nf_osf_match_one (net/netfilter/nfnetlink_osf.c:98)
> >  Call Trace:
> >  <IRQ>
> >   nf_osf_match (net/netfilter/nfnetlink_osf.c:220 (discriminator 6))
> >   xt_osf_match_packet (net/netfilter/xt_osf.c:32)
> >   ipt_do_table (net/ipv4/netfilter/ip_tables.c:348)
> >   nf_hook_slow (net/netfilter/core.c:622 (discriminator 1))
> >   ip_local_deliver (net/ipv4/ip_input.c:265)
> >   ip_rcv (include/linux/skbuff.h:1162)
> >   __netif_receive_skb_one_core (net/core/dev.c:6181)
> >   process_backlog (.include/linux/skbuff.h:2502 net/core/dev.c:6642)
> >   __napi_poll (net/core/dev.c:7710)
> >   net_rx_action (net/core/dev.c:7945)
> >   handle_softirqs (kernel/softirq.c:622)
> > 
> > Fixes: 31a9c29210e2 ("netfilter: nf_osf: add struct nf_osf_hdr_ctx")
> 
> Hmm, why?  AFAICS the bug was there from start:
> 
> 11eeef41d5f63 case OSF_WSS_MODULO:
> 11eeef41d5f63    if ((window % f->wss.val) == 0)
> 11eeef41d5f63        fmatch = FMATCH_OK;
> 
> So:
> Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
> 
> > diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
> > index 45d9ad231..193436aa9 100644
> > --- a/net/netfilter/nfnetlink_osf.c
> > +++ b/net/netfilter/nfnetlink_osf.c
> > @@ -150,7 +150,7 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
> >  				fmatch = FMATCH_OK;
> >  			break;
> >  		case OSF_WSS_MODULO:
> > -			if ((ctx->window % f->wss.val) == 0)
> > +			if (f->wss.val == 0 || (ctx->window % f->wss.val) == 0)
> 
> Could you send a v2 that rejects this from control plane instead?
> Nobody is using a 0 value, else we'd have gotted such crash reports by
> now.

No news from this, I think this should be fine:

@@ -329,6 +332,15 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
                if (f->opt[i].kind == OSFOPT_MSS && f->opt[i].length < 4)
                        return -EINVAL;
 
+               switch (f->wss.wc) {
+               case OSF_WSS_MODULO:
+                       if (f->wss.val == 0)
+                               return -EINVAL;
+                       break;
+               default:
+                       break;
+               }
+
                tot_opt_len += f->opt[i].length;
                if (tot_opt_len > MAX_IPOPTLEN)
                        return -EINVAL;

If no concerns, I will post a patch.
