From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Revert "netfilter: ensure number of counters is >0 in
 do_replace()"
Date: Mon, 1 Jun 2015 19:47:33 +0200
Message-ID: <20150601174733.GA3225@salvia>
References: <1432801578-11970-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54657 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbbFARmZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jun 2015 13:42:25 -0400
Content-Disposition: inline
In-Reply-To: <1432801578-11970-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 28, 2015 at 10:26:18AM +0200, Bernhard Thaler wrote:
> This partially reverts commit 1086bbe97a07 ("netfilter: ensure number of
> counters is >0 in do_replace()") in net/bridge/netfilter/ebtables.c.
> 
> Setting rules with ebtables does not work any more with 1086bbe97a07 place.
> 
> There is an error message and no rules set in the end.
> 
> e.g.
> 
> ~# ebtables -t nat -A POSTROUTING --src 12:34:56:78:9a:bc -j DROP
> Unable to update the kernel. Two possible causes:
> 1. Multiple ebtables programs were executing simultaneously. The ebtables
>    userspace tool doesn't by default support multiple ebtables programs
> running
> 
> Reverting the ebtables part of 1086bbe97a07 makes this work again.

Applied, thanks Bernhard!

