From: Patrick McHardy <kaber@trash.net>
Subject: Re: bug in iptables
Date: Fri, 22 Feb 2008 15:08:26 +0100
Message-ID: <47BED75A.9090204@trash.net>
References: <74d7e2880802141038t53e58f5frafe12a3a77a3fca9@mail.gmail.com> <47B53643.9000107@gmail.com> <47BACB6C.4090000@trash.net> <47BE7917.1030301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: justin joseph <justin.cok@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep11-int.chello.at ([62.179.121.31]:56040 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760915AbYBVOIw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:08:52 -0500
In-Reply-To: <47BE7917.1030301@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

justin joseph wrote:
> Patrick McHardy wrote:
>> Your example doesn't contain the rule jumping to "tcpost", so
>> its not clear whether this really is a bug. Please post all
>> four rules (tcpost and -j tcpost) and the kernel version you're
>> using.
>>
> 
> Chain POSTROUTING (policy ACCEPT 2263 packets, 528K bytes)
>  pkts bytes target     prot opt in     out     source               
> destination
>  2227  523K MARK       all  --  any    any     anywhere             
> anywhere            MARK and 0xff
>  2227  523K tcpost     all  --  any    any     anywhere             
> anywhere
> 
> Chain tcfor (1 references)
>  pkts bytes target     prot opt in     out     source               
> destination
> 
> Chain tcout (1 references)
>  pkts bytes target     prot opt in     out     source               
> destination
> 
> Chain tcpost (1 references)
>  pkts bytes target     prot opt in     out     source               
> destination
>     0     0 CLASSIFY   tcp  --  lan1   wan1    anywhere             
> anywhere            tcp dpt:ssh CLASSIFY set 1:11
>     0     0 CLASSIFY   all  --  any    wan1    anywhere             
> anywhere            MARK match 0x1/0xff CLASSIFY set 1:11
>     0     0 CLASSIFY   all  --  any    wan1    anywhere             
> anywhere            MARK match 0xfe/0xff CLASSIFY set 1:1254
> 
> 
> root@hq.enpaq:~# uname -r
> 2.6.15-29-386
> root@hq.enpaq:~#


Thanks, I can reproduce it on current -git. I'll look into it.

