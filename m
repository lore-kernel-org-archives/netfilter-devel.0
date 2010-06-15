From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack fails to track Windows Vista TCP connection
Date: Tue, 15 Jun 2010 04:23:01 +0200
Message-ID: <4C16E405.40705@trash.net>
References: <0199E0D51A61344794750DC57738F58E70B258E2B3@GVW1118EXC.americas.hpqcorp.net> <4C165596.8020700@trash.net> <alpine.LSU.2.01.1006141834280.7212@obet.zrqbmnf.qr> <0199E0D51A61344794750DC57738F58E70B258E346@GVW1118EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Fischer, Anna" <anna.fischer@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62609 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab0FOCXG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:23:06 -0400
In-Reply-To: <0199E0D51A61344794750DC57738F58E70B258E346@GVW1118EXC.americas.hpqcorp.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fischer, Anna wrote:
>>> You're mentioning ip_conntrack, which is obsoleted for multiple
>>> years now. Which kernel version are you using?
>>>       
>> By definition of ip_conntrack, that must be older than 2.6.20.
>>     
>
> Yes, this is a 2.6.18 Xen kernel that I am using. Even if it is obsolete, can you let me know if you are aware of such a problem ever having caused any issues? I just want to get a feeling if I am at least roughly on the right track while figuring out what the problem is.
>   

We've had a couple of problems related to related to
acknowledgement numbers in TCP conntrack, I'd suggest
you check the nf_conntrack_proto_tcp.c changelogs,
basically everything in there should also apply to
the old version.
