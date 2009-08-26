From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/6] netfilter: xtables: consolidate table hook functions
Date: Wed, 26 Aug 2009 14:53:05 +0200
Message-ID: <4A953031.50807@trash.net>
References: <1249931992-18761-1-git-send-email-jengelh@medozas.de> <1249931992-18761-2-git-send-email-jengelh@medozas.de> <4A928D3A.1000502@trash.net> <alpine.LSU.2.00.0908241614370.6695@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40201 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901AbZHZMxF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:53:05 -0400
In-Reply-To: <alpine.LSU.2.00.0908241614370.6695@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-08-24 14:53, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> For a following patch in this series ("generate nf hook ops on
>>> demand"), we will be requiring that a single hook entry function per
>>> table does the processing. Would this not be done would I need to
>>> pass multiple hook functions as arguments in that later patch, which
>>> would have been not so nice.
>> Removing duplicates is fine of course, but I don't like the
>> "consolidation" of multiple different hook functions very much.
>> You're trading more runtime overhead (admittedly not that much,
>> but those functions are heavily used)
> 
> Heavily? Most systems run the initialization exactly once.

I'm talking about the hook functions.

>> The second problem is that your automatically generated hook ops
>> can't even represent all the cases we have since some tables
>> actually do use different priorities for the different hooks.
> 
> I never claimed it was a fits-it-all solution. The nat table
> still has its original scheme.
> 
>> And I'm not sure where the memory savings you claim should come
>> from, the hook ops are still required at runtime.
> 
> Hm, true. That's why someone is supposed to look over them :>



