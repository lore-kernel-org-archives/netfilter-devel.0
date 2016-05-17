From: subashab@codeaurora.org
Subject: Re: [PATCH v2] xtables: Add a smaller delay option when waiting for
 xtables lock
Date: Mon, 16 May 2016 21:30:15 -0600
Message-ID: <8502fe32e83f67c567d4fadeb6c479f4@codeaurora.org>
References: <1462504699-14988-1-git-send-email-subashab@codeaurora.org>
 <20160509214044.GA23794@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57671 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbcEQDaQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 May 2016 23:30:16 -0400
In-Reply-To: <20160509214044.GA23794@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> 
> My impression after looking at this patch is that you can simplify it
> using 'struct timeval' and use select() to wait for the time you need.
> 

Hi Pablo

Sure, I can send a v3 with the select. Just to clarify, here is what the 
patch does -

iptables -w 2.1

0.01s sleep, retry
0.02s sleep, retry
0.03s sleep, retry
...
2.1s sleep, exit

Note that it sleeps for 10ms and retries rather than sleeping for a 
single iteration for 2.1s seconds and then retrying.

Let me know if there are any concerns with this.

--
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, a Linux Foundation Collaborative Project.

