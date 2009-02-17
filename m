From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter: half a patch for the pseudoregression
Date: Tue, 17 Feb 2009 19:53:06 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902171952521.999@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901272322210.31372@fbirervta.pbzchgretzou.qr> <499057DC.9000102@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58755 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZBQSxH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:53:07 -0500
In-Reply-To: <499057DC.9000102@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-02-09 17:20, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>>
>> Here is the sample patch that fixes ip_tables_matches, but I still challenge
>> the usefulness of /proc/net/ip_tables_* altogether.
>> Those files should have been removed, or appropriately upgraded when revision
>> support was introduced.
>
> Thats not really the question right now since it exists and people
> are using it. Feel free to start a discussion on removing it once
> we've fixed the regression.

I've also send the complete thing (twice now). Did you receive it?
