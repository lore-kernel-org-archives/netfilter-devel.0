From: Max Kellermann <max@duempel.org>
Subject: conntrackd: questions about the new alarm implementation
Date: Mon, 21 Jan 2008 07:20:59 +0100
Message-ID: <20080121062059.GA3995@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:38418 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752324AbYAUGVB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 01:21:01 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

I have had a look at your new alarm.c.  I have a few questions about
it:

- Please explain why you now have 2048 (!) alarm queues, where the
  correct one is determined by hashing the alarm struct.  I fail to
  imagine how this hashing might be useful.  I can only see that it
  makes the code more complex and 2048 times slower - except for
  add_alarm(), which becomes a little bit faster, but there are only
  few add_alarm() invocations compared with get_next_alarm_run() and
  do_alarm_run().

- __run() is again bugged regarding due alarms: when an alarm is due,
  all readied file descriptors are ignored (l 193).  This is
  automatically recovered in the next select() call, so you didn't
  notice it.  Why do you keep screwing up this piece of code over and
  over? ;-)

- why this overcomplicated new __run() prototype with an int pointer
  parameter?  Its returned value is never used.  Its input value is
  only used to set next_alarm to NULL - why not just pass NULL as
  next_alarm in the first place (my patches did exactly that)?  Why
  does __run() have a return value?

Max

