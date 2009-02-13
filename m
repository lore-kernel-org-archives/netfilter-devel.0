From: jamal <hadi@cyberus.ca>
Subject: Re: [PATCH] libxtables: Dont initialize global xt_params
Date: Fri, 13 Feb 2009 08:49:18 -0500
Message-ID: <1234532958.4078.10.camel@dogo.mojatatu.com>
References: <1234448162.3271.1.camel@dogo.mojatatu.com>
	 <200902121609.43664.thomas.jarosch@intra2net.com>
	 <alpine.LSU.2.00.0902121612200.5658@fbirervta.pbzchgretzou.qr>
	 <200902121641.54430.thomas.jarosch@intra2net.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:64195 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbZBMNvR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:51:17 -0500
Received: by ewy14 with SMTP id 14so1010810ewy.13
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2009 05:51:14 -0800 (PST)
In-Reply-To: <200902121641.54430.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2009-02-12 at 16:41 +0100, Thomas Jarosch wrote:

> Well, I guess that's a job for the compiler/optimizer. I did a quick test by 
> writing two versions of a small program initializing a static variable with 
> zero and one version that doesn't (=zeroed in .bss). Guess what,
> the size of the resulting executable stays the same.
> 
> When I initialize the variable with a non-zero value, then the program size 
> increases. I tested "-O2", "-O0" and "-Os" and the results where the same.
> Feel free to look at the assembler output, though I guess this optimization
> is not measurable and makes the code harder to read :o)
> 

I have no objection with junking the patch i sent. My initial intent of
NULLing was to use it as a check when first initializing - but now i
realize it actually didnt matter; and the readability arguement sounds
fair.

cheers,
jamal

