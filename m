From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] xtables: Add a smaller delay option when waiting for
 xtables lock
Date: Tue, 17 May 2016 12:41:52 +0200
Message-ID: <20160517104152.GA3354@salvia>
References: <1462504699-14988-1-git-send-email-subashab@codeaurora.org>
 <20160509214044.GA23794@salvia>
 <8502fe32e83f67c567d4fadeb6c479f4@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: subashab@codeaurora.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33694 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbcEQKmC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 06:42:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 592AD1BD5B2
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 12:42:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8D53816E3FF
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 12:41:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1AF8411C38B
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 12:41:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <8502fe32e83f67c567d4fadeb6c479f4@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 16, 2016 at 09:30:15PM -0600, subashab@codeaurora.org wrote:
> >
> >My impression after looking at this patch is that you can simplify it
> >using 'struct timeval' and use select() to wait for the time you need.
> >
> 
> Hi Pablo
> 
> Sure, I can send a v3 with the select. Just to clarify, here is what the
> patch does -
> 
> iptables -w 2.1
> 
> 0.01s sleep, retry
> 0.02s sleep, retry
> 0.03s sleep, retry
> ...
> 2.1s sleep, exit
> 
> Note that it sleeps for 10ms and retries rather than sleeping for a single
> iteration for 2.1s seconds and then retrying.
>
> Let me know if there are any concerns with this.

But this is changing the existing behaviour, right? My understanding
is that -w indicates the net wait time for each try.
