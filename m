From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables 1.4.11, cannot invert tcp flags
Date: Tue, 07 Jun 2011 16:06:47 +0200
Message-ID: <4DEE3077.3080400@trash.net>
References: <4DDE857E.40807@trash.net> <4DEDB617.7090805@ban-solms.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Olaf <mailinglists@ban-solms.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53277 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab1FGOG4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:06:56 -0400
In-Reply-To: <4DEDB617.7090805@ban-solms.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.06.2011 07:24, Olaf wrote:
> Hi all,
> 
> 
> with 1.4.11 I can no longer invert --syn nor it's equivalent --tcp-flags
> SYN,RST,ACK,FIN SYN.
> Both show up 'normal' (tcp flags:0x17/0x02) instead of 'inverted' (tcp
> flags:!0x17/0x02) when listing rules.
> Works fine when using 1.4.10 or older versions.

It works for me when using "-p tcp -m tcp ! --syn", but not when
using "-p tcp ! --syn", so I guess something is broken in command
parsing for implicitly loaded matches.

CCed Jan, who can probably help.
