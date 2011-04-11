From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset-6.3 unexpected htable order
Date: Mon, 11 Apr 2011 10:48:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104111040380.6049@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1104110439420.14676@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:39718 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab1DKIsq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:48:46 -0400
In-Reply-To: <alpine.LNX.2.01.1104110439420.14676@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Mon, 11 Apr 2011, Jan Engelhardt wrote:

> What would it mean if this testcase failure occured to me? I have
> observing this issue reproducibly with ipset-6.3-genl, though I can't
> make heads-tails of it. Apparently the members are the same, albeit
> in different order (which should be irrelevant in hashes anyway), and
> less memory happens to be used in this occurrence.
> 
> What immediately comes to mind about the different order is that
> the hash was perturbed, perhaps by an uninitialized variable or
> otherwise undefined operation.

No, it's the locale settings... "sort" is dependent of the locale.

> The fact that occurs only on ipv6 hash types is also worth mentioning.

Punctuation characters are ignored by sort if the locale is not C/POSIX. 
Therefore if your locale setting is different than mine :-), the checking 
failed.
 
I set LC_ALL to C in the testsuite script and re-sorted the results 
according to that. Git is updated, testsuite is re-checked.

Thanks for the testings!
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
