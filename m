From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd's SQLITE3 "buffer" option
Date: Wed, 30 Dec 2015 01:19:05 +0100
Message-ID: <20151230001905.GA1700@salvia>
References: <20151229183831.0ff29890@alex-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	eric@regit.org
To: Alex Xu <alex_y_xu@yahoo.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45526 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbbL3ATQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Dec 2015 19:19:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D57FE1022B7
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 01:19:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C66F0DA814
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 01:19:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1FD72DA801
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 01:19:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151229183831.0ff29890@alex-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 29, 2015 at 06:38:31PM -0500, Alex Xu wrote:
> I was attempting to configure sqlite3 output in ulogd and could not
> determine the function of the "buffer" configuration option.
> 
> $ grep buffer output/sqlite3/ulogd_output_sqlite3.c
>         int buffer_size;
>         int buffer_curr;
>                         .key = "buffer",
> #define buffer_ce(pi)   (pi)->config_kset->ces[2].u.value
>                 priv->buffer_curr++;
>         /* initialize our buffer size and counter */
>         priv->buffer_size = buffer_ce(pi);
>         priv->buffer_curr = 0;
> $ grep -rF buffer_curr .
> output/sqlite3/ulogd_output_SQLITE3.c:  int buffer_curr;
> output/sqlite3/ulogd_output_SQLITE3.c:          priv->buffer_curr++;
> output/sqlite3/ulogd_output_SQLITE3.c:  priv->buffer_curr = 0;
> 
> Now, it is quite likely that I am missing something, but it would
> appear that buffer_curr is never actually *read*, only *written*,
> and it's a basic fact of programming that a variable can have no effect
> if it is never read from. [citation needed]
> 
> It would appear that the original code in ulogd-1.x employed a 'buffer'
> which was actually a counter for when to tell sqlite to sync to disk.
> When the code was rewritten by "Holger" and committed by Pablo Neira
> Ayuso (8f7bb61), the syncing part was removed but the buffer variable
> was simply renamed.
> 
> Nobody noticed because one fsync every few seconds is tiny.
> 
> Therefore, I think we should remove the "buffer" option entirely.
> 
> Thoughts? I will send a patch if there are no objections.

This may be well a leftover that was introduced by when that large
rewrite took, please submit a patch that we can review.

I'm also Cc'ing Eric Leblond, he maintains ulogd2, just in case he
finds some cycles to confirm this issue.

Thanks for reporting.
