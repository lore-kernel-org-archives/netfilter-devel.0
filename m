From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd2 suggest
Date: Fri, 13 Jan 2012 21:14:56 +0100
Message-ID: <20120113201456.GA23488@1984>
References: <4F0F6757.8090700@gmail.com>
 <20120113142833.GA21240@1984>
 <4F105E2B.4050400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: marty <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47133 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694Ab2AMUPD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jan 2012 15:15:03 -0500
Content-Disposition: inline
In-Reply-To: <4F105E2B.4050400@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 13, 2012 at 11:39:07AM -0500, marty wrote:
> >You don't even point to evindences. You don't even specify a
> >list of reasons why you affirm this or a list of unresolved
> >issues.
> >
> >This is completely gratuitous.
> 
> 1. when ulogd logs to mysql, and a failure occurs, the last
> auto_increment value may still contain a previous, used value.
> So mysql will hang terminally. Transactions should prevent this.
>
> 2. transactions cannot be used in a mysql function, only a procedure.
> 
> 3. When you call a stored procedure from a function, that puts the
> sproc into the same execution environment as the function, with the
> same restrictions, e.g. transactions don't work.
> 
> 4. mysql provides a warning but ulogd2 ignores it.
> mysql is not logging those warnings but they can be seen on command line
> 
> 5. You cannot execute a procedure with a select statement.
>    Mysql will look for a function, not a procedure.
> 
> 6. Ulogd is hardwired to use SELECT statements for ALL DBMS in db.c.
> So this breaks things and therfor I consider it wrong..
> 
> 7. All key values, except "addresses" are in host byte order.
> This inconsistency is problematic on little endian systems because
> it breaks the native math processes for all client applications.
> 
> eg: You cannot do a SQL geo_ip lookup with wrong_endian numbers.
> Converting a numeric address to host order is not practical in SQL.
> 
> 8. IPv6 may be important to many, but in fact it is not the standard.
> Almost every filter plugin is sprinkled with the same protocol
> conversion code. That is redundant.
> This can be accommodated on a per-instance basis by a single plugin.
> AFAIK this is the only reason for the byte order mess anyway.

Bah.

You're asking for enhancements for ulogd2's mysql plugin.

However, you decided to start your email telling that ulogd2 (which
can make *way more things than logging to mysql*) is broken because
the current mysql support doesn't fit your needs.

[...]
> >If you change the endianness of the address, you have to propagate the
> >changes to other plugins.
> 
> That's exactly the problem!
> Ulogd2 uses big-endian addresses on all host architectures,
> so all the plugins are affected.
> To fix this almost everything needs change, and I can't do that.

[...]
> I have fixed all my issues, making only 3 minor changes.
> True enough, things I don't use are probably broken.
> But it works for me.

This comment shows that you know nothing about how Free/OpenSource
community projects work.

You just want to grab the software and provide ZERO return to the
existing codebase. Very sad.

Please, stop trolling us.
