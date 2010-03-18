From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables pull request, add XT_RECENT_REAP support
Date: Thu, 18 Mar 2010 14:05:06 +0100
Message-ID: <4BA22502.7060405@trash.net>
References: <20100317184852.89F0DF89BB@sepang.rtg.net> <1268854497.2894.2.camel@edumazet-laptop> <4BA13E50.9050706@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: timg@tpi.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48095 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab0CRNFI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:05:08 -0400
In-Reply-To: <4BA13E50.9050706@tpi.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tim Gardner wrote:
> On 03/17/2010 01:34 PM, Eric Dumazet wrote:
>> Le mercredi 17 mars 2010 =E0 12:48 -0600, Tim Gardner a =E9crit :
>>> diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.=
man
>>> index 532c328..26e4fb9 100644
>>> --- a/extensions/libxt_recent.man
>>> +++ b/extensions/libxt_recent.man
>>> @@ -41,6 +41,11 @@ This option must be used in conjunction with one
>>> of \fB\-\-rcheck\fP or
>>>   \fB\-\-update\fP. When used, this will narrow the match to only
>>> happen when the
>>>   address is in the list and was seen within the last given number =
of
>>> seconds.
>>>   .TP
>>> +\fB\-\-reap\fP \fIreap\fP
>>> +This option must be used in conjunction with \fB\-\-seconds\fP. Wh=
en
>>> used, this
>>> +will remove entries with the most recent timestamp older then
>>> \fB\-\-seconds\fP
>>> +since the last packet was received.
>>> +.TP
>>>   \fB\-\-hitcount\fP \fIhits\fP
>>>   This option must be used in conjunction with one of
>>> \fB\-\-rcheck\fP or
>>>   \fB\-\-update\fP. When used, this will narrow the match to only
>>> happen when the
>>
>> Are you sure this "most recent timestamp older then " is correct ? ;=
)
>>
>>
>>
>=20
> How about this (attached):

Looks fine to me. Any further objections?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
