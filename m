From: Pierre Chifflier <chifflier@wzdftpd.net>
Subject: Re: ulogd2 suggest
Date: Fri, 13 Jan 2012 08:40:29 +0100
Message-ID: <20120113074029.GA32629@mail.wzdftpd.net>
References: <4F0F6757.8090700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: marty <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.wzdftpd.net ([91.121.80.151]:56743 "EHLO mail.wzdftpd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab2AMHtj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jan 2012 02:49:39 -0500
Content-Disposition: inline
In-Reply-To: <4F0F6757.8090700@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 12, 2012 at 06:05:59PM -0500, marty wrote:
> Ulogd2 is NOT a prime-time candidate. Never has been.
> The API has been broken a long time.
> Too many issues unresolved.
> 
> The wise way to fix the endian issues I documented are to use
> host byte order from the very beginning, as per my freely given patch.
> That leaves all math options open.
> That patch is absolutely correct. Won't break the core design.
> 
> NOW, to provide endian conversion simply write a tiny filter module
> that does endian conversion of addresses. Duh! How hard could that be?
> Then the user can add that mod to stack as needed for an instance,
> but it is not global and he can still enjoy both formats.
> Gaa, how simple can it get?
> 
> Then of course remove every line in every other module that changes
> byte order. That is totally inconsistent behavior and wrong.
> 
> Likewise IPV6 is NOT the default protocol yet so any and ALL IPv6
> conversions need to be done by a single module the user can add to
> the stack only when/where desired.
> It is stupid and redundant to hardwire that into every module.
> Get that out of the other modules and into a single filter.
> 
> The database modules NEED to have more options in the config file,
> or a LOT of capabilities are unavailable. This is particular to
> each DBMS or DBI, so those need to be addressed individually.
> 
> After that we should have a much more logical API to work with.
> 
> I dare you to tell me I am wrong.
> 

Hi,

[I'm slowly getting back to the subject)

ulogd2 is not wrong, mysql is the cause of the problem: it does not
provide any way to store IP addresses.
You can store them as integers, but that will only work for IPv4. Using
big-endian is only a workaround to avoid some conversions during a query
- you can also change the procedures for insertions, that will give the
  same result (though I agree byte swapping in SQL is really ugly).
If you want a good way to store IP addresses, use PostgreSQL, it
provides the type inet_addr which allows subnet queries, IPv6/IPv4
handling etc.

That said, I'm not against the idea of controlling the byte order or the
IPv6 conversion.
Adding some options to output modules may be a solution (or do we have
something more generic ?).

Regards,
Pierre
