From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: RFC: netfilter: cache dst_entry in conntrack
Date: Mon, 8 Nov 2010 22:29:16 +0800
Message-ID: <AANLkTinUqYAie_4bDbgp+b9Q9Y_aZdKSN0wga5mV=bfc@mail.gmail.com>
References: <AANLkTimVY870t+ugopoabpe3+QCDC9RFh0nCtgPmJLq8@mail.gmail.com>
 <AANLkTinFKxOb2quNxV8HKz3Bgp9CwO_uzqE+7hBd+WxW@mail.gmail.com> <166541289209552@web79.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Cc: netfilter-devel@vger.kernel.org
To: "Oleg A. Arkhangelsky" <sysoleg@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43560 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab0KHO3h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:29:37 -0500
Received: by bwz11 with SMTP id 11so4903264bwz.19
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Nov 2010 06:29:36 -0800 (PST)
In-Reply-To: <166541289209552@web79.yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 8, 2010 at 5:45 PM, "Oleg A. Arkhangelsky"
<sysoleg@yandex.ru> wrote:
>
>
> 08.11.2010, 09:34, "Changli Gao" <xiaosuo@gmail.com>:
>
>> When conntrack is enabled, we can cache dst_entry into the
>> corresponding conntrack to eliminate the subsequence
>> ip_route_input_noref() calls for the same connection. The current
>
> Any performance gains? How much?
>

I have tested between my host OS and virtual OS runs on virtualbox.
Here is the result.


xiaosuo@gentux src $ netperf -t TCP_RR -H 10.13.150.50 -l 60
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
10.13.150.50 (10.13.150.50) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

16384  87380  1        1       60.00    5625.71
16384  87380
xiaosuo@gentux src $ netperf -t TCP_RR -H 10.13.150.50 -l 60
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to
10.13.150.50 (10.13.150.50) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate
bytes  Bytes  bytes    bytes   secs.    per sec

16384  87380  1        1       60.00    5614.79
16384  87380

The former is with nf_rtcache enabled.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
