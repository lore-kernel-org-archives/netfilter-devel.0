From: subashab@codeaurora.org
Subject: Re: [PATCH v2] xtables: Add a smaller delay option when waiting for
 xtables lock
Date: Thu, 19 May 2016 16:06:46 -0600
Message-ID: <6323391815f454dccce0539b3a624952@codeaurora.org>
References: <1462504699-14988-1-git-send-email-subashab@codeaurora.org>
 <20160509214044.GA23794@salvia>
 <8502fe32e83f67c567d4fadeb6c479f4@codeaurora.org>
 <20160517104152.GA3354@salvia>
 <736e561105702835e5cedea5e3ed18b7@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56497 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbcESWGr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 May 2016 18:06:47 -0400
In-Reply-To: <736e561105702835e5cedea5e3ed18b7@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2016-05-17 12:25, subashab@codeaurora.org wrote:
>>> iptables -w 2.1
>>> 
>>> 0.01s sleep, retry
>>> 0.02s sleep, retry
>>> 0.03s sleep, retry
>>> ...
>>> 2.1s sleep, exit
>>> 
>>> Note that it sleeps for 10ms and retries rather than sleeping for a 
>>> single
>>> iteration for 2.1s seconds and then retrying.
>>> 
>>> Let me know if there are any concerns with this.
>> 
>> But this is changing the existing behaviour, right? My understanding
>> is that -w indicates the net wait time for each try.
> 
> Hi Pablo
> 
> Currently, each wait time is 1 second. -w is the overall time upto
> which it has to wait.
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
> 		else if (wait >= 0 && waited >= wait)  //total time upto which we
> need to wait.
> 			return false;
> 		if (++i % 2 == 0)
> 			fprintf(stderr, "Another app is currently holding the xtables lock; 
> "
> 				"waiting (%ds) for it to exit...\n", waited);
> 		waited++;
> 		sleep(1); //sleep for one second only
> 	}
> }
> 
> My patch does not change the behavior of -w itself. It only changes
> the sleep interval to 10ms when a decimal is specified.
> Existing behavior of 1 second sleep for integral interval is preserved.
> 

Hi Pablo

Please let me know if you have any other concerns. Also, can you tell me 
if I still need to change the sleep to select.
I feel sleep / usleep should suffice here.

--
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project.
