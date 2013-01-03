From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nfacct PATCH] Add restore command
Date: Thu, 3 Jan 2013 01:44:20 +0100
Message-ID: <20130103004420.GA31385@1984>
References: <1356596193-2782-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41841 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab3ACAoY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2013 19:44:24 -0500
Content-Disposition: inline
In-Reply-To: <1356596193-2782-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 27, 2012 at 09:16:33AM +0100, Eric Leblond wrote:
> This patch adds a 'restore' command to nfacct commands. It takes
> the output of 'list' command and use it to restore the counters.
> Basically, the user can save the counter with:
>  nfacct list >nfacct.dump
> And restore them with:
>  nfacct restore <nfacct.dump

Thanks a lot, this is good, I was expecting someone to take it and to
add support for that :-).
