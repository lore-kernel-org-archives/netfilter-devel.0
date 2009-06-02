From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] TCP simultaneous open support
Date: Tue, 02 Jun 2009 14:12:03 +0200
Message-ID: <4A251713.2010508@trash.net>
References: <alpine.DEB.2.00.0905311614330.760@blackhole.kfki.hu> <alpine.DEB.2.00.0905311631480.760@blackhole.kfki.hu> <4A2514EA.6000100@trash.net> <alpine.DEB.2.00.0906021405510.11925@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Saatvik Agarwal <saatvik.agarwal@stanford.edu>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37881 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbZFBMME (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:12:04 -0400
In-Reply-To: <alpine.DEB.2.00.0906021405510.11925@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Tue, 2 Jun 2009, Patrick McHardy wrote:
> 
>>
>>>  		.proc_handler	= proc_dointvec_jiffies,
>>>  	},
>>> +		.procname	= "ip_conntrack_tcp_timeout_syn_sent2",
>>> +		.data		= &tcp_timeouts[TCP_CONNTRACK_SYN_SENT2],
> 
> That's a copy-paste bug, sorry: I have to run a slighty older kernel 
> release on my test system and I selected the paste area one line off.

Don't worry, I've seen worse problems with patches :)
