From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: claim lockfile ownership properly
Date: Tue, 25 Mar 2014 22:05:28 +0100
Message-ID: <20140325210528.GA3780@localhost>
References: <1394587873-9821-1-git-send-email-aatteka@nicira.com>
 <20140325205831.GA3681@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ansis Atteka <aatteka@nicira.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55304 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882AbaCYVFd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:05:33 -0400
Content-Disposition: inline
In-Reply-To: <20140325205831.GA3681@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 25, 2014 at 09:58:31PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 11, 2014 at 06:31:13PM -0700, Ansis Atteka wrote:
> > Before this patch, if conntrackd died in an abrupt manner (either
> > by SIGKILL, SIGSEGV or abrupt shutdown), then it would have left
> > a stale lock file that would have prevented any new conntrackd
> > instances from running.
> 
> SIGKILL and SIGSEGV need a closer look from the admin, since things
> are not going right. Sudden (abrupt) shutdown is indeed a problem.
> 
> > Contrary to abrupt termination, this same bug was not present when
> > conntrackd was terminated with a graceful signal (e.g. SIGTERM).
> > This was because then the lock file would have been removed from
> > the signal handler as expected.
> > 
> > This patch fixes this bug by using POSIX File Locking API instead
> > of opening file in O_EXCL mode. File Locking API ensures that file
> > lock will be released once the process holding it terminates (either
> > gracefully or abruptly).
> > 
> > One side effect of this patch is that daemonization has to happen
> > before the lock file is locked (due to the fact that child processes
> > do not inherit file locks from the parent process).  This means that
> > some error messages have to be logged in log file instead of STDOUT.
> 
> Can you rework this to avoid converting all those message from stdout
> to the log file? I like that this daemon bails out to stdout if early
> problems are found, I find it quite annoying when you launch things
> and then you have to check ps and log file to see the reason for an
> early configuration problem. And I don't find a good reason why we
> need an early daemonization that this patch introduces.

Now I noticed after reading my own words, this can be problematic if
someone just types 'conntrackd' by mistake instead of 'conntrackd -e'
to dump the external cache.

What about using two locks? I mean, one that is grabbed when the
process is in non-daemon stage, then another one once one it enters
daemon stage. I think that should help to workaround the posix file
locking limitation which doesn't allow us to inherit lock file?
