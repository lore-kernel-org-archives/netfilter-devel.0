From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH ipset] kernel: uapi: fix MARKMASK attr ABI breakage
Date: Fri, 14 Feb 2014 09:23:07 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1402140922240.19460@blackhole.kfki.hu>
References: <1392291659-27444-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:51739 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbaBNIXL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:23:11 -0500
In-Reply-To: <1392291659-27444-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 13 Feb 2014, Florian Westphal wrote:

> commit 2dfb973c0dcc6d2211 (add markmask for hash:ip,mark data type)
> inserted IPSET_ATTR_MARKMASK in-between other enum values, i.e.
> changing values of all further attributes.  This causes 'ipset list'
> segfault on existing kernels since ipset no longer finds
> IPSET_ATTR_MEMSIZE (it has a different value on kernel side).
> 
> Jozsef points out it should be moved below IPSET_ATTR_MARK which
> works since there is some extra reserved space after that value.

Patch is applied, thanks Florian!

Best regards,
Jozsef 
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
