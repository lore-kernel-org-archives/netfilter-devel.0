From: "Anthony G. Basile" <basile@opensource.dyc.edu>
Subject: Re: [PATCH] xtables-addons: match packets based on status of grsecurity
 RBAC
Date: Tue, 19 Oct 2010 07:08:29 -0400
Message-ID: <4CBD7C2D.5090600@opensource.dyc.edu>
References: <20101017135202.8AFEE148E1BC@opensource.dyc.edu> <alpine.LNX.2.01.1010181145360.18053@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pva@gentoo.org,
	hardened@gentoo.org, zbyniu@destrukcja.pl, spender@grsecurity.net,
	pageexec@freemail.hu
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from virtual.dyc.edu ([67.222.116.22]:59329 "EHLO virtual.dyc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069Ab0JSLSl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:18:41 -0400
In-Reply-To: <alpine.LNX.2.01.1010181145360.18053@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/18/2010 05:50 AM, Jan Engelhardt wrote:
> On Sunday 2010-10-17 15:52, basile@opensource.dyc.edu wrote:
> 
>> This patch adds a module which is useful to users of
>> grsecurity's RBAC system.  It matches packets based
>> on whether RBAC is enabled or disabled.
> 
> Can you elaborate a bit on how this is useful in conjunction with 
> rulesets? I could imagine it be used with LSM selctx'es for example, or 
> another extension that tests for other RBAC attributes.

The idea here is that when the RBAC rulesets are not being enforced, the
system is more vulnerable and the user wants stricter firewall rules.
When RBAC is being enforced, one can relax the firewall and access to
services which are now better protected.  In practice this usually means
allowing only access to some trusted IP(s) on boot before RBAC is turned on.

> 
> Also, I don't see a xt_gradm.c in this patch.
> 

This is part of the grsecurity patch which not only adds the xtable code
but also the RBAC code.  Without the entire RBAC stuff, xt_gradm doesn't
make sense and so it is included with the grsecurity patch to the kernel
and not this patch to xtables-addons.

See: http://grsecurity.net/download_stable.php

> 
> thanks,
> Jan
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


- -- 
Anthony G. Basile, Ph. D.
Chair of Information Technology
D'Youville College
Buffalo, NY 14201
(716) 829-8197
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAky9fC0ACgkQl5yvQNBFVTWZCACfX+x2JtBHJ0m2SpjroQHxzRnc
KQYAoKFli7u3ikP0PcB1uMtty07HyS0P
=RgNX
-----END PGP SIGNATURE-----
