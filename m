From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nftables: add connlabel set
 support
Date: Wed, 16 Mar 2016 14:18:53 +0100
Message-ID: <20160316131853.GB28195@salvia>
References: <1458058211-11147-1-git-send-email-fw@strlen.de>
 <1458058211-11147-2-git-send-email-fw@strlen.de>
 <20160315170813.GA25284@salvia>
 <20160315230921.GD8185@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56636 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965315AbcCPNTB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2016 09:19:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 944DA4B111
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 14:19:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 71CFFDA39C
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 14:19:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5B398DA386
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 14:18:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160315230921.GD8185@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 16, 2016 at 12:09:21AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Mar 15, 2016 at 05:10:09PM +0100, Florian Westphal wrote:
> > > Instead of taking the value to set from a source register, userspace
> > > passes the bit that we should set as a netlink attribute.
> > > 
> > > This follows a similar approach that xtables 'connlabel'
> > > match uses, so when user inputs
> > > 
> > >     ct label set bar
> > 
> > I think we can introduce:
> > 
> >         ct label bitset bar
> > 
> > so this is clear to the user this is just setting the bit at that
> > position.
> 
> I don't like this one bit ;)
> 
> Seriously, I think "label set bar" is fine.
> 
> We already treat "ct label foo" correctly without
> using "ct label testbit foo", so I like it better
> without the extra special-case "bitset" keyword.

OK, I don't have a strong opinion on the connlabel usecase, so let's
stick to 'label set bar'.
