From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Subject: Re: ipset: usage of unitialized variable ip_to in
 ip_set_hash_ipportnet.c
Date: Tue, 8 Nov 2011 13:00:00 +0100
Message-ID: <20111108120000.GJ18221@smp.if.uj.edu.pl>
References: <20111107221823.GH18221@smp.if.uj.edu.pl>
 <alpine.DEB.2.00.1111080848040.29308@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smp.if.uj.edu.pl ([149.156.82.206]:41721 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab1KHMAH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:00:07 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111080848040.29308@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11-08 08:56, Jozsef Kadlecsik wrote:
> Hi,
> 
> On Mon, 7 Nov 2011, Witold Baryluk wrote:
> 
> > in file et/netfilter/ipset/ip_set_hash_ipportnet.c
> > in functionhash_ipportnet4_uadt(...)
> > variable u32 ip_to, can be used uninitialized
> > in line 283
> > 	for (; !before(ip_to, ip); ip++) {
> > 
> > because, if both tb[IPSET_ATTR_IP_TO] and tb[IPSET_ATTR_CIDR]
> > are false, then there is no initialization of ip_to.
> > 
> >   CC [M]  net/netfilter/ipset/ip_set_hash_ipportnet.o
> > net/netfilter/ipset/ip_set_hash_ipportnet.c: In function ?hash_ipportnet4_uadt?:
> > include/net/tcp.h:266:28: warning: ?ip_to? may be used uninitialized in this function [-Wuninitialized]
> > net/netfilter/ipset/ip_set_hash_ipportnet.c:187:10: note: ?ip_to? was declared here
> 
> Which ipset version you are looking at? What gcc version are you running?

Hi,

sorry to not mention it.

I'm compiling on 32-bit Intel x86, using gcc 4.6.2-4 with -march=pentium-m.
I'm using current/today mainline Linus' tree.
Last significant ipset change in this tree is from Jul 21, 2011.

> 
> ip_to is explicitly initialized to zero in line 187 in the current ipset 
> version.
>  
> > I think this should be fixed be properly initializing / using ip_to,
> > or by telling compiler that some of paths will end in initialization.
> >  
> > Also why on earth a before(a,b) function is used
> > to compare IP addresses? Shouldn't before(seq1,seq2) function
> > be used only to compare TCP sequnce numbers?!
> 
> That's a quick way to avoid wraparound in the for loop.
> 

It's somehow ugly. I agree that same method should be used,
but this just leaks a abstraction and who knows in the future
if this will not make problems.


Regards,
WItek


-- 
Witold Baryluk
JID: witold.baryluk // jabster.pl
