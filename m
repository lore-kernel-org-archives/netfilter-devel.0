From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Chain priorities for NAT
Date: Mon, 6 Feb 2017 18:48:26 +0100
Message-ID: <20170206174826.GA18766@salvia>
References: <0d585498cb83fc8b2b03855bf58a5a28.squirrel@postweb.cs.tu-dortmund.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Christoph Pleger <Christoph.Pleger@cs.tu-dortmund.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52426 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751414AbdBFRsb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 12:48:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C0E0B1395DC
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 18:48:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B0422DA809
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 18:48:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 380DEDA807
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 18:48:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <0d585498cb83fc8b2b03855bf58a5a28.squirrel@postweb.cs.tu-dortmund.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 02, 2017 at 01:52:18PM +0100, Christoph Pleger wrote:
> Hello,
> 
> On 2017-01-11, I wrote:
> 
> > The Wiki on https://wiki.nftables.org mentions two priorities
> specifically available for NAT, -100 and 100. But of these two, the
> wiki's example for NAT only uses the value 100 for the postrouting
> chain. The prerouting chain has priority 0, and there is no difference
> between SNAT and DNAT.
> >
> > When I look at the ipv4-nat example which is shipped together with my
> nftables package, both chains use priority -150, though due to the Wiki,
> that value is used for mangling.
> >
> > And when I look at some online-exmaples, they use 0 for prerouting and
> postrouting.
> >
> > So, what are really the best values to use for priority in snat
> prerouting and postrouting and dnat prerouting and postrouting?
> 
> Does "No answer in three weeks" mean that nobody here knows how to use
> these priority values for NAT chains? Though probably netfilter developers
> are reading this list?

Sorry, I overlooked this email.

See nf_ip_hook_priorities:
http://lxr.free-electrons.com/source/include/uapi/linux/netfilter_ipv4.h

See nf_ip6_hook_priorities:
http://lxr.free-electrons.com/source/include/uapi/linux/netfilter_ipv6.h

Yes, I'm pointing to source code, I know I should not be doing this ;-)

Probably we can add the 'default' label, so:

        add chain x y { type filter hook input priority default\; }

In this case, default translates to 0.

        add chain x y { type nat hook prerouting priority default\; }

In this case this would be -100.

Then:

        add chain x y { type nat hook postrouting priority default\; }

This results in priority 100.

We would still need explicit labels though, eg. raw and security at
least. These are special type of filter chains.

Comments welcome. Thanks.
