From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] Fix adding an IPv4 range containing more than 2^31
 addresses
Date: Tue, 26 Sep 2017 20:45:55 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1709262045160.19429@blackhole.kfki.hu>
References: <1506202660-12553-1-git-send-email-kadlec@blackhole.kfki.hu> <1506202660-12553-2-git-send-email-kadlec@blackhole.kfki.hu> <20170926180136.GA24950@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:42483 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031612AbdIZSp7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2017 14:45:59 -0400
In-Reply-To: <20170926180136.GA24950@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 26 Sep 2017, Pablo Neira Ayuso wrote:

> On Sat, Sep 23, 2017 at 11:37:40PM +0200, Jozsef Kadlecsik wrote:
> > Wrong comparison prevented the hash types to add a range with
> > more than 2^31 addresses but reported as a success.
> > 
> > Fixes bugzilla id #1005, reported by Oleg Serditov and Oliver Ford.
> 
> Applied, thanks Jozsef.
> 
> Jozsef, I'm prepending the following to this patch title: "netfilter: ipset:"

I forgot to add that prefix... Thanks indeed!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
