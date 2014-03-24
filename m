From: Ansis Atteka <aatteka@nicira.com>
Subject: Re: [PATCH] conntrackd: claim lockfile ownership properly
Date: Mon, 24 Mar 2014 10:37:33 -0700
Message-ID: <CAA=3Oq=3=f5N2st86_t32Bp-2LOEUqtXZPw43VFByZsSZze=TQ@mail.gmail.com>
References: <1394587873-9821-1-git-send-email-aatteka@nicira.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ansis Atteka <aatteka@nicira.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:48829 "HELO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752653AbaCXRov (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Mar 2014 13:44:51 -0400
Received: by mail-yh0-f43.google.com with SMTP id b6so5420325yha.2
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Mar 2014 10:44:49 -0700 (PDT)
In-Reply-To: <1394587873-9821-1-git-send-email-aatteka@nicira.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 11, 2014 at 6:31 PM, Ansis Atteka <aatteka@nicira.com> wrote:
> Before this patch, if conntrackd died in an abrupt manner (either
> by SIGKILL, SIGSEGV or abrupt shutdown), then it would have left
> a stale lock file that would have prevented any new conntrackd
> instances from running.
>
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
>
> Signed-Off-By: Ansis Atteka <aatteka@nicira.com>


Could anyone look into this patch? Unless I am missing something, this
seems like a bug to me that could result into conntrackd not running,
if it was abruptly terminated.

Regards,
Ansis
