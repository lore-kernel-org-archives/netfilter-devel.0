Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9E63B6363
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 15:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775747172; cv=none; b=n+mtPu4H0mXv85h3do2CKZveZPNckU7E9LdtuOwgVaMk3QkxotjLm7oAExCq2/4cKIgN/LczK20J+4iG7WnjiFsgOQGSgRCxfqvoCWqOAy7bl/NjEddlXWcsX/QLGiLF9bE/kP9ToP9g2dKXVbQjTajT6dAl86hMmPXzG7zuNqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775747172; c=relaxed/simple;
	bh=iduZko/88iujLyFvTRXcgG+QUimtLLRipU7l8Yq24Kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8D8aK58LGLSMWZlmslpCl7LCDJE9Cxll8v7thAfHn9Q3gzhfh+YeZt4xLRPFUXfZPICYKofKF6vnJVawJmcHWNKQNpLUmeAGbqQrFLSjfODQRoJDSVK1emXVqO2IiXs4a3Q0csnIyxwmqz2JLGj0mwtnox9/xMT+EbnO2TJnqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aFEJvn/E; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aFEJvn/E"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82cebbdbdccso579608b3a.1
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Apr 2026 08:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775747170; x=1776351970; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JNkav/yhWdJLbDPIInjuFZXY0iHAcSm7PTNNRKiplfk=;
        b=aFEJvn/EEpt+JVsqt2JniGJgVgE3MgGuKMeDYK0/zVYJlgudOoSmY/SIKefkld9Log
         Jn3+mggIq4vvF1F0wjZ/k8Z35CGkD9S+ajQMAzVxsteGVB5N2Hz8EH2FHqcC44K6XnT3
         0u9e1IOz2kFDhjOpgoIUJPkV9CvkO2QpuUzlytupwQcQnj5upmOYCCUxPd474dimNwWo
         sM1uUx93KCLZAPYeo4Nm5bTMTXw9o6LqSvZa5Q4GaxbFNGeZh30RWDhWg0A4E4/0mpYQ
         bOIT3AJDOeo5gILw+HnF1QVymyCv4AhHnK0JIBmACgUidFuXV44Q1gYbJy+WT/GeFhci
         xs6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775747170; x=1776351970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JNkav/yhWdJLbDPIInjuFZXY0iHAcSm7PTNNRKiplfk=;
        b=pUBsMt5alj563h4q4XQg5Q7lcP1IXXpQCTzHrT6nzgzPD9oyF5THTPUGvZrPp+sEIn
         DXsp2B5kWbx24eEdlDJwaljbgBYNoxOsP7lFJGJJzVyQNgBf1xamQhnyYzgwQ+HCi/zr
         WDkAT0Sot/tdq3p0nee9O+JWq+9fvFKggXEDCmfGDqRGP0YxnYuDAZyfWJH/R7zyB5ay
         N4YbJGA3aJJnP8pMafoxC+h0VXeKEX7nVU2PvhZ5apO+xvx7FehPf4qu2ETtWGKBdJ9y
         P+aIs33Rt9pb4E3v1uPjKTWVPkvu9IVv813IMOeCZWSWHYSwBj2F0hloiAvVgOkswPG8
         YZlA==
X-Forwarded-Encrypted: i=1; AJvYcCUyHRAmDealdNWtAkWMC9bzTEzPEEY/cT8+rf1V25Jpsid94ATCAIu/t5K6pF+WXCGB8pRgcHZvo393LMBNpBM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw2fxlivLyg7Py6cIasDZDrhL5Xk1lTIum3Bwd505hWevnSkaa
	yOjAPB74Xou7dB6H5t121H/eoIbSdPUTtxK5+zd1IhRQSJdNKrVfgcZ7
X-Gm-Gg: AeBDiesCr4HtsowYehdt1NcFTkTwcdJBdimd3z68y4+fJ1EjqzxYRJG/55Grpl3STIF
	T0G098gwTlpvm2kZ3eO5040aHu8omzMnFe42nmooA494zGMp12oH9FUfFx2UPS4fxjqsROM6Rq7
	U2mY6lGk4UuYQQvzFMYkcKMaU5cDZOnCv7y7bJH/uZ43hLmMT0kvo+1X6CciiJD9TAZhY0K64Cc
	4UFyhFonoz59VKsm+7aneeL30in4nAuk5Uo6b8sDRQ8FJGxm57EWd2Cl/zTDWZsBe9+JucZvQIg
	5Qx7q5m29Py45sidbu/oQYjEQoo4lslJ9PIri3jDqcgG7KMtbjXps2rIZwYrML0j5zt4iCpMiDs
	SFlKErNO7yUuaQ4xbZraEcANGeAvgWpKlaMOVRWOsj36rzrPAlsCYIVzAzmVPz/64qlcW9IAsMR
	42LVvtApcjH+zflS8sGXpFFy/5nRjaurFDU4MgrhpgEXbKsqb6IaSSmBifNH6l
X-Received: by 2002:aa7:8892:0:b0:829:6f7d:3086 with SMTP id d2e1a72fcca58-82dd8aba240mr3203326b3a.11.1775747170163;
        Thu, 09 Apr 2026 08:06:10 -0700 (PDT)
Received: from SLSGDTSWING002 ([129.126.109.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c6ba2fsm24779155b3a.45.2026.04.09.08.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 08:06:09 -0700 (PDT)
Date: Thu, 9 Apr 2026 23:06:05 +0800
From: Weiming Shi <bestswngs@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v2] netfilter: nft_fwd_netdev: use recursion counter in
 neigh egress path
Message-ID: <adfAXBbb3P616LX-@SLSGDTSWING002>
References: <20260409104911.722698-2-bestswngs@gmail.com>
 <adeIF7ZsJsZsgwQy@chamomile>
 <adeLtBMyR3KZInDW@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adeLtBMyR3KZInDW@chamomile>

On 26-04-09 13:21, Pablo Neira Ayuso wrote:
> On Thu, Apr 09, 2026 at 01:06:03PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Apr 09, 2026 at 06:49:12PM +0800, Weiming Shi wrote:
> > > nft_fwd_neigh can be used in egress chains (NF_NETDEV_EGRESS). When the
> > > forwarding rule targets the same device or two devices forward to each
> > > other, neigh_xmit() triggers dev_queue_xmit() which re-enters
> > > nf_hook_egress(), causing infinite recursion and stack overflow.
> > > 
> > > Move the nf_get_nf_dup_skb_recursion() accessor and NF_RECURSION_LIMIT
> > > to the shared header nf_dup_netdev.h as a static inline, so that
> > > nft_fwd_netdev can use the recursion counter directly without exported
> > > function call overhead. Guard neigh_xmit() with the same recursion
> > > limit already used in nf_do_netdev_egress().
> > > 
> > > Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
> > 
> > I would just restrict this "feature", I don't see a point in allowing
> > this from egress?
> 
> Hm, actually this can be combined with if0 device, fixing it makes sense.
> 
> > > Reported-by: Xiang Mei <xmei5@asu.edu>
> > > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > > ---
> > >  include/net/netfilter/nf_dup_netdev.h | 13 +++++++++++++
> > >  net/netfilter/nf_dup_netdev.c         | 16 ----------------
> > >  net/netfilter/nft_fwd_netdev.c        |  7 +++++++
> > >  3 files changed, 20 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
> > > index b175d271aec9..609bcf422a9b 100644
> > > --- a/include/net/netfilter/nf_dup_netdev.h
> > > +++ b/include/net/netfilter/nf_dup_netdev.h
> > > @@ -3,10 +3,23 @@
> > >  #define _NF_DUP_NETDEV_H_
> > >  
> > >  #include <net/netfilter/nf_tables.h>
> > > +#include <linux/netdevice.h>
> > > +#include <linux/sched.h>
> > >  
> > >  void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
> > >  void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
> > >  
> > > +#define NF_RECURSION_LIMIT	2
> > > +
> > > +static inline u8 *nf_get_nf_dup_skb_recursion(void)
> > > +{
> > > +#ifndef CONFIG_PREEMPT_RT
> > > +	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
> > > +#else
> > > +	return &current->net_xmit.nf_dup_skb_recursion;
> > > +#endif
> > > +}
> > > +
> > >  struct nft_offload_ctx;
> > >  struct nft_flow_rule;
> > >  
> > > diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
> > > index fab8b9011098..a958a1b0c5be 100644
> > > --- a/net/netfilter/nf_dup_netdev.c
> > > +++ b/net/netfilter/nf_dup_netdev.c
> > > @@ -13,22 +13,6 @@
> > >  #include <net/netfilter/nf_tables_offload.h>
> > >  #include <net/netfilter/nf_dup_netdev.h>
> > >  
> > > -#define NF_RECURSION_LIMIT	2
> > > -
> > > -#ifndef CONFIG_PREEMPT_RT
> > > -static u8 *nf_get_nf_dup_skb_recursion(void)
> > > -{
> > > -	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
> > > -}
> > > -#else
> > > -
> > > -static u8 *nf_get_nf_dup_skb_recursion(void)
> > > -{
> > > -	return &current->net_xmit.nf_dup_skb_recursion;
> > > -}
> > > -
> > > -#endif
> > > -
> > >  static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
> > >  				enum nf_dev_hooks hook)
> > >  {
> > > diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
> > > index 152a9fb4d23a..492bb599a499 100644
> > > --- a/net/netfilter/nft_fwd_netdev.c
> > > +++ b/net/netfilter/nft_fwd_netdev.c
> > > @@ -141,13 +141,20 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
> > >  		goto out;
> > >  	}
> > >  
> > > +	if (*nf_get_nf_dup_skb_recursion() > NF_RECURSION_LIMIT) {
> > > +		verdict = NF_DROP;
> > > +		goto out;
> > > +	}
> > > +
> > >  	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
> > >  	if (dev == NULL)
> > >  		return;
> > >  
> > >  	skb->dev = dev;
> > >  	skb_clear_tstamp(skb);
> > > +	(*nf_get_nf_dup_skb_recursion())++;
> > >  	neigh_xmit(neigh_table, dev, addr, skb);
> > > +	(*nf_get_nf_dup_skb_recursion())--;
> > >  out:
> > >  	regs->verdict.code = verdict;
> > >  }
> > > -- 
> > > 2.43.0
> > > 
> > > 

Thanks Pablo. So shall I keep v2 as is, or is there anything else you'd 
like me to change?
