From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables nfacct match question
Date: Mon, 25 Feb 2013 16:48:48 +0100
Message-ID: <20130225154848.GA20609@localhost>
References: <51292D41.8000703@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:26372 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759778Ab3BYPsw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:48:52 -0500
Content-Disposition: inline
In-Reply-To: <51292D41.8000703@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Michael,

On Sat, Feb 23, 2013 at 08:57:37PM +0000, Michael Zintakis wrote:
> As part of my daily job, I am currently trying to expand the
> functionality of the 4 netfilter components dealing with accounting:
> nfacct (executable), nfnetlink_acct (userspace library), nfacct
> (kernel part) and iptables match (kernel+userspace).
> 
> I need to be able to pre-select the number formatting of "bytes" and
> "packets" for each registered nfacct name using additional option in
> the nfacct iptables match (called --nfacct-fmt). Each registered
> nfacct name would have different formatting depending on the amount
> of traffic and also other factors. This formatting is going to be
> used mainly by invoking nfacct (executable) as plain text (in other
> words as "nfacct list").
> 
> What I currently implemented is add an additional property to nfacct
> struct (uint16_t fmt), storing the format to be used for "bytes" and
> "packets" for each registered name. The higher 8 bits of that number
> contain the format to be used for "packets", the lower 8 bits - for
> "bytes".

Could you develop some example usage of your extension?

> I was able to successfully modify the kernel part (nfacct), nfacct
> (the executable) and libnfnetlink_act userspace library to
> accommodate the above change, but I am currently struggling with
> modifying the nfacct match in iptables.
> 
> The problem arises when new nfacct match is used against old version
> of the nfacct iptables match in the kernel. It all stems from
> "struct xt_nfacct_match_info", which I need to expand in order to
> include the new option, but since this struct is part of
> kernel-headers, I am unable to do that, so I thought to ask for a
> bit of advice on this list!
> 
> One possible solution for me is to add a new pair of parse and print
> functions, as well as add another element to the nfacct_match array
> defined in libxt_nfacct.c to accommodate this new functionality and
> then use these newly-defined functions to possibly communicate with
> the kernel part to propagate/retrieve the new uint16_t fmt property
> value via nfnetlink. 
> 
> This approach seems to me a bit overly complex so I thought to ask -
> is this the "usual" way of dealing with such scenarios or is there
> another, simpler (or better) alternative? Thank you!

Yes, this is how our (limited) revision infrastructure works at this
moment.
