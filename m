From: Tim Gardner <timg@tpi.com>
Subject: Re: iptables pull request, add XT_RECENT_REAP support
Date: Wed, 17 Mar 2010 14:29:33 -0600
Message-ID: <4BA13BAD.3090508@tpi.com>
References: <20100317184852.89F0DF89BB@sepang.rtg.net> <alpine.LSU.2.01.1003172113480.16169@obet.zrqbmnf.qr>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2046 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab0CQU3q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 16:29:46 -0400
In-Reply-To: <alpine.LSU.2.01.1003172113480.16169@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/17/2010 02:14 PM, Jan Engelhardt wrote:
>
> On Wednesday 2010-03-17 19:48, Tim Gardner wrote:
>> @@ -41,6 +41,11 @@ This option must be used in conjunction with one of \fB\-\-rcheck\fP or
>> \fB\-\-update\fP. When used, this will narrow the match to only happen when the
>> address is in the list and was seen within the last given number of seconds.
>> .TP
>> +\fB\-\-reap\fP \fIreap\fP
>> +This option must be used in conjunction with \fB\-\-seconds\fP. When used, this
>> +will remove entries with the most recent timestamp older then \fB\-\-seconds\fP
>> +since the last packet was received.
>> +.TP
>
>   --reap does not take any argument.
>
> Also, this option does not need to be used (!must be), it's optional.
>

You're correct. Looks like a copy/paste error. I'll fix it and push a 
new patch.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
