From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: null-pointer deref in ulogd2
Date: Tue, 23 Jun 2009 18:54:46 +0200
Message-ID: <4A4108D6.901@birkenwald.de>
References: <h1q05h$o8h$1@ger.gmane.org> <h1q3tu$2vi$1@ger.gmane.org> <4A40F777.7010505@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.svr02.mucip.net ([83.170.6.69]:35971 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbZFWRG5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:06:57 -0400
In-Reply-To: <4A40F777.7010505@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>>> now it seems to work okay. In the database about 90% of the flows have
>>> flow_end_sec NULL.
> Please, rise "netlink_socket_buffer_size" and
> "netlink_socket_buffer_maxsize". If you use the default buffer, it's
> likely to overrun and, thus, to lose events.

We had increased that in the meantime, to

netlink_socket_buffer_size=10854400
netlink_socket_buffer_maxsize=20971520

That pretty much stopped the warning messages in /var/log/ulogd.log

We had also figured that the hash was the problem, so we tried the 
hash_enable=0 and used the INSERT_OR_REPLACE_CT function. However, that 
was also pretty unsuccessful, right now we have 750k flows in ulog2_ct 
where ct_event < 4 (so, as far as I understand it, the DESTROY event has 
not yet been received). Which is a bit too much for a box that only has 
40k-50k connections at the same time according to conntrack -L. 1.67M 
flows in total, I suspect that's a bit low as well. When I did 100 HTTP 
connections through the box I could only find ~20 flows in the database, 
none of them in DESTROYed state.

>> What is happening here?
> I think that you're using the default "hash_max_entries" which is too
> small. I suggest you to rise this value. I'm going to push a patch that
> includes information on these parameter tweaking to the example config file.

I've now set

hash_buckets=81920
hash_max_entries=327680

and went back to hash_enable=1.

However, it still doesn't look too great. About five minutes after 100 
TCP connects the number of flows in the ulog2_ct table for this IP 
address has stabilized at 116, consisting of
- 9 flows with both flow_start_sec and flow_end_sec
- 83 flows with only flow_start_sec
- 24 flows with only flow_end_sec

SELECT COUNT(DISTINCT orig_l4_sport) tells me that 92 real connections 
are listed in the table somehow, so 8 connections are totally lost and 
24 connections are listed twice.

[ half an hour later ]

ARGH! I found my problem. Apparently Postgres was too slow on INSERT. 
Although the CPU load looked fine (and even IOWait wasn't out of the 
ordinary, 20% on one CPU) it seems to have blocked. Sacrificing 
consistency for speed by setting fsync=no in postgres the IOwait went 
down to 0.5% and I now have 100 flows, all of them with start and end!

> BTW, could you give a quick test to this patch, yours seems to leak
> memory since NFCT_CB_STOLEN means not to release the ct object (no
> problem, I guess that you're not familiar with libnetfilter_conntrack).

Thanks. Yes, I'm even not that familiar with C :-)

Your patch compiles and runs fine. Can't tell much about memory leaks, 
but the system has not exploded yet.

Bernhard
