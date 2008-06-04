From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [PATCH] netfilter ulog byte alignment problem
Date: Wed, 04 Jun 2008 09:43:10 +0100
Message-ID: <4846559E.2090002@gmx.ch>
References: <1212426348.31217.30.camel@pumper.lan.luxnet.ch> <48454163.1060700@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41401 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751824AbYFDInO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:43:14 -0400
In-Reply-To: <48454163.1060700@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Fabian Hugelshofer wrote:
>> I tracked the issue down to a byte alignment problem in
>> ulog_packet_msg_t (include/linux/netfilter_ipv4/ipt_ULOG.h). Setting
>> attributes 'packed' or 'aligned' or using 'size_t' instead of 'unsigned
>> char' for field 'mac_len' solved the problem. It seems necessary to help
>> the compiler doing things right.
[...]
> I'm afraid it might break compatibility on other architectures.
> Are your userspace and kernel compiled using the same options?
> Why would they lay out the structure differently?

I think you are right. The compiler lays it out consistantly while
respecting proper alignment. I removed my patch again and it worked
event without. I think the reason was header files which were out of 
sync (kernel vs. userspace). I had to modify ipt_ULOG.(c|h) for a driver 
problem workaround. I'm quire sure that I reverted the changes during 
the testing, but maybe I missed that.

I would write again, if the problem reappears later.
