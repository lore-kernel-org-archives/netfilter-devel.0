From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] xtables: Add a smaller delay option when waiting for
 xtables lock
Date: Fri, 20 May 2016 12:14:46 +0200
Message-ID: <20160520101446.GA8771@salvia>
References: <1462504699-14988-1-git-send-email-subashab@codeaurora.org>
 <20160509214044.GA23794@salvia>
 <8502fe32e83f67c567d4fadeb6c479f4@codeaurora.org>
 <20160517104152.GA3354@salvia>
 <736e561105702835e5cedea5e3ed18b7@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: subashab@codeaurora.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45517 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbcETKOx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2016 06:14:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EFC72EAA75
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 12:14:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DEA1615D623
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 12:14:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B60C011C38B
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 12:14:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <736e561105702835e5cedea5e3ed18b7@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 17, 2016 at 12:25:53PM -0600, subashab@codeaurora.org wrote:
> >>iptables -w 2.1
> >>
> >>0.01s sleep, retry
> >>0.02s sleep, retry
> >>0.03s sleep, retry
> >>...
> >>2.1s sleep, exit
> >>
> >>Note that it sleeps for 10ms and retries rather than sleeping for a
> >>single
> >>iteration for 2.1s seconds and then retrying.
> >>
> >>Let me know if there are any concerns with this.
> >
> >But this is changing the existing behaviour, right? My understanding
> >is that -w indicates the net wait time for each try.
> 
> Hi Pablo
> 
> Currently, each wait time is 1 second. -w is the overall time upto which it
> has to wait.
> 
> bool xtables_lock(int wait)
> {
> 	int fd, waited = 0, i = 0;
> 
> 	fd = open(XT_LOCK_NAME, O_CREAT, 0600);
> 	if (fd < 0)
> 		return true;
> 
> 	while (1) {
> 		if (flock(fd, LOCK_EX | LOCK_NB) == 0)
> 			return true;
> 		else if (wait >= 0 && waited >= wait)  //total time upto which we need to
> wait.
> 			return false;
> 		if (++i % 2 == 0)
> 			fprintf(stderr, "Another app is currently holding the xtables lock; "
> 				"waiting (%ds) for it to exit...\n", waited);
> 		waited++;
> 		sleep(1); //sleep for one second only
> 	}
> }
> 
> My patch does not change the behavior of -w itself. It only changes the
> sleep interval to 10ms when a decimal is specified.

Sorry, then I misunderstood the semantics of -w, I remembered this
specified the sleep interval but I was wrong.

> Existing behavior of 1 second sleep for integral interval is preserved.

Then, I'd suggest you add a new specific option to specify the
interval, allowing this sec.msecs notation, preserving the 1 second
interval as default.

Thanks.
