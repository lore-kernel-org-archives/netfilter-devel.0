From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: half a patch for the pseudoregression
Date: Wed, 18 Feb 2009 15:35:36 +0100
Message-ID: <499C1CB8.4010901@trash.net>
References: <alpine.LSU.2.00.0901272322210.31372@fbirervta.pbzchgretzou.qr> <499057DC.9000102@trash.net> <alpine.LSU.2.00.0902171952521.999@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54223 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbZBROfi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 09:35:38 -0500
In-Reply-To: <alpine.LSU.2.00.0902171952521.999@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-02-09 17:20, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> Here is the sample patch that fixes ip_tables_matches, but I still challenge
>>> the usefulness of /proc/net/ip_tables_* altogether.
>>> Those files should have been removed, or appropriately upgraded when revision
>>> support was introduced.
>> Thats not really the question right now since it exists and people
>> are using it. Feel free to start a discussion on removing it once
>> we've fixed the regression.
> 
> I've also send the complete thing (twice now). Did you receive it?

Applied, thanks. Will pass it upstream after some testing.
