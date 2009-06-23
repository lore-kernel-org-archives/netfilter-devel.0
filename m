From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: null-pointer deref in ulogd2
Date: Wed, 24 Jun 2009 00:39:58 +0200
Message-ID: <4A4159BE.7040807@birkenwald.de>
References: <h1q05h$o8h$1@ger.gmane.org> <h1q3tu$2vi$1@ger.gmane.org> <4A40F777.7010505@netfilter.org> <4A4108D6.901@birkenwald.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.svr02.mucip.net ([83.170.6.69]:48187 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZFWWj5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:39:57 -0400
In-Reply-To: <4A4108D6.901@birkenwald.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

> ARGH! I found my problem. Apparently Postgres was too slow on INSERT. 
> Although the CPU load looked fine (and even IOWait wasn't out of the 
> ordinary, 20% on one CPU) it seems to have blocked. Sacrificing 
> consistency for speed by setting fsync=no in postgres the IOwait went 
> down to 0.5% and I now have 100 flows, all of them with start and end!

Looks like I spoke too early :-(

We have now passed peak-time, which means about 450 Mbps traffic, 60k 
concurrent sessions and about 300 flows/s in a 1hour average.

First of all, ulogd has segfaulted again. Unfortunately I didn't get a 
coredump, I've restarted it in gdb now.

Second, the number of flow records without any time stamp is getting 
higher and higher again, with now 20% lacking either start or endtime

ulogd=# SELECT count(*) FROM ulog2_ct;
   count
---------
  3278208
(1 row)

ulogd=# SELECT count(*) FROM ulog2_ct WHERE flow_start_sec IS NULL;
  count
--------
  270690
(1 row)

ulogd=# SELECT count(*) FROM ulog2_ct WHERE flow_end_sec IS NULL;
  count
--------
  306740
(1 row)

This seems to get worse the longer ulogd runs, shortly before the 
segfault there were 8000 flows without end_time in a row. The recent 
ones are fine again.

I'm still getting (very ocasionally)

Wed Jun 24 00:31:21 2009 <5> ulogd_inpflow_NFCT.c:656 Maximum buffer 
size (17367040) in NFCT has been reached. Please, consider rising 
`netlink_socket_buffer_size
` and `netlink_socket_buffer_maxsize` clauses.

does it make sense to increase the buffer even more? If 17MB of buffer 
aren't enough I don't think it can keep up with any setting. And now 
that fsync is disabled in Postgres the box is really not that heavily 
loaded. CPUs 3&4 (serving the interrupts of the two NICs) are near 100% 
interrupt load at peak time, but 1&2 are >80% idle.

Does anyone else run this setup with similar numbers and can shed some 
light on tuning?

Oh, and we're dumping conntrack -L every minute. Works fine during the 
day with 30k connections, but starts to frequently segfault with 60k 
connections in the evening. Also trying to get a coredump now.

Bernhard
