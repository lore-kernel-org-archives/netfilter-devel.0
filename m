From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Scheduled removals
Date: Mon, 12 Jan 2009 07:03:46 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901120703390.21692@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901060425250.14442@fbirervta.pbzchgretzou.qr> <496AC7E4.6080204@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53482 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbZALGDs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:03:48 -0500
In-Reply-To: <496AC7E4.6080204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-01-12 05:32, Patrick McHardy wrote:
>> as per Documentation/feature-removal-schedule.txt, some legacy code is ripe
>> for removal. Now while pursuing this I wondered whether the struct definitions
>> for the old code in the header files (e.g. in linux/netfilter/xt_CONNMARK.h)
>> can also be removed or whether people will argue that doing so would
>> unnecessarily cause dismay on behalf the potential users (of which there are
>> not any). I am not aware of any users, and neither is Search Engine Google, so
>> I'd just take the bait and kill it. Vetoes?
>
> Every time I'm searching I do find some users of at least some
> iptables headers. Maybe not this specific one, but that doesn't
> mean much, fact is there might be users.
>
> That being said, I'd be fine removing both the functionality
> and the headers after a sufficiently long period. I'm not
> really confident that the period has indeed be long enough
> though. When did we schedule this for removal?

January 2008.
