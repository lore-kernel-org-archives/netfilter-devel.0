From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables 1.4.11, cannot invert tcp flags
Date: Tue, 7 Jun 2011 23:29:47 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106072329430.3052@frira.zrqbmnf.qr>
References: <4DDE857E.40807@trash.net> <4DEDB617.7090805@ban-solms.de> <4DEE3077.3080400@trash.net> <4DEE96B2.5020104@ban-solms.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Olaf <mailinglists@ban-solms.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59110 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074Ab1FGV3s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:29:48 -0400
In-Reply-To: <4DEE96B2.5020104@ban-solms.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-06-07 23:22, Olaf wrote:

> On 2011-06-07 16:06, Patrick McHardy wrote:
>
>>> with 1.4.11 I can no longer invert --syn nor it's equivalent --tcp-flags
>>> SYN,RST,ACK,FIN SYN.
>>> Both show up 'normal' (tcp flags:0x17/0x02) instead of 'inverted' (tcp
>>> flags:!0x17/0x02) when listing rules.
>>> Works fine when using 1.4.10 or older versions.
>>
>> It works for me when using "-p tcp -m tcp ! --syn", but not when
>> using "-p tcp ! --syn", so I guess something is broken in command
>> parsing for implicitly loaded matches.
>>
>> CCed Jan, who can probably help.
>
> Sure looks that way :-)

Fixes sent in.
