From: "ron lai" <ronlai@cs.stanford.edu>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Tue, 6 Nov 2007 05:19:44 -0800
Message-ID: <001e01c82077$b4d67610$6500a8c0@ronPc>
References: <001601c81ccc$682bb4a0$bb0b10ac@FireEye.com> <47303E9D.2050909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-15";
	reply-type=response
Content-Transfer-Encoding: 7bit
Cc: <netfilter@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cs-smtp-1.Stanford.EDU ([171.64.64.25]:40962 "EHLO
	cs-smtp-1.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbXKFNTp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Nov 2007 08:19:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

No, I am not using any patch. Is there any debug info I can turn on to see 
why the helper gets invoked twice?

BTW, my build is a SMP build.

Ron
----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Ron Lai" <ronlai@cs.stanford.edu>
Cc: <netfilter@vger.kernel.org>; <netfilter-devel@vger.kernel.org>
Sent: Tuesday, November 06, 2007 2:14 AM
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 
2.6.22.6


> Ron Lai wrote:
>> The log I got is listed below and the corresponding pcap file is 
>> attached.
>>
>> Nov  1 21:14:54 ron kernel: ftp: Conntrackinfo = 2
>> Nov  1 21:14:54 ron kernel: ftp: Conntrackinfo = 2
>> Nov  1 21:14:54 ron kernel: ftp: dataoff(60) >= skblen(60)
>> Nov  1 21:14:54 ron kernel: ftp: dataoff(60) >= skblen(60)
>> Nov  1 21:14:54 ron kernel: ftp: dataoff(52) >= skblen(52)
>> Nov  1 21:14:54 ron kernel: ftp: dataoff(52) >= skblen(52)
>
>
> This very much looks like your packets hit the helper twice, which would
> also explain the double sequence number adjustment. You didn't answer
> my question before, are you using any patches?
>
> -
> To unsubscribe from this list: send the line "unsubscribe netfilter" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

