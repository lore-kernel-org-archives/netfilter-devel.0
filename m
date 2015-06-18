From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] nfnetlink_queue: add security context information
Date: Thu, 18 Jun 2015 21:02:21 +0200
Message-ID: <20150618190221.GA29618@salvia>
References: <55646731.9040803@samsung.com>
 <20150526130623.GD7817@breakpoint.cc>
 <5565A4D2.70701@samsung.com>
 <5565A6AA.90908@samsung.com>
 <20150527124957.GA19819@salvia>
 <557855B2.8030803@samsung.com>
 <20150610160541.GD7125@breakpoint.cc>
 <55798582.1040903@samsung.com>
 <20150611233757.GE7125@breakpoint.cc>
 <557AB559.1000001@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	=?utf-8?B?UmFmYcWC?= Krypa <r.krypa@samsung.com>
To: Roman Kubiak <r.kubiak@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52295 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbbFRS5A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Jun 2015 14:57:00 -0400
Content-Disposition: inline
In-Reply-To: <557AB559.1000001@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 12, 2015 at 12:32:57PM +0200, Roman Kubiak wrote:
> This way works and seems sensible (i tested it)
> 
> a fixed patch below
> 
> -- cut here
> 
> This patch adds an additional attribute when sending
> packet information via netlink in netfilter_queue module.
> It will send additional security context data, so that
> userspace applications can verify this context against
> their own security databases.
> 
> Signed-off-by: Roman Kubiak <r.kubiak@samsung.com>
> ---
> v2:
> - nfqnl_get_sk_secctx returns seclen now, this changes
> - updated size calculation
> - changed NFQA_SECCTX comment
> - removed duplicate testing of NFQA_CFG_F flags
> 
> v3:
> - NULL is not added to the security context anymore
> - return 0 when socket is invalid in nfqnl_get_sk_secctx
> - small intent change
> - removed ret variable in nfqnl_get_sk_secctx
> 
> v4:
> - removed security dependency, this patch does not
>   require any changes in other subsystems
> - nfqnl_get_sk_secctx returns seclen
> - added IFDEF when using secmark from the sk_buff
>   structure
> 
> v5:
> - added a check to disable security context sending
>   if CONFIG_NETWORK_SECMARK is not set
> 
> v6:
> - changed the way flags and mask are checked in
>   nfqnl_recv_config

Applied this v6. Thank you.
