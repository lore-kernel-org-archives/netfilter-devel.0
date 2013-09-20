From: Patrick McHardy <kaber@trash.net>
Subject: Re: [FIX 1/1] sip: add missing RCU reader lock
Date: Fri, 20 Sep 2013 17:55:40 +0100
Message-ID: <20130920165539.GA27970@macbook.localnet>
References: <20130920155217.281613399@eitzenberger.org>
 <20130920155817.660882995@eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Holger Eitzenberger <holger.eitzenberger@sophos.com>
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 136.Red-79-152-198.dynamicIP.rima-tde.net ([79.152.198.136]:34090
	"EHLO macbook.localnet" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753301Ab3ITSPz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:15:55 -0400
Content-Disposition: inline
In-Reply-To: <20130920155817.660882995@eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 20, 2013 at 05:52:18PM +0200, Holger Eitzenberger wrote:
> Currently set_expected_rtp_rtcp() in the SIP helper uses
> rcu_dereference() two times to access two different NAT hook
> functions.  However, only the first one is protected properly by
> the RCU reader lock, but the 2nd isn't.

Its more a cosmetic thing since we rely on all netfilter hooks being
rcu_read_lock()ed by nf_hook_slow() in many places anyways.

> I chose to not just extend the first RCU protected area but putting
> the rcu_read_unlock() down, because there is a 'return' in between.

I'd suggest to do that since your patch still doesn't cover the
direct_rtp nf_nat_sdp_port_hook dereference. Actually with your patch
we have unbalanced RCU locking since the direct_rtp case contains
a "goto err1".

> 
> Signed-off-by: Holger Eitzenberger <holger.eitzenberger@sophos.com>
> 
> Index: net-next/net/netfilter/nf_conntrack_sip.c
> ===================================================================
> --- net-next.orig/net/netfilter/nf_conntrack_sip.c
> +++ net-next/net/netfilter/nf_conntrack_sip.c
> @@ -983,6 +983,7 @@ static int set_expected_rtp_rtcp(struct
>  	if (skip_expect)
>  		return NF_ACCEPT;
>  
> +	rcu_read_lock();
>  	rtp_exp = nf_ct_expect_alloc(ct);
>  	if (rtp_exp == NULL)
>  		goto err1;
> @@ -1012,6 +1013,7 @@ static int set_expected_rtp_rtcp(struct
>  err2:
>  	nf_ct_expect_put(rtp_exp);
>  err1:
> +	rcu_read_unlock();
>  	return ret;
>  }
>  
