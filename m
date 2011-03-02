From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] nf_log: avoid oops in (un)bind with invalid nfproto values
Date: Wed, 02 Mar 2011 12:11:59 +0100
Message-ID: <4D6E25FF.6020701@trash.net>
References: <alpine.LNX.2.01.1102282102400.16012@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, eric@inl.fr,
	"David S. Miller" <davem@davemloft.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64422 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab1CBLMF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:12:05 -0500
In-Reply-To: <alpine.LNX.2.01.1102282102400.16012@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 28.02.2011 21:06, schrieb Jan Engelhardt:
> 
> The following changes since commit 41ac51eeda58a85b8a06d748cce7035cc77deebd
> (kaber/nf-next-2.6 @ 2.6.38-rc1+):
> 
>   ipvs: make "no destination available" message more informative (2011-02-16 14:53:33 +0900)
> 
> are available in the git repository at:
>   git://dev.medozas.de/linux master
> 
> Jan Engelhardt (1):
>       netfilter: nf_log: avoid oops in (un)bind with invalid nfproto values
> 

Since this fixes an oops, I've applied it to nf-2.6.git instead
of nf-next-2.6.git.

>  void nf_log_unbind_pf(u_int8_t pf)
>  {
> +	if (pf >= ARRAY_SIZE(nf_loggers))
> +		return -EINVAL;

I also fixed a warning, nf_log_unbind_pf is void.

>  	mutex_lock(&nf_log_mutex);
>  	rcu_assign_pointer(nf_loggers[pf], NULL);
>  	mutex_unlock(&nf_log_mutex);

