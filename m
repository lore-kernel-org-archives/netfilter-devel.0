From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/4] ipset patches for nf-next
Date: Mon, 18 Sep 2017 20:31:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1709182030370.29725@blackhole.kfki.hu>
References: <1505159560-13161-1-git-send-email-kadlec@blackhole.kfki.hu> <20170918123052.GA28702@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:45409 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753928AbdIRSbt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2017 14:31:49 -0400
In-Reply-To: <20170918123052.GA28702@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Mon, 18 Sep 2017, Pablo Neira Ayuso wrote:

> On Mon, Sep 11, 2017 at 09:52:36PM +0200, Jozsef Kadlecsik wrote:
> > Hi Pablo,
> > 
> > Here follows a few ipset patches for the nf-next tree:
> > 
> > * Merge assignment and simplify return in a fuction by Simran Singhal
> > * Fix a sparse warning from me
> > * Deduplicate prefixlen maps by Aaron Conole
> > * Fix the outdated element counter for sets with timeout by Vishwanath Pai
> 
> Let me take 4/4 to nf.git as a fix, so we don't wait for one month for
> this to show up.
> 
> I will take from 1/4 to 3/4 to nf-next. You can either send me a new 
> pull request for this or I can just include your Signed-off-by: tag in 
> those patches when applying them.

Please just include my tag

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
