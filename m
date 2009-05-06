From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: flow start_time
Date: Wed, 06 May 2009 15:07:32 +0400
Message-ID: <4A016F74.6050601@msgid.tls.msk.ru>
References: <49F08A19.6010909@msgid.tls.msk.ru> <4A0045E8.1000508@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([81.13.33.159]:41272 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbZEFLHg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 May 2009 07:07:36 -0400
In-Reply-To: <4A0045E8.1000508@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Michael Tokarev wrote:
>> Hello.
>>
>> Right now I'm evaluating various ways to perform traffic accounting
>> in Linux.  Nowadays solutions are all based on netfilter and packet
>> queuing over netlink interface.  And most tools used for that sort
>> of stuff are based on Cisco "flows".  So far so good.
>>
>> There are several tools available to perform logging of various
>> statistics which are being logging over netlink, including the
>> successor of ulogd.  But all the tools I've seen so far perform
>> "flow management" in userspace in addition to all the housekeeping
>> the kernel already does - namely, mixing-n-matching various
>> conntrack entries together, keeping/managing hash tables of
>> various (src_IP, dst_IP, src_port, dst_port etc) stuff.
>>
>> For flow-based accounting (compatible with cisco netflows I mean)
>> this all is only to get one field of the flow structure: it's
>> the start_time, i.e., in terms of conntrack, it's the time when
>> the conntrack entry were created.
>>
>> But isn't it a bit excessive to duplicate all the (quite heavy
>> and fast-changing) data structures in both kernel- and user-space?
>> I mean, at least for the "industry standard" format, the one
>> missing field can be kept by kernel, especially since there,
>> it costs only extra 4 bytes, and zero CPU, while in duplicating
>> the whole thing in user space is something entirely else?
> 
> I think its done for aggregation, but not sure. And we used
> to have 32bit counters for a while, so userspace needed to
> track overflows.

Aggregation is nice when needed.  Most tools that deals with
netflows does their own aggregation later, probably after some
filtering and probably on another hardware.

As for counters, they're 64bits now, so should be fine.

[]
>> So, are there any objections/comments/suggestions about just
>> adding this one thing (conditionally using CONFIG_foo or not)?
>> Or maybe it is already there and there's nothing to do?
> 
> How are you going to log the data of a connection thats removed
> from the conntrack tables without using netlink? If you're using
> netlink, you can generate a time stamp when you receive a NEW
> event.

In case either "new" or "remove" event is missing now, that connection
can't be logged properly, because we don't see some part of the
info in either of the two cases.

For nowadays tools, in case we've seen "new" but not "remove" event,
that connection will be in our hash table sorta forever (ok, till
restart).  Which is, I think, worse than not logging it at all (it
will not be logged anyway).

Basically, I don't see such a case (lost "remove" event) as valid.

But what I do see is: if our accounting tool were started long
time after system startup and when some connections are already
established, that tool will not know the actual start time --
the tool can force all current entries to be sent over netlink
again to catch up, but all that will be with current timestamp
obviously, since kernel does not keep that info now.

And there's one more interesting thing, too.

Suppose our tool gets restarted somehow.  Currently, it's forced
to write down all its current connections as if they were all
suddenly finished, and after restart there will be a bunch of
"new" connections -- all the same as just logged as "finished".
With the suggested approach, we don't need to care about that,
since we only interested in really finished connections, kernel
keeps track of the start time for us.  Sure we still can do our
own timekeeping as before -- for example, to force "daily" stats
at midnight even for connections which are still established.

Thanks.

/mjt
