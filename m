From: Olaf <mailinglists@ban-solms.de>
Subject: Re: iptables 1.4.11, cannot invert tcp flags
Date: Tue, 07 Jun 2011 23:22:58 +0200
Message-ID: <4DEE96B2.5020104@ban-solms.de>
References: <4DDE857E.40807@trash.net> <4DEDB617.7090805@ban-solms.de> <4DEE3077.3080400@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hss-server.de ([212.72.183.75]:49517 "EHLO hss-server.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510Ab1FGVW6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:22:58 -0400
In-Reply-To: <4DEE3077.3080400@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2011-06-07 16:06, Patrick McHardy wrote:

>> with 1.4.11 I can no longer invert --syn nor it's equivalent --tcp-flags
>> SYN,RST,ACK,FIN SYN.
>> Both show up 'normal' (tcp flags:0x17/0x02) instead of 'inverted' (tcp
>> flags:!0x17/0x02) when listing rules.
>> Works fine when using 1.4.10 or older versions.
>
> It works for me when using "-p tcp -m tcp ! --syn", but not when
> using "-p tcp ! --syn", so I guess something is broken in command
> parsing for implicitly loaded matches.
>
> CCed Jan, who can probably help.

Sure looks that way :-)

Thanks Jan!


Olaf
