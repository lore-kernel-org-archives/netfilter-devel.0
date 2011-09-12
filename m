From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack (nf_conn) locking question
Date: Mon, 12 Sep 2011 10:45:57 +0200
Message-ID: <20110912084557.GA2080@1984>
References: <CAOAcFN-fXwCrtDu1snSAH-O5ud92bcBS4Dh8fR2m38pc=5hbTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Gidon Miller <gmiller@vasonanetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34707 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab1ILIp7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 04:45:59 -0400
Content-Disposition: inline
In-Reply-To: <CAOAcFN-fXwCrtDu1snSAH-O5ud92bcBS4Dh8fR2m38pc=5hbTA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 08, 2011 at 11:12:53AM +0300, Gidon Miller wrote:
> Hi,
> I hope I'm posting this question to the correct list. if not please
> let me know where I should be posting.
> 
> I'm writing a kernel module (against 2.6.32) to add functionality to
> conntrack to maintain extra state information for certain tcp
> connections.

Better use one ct extension.

> the way I'm doing this is by unregistering the l4proto handler for tcp
> on module load and registering my own handler struct which is the same
> except for the new(), destroy(), packet() and print_conntrack()
> functions. my functions call the original tcp handler functions and
> then perform some of their own logic - they change the ct->mark to
> hold an id used to reference a table of "my" connection info (that
> holds my state and other data). I also have xtables matcher and target
> modules that reference this conntrack info and do some logic
> accordingly.
> therefore I'd like to protect my data and the nf_conn data while in my
> handler functions.
> 
> this raises a few questions:
> 1. I see that xtables modules (such as xt_CONNMARK and xt_state) do
> not take the ct->lock. what protects the ct entry in this case?
> 2. since I cant take the ct->lock in my functions (because they call
> the tcp functions who take the lock) its not clear to me how to
> protect my data. in general, is my approach the correct one?

The ct->lock is only used if you modify the internal TCP data for that
ct flow, like it happens in the nf_conntrack_tcp code.
