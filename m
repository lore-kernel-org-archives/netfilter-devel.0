From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] xtables: Add a smaller delay option when waiting for
 xtables lock
Date: Tue, 7 Jun 2016 00:56:40 +0200
Message-ID: <20160606225640.GA3118@salvia>
References: <1464914794-21787-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52082 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbcFFW4s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 18:56:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 71E2DCD6F16
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:56:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 55ED69EBA4
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:56:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D79969EBA0
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:56:41 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464914794-21787-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Subash,

Almost there, more comments on this round.

On Thu, Jun 02, 2016 at 06:46:34PM -0600, Subash Abhinov Kasiviswanathan wrote:
> ip[6]tables currently waits for 1 second for the xtables lock to be
> freed if the -w option is used. We have seen that the lock is held
> much less than that resulting in unnecessary delay when trying to
> acquire the lock. This problem is even severe in case of latency
> sensitive applications.
> 
> Introduce a new option 'W' with 10ms granularity (experimentally
> determined) by specifying the delay in [seconds.milliseconds].
> If milliseconds are not specified, the command sleeps for 1 second
> similar to option 'w'.
> 
> v1->v2: Change behavior to take millisecond sleep as an argument to
> -w as suggested by Pablo. Also maintain current behavior for -w to
> sleep for 1 second as mentioned by Liping.
> 
> v2->v3: Move the millisecond behavior to a new option as suggested
> by Pablo.
> 
> Cc: Liping Zhang <zlpnobody@gmail.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
>  iptables/ip6tables.c | 28 +++++++++++++++++++++++++---
>  iptables/iptables.c  | 28 +++++++++++++++++++++++++---
>  iptables/xshared.c   | 27 ++++++++++++++++++++-------
>  iptables/xshared.h   |  2 +-
>  iptables/xtables.c   | 27 +++++++++++++++++++++++++--
>  5 files changed, 96 insertions(+), 16 deletions(-)
> 
> diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
> index 2731209..c0f481f 100644
> --- a/iptables/ip6tables.c
> +++ b/iptables/ip6tables.c
> @@ -103,6 +103,7 @@ static struct option original_opts[] = {
>  	{.name = "out-interface", .has_arg = 1, .val = 'o'},
>  	{.name = "verbose",       .has_arg = 0, .val = 'v'},
>  	{.name = "wait",          .has_arg = 2, .val = 'w'},
> +	{.name = "wait-ms",       .has_arg = 2, .val = 'W'},

OK, so let's summarize what we have after this:

--wait tells us the maximum (global) wait time, default is to retry
every 1 second.

Your proposed --wait-ms allow us to change the default time to retry
(instead of the predefined 1 second wait).

If this description is accurate, then I think --wait-interval is a
better name for this, right?

It would be good to document this in the manpage.

>  	{.name = "exact",         .has_arg = 0, .val = 'x'},
>  	{.name = "version",       .has_arg = 0, .val = 'V'},
>  	{.name = "help",          .has_arg = 2, .val = 'h'},
> @@ -260,6 +261,9 @@ exit_printhelp(const struct xtables_rule_match *matches)
>  "  --table	-t table	table to manipulate (default: `filter')\n"
>  "  --verbose	-v		verbose mode\n"
>  "  --wait	-w [seconds]	wait for the xtables lock\n"
> +"  --wait-ms	-W [seconds.milliseconds]\n"
> +"				wait for the xtables lock\n"
> +"				10ms is the minimum millisecond resolution\n"
>  "  --line-numbers		print line numbers when listing\n"
>  "  --exact	-x		expand numbers (display exact values)\n"
>  /*"[!] --fragment	-f		match second or further fragments only\n"*/
[...]
> @@ -255,12 +259,21 @@ bool xtables_lock(int wait)
>  	while (1) {
>  		if (flock(fd, LOCK_EX | LOCK_NB) == 0)
>  			return true;
> -		else if (wait >= 0 && waited >= wait)
> +		else if (wait >= 0 && waited >= (int)wait && us_waited >= us_wait)
>  			return false;
> -		if (++i % 2 == 0)
> +		if ((++i % 2 == 0 && !us_wait) || (++i % 10 == 0))
>  			fprintf(stderr, "Another app is currently holding the xtables lock; "
> -				"waiting (%ds) for it to exit...\n", waited);
> -		waited++;
> -		sleep(1);
> +				"waiting (%ds %dms) for it to exit...\n", waited, us_waited/1000);
> +		if (us_wait) {
> +			us_waited += BASE_MICROSECOND_WAIT;
> +			usleep(BASE_MICROSECOND_WAIT);
> +			if (us_waited == 1000000) {
> +				waited++;
> +				us_waited = 0;
> +			}
> +		} else {
> +			waited++;
> +			sleep(1);
> +		}

I really think you can simplify this via:

        select(0, NULL, NULL, NULL, &tv);

where tv default is 1 second.

Then, use timersub() to subtract the time --wait-interval we already
waited.
