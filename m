From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH 2/4] don't ignore fd events when an alarm is due
Date: Mon, 21 Jan 2008 15:09:30 +0100
Message-ID: <20080121140930.GA2455@swift.blarg.de>
References: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag> <20080121082958.27612.37473.stgit@rabbit.intern.cm-ag> <47949AA4.9070000@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:50260 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752746AbYAUOJc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 09:09:32 -0500
Content-Disposition: inline
In-Reply-To: <47949AA4.9070000@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008/01/21 14:14, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Max Kellermann wrote:
> > also, pass &next_alarm to __run() only if there is an alarm; eliminate
> > the "timeout" parameter; the alarm functions get_next_alarm_run() and
> > do_alarm_run() return an timeval pointer instead of a boolean.
> 
> Hm, this patch makes my CPU suck up after the first alarm run.

Damn.  I forgot a "!".

commit 02683a053a26e142e8067b0e884ff5c49af908d4
Author: Max Kellermann <max@duempel.org>
Date:   Mon Jan 21 15:13:38 2008 +0100

    added "!" before timerisset(next)

diff --git a/src/run.c b/src/run.c
index 718e63c..fe57858 100644
--- a/src/run.c
+++ b/src/run.c
@@ -237,7 +237,7 @@ run(void)
 
 	while(1) {
 		sigprocmask(SIG_BLOCK, &STATE(block), NULL);
-		if (next != NULL && timerisset(next))
+		if (next != NULL && !timerisset(next))
 			next = do_alarm_run(&next_alarm);
 		else
 			next = get_next_alarm_run(&next_alarm);
