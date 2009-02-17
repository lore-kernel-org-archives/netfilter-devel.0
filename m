From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libxtables: Dont initialize global xt_params
Date: Tue, 17 Feb 2009 15:54:06 +0100
Message-ID: <499ACF8E.9080301@trash.net>
References: <1234448162.3271.1.camel@dogo.mojatatu.com> <4998F0EE.3020404@snapgear.com> <49994239.6000307@trash.net> <200902171546.13305.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Philip Craig <philipc@snapgear.com>,
	Jan Engelhardt <jengelh@medozas.de>, hadi@cyberus.ca,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57928 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZBQOyI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:54:08 -0500
In-Reply-To: <200902171546.13305.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jarosch wrote:
> On Monday, 16. February 2009 11:38:49 you wrote:
>> I think the 3.x versions don't do this by default, so as long as they're
>> supported by the kernel, we should expect people to use them and not
>> assume defaults of later versions.
> 
> Thanks for clearing this up, Philip and Patrick.
> 
> So we've got so far:
> 
> 1. Better readbility by writing "xyz = NULL;"
> 2. Correct and a tiny bit larger code using gcc 3
> 3. Correct and compact code using gcc 4 (released April 2005).
> 
> I guess the assembler code generated from gcc 3 <-> gcc 4
> will have other performance/size differences,
> but it's Patrick's final decision what to do :-)

I actually prefer no initializers for two reasons:

- it avoids these discussions that come up once every couple
   of months :)

- they're useless


