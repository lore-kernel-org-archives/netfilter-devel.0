From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd won't start, "can't open multicast server!"
Date: Thu, 10 Jan 2008 00:06:51 +0100
Message-ID: <4785538B.9020609@netfilter.org>
References: <20080104081007.GA30807@swift.blarg.de> <477F94BC.40804@netfilter.org> <20080105172955.GA14295@swift.blarg.de> <47820876.8030204@netfilter.org> <20080107115510.GA22230@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42889 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752935AbYAIXHO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:07:14 -0500
In-Reply-To: <20080107115510.GA22230@swift.blarg.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> Waking up daemons without a reason is sloppy design most of the time.
> A quick look at the conntrackd code made me believe that conntrackd
> just doesn't check when the next scheduled event is due, and instead
> performs a check on all alarm objects in the current step 5 times a
> second.  That is easily fixable, and not only saves CPU cycles and
> power, but also leads to better overall design.

Indeed. This makes a lot sense to me. I have committed a patch to SVN to
wake up the daemon only if there is any alarm event to process instead
of polling. I'll do some testing of it tomorrow.

> The whole alarm.c looks like duplicated effort, you could have used
> libevent instead.

Well, I think that libevent is too much since conntrackd handles not
that many descriptors and the alarm implementation is enough for what
conntrackd needs IMO.

> By the way, I saw an add_alarm() in cache_timer.c, but its callback
> function "timeout()" neither sets a new "expires" value, nor does it
> delete the alarm object.  That may lead to integer underflow in the
> next do_alarm_run() invocation.

I have also changed this since I needed it for the lastest commit.
However, AFAICS such underflow doesn't ever happen in 0.9.5.

>> I'll investigate this. Are you using 0.9.5 or a SVN snapshot? Are
>> you using the `alarm' mode (formely known as `persistent')?
> 
> I am using the most recent release, i.e. 0.9.5.  I have no idea about
> "alarm" or "persistent" mode, and I did not find any documentation on
> this.  I am using the "stats" example configuration from the tarball.

Please, could you check out a working copy from SVN and tell me if the
problem that you're reporting persists?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
