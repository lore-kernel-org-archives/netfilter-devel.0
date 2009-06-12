From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Reserve nfnetlink subsys ids.
Date: Fri, 12 Jun 2009 15:02:34 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906121413070.30679@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0906111334090.28605@blackhole.kfki.hu> <4A310FF4.2070207@trash.net> <4A31142E.50707@netfilter.org> <4A31198F.7010004@trash.net> <alpine.DEB.2.00.0906112349380.30129@blackhole.kfki.hu> <4A324558.3020506@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:50034 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763871AbZFLNCc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:02:32 -0400
In-Reply-To: <4A324558.3020506@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 12 Jun 2009, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
> > On Thu, 11 Jun 2009, Patrick McHardy wrote:
> > 
> > > Pablo Neira Ayuso wrote:
> > > > Patrick McHardy wrote:
> > > > > Jozsef Kadlecsik wrote:
> > > > > > Hi Patrick,
> > > > > > 
> > > > > > A tiny patch to add nfnetlink subsys ids for nftables and ipset. :-)
> > > As I said, IDs are usually not reserved until something is merged,
> > > even if there is agreement to merge it. I guess there has been too
> > > much bad experience with reserved IDs and code that never got merged.
> > > I have to justify the patches I merge myself and so far I can't.
> > 
> > You're right, of course. I'm going to find another way for a smooth protocol
> > migration.
> 
> I didn't mean to finally say no, just wondering if there are special
> circumstances which would justify an exception.

No need for an exception, there's a much nicer solution. 

What is my main problem actually? That currently there is no way for an 
extension-specific error reporting from the kernel to iptables when 
there's some problem with a rule. Therefore in order to catch the typical 
mistakes, I have to check the existence of the set specified on the 
iptables command line before the rules are sent to the kernel. It is done 
by querying the kernel about the set, currently via *sockopt calls. But 
when ipset is migrated to nfnetlink, it'd mean libnfnetlink dependecy, 
just for the sake of the set match/target in iptables. That's a too high 
price and I'm not willing to pay it.

So what I'm working on it is a protocol change in iptables itself (:-), 
which is fully backward compatible.

- add a new sockopt option, IPT_SO_GET_REPLACE, which is used instead of
  IPT_SO_SET_REPLACE (if supported by the kernel.  New iptables will 
  use IPT_SO_SET_REPLACE with old kernels.)
- new checkentry functions, which return the extension-specific error 
  codes instead of a simple boolean value
- if any error is detected by the checkentry funtions, IPT_SO_GET_REPLACE 
  returns the corresponding full ipt_entry, with the offset stored in 
  comefrom to the match/target which produced the error
- the userspace match/targets, with their new error function, 
  can translate the received error code to the appropriate error message 
  and can insert any specific data into the text using the offset into the 
  ipt_entry.

So we'll be able to report back exactly what is wrong with the given rule.
No need anymore to print 'Run `dmesg' for more information.' :-).

And from the set match/target point of view, I won't have to query the 
kernel at all :-)).

So far, working on the kernel part, surprisingly small modifications are 
required.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
