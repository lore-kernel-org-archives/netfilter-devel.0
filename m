From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd2 suggest
Date: Fri, 13 Jan 2012 15:28:33 +0100
Message-ID: <20120113142833.GA21240@1984>
References: <4F0F6757.8090700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: marty <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37719 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab2AMO2i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:28:38 -0500
Content-Disposition: inline
In-Reply-To: <4F0F6757.8090700@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 12, 2012 at 06:05:59PM -0500, marty wrote:
> Ulogd2 is NOT a prime-time candidate. Never has been.
> The API has been broken a long time.
> Too many issues unresolved.

Bah.

You don't even point to evindences. You don't even specify a
list of reasons why you affirm this or a list of unresolved
issues.

This is completely gratuitous.

> The wise way to fix the endian issues I documented are to use
> host byte order from the very beginning, as per my freely given patch.

Your patch breaks other plugins, I already told you. It's imcomplete.

If you change the endianness of the address, you have to propagate the
changes to other plugins.

[...]
> The database modules NEED to have more options in the config file,
> or a LOT of capabilities are unavailable. This is particular to
> each DBMS or DBI, so those need to be addressed individually.

Stop ranting, send patches.

This is a community project, if you feel something is broken, contribute
it, improve it and fix it, or if you don't know how to make it,
try to convince anyone to get it done. This is how it works.

So far, your overall contribution to the Netfilter project is ZERO
lines of code by now and tons of long emails with lots of complains.

Disregarding others is not the way to go, definitely not.

I'm very upset with your attitute, it's not coollaborative at all.
