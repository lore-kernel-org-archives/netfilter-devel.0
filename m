From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] libiptc: don't set_changed() when checking rules with
 module jumps
Date: Tue, 28 Feb 2017 13:18:53 +0100
Message-ID: <20170228121853.GA20563@salvia>
References: <1487960119.27698.11.camel@redhat.com>
 <1487960755.27698.15.camel@redhat.com>
 <1488081723.31061.5.camel@redhat.com>
 <20170228113312.GA19580@salvia>
 <20170228120307.GA6834@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Dan Williams <dcbw@redhat.com>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46240 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752010AbdB1MUQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 07:20:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5A7601AAB1B
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 13:18:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49B24DA80B
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 13:18:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C63EDA7E0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 13:18:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170228120307.GA6834@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 28, 2017 at 01:03:07PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sat, Feb 25, 2017 at 10:02:03PM -0600, Dan Williams wrote:
> > > Checking a rule that includes a jump to a module-based target currently
> > > sets the "changed" flag on the handle, which then causes TC_COMMIT() to
> > > run through the whole SO_SET_REPLACE/SO_SET_ADD_COUNTERS path.  This
> > > seems wrong for simply checking rules, an operation which is documented
> > > as "...does not alter the existing iptables configuration..." but yet
> > > it clearly could do so.
> > > 
> > > Fix that by ensuring that rule check operations for module targets
> > > don't set the changed flag, and thus exit early from TC_COMMIT().
> > 
> > Thanks for explaining. How are you hitting this problem? I'm curious
> > to see if I can reproduce it.
> 
> Its easy to reproduce.
> 
> iptables -t nat -o lo -A POSTROUTING -s 10.2.3.4 -j MASQUERADE
> iptables -t nat -o lo -C POSTROUTING -s 10.2.3.4 -j MASQUERADE
> 
> you should see (via strace) that 2nd command also issues the iptables
> setsockopt calls.

Thanks for explain. Applied, thanks.
