From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] nftables: reverse path filtering for nft
Date: Thu, 15 Sep 2016 00:00:49 +0200
Message-ID: <20160914220049.GC4925@breakpoint.cc>
References: <20160910200102.GA11377@breakpoint.cc>
 <20160912120437.GA9323@salvia>
 <20160912122107.GB27566@breakpoint.cc>
 <20160912185228.GA10862@salvia>
 <20160912190025.GB11685@breakpoint.cc>
 <20160912191438.GA11229@salvia>
 <20160914174515.GA4925@breakpoint.cc>
 <CAOkSjBheup7MmfT74FF0ZE3irCf=7OFGL5acWfMen5dkxvOy8Q@mail.gmail.com>
 <20160914211340.GB4925@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40754 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1762024AbcINWAx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Sep 2016 18:00:53 -0400
Content-Disposition: inline
In-Reply-To: <20160914211340.GB4925@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Yet another option:
> 
> FIB     fib_type     fib_family   fib_key_flags	fib_addr
> 
> Which is not ambiguous anymore as either saddr or daddr will terminate
> the statement.  We'd have to remove the saddr option but I don't think its a
> problem (the iptables rpfilter modules set flowi.saddr if packet daddr
> is unicast address).
> 
> Would give following syntax :
> 
> fib oif mark saddr
> fib oif saddr
> fib oif mark,oif daddr

But also
fib oif oif saddr

Yuck.
