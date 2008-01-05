From: Ben Lentz <BLentz@channing-bete.com>
Subject: Re: conntrack accounting
Date: Sat, 05 Jan 2008 13:52:03 -0500
Message-ID: <477FD1D3.8000708@channing-bete.com>
References: <477704CB.8030809@channing-bete.com> <477D0553.4010906@netfilter.org> <477D257B.4060901@channing-bete.com> <477DA70E.5080301@channing-bete.com> <477DA84A.3030304@channing-bete.com> <477EAEF0.4000300@channing-bete.com> <477F7BF1.8060705@netfilter.org> <477F928A.70206@channing-bete.com> <477FB3E8.9080609@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.channing-bete.com ([12.169.82.107]:55212 "EHLO
	smtp.channing-bete.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbYAESwY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 13:52:24 -0500
In-Reply-To: <477FB3E8.9080609@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> I just implemented buffer logging that guarantees that fflush is called
> if the buffer is full. Have a look at LogFileBufferSize. This must
> improve performance under very busy firewall. Does syslog have any
> similar setting?
>   

That's good question, I'm not really sure what buffering is available in 
the various syslog implementations.

> The logging format must be discussed before the release. It would be
> fairly easy to dump the connection logging info in XML instead of plain
> text and I'm not sure if current format is fine.

In my opinion, the existing plain text log format is fine. I have an 
existing tool that's used to parse out the existing plain text iptables 
syslog data, and I plan on adapting it to support the similar format 
produced by conntrackd. If there are changes that could be made to make 
the formats similar, that might be nice (so the "family" netfilter 
softwares log uniformly (?)). XML would be nice, but I won't use it at 
this time.
