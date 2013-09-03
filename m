From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/6] Ipset comment extension - provide annotation of
 ipset entries
Date: Tue, 3 Sep 2013 10:43:55 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309031022410.2504@blackhole.kfki.hu>
References: <1378103757-14426-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309022205030.1199@blackhole.kfki.hu> <1421284.CRq8hvcun7@gentoovm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:45683 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473Ab3ICIn5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 04:43:57 -0400
In-Reply-To: <1421284.CRq8hvcun7@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2 Sep 2013, Oliver wrote:

> On Monday 02 September 2013 22:08:46 Jozsef Kadlecsik wrote:
> > 
> > On Mon, 2 Sep 2013, Oliver wrote:
> > > From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > > 
> > > The following patch series provides a new extension that can be
> > > enabled on any of the bitmap/hash ipsets to provide the ability
> > > to annotate each entry with an arbitrary string comment.
> > 
> > I'd really like to know where it's useful and required.
> > 
> > The comments are not used for anything at all in the kernel, those are
> > just extra baggage. Static sets (not updated by the SET target) are
> > created from userspace, where all these comments belong to. Dynamic sets
> > (updated by the SET target) are just dynamic and I don't really see how
> > the comments could be useful there.
> > 
> > So what are the user cases where it's useful?
> 
> Same as the user cases where -m comment is useful in iptables... Granted 
> that I can't see a use for dynamically setting them via -j SET, but 
> there may be a case for that if you wanted to be able to discern 
> manually entered comments from dynamic ones in a single ipset.

-m comment in ip[6]tables was a step in a slippery slope... In a similar 
way one could argue for comment fields in routing or traffic shaping 
entries too.
 
> Anyhow, the use case is simple: 
> 
> If you're using a system for firewalling, very often comments are 
> applied to iptables rules in order to explain why they are there, or 
> whatever unblocking/blocking/mangling request they relate to. If you're 
> leveraging ipset to avoid massive, unwieldly, slow chains of iptables 
> rules, you've then lost the ability to annotate entries that you've 
> added. So, the use case is exactly as it is for xt_comment in 
> ip(6)tables-land; Namely to enable documentation of why an entry is 
> present.

In my opinion complex cases where rules/entries are best annotated with 
comments should be implemented in a meta language on top of 
ip[6]tables/ipset. The configuration is then viewed entirely in userspace, 
without any kernel queries and the task of the kernel is just to run the 
rules/sets translated from the language and pushed into kernel.

Anyway, I'll review your patches on the comment extension. However it'll 
depend on the internal reorganization of the extensions, so reworking will 
be required.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
