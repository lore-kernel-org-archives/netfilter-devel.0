From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/4] netfilter fixes for 3.4-rc7
Date: Wed, 16 May 2012 20:41:51 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1205162037110.2742@blackhole.kfki.hu>
References: <1336996023-20249-1-git-send-email-pablo@netfilter.org> <20120514.185607.1967456974676336550.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:59798 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760344Ab2EPSlz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 May 2012 14:41:55 -0400
In-Reply-To: <20120514.185607.1967456974676336550.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

On Mon, 14 May 2012, David Miller wrote:

> From: pablo@netfilter.org
> Date: Mon, 14 May 2012 13:46:59 +0200
> 
> > * One fix for possible timeout overflow for ipset, from Jozsef
> >   Kadlecsik.
> > 
> > * One fix to ensure that hash size is correct, again for ipset
> >   from Jozsef Kadlecsik.
> > 
> > * Removal of redundant include in xt_CT from Eldad Zack.
> > 
> > * Fix for wrong usage of MODULE_ALIAS_NFCT_HELPER in nf_ct_h323
> >   helper from myself.
> 
> I don't consider any of these appropriate this late in the -RC
> series.
> 
> They don't fix major regressions seen by many users.

Could at least the patch with the subject

   netfilter: ipset: fix hash size checking in kernel

   The hash size must fit both into u32 (jhash) and the max value of
   size_t. The missing checking could lead to kernel crash, bug reported
   by Seblu.

be submitted into 3.4-rc7? Any non most-recent ipset package compiled with 
gcc-4.7 or above can trigger the bug.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
