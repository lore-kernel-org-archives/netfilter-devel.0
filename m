From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] [RFC] Extended accounting infrastructure for
 iptables
Date: Fri, 16 Dec 2011 14:08:53 +0100
Message-ID: <20111216130853.GA21433@1984>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
 <CABa6K_Ffexe2SsaxyRPLBEjf1WOfSEgzJ4fa5L81QZs6JvXsVA@mail.gmail.com>
 <20111214133010.GA3155@1984>
 <CABa6K_HLc2w5K4taYmrNfhdXTPZsvE=OmdQtNnYBm32Erw8yBA@mail.gmail.com>
 <alpine.LNX.2.01.1112141655510.26476@frira.zrqbmnf.qr>
 <871us5bn3t.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Changli Gao <xiaosuo@gmail.com>,
	netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, thomas.jarosch@intra2net.com
To: Ferenc Wagner <wferi@niif.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49230 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab1LPNJD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Dec 2011 08:09:03 -0500
Content-Disposition: inline
In-Reply-To: <871us5bn3t.fsf@tac.ki.iif.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 15, 2011 at 09:23:34PM +0100, Ferenc Wagner wrote:
> Jan Engelhardt <jengelh@medozas.de> writes:
> 
> > On Wednesday 2011-12-14 15:52, Changli Gao wrote:
> >
> >> On Wed, Dec 14, 2011 at 9:30 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >>
> >>> On Wed, Dec 14, 2011 at 09:12:52PM +0800, Changli Gao wrote:
> >>>>
> >>>> Why not use the counters of iptables instead?
> >>>>
> >>>> iptables-save -c
> >>>
> >>> If you want to obtain the sum of the counters that match some criteria,
> >>> you have to iterate over the whole list of existing rules, look for
> >>> matchings and update the counters.
> >>
> >> As I said in another thread, you can redirect the traffic to a
> >> separated chain, and use the counters of that chain.
> >
> > UDCs (user defined chains) don't have counters, though.
> 
> So put an empty rule into them.  The ip_ plugin of Munin uses this
> technique for quite some time.
> 
> >>> Moreover, if you have a large rule-set, polling periodically
> >>> iptables-save -c can be expensive.
> >>
> >> I got it. Thanks. Maybe we can index the entries in the kernel, and
> >> add a new interface to get the counters of a special entry with a
> >> entry ID.
> >
> > Relying on the rule number is a terrible idea (just like 
> > iptables-save|head -n5|tail -n1 would be). Unique persistend IDs are 
> > unfavorable as well; names, as used with xt_quota2/xt_NFACCT can be 
> > remembered much more easily.
> 
> Rule names could serve this, couldn't they?  And rules can be identified
> by -m comment if batch processing is required.

What you propose is hackish. You parse text-based outputs, which is
not the nice way to make things.
