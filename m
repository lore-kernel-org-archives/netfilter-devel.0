From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: nft synproxy integration
Date: Mon, 9 Nov 2015 20:36:06 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1511092030480.30088@blackhole.kfki.hu>
References: <20151109163015.GM8098@macbook.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	bjornar.ness@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:50941 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbbKITe3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 14:34:29 -0500
In-Reply-To: <20151109163015.GM8098@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 9 Nov 2015, Patrick McHardy wrote:

> Basically the idea is:
> 
> * don't mark the first SYN untracked and have it create a conntrack as normal
> * direct that SYN to synproxy
> * mark the connection as proxied, which will avoid setting the ASSURED bit when
>   receiving our spoofed reply
> * only set assured once we have the connection fully established
> 
> This would create a conntrack, but keep it evictable under pressure. So the
> cost would be ct set up, but we could tear it down at any point when we're
> under pressure. The synproxy target can handle both connections with and
> without a conntrack.
[...] 
> The ct state rule could actually be created automatically since it is a
> dependency.
[...]
> The method of using notrack would of course still be possible.

I like the idea: the notrack method would still be supported and the "do 
conntrack but with safety-net" way would be possible too. Looks cool!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
