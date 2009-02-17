From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [PATCH] libxtables: Dont initialize global xt_params
Date: Tue, 17 Feb 2009 15:46:12 +0100
Message-ID: <200902171546.13305.thomas.jarosch@intra2net.com>
References: <1234448162.3271.1.camel@dogo.mojatatu.com> <4998F0EE.3020404@snapgear.com> <49994239.6000307@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Philip Craig <philipc@snapgear.com>,
	Jan Engelhardt <jengelh@medozas.de>, hadi@cyberus.ca,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:41470 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZBQOqS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:46:18 -0500
In-Reply-To: <49994239.6000307@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday, 16. February 2009 11:38:49 you wrote:
> >> Well, I guess that's a job for the compiler/optimizer. I did a quick
> >> test by writing two versions of a small program initializing a static
> >> variable with zero and one version that doesn't (=zeroed in .bss). Guess
> >> what, the size of the resulting executable stays the same.
> >>
> >> When I initialize the variable with a non-zero value, then the program
> >> size increases. I tested "-O2", "-O0" and "-Os" and the results where
> >> the same. Feel free to look at the assembler output, though I guess this
> >> optimization is not measurable and makes the code harder to read :o)
> >
> > For gcc, this depends on the -fno-zero-initialized-in-bss option.
> > Recommendations to avoid zero initialization generally come from
> > a time when gcc didn't do this by default.  Now it is more just
> > personal preference.
>
> I think the 3.x versions don't do this by default, so as long as they're
> supported by the kernel, we should expect people to use them and not
> assume defaults of later versions.

Thanks for clearing this up, Philip and Patrick.

So we've got so far:

1. Better readbility by writing "xyz = NULL;"
2. Correct and a tiny bit larger code using gcc 3
3. Correct and compact code using gcc 4 (released April 2005).

I guess the assembler code generated from gcc 3 <-> gcc 4
will have other performance/size differences,
but it's Patrick's final decision what to do :-)

Cheers,
Thomas

