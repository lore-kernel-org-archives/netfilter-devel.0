From: Tim Gardner <timg@tpi.com>
Subject: Re: iptables pull request, add XT_RECENT_REAP support
Date: Wed, 17 Mar 2010 13:44:13 -0600
Message-ID: <4BA1310D.5080800@tpi.com>
References: <20100317184852.89F0DF89BB@sepang.rtg.net> <1268854497.2894.2.camel@edumazet-laptop>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:3894 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab0CQTod (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:44:33 -0400
In-Reply-To: <1268854497.2894.2.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/17/2010 01:34 PM, Eric Dumazet wrote:
> Le mercredi 17 mars 2010 =C3=A0 12:48 -0600, Tim Gardner a =C3=A9crit=
 :
>> diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.m=
an
>> index 532c328..26e4fb9 100644
>> --- a/extensions/libxt_recent.man
>> +++ b/extensions/libxt_recent.man
>> @@ -41,6 +41,11 @@ This option must be used in conjunction with one =
of \fB\-\-rcheck\fP or
>>   \fB\-\-update\fP. When used, this will narrow the match to only ha=
ppen when the
>>   address is in the list and was seen within the last given number o=
f seconds.
>>   .TP
>> +\fB\-\-reap\fP \fIreap\fP
>> +This option must be used in conjunction with \fB\-\-seconds\fP. Whe=
n used, this
>> +will remove entries with the most recent timestamp older then \fB\-=
\-seconds\fP
>> +since the last packet was received.
>> +.TP
>>   \fB\-\-hitcount\fP \fIhits\fP
>>   This option must be used in conjunction with one of \fB\-\-rcheck\=
fP or
>>   \fB\-\-update\fP. When used, this will narrow the match to only ha=
ppen when the
>
> Are you sure this "most recent timestamp older then " is correct ? ;)
>
>
>

That does kind of make my head hurt. Perhaps it is better stated, "When=
=20
used, this will remove entries that have not received a packet in the=20
time specified by --seconds."

rtg
--=20
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
