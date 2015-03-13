From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: propose rewording in manpage
Date: Fri, 13 Mar 2015 21:25:03 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1503132124230.16613@blackhole.kfki.hu>
References: <20150313020019.GA25141@oxygen>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:37776 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbbCMUXO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Mar 2015 16:23:14 -0400
In-Reply-To: <20150313020019.GA25141@oxygen>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 13 Mar 2015, Neutron Soutmun wrote:

> I have prepared the patch which refers to
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=780336,
> reported and proposed by H. Renault <hr@herverenault.fr>.
> 
> man ipset reads:
> 
>     del SETNAME DEL-ENTRY [ DEL-OPTIONS ]
>         Delete an entry from a set. If the -exist option is specified,
>         ipset ignores if the entry does not added to  (already expired
>         from)  the set.
> 
> Proposed rewording:
> 
>         Delete an entry from a set. If the -exist option is specified
>         and the entry is not in the set (maybe already expired), then
>         the command is ignored.
> 
> Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>

Patch is applied, thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
