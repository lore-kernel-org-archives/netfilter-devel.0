From: marty <martinbarrowcliff@gmail.com>
Subject: Re: ulogd2 suggest
Date: Fri, 13 Jan 2012 11:39:07 -0500
Message-ID: <4F105E2B.4050400@gmail.com>
References: <4F0F6757.8090700@gmail.com> <20120113142833.GA21240@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55043 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2AMQjK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jan 2012 11:39:10 -0500
Received: by ghbg16 with SMTP id g16so961157ghb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jan 2012 08:39:09 -0800 (PST)
In-Reply-To: <20120113142833.GA21240@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/13/2012 09:28 AM, Pablo Neira Ayuso wrote:
> On Thu, Jan 12, 2012 at 06:05:59PM -0500, marty wrote:
>> Ulogd2 is NOT a prime-time candidate. Never has been.
>> The API has been broken a long time.
>> Too many issues unresolved.
>
> Bah.
>
> You don't even point to evindences. You don't even specify a
> list of reasons why you affirm this or a list of unresolved
> issues.
>
> This is completely gratuitous.
>

1. when ulogd logs to mysql, and a failure occurs, the last
auto_increment value may still contain a previous, used value.
So mysql will hang terminally. Transactions should prevent this.

2. transactions cannot be used in a mysql function, only a procedure.

3. When you call a stored procedure from a function, that puts the sproc 
into the same execution environment as the function, with the same 
restrictions, e.g. transactions don't work.

4. mysql provides a warning but ulogd2 ignores it.
mysql is not logging those warnings but they can be seen on command line

5. You cannot execute a procedure with a select statement.
    Mysql will look for a function, not a procedure.

6. Ulogd is hardwired to use SELECT statements for ALL DBMS in db.c.
So this breaks things and therfor I consider it wrong..

7. All key values, except "addresses" are in host byte order.
This inconsistency is problematic on little endian systems because
it breaks the native math processes for all client applications.

eg: You cannot do a SQL geo_ip lookup with wrong_endian numbers.
Converting a numeric address to host order is not practical in SQL.

8. IPv6 may be important to many, but in fact it is not the standard.
Almost every filter plugin is sprinkled with the same protocol
conversion code. That is redundant.
This can be accommodated on a per-instance basis by a single plugin.
AFAIK this is the only reason for the byte order mess anyway.

>> The wise way to fix the endian issues I documented are to use
>> host byte order from the very beginning, as per my freely given patch.
>
> Your patch breaks other plugins, I already told you. It's imcomplete.

Of course it breaks other plugins and thus incomplete.
I did not design or write ulogd2. I just tried to make it work for me.
I have limited resources and cannot test every available DBMS, or other 
output plugin.

> If you change the endianness of the address, you have to propagate the
> changes to other plugins.

That's exactly the problem!
Ulogd2 uses big-endian addresses on all host architectures,
so all the plugins are affected.
To fix this almost everything needs change, and I can't do that.

>
> [...]
>> The database modules NEED to have more options in the config file,
>> or a LOT of capabilities are unavailable. This is particular to
>> each DBMS or DBI, so those need to be addressed individually.
>
> Stop ranting, send patches.
>
> This is a community project, if you feel something is broken, contribute
> it, improve it and fix it, or if you don't know how to make it,
> try to convince anyone to get it done. This is how it works.

That is what I was trying to do.
I reported the issues clearly and asked for feedback
All I heard was send patches.
I sent a patch because that hack fixed my issue.
All I heard is that it wasn't acceptable, pretty enough, whatever.

I have fixed all my issues, making only 3 minor changes.
True enough, things I don't use are probably broken.
But it works for me.

>
> So far, your overall contribution to the Netfilter project is ZERO
> lines of code by now and tons of long emails with lots of complains.
>
> Disregarding others is not the way to go, definitely not.
>
> I'm very upset with your attitute, it's not coollaborative at all.

Sorry, didn't mean to offend.
Collaboration is not a 1 person act.
Don't expect me to re-write the entire program as a patch.

Marty B.
