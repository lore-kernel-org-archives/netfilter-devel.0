From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] ebtables: Allow RETURN target rules in user defined
 chains
Date: Wed, 28 Oct 2015 02:01:55 +0100
Message-ID: <20151028010155.GD9420@breakpoint.cc>
References: <5628F57F.1010504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alin Nastac <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56253 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754008AbbJ1BB6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Oct 2015 21:01:58 -0400
Content-Disposition: inline
In-Reply-To: <5628F57F.1010504@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alin Nastac <alin.nastac@gmail.com> wrote:
> ebtables has a bug that prevents creation of rules with RETURN target, any attempt will result in an
>    RETURN not allowed on base chain
> error even if the chain where you want to create the rule is a user defined chain.
> 
> Reproduction scenario:
>    root@OpenWrt:~# ebtables -N foo
>    root@OpenWrt:~# ebtables -A OUTPUT -j foo
>    root@OpenWrt:~# ebtables -A foo -j mark --mark-or 3 --mark-target RETURN
>    --mark-target RETURN not allowed on base chain.
> 
> My email client will probably replace tabs in the patch below, but

Yes, I applied this manually (with minor edits to commit message).

Thanks.
