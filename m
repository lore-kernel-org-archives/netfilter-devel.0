From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH v3] iptables: libxt_recent: Add support for --reap
 option
Date: Fri, 9 Dec 2011 05:17:55 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112090516470.25256@frira.zrqbmnf.qr>
References: <1322789373-30474-1-git-send-email-tim.gardner@canonical.com> <alpine.LNX.2.01.1112021628190.5296@frira.zrqbmnf.qr> <4ED91CEF.1080006@canonical.com> <4EE1730E.90200@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Tim Gardner <tim.gardner@canonical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:47548 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1LIER6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:17:58 -0500
In-Reply-To: <4EE1730E.90200@canonical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2011-12-09 03:31, Tim Gardner wrote:
>>
>>> If not, we should probably consider using .min=1 on the --seconds
>>> parameter, in which case the test is also redundant.
>>>
>>
>> Done. Tested with the following combinations and received the expected
>> failures on the first 2:
>>
>> iptables -A FORWARD -m recent --rcheck --seconds 0 -j DROP
>> iptables -A FORWARD -m recent --rcheck --reap -j DROP
>> iptables -A FORWARD -m recent --rcheck --seconds 10 --reap -j DROP
>>
>> rtg
>
> Jan ? Is this v3 patch sufficient ?

No more showstopper comments were made, therefore, I moved to apply.
In git now.
