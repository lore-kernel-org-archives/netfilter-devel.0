From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables-restore: remove unused --binary flag
Date: Wed, 21 Jan 2009 09:06:24 +0100
Message-ID: <4976D780.7010308@trash.net>
References: <alpine.LNX.1.10.0812242031570.514@fbirervta.pbzchgretzou.qr> <495A0123.3020509@netfilter.org> <alpine.LSU.2.00.0901192119330.12940@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47896 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbZAUIG2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:06:28 -0500
In-Reply-To: <alpine.LSU.2.00.0901192119330.12940@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-12-30 12:08, Pablo Neira Ayuso wrote:
>> Jan Engelhardt wrote:
>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>> Date:   Wed Dec 24 20:30:47 2008 +0100
>>>
>>> iptables-restore: remove unused --binary flag
>>>
>> I doubt that someone is using this option, anyhow I think that it would
>> be better to output a warning message to stderr that says "-b is
>> deprecated, fix your scripts". Later, we can remove it.
> 
> Requesting comments from Patrick.

Both is fine with me, although I don't see a compelling reason against
taking the safe route.
