From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables-restore: remove unused --binary flag
Date: Thu, 22 Jan 2009 20:51:26 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901222051130.7246@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0812242031570.514@fbirervta.pbzchgretzou.qr> <495A0123.3020509@netfilter.org> <alpine.LSU.2.00.0901192119330.12940@fbirervta.pbzchgretzou.qr> <4976D780.7010308@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35355 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbZAVTv1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:51:27 -0500
In-Reply-To: <4976D780.7010308@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-01-21 09:06, Patrick McHardy wrote:
>>>>
>>>> iptables-restore: remove unused --binary flag
>>>>
>>> I doubt that someone is using this option, anyhow I think that it would
>>> be better to output a warning message to stderr that says "-b is
>>> deprecated, fix your scripts". Later, we can remove it.
>>
>> Requesting comments from Patrick.
>
> Both is fine with me, although I don't see a compelling reason against
> taking the safe route.
>
Then I pick the option to just nuke it.
