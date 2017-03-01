From: Florian Westphal <fw@strlen.de>
Subject: Re: nft authentication
Date: Wed, 1 Mar 2017 09:41:15 +0100
Message-ID: <20170301084115.GB24798@breakpoint.cc>
References: <e7b26751-8914-e32e-0760-c300bf217b50@students.fh-hagenberg.at>
 <20170228232451.GA24798@breakpoint.cc>
 <79f454c1-a8ef-5043-35f5-90d83447dc83@students.fh-hagenberg.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Fabian Franz <s1410239008@students.fh-hagenberg.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37616 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750988AbdCAImo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 03:42:44 -0500
Content-Disposition: inline
In-Reply-To: <79f454c1-a8ef-5043-35f5-90d83447dc83@students.fh-hagenberg.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Franz <s1410239008@students.fh-hagenberg.at> wrote:
> yes it is academic and what I want to do is user id matching on
> non-local users (which means I need to connect the IP address with an
> user id or something like that). What I want is to keep the full match
> together, nf_queue is a target.

I'm not sure what 'keep the full match together' is supposed to mean.

> It should be my last year project but it seems to be impossible to
> finalize due to a lack of documentation. An alternative Method would be
> keeping an array of structs with IP addresses and user IDs in the kernel
> and use those.

That seems like the only solution, what did you have in mind instead?

> Stack now 0 1
> Cleanup: popping nterm input (: )
> <cmdline>:1:28-31: Error: No symbol type information
> add rule inet filter input auth 1 accept
> created using this command:
> 
> nft --debug all add rule inet filter input auth 1 accept
>
> I hope this helps you to understand the error.

It looks like you haven't extended nft parser yet.
You need to extend both libnftnl and nft.

Have a look at

commit dfd92948a0a88a9f245e71c1cfb63ae670e6e7c1
rt: introduce routing expression

in nftables.git for an example.

