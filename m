From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: claim lockfile ownership properly
Date: Tue, 25 Mar 2014 21:58:31 +0100
Message-ID: <20140325205831.GA3681@localhost>
References: <1394587873-9821-1-git-send-email-aatteka@nicira.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ansis Atteka <aatteka@nicira.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54279 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbaCYU6m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:58:42 -0400
Content-Disposition: inline
In-Reply-To: <1394587873-9821-1-git-send-email-aatteka@nicira.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 11, 2014 at 06:31:13PM -0700, Ansis Atteka wrote:
> Before this patch, if conntrackd died in an abrupt manner (either
> by SIGKILL, SIGSEGV or abrupt shutdown), then it would have left
> a stale lock file that would have prevented any new conntrackd
> instances from running.

SIGKILL and SIGSEGV need a closer look from the admin, since things
are not going right. Sudden (abrupt) shutdown is indeed a problem.

> Contrary to abrupt termination, this same bug was not present when
> conntrackd was terminated with a graceful signal (e.g. SIGTERM).
> This was because then the lock file would have been removed from
> the signal handler as expected.
> 
> This patch fixes this bug by using POSIX File Locking API instead
> of opening file in O_EXCL mode. File Locking API ensures that file
> lock will be released once the process holding it terminates (either
> gracefully or abruptly).
> 
> One side effect of this patch is that daemonization has to happen
> before the lock file is locked (due to the fact that child processes
> do not inherit file locks from the parent process).  This means that
> some error messages have to be logged in log file instead of STDOUT.

Can you rework this to avoid converting all those message from stdout
to the log file? I like that this daemon bails out to stdout if early
problems are found, I find it quite annoying when you launch things
and then you have to check ps and log file to see the reason for an
early configuration problem. And I don't find a good reason why we
need an early daemonization that this patch introduces.

