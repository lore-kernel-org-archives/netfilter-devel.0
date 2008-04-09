From: Patrick McHardy <kaber@trash.net>
Subject: Re: Ebtables hook order anomaly
Date: Wed, 09 Apr 2008 16:36:42 +0200
Message-ID: <47FCD47A.7060600@trash.net>
References: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com> <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0803250455030.9368@fbirervta.pbzchgretzou.qr> <47E8F6B4.4030800@trash.net> <alpine.LNX.1.10.0804081645450.2229@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Greg Scott <GregScott@InfraSupportEtc.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48964 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYDIOgp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:36:45 -0400
In-Reply-To: <alpine.LNX.1.10.0804081645450.2229@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-03-25 13:57, Patrick McHardy wrote:
>>>> which means ebtables actually comes after iptables, and hence,
>>>> your mark 3 will not show up as you expected.
>> Indeed, on output bridge netfilter will run after IPv4 netfilter.
>> Does that explain things?
> 
> It explains things, but having the feature removed is not nice.
> I cannot deny that the previous code was real a hook spaghetteria,
> but how could it be done better?

Good question. The order on output is logically correct, so I
wouldn't change it. I never liked the invocation of IP hooks
from bridging at all, so long-term we could consider making
the features people want to bridging available "natively"
(like conntrack/NAT/...).
