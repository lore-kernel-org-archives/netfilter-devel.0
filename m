From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ipset] hash:net,iface bug?
Date: Thu, 26 May 2016 21:40:29 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1605262132160.24467@blackhole.kfki.hu>
References: <bc61b1ffc5fd4402bab9a533a1b2a384@BTS-XEXCH01-B.eset.corp> <alpine.DEB.2.10.1605232044560.2937@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Marek Mrva <mrva@eset.sk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:51871 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbcEZTjI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 May 2016 15:39:08 -0400
In-Reply-To: <alpine.DEB.2.10.1605232044560.2937@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 23 May 2016, Jozsef Kadlecsik wrote:

> On Mon, 23 May 2016, Marek Mrva wrote:
> 
> > I have been playing with hash:net,iface table for a couple of days now, 
> > but for the love of me, I can't make it accept physdev: devices.
> > 
> > The man says: When the interface is flagged with physdev:, the interface 
> > is interpreted as the incoming/outgoing bridge port.
[...]
>
> The IPSET_FLAG_PHYSDEV is passed from userspace, of course, see 
> ipset_parse_iface() in lib/parse.c. However, it seems it is not stored 
> when the user input in processed in the kernel. I'll double check and fix 
> it.

Digging into the code further, the IPSET_FLAG_PHYSDEV is stored in the 
kernel in the hash data. However, the logic to test it is broken. The 
current code in the kernel assumes that the "set" match has got a flag 
like "--match--physdev", however there is no such a flag.

The problem is that we may store in a hash:net,iface type of set both or 
either of

10.0.0.0/24,eth0
10.0.0.0/24,physdev:eth0

So we have to tell to the "set" match which one we want to match. I'm 
going to add the flag "--match--physdev" to the "set" match in a new 
revision.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
