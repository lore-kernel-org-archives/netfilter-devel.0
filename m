From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfnetlink and conntrack extension question
Date: Wed, 30 Nov 2011 19:09:02 +0100
Message-ID: <20111130180902.GA20336@1984>
References: <1322668453.4443.24.camel@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45397 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1K3SJQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:09:16 -0500
Content-Disposition: inline
In-Reply-To: <1322668453.4443.24.camel@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 30, 2011 at 04:54:13PM +0100, KOVACS Krisztian wrote:
> Dear Netfilter developers,
> 
> We're working on releasing a GPL version of our modular proxy software
> again, this time complete with our custom iptables target and matcher
> modules that implement much of our policy evaluation in iptables. (Think
> something like being able to define sets of rules that are evaluated
> using a best-match algorithm instead of linear evaluation like iptables
> does.)
> 
> The kernel space is obviously under GPL, and we'd be very glad to make
> it as easy to install as possible -- having to apply kernel patches and
> recompile your distro kernel is out of question for most of the
> potential users.
> 
> Unfortunately upstream submission is not really an option, since the
> module itself is very much tied to the userspace and there's really no
> point in having it in the kernel unless you want to use Zorp. (I thought
> a lot about potential use cases without the userspace proxy, but really
> couldn't come up with anything meaningful.)
> 
> There are two things remaining that prevent us doing simple out-of-tree
> kernel module builds:
> 
>      1. We use nfnetlink for the userspace->kernelspace communication.
>         This works beautifully, however, since NFNL_SUBSYS_COUNT is a
>         compile-time constant there's no way of registering a subsystem
>         with an ID not known at compile time.
>      2. Pretty much the same happens with conntrack extensions: we use a
>         conntrack extension to store cached results of policy
>         evaluation. Unfortunatly here we have an NF_CT_EXT_NUM sized
>         static array storing the registered conntrack extensions.
> 
> My question is whether or not removing those limitations and allowing
> runtime registration of both nfnetlink subsystems and conntrack
> extensions would be acceptable upstream? That way out-of-tree modules
> could possibly use those features without having to resort to patching
> and recompiling the kernel.

My opinion: I think that it is hard to justify any sort of change in
mainstream to make life easier to out-of-tree modules.

We want things in mainstream.

P.S: Any chance to integrate your development with nfgrep? I didn't
find any time to release the source code yet. I expect to find some
spare time during the end of year holidays. If I have access to that
GPL code we can think of some sort of integration nfgrep <-> zorp.
