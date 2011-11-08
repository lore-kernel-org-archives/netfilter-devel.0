From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: usage of unitialized variable ip_to in
 ip_set_hash_ipportnet.c
Date: Tue, 8 Nov 2011 08:56:12 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1111080848040.29308@blackhole.kfki.hu>
References: <20111107221823.GH18221@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:55868 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab1KHH4P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Nov 2011 02:56:15 -0500
In-Reply-To: <20111107221823.GH18221@smp.if.uj.edu.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 7 Nov 2011, Witold Baryluk wrote:

> in file et/netfilter/ipset/ip_set_hash_ipportnet.c
> in functionhash_ipportnet4_uadt(...)
> variable u32 ip_to, can be used uninitialized
> in line 283
> 	for (; !before(ip_to, ip); ip++) {
> 
> because, if both tb[IPSET_ATTR_IP_TO] and tb[IPSET_ATTR_CIDR]
> are false, then there is no initialization of ip_to.
> 
>   CC [M]  net/netfilter/ipset/ip_set_hash_ipportnet.o
> net/netfilter/ipset/ip_set_hash_ipportnet.c: In function ?hash_ipportnet4_uadt?:
> include/net/tcp.h:266:28: warning: ?ip_to? may be used uninitialized in this function [-Wuninitialized]
> net/netfilter/ipset/ip_set_hash_ipportnet.c:187:10: note: ?ip_to? was declared here

Which ipset version you are looking at? What gcc version are you running?

ip_to is explicitly initialized to zero in line 187 in the current ipset 
version.
 
> I think this should be fixed be properly initializing / using ip_to,
> or by telling compiler that some of paths will end in initialization.
>  
> Also why on earth a before(a,b) function is used
> to compare IP addresses? Shouldn't before(seq1,seq2) function
> be used only to compare TCP sequnce numbers?!

That's a quick way to avoid wraparound in the for loop.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
