From: Max Kellermann <max@duempel.org>
Subject: Re: conntrackd won't start, "can't open multicast server!"
Date: Mon, 7 Jan 2008 12:55:10 +0100
Message-ID: <20080107115510.GA22230@swift.blarg.de>
References: <20080104081007.GA30807@swift.blarg.de> <477F94BC.40804@netfilter.org> <20080105172955.GA14295@swift.blarg.de> <47820876.8030204@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [78.31.71.42] ([78.31.71.42]:33829 "HELO duempel.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1754286AbYAGLzM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:55:12 -0500
Content-Disposition: inline
In-Reply-To: <47820876.8030204@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008/01/07 12:09, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The conntrackd page wasn't available in 0.9.5, but it will in 0.9.6.
> It's impossible that we can bundle something to a package when it
> didn't exist at that time :)

Ah, so the manual page on the project home page is from an unreleased
version.

> > I noticed conntrackd runs select() with a 200ms timeout, i.e. it wakes
> > up 5 times a second only to see that there is nothing to do.  Why
> > that?  This leads to increased power consumption for no good.
> 
> I have implemented alarms based on times slices so I use select to wake
> up expired alarms once the slice has been consumed. Are you really
> observing this power consumption increment?

We can argue about whether fixing just conntrackd would be measurable,
but it's yet another daemon who is polling when he could better wait
for real events.  Let's fix all of them, and enjoy a tickless system
which lets the CPU sleep until there is real work to do.

Waking up daemons without a reason is sloppy design most of the time.
A quick look at the conntrackd code made me believe that conntrackd
just doesn't check when the next scheduled event is due, and instead
performs a check on all alarm objects in the current step 5 times a
second.  That is easily fixable, and not only saves CPU cycles and
power, but also leads to better overall design.

The whole alarm.c looks like duplicated effort, you could have used
libevent instead.

By the way, I saw an add_alarm() in cache_timer.c, but its callback
function "timeout()" neither sets a new "expires" value, nor does it
delete the alarm object.  That may lead to integer underflow in the
next do_alarm_run() invocation.

> I'll investigate this. Are you using 0.9.5 or a SVN snapshot? Are
> you using the `alarm' mode (formely known as `persistent')?

I am using the most recent release, i.e. 0.9.5.  I have no idea about
"alarm" or "persistent" mode, and I did not find any documentation on
this.  I am using the "stats" example configuration from the tarball.

Max
