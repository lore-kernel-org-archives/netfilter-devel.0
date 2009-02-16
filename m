From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libxtables: Dont initialize global xt_params
Date: Mon, 16 Feb 2009 11:38:49 +0100
Message-ID: <49994239.6000307@trash.net>
References: <1234448162.3271.1.camel@dogo.mojatatu.com> <200902121609.43664.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0902121612200.5658@fbirervta.pbzchgretzou.qr> <200902121641.54430.thomas.jarosch@intra2net.com> <4998F0EE.3020404@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
	Jan Engelhardt <jengelh@medozas.de>, hadi@cyberus.ca,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53044 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZBPKiy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:38:54 -0500
In-Reply-To: <4998F0EE.3020404@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Craig wrote:
> Thomas Jarosch wrote:
>> Well, I guess that's a job for the compiler/optimizer. I did a quick test by 
>> writing two versions of a small program initializing a static variable with 
>> zero and one version that doesn't (=zeroed in .bss). Guess what,
>> the size of the resulting executable stays the same.
>>
>> When I initialize the variable with a non-zero value, then the program size 
>> increases. I tested "-O2", "-O0" and "-Os" and the results where the same.
>> Feel free to look at the assembler output, though I guess this optimization
>> is not measurable and makes the code harder to read :o)
> 
> For gcc, this depends on the -fno-zero-initialized-in-bss option.
> Recommendations to avoid zero initialization generally come from
> a time when gcc didn't do this by default.  Now it is more just
> personal preference.

I think the 3.x versions don't do this by default, so as long as they're
supported by the kernel, we should expect people to use them and not
assume defaults of later versions.
