From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] ipset: allow a 0 netmask with hash_netiface type
Date: Wed, 13 Jan 2016 14:07:02 +0100
Message-ID: <20160113130702.GA19398@salvia>
References: <1452614825-19749-1-git-send-email-fw@strlen.de>
 <alpine.DEB.2.10.1601130933320.22698@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39417 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932631AbcAMNHG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 08:07:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B18A2FB459
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 14:07:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9F9D3DA814
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 14:07:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5C4B8DA801
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 14:07:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1601130933320.22698@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 13, 2016 at 09:35:02AM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please apply the patch to the nf tree, thanks!
> 
> On Tue, 12 Jan 2016, Florian Westphal wrote:
> 
> > Jozsef says:
> >  The correct behaviour is that if we have
> >  ipset create test1 hash:net,iface
> >  ipset add test1 0.0.0.0/0,eth0
> >  iptables -A INPUT -m set --match-set test1 src,src
> > 
> >  then the rule should match for any traffic coming in through eth0.
> > 
> > This removes the -EINVAL runtime test to make matching work
> > in case packet arrived via the specified interface.
> > 
> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1297092
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Applied, thanks!

This applies cleanly to 4.3 and 4.4, so will be requesting -stable for
these two.
