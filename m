From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] TCP simultaneous open support
Date: Tue, 02 Jun 2009 14:02:50 +0200
Message-ID: <4A2514EA.6000100@trash.net>
References: <alpine.DEB.2.00.0905311614330.760@blackhole.kfki.hu> <alpine.DEB.2.00.0905311631480.760@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Saatvik Agarwal <saatvik.agarwal@stanford.edu>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37704 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZFBMCw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:02:52 -0400
In-Reply-To: <alpine.DEB.2.00.0905311631480.760@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Sun, 31 May 2009, Jozsef Kadlecsik wrote:
> 
>> ---
>>  include/linux/netfilter/nf_conntrack_tcp.h |    2 +-
>>  net/netfilter/nf_conntrack_proto_tcp.c     |   97 +++++++++++++++++-----------
>>  2 files changed, 61 insertions(+), 38 deletions(-)
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> 
> Sorry, that line was not added.

Applied to nf-next.git, thanks Jozsef. I've made two minor changes:

- keep TCP_CONNTRACK_LISTEN around to avoid userspace compilation
   errors and make the new state a #define to be able to check for
   it using the preprocessor:

	TCP_CONNTRACK_LISTEN,	/* obsolete */
#define TCP_CONNTRACK_SYN_SENT2	TCP_CONNTRACK_LISTEN

- fixed a compilation error resulting from a missing '{':

>  		.proc_handler	= proc_dointvec_jiffies,
>  	},
> +		.procname	= "ip_conntrack_tcp_timeout_syn_sent2",
> +		.data		= &tcp_timeouts[TCP_CONNTRACK_SYN_SENT2],

