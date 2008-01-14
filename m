From: Max Kellermann <max@duempel.org>
Subject: Re: conntrackd won't start, "can't open multicast server!"
Date: Mon, 14 Jan 2008 10:40:13 +0100
Message-ID: <20080114094012.GA19966@swift.blarg.de>
References: <20080104081007.GA30807@swift.blarg.de> <477F94BC.40804@netfilter.org> <20080105172955.GA14295@swift.blarg.de> <47820876.8030204@netfilter.org> <20080107115510.GA22230@swift.blarg.de> <4785538B.9020609@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [78.31.71.42] ([78.31.71.42]:54610 "HELO duempel.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1752842AbYANJkO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:40:14 -0500
Content-Disposition: inline
In-Reply-To: <4785538B.9020609@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008/01/10 00:06, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Max Kellermann wrote:
> > Waking up daemons without a reason is sloppy design most of the time.
> > A quick look at the conntrackd code made me believe that conntrackd
> > just doesn't check when the next scheduled event is due, and instead
> > performs a check on all alarm objects in the current step 5 times a
> > second.  That is easily fixable, and not only saves CPU cycles and
> > power, but also leads to better overall design.
> 
> Indeed. This makes a lot sense to me. I have committed a patch to SVN to
> wake up the daemon only if there is any alarm event to process instead
> of polling. I'll do some testing of it tomorrow.

Looks much better!

 15 files changed, 103 insertions(+), 208 deletions(-)

Also, the code has become smaller :)

Why did you create separate functions for setting secs and usecs?
(set_alarm_expiration_secs and set_alarm_expiration_usecs); both
functions are not prototyped in a header file.  Why not add something
like this to alarm.h:

 static inline void
 set_alarm_expiration_secs(struct alarm_list *t, long tv_sec, long tv_usec)
 {
     t->tv.tv_sec = tv_sec;
     t->tv.tv_usec = tv_usec;
 }

Since the alarm_list struct is public anyway, this looks more elegant
and creates smaller code.

The function do_alarm_run() assumes that all alarms are sorted by
their due time, but add_alarm() does not enforce this.

I do not understand why you use random() to generate the next alarm
time in sync-alarm.c.

Why do you call INIT_LIST_HEAD() on all alarm_list objects?  For
linux_list.h, that is only required on the sentinel (the global
variable "alarm_list" in this case which is already statically
initalized with the LIST_HEAD macro).

> > The whole alarm.c looks like duplicated effort, you could have used
> > libevent instead.
> 
> Well, I think that libevent is too much since conntrackd handles not
> that many descriptors and the alarm implementation is enough for what
> conntrackd needs IMO.

I tend to use libevent for small projects, too; maybe libowfat is more
appropriate for smaller projects.  That is a matter of taste.

> > I am using the most recent release, i.e. 0.9.5.  I have no idea about
> > "alarm" or "persistent" mode, and I did not find any documentation on
> > this.  I am using the "stats" example configuration from the tarball.
> 
> Please, could you check out a working copy from SVN and tell me if the
> problem that you're reporting persists?

With conntrackd and libnetfilter_conntrack from SVN r7196, the crash
does not occur anymore.  Please tell me as soon as you release both,
so I can update the Debian package.

But have a look at the strace:

 select(6, [4 5], NULL, NULL, {1, 0})    = 0 (Timeout)

After that, it goes into an endless loop of:

 select(6, [4 5], NULL, NULL, {0, 0})    = 0 (Timeout)

This is because select() modifies the timeout value, it contains the
rest time when select() returns.  So timeout is zeroed after the first
select() because it times out, and do_alarm_run() never sets a new
timeout value.

I suggest you pass a NULL timeout when there is no alarm, and ensure
that you always set the correct next_alarm value in do_alarm_run().

Max


