From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd won't start, "can't open multicast server!"
Date: Mon, 14 Jan 2008 16:41:51 +0100
Message-ID: <478B82BF.30105@netfilter.org>
References: <20080104081007.GA30807@swift.blarg.de> <477F94BC.40804@netfilter.org> <20080105172955.GA14295@swift.blarg.de> <47820876.8030204@netfilter.org> <20080107115510.GA22230@swift.blarg.de> <4785538B.9020609@netfilter.org> <20080114094012.GA19966@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45181 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbYANPmV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:42:21 -0500
In-Reply-To: <20080114094012.GA19966@swift.blarg.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> Why did you create separate functions for setting secs and usecs?
> (set_alarm_expiration_secs and set_alarm_expiration_usecs); both
> functions are not prototyped in a header file.  Why not add something
> like this to alarm.h:
> 
>  static inline void
>  set_alarm_expiration_secs(struct alarm_list *t, long tv_sec, long tv_usec)
>  {
>      t->tv.tv_sec = tv_sec;
>      t->tv.tv_usec = tv_usec;
>  }
> 
> Since the alarm_list struct is public anyway, this looks more elegant
> and creates smaller code.

I have changed this. Thanks for the suggestion. I'd appreciate patches
for this sort of cleanups.

> The function do_alarm_run() assumes that all alarms are sorted by
> their due time, but add_alarm() does not enforce this.

Hm, add_alarm() always inserts new alarms at the end of the alarm list,
so the list is sorted by their due time AFAICS.

> I do not understand why you use random() to generate the next alarm
> time in sync-alarm.c.

This is part of the alarm-based synchronization approach. We send a
synchronization message which talks about a conntrack entry each
random(RefreshTime) seconds. This approach is, of course, spamming and
CPU consuming but is simple and it resolves very well inconsistent
situations among several replicas. The FTFW synchronization approach
uses an ACK/NACK based protocol which requires less resources.

> Why do you call INIT_LIST_HEAD() on all alarm_list objects?  For
> linux_list.h, that is only required on the sentinel (the global
> variable "alarm_list" in this case which is already statically
> initalized with the LIST_HEAD macro).

Indeed, I have removed them.

>>> I am using the most recent release, i.e. 0.9.5.  I have no idea about
>>> "alarm" or "persistent" mode, and I did not find any documentation on
>>> this.  I am using the "stats" example configuration from the tarball.
>> Please, could you check out a working copy from SVN and tell me if the
>> problem that you're reporting persists?
> 
> With conntrackd and libnetfilter_conntrack from SVN r7196, the crash
> does not occur anymore.  Please tell me as soon as you release both,
> so I can update the Debian package.
> 
> But have a look at the strace:
> 
>  select(6, [4 5], NULL, NULL, {1, 0})    = 0 (Timeout)
> 
> After that, it goes into an endless loop of:
> 
>  select(6, [4 5], NULL, NULL, {0, 0})    = 0 (Timeout)
> 
> This is because select() modifies the timeout value, it contains the
> rest time when select() returns.  So timeout is zeroed after the first
> select() because it times out, and do_alarm_run() never sets a new
> timeout value.
> 
> I suggest you pass a NULL timeout when there is no alarm, and ensure
> that you always set the correct next_alarm value in do_alarm_run().

Fixed in SVN. Moreover, I have removed the ugly 1 sec wait start in the
run() loop. Thanks for catching up this issue. As soon as we finish with
this discussion, I plan to pass it to testing stage and then release a
new version.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
