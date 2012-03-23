From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset nomatch not showing
Date: Fri, 23 Mar 2012 21:00:36 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1203232057030.20864@blackhole.kfki.hu>
References: <4F6C7368.3040905@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:53040 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab2CWUAj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 16:00:39 -0400
In-Reply-To: <4F6C7368.3040905@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 23 Mar 2012, Mr Dash Four wrote:

> If I create a set using the following set of statements:
> 
> ipset n test-net hash:net family inet timeout 0 hashsize 64
> ipset a test-net 10.1.1.0/24
> ipset a test-net 10.1.1.2 nomatch
> 
> and then issue "ipset l test-net" I get this:
> Header: family inet hashsize 64 maxelem 65536 timeout 0
> Size in memory: 924
> References: 0
> Members:
> 10.1.1.0/24 timeout 0
> 10.1.1.2 timeout 0

I can't reproduce this. What is your kernel version, ipset version and how 
did you install the ipset kernel modules: from the ipset package or the 
modules came together with the kernel.
 
> It is not clear whether the "nomatch" option on the 10.1.1.2 member I 
> used above is in fact non matching. Am I missing something?
> 
> Also, a minor nitpick on some of the help text displayed using "ipset help":
> -n
>        When listing, list just setnames from kernel.
> 
> It should be "When listing, just list setnames from the kernel."
> 
> -!
>        Ignore errors when creating already created sets,
>        when adding already existing elements
>        or when deleting non-existing elements.
> 
> It should be "Ignore errors when creating or adding sets or elements that do
> exist or when deleting elements that don't exist."

Thanks, I correct the help text messages.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
