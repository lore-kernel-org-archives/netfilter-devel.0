From: Jesper Juhl <juhl-lkml@dif.dk>
Subject: Re: [PATCH] Warn people that ipchains and ipfwadm are going away.
Date: Wed, 22 Sep 2004 15:58:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.61.0409221556010.14486@jjulnx.backbone.dif.dk>
References: <1095721742.5886.128.camel@bach> <20040921143613.2dc78e2f.Ballarin.Marc@gmx.de>
 <1095803902.1942.211.camel@bach> <20040922003646.3a84f4c5.Ballarin.Marc@gmx.de>
 <20040921153600.2e732ea6.davem@davemloft.net> <20040922013516.753044db.Ballarin.Marc@gmx.de>
 <4150C448.5040604@trash.net> <20040922153707.2cc1d886.Ballarin.Marc@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, davem@davemloft.net,
	rusty@rustcorp.com.au, torvalds@osdl.org,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S265331AbUIVOB0@vger.kernel.org>
To: Marc Ballarin <Ballarin.Marc@gmx.de>
In-Reply-To: <20040922153707.2cc1d886.Ballarin.Marc@gmx.de>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 22 Sep 2004, Marc Ballarin wrote:

> Date: Wed, 22 Sep 2004 15:37:07 +0200
> From: Marc Ballarin <Ballarin.Marc@gmx.de>
> To: Patrick McHardy <kaber@trash.net>
> Cc: davem@davemloft.net, rusty@rustcorp.com.au, torvalds@osdl.org,
>     netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Warn people that ipchains and ipfwadm are going away.
> 
> On Wed, 22 Sep 2004 02:16:08 +0200
> Patrick McHardy <kaber@trash.net> wrote:
> 
> > Fixed by this patch.
> 
> Yes, works fine. Does this mean that ipchains was broken for a while, but
> no one complained?
> 
> Anyway, here is another trivial patch against -bk7 that adds runtime
> warnings. IMO most users are going to miss compile time warnings, or
> won't even compile kernels themselves.
> 

I like having runtime info as well as a compile time warning, but maybe 
the message should mention that iptables is staying and people should 
migrate??

> +	printk(KERN_WARNING
> +		"Warning: ipchains is obsolete, and will be removed soon!\n");
> +			

Perhaps something like this instead:

"Warning: ipchains is obsolete, and will be removed soon. Please migrate to iptables."


--
Jesper Juhl
