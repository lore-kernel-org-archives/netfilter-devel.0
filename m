From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [PATCH] libxtables: Dont initialize global xt_params
Date: Thu, 12 Feb 2009 16:41:53 +0100
Message-ID: <200902121641.54430.thomas.jarosch@intra2net.com>
References: <1234448162.3271.1.camel@dogo.mojatatu.com> <200902121609.43664.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0902121612200.5658@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: hadi@cyberus.ca, Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:58568 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbZBLPl5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 10:41:57 -0500
In-Reply-To: <alpine.LSU.2.00.0902121612200.5658@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday, 12. February 2009 16:14:23 Jan Engelhardt wrote:
> >1. Other people which don't know this "trick" will think
> >the variable is not initialized -> Hard to read.
>
> Well, maybe then they should get a better C book --
> automatic initialization is said to be(*) part of the C standard.
> And one should know the standard of a language IMHO.
>
> (*) Because it is not free, it remains a saga from people who do
> have access to it. :p

That is completly true. OTOH avoid the dark corners of the language.

> >2. If that variable gets moved f.e. inside a function, it will become
> >uninitialized. Also I'm not sure if the savings are even measurable...
>
> It seems to be for the Linux kernel. Especially when you happen
> to have large globals (both a lot of them, and large; e.g.
> foo[NR_CUPS]) this becomes a concern.

Well, I guess that's a job for the compiler/optimizer. I did a quick test by 
writing two versions of a small program initializing a static variable with 
zero and one version that doesn't (=zeroed in .bss). Guess what,
the size of the resulting executable stays the same.

When I initialize the variable with a non-zero value, then the program size 
increases. I tested "-O2", "-O0" and "-Os" and the results where the same.
Feel free to look at the assembler output, though I guess this optimization
is not measurable and makes the code harder to read :o)

Thomas

