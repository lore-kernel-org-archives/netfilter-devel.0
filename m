Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D46DC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Nov 2022 22:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbiKVWNy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 17:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiKVWNx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 17:13:53 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1292832066
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Nov 2022 14:13:50 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 58196CC0112;
        Tue, 22 Nov 2022 23:13:49 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 22 Nov 2022 23:13:47 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 28E43CC0116;
        Tue, 22 Nov 2022 23:13:47 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 24C35343157; Tue, 22 Nov 2022 23:13:47 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 23A89343156;
        Tue, 22 Nov 2022 23:13:47 +0100 (CET)
Date:   Tue, 22 Nov 2022 23:13:47 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] netfilter: ipset: restore allowing 64 clashing
 elements in hash:net,iface
In-Reply-To: <Y30064mEhfsX1xQ1@salvia>
Message-ID: <be565d60-e3b9-327a-7218-780b131bdb@netfilter.org>
References: <20221122191858.1051777-1-kadlec@netfilter.org> <20221122191858.1051777-2-kadlec@netfilter.org> <Y30064mEhfsX1xQ1@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, 22 Nov 2022, Pablo Neira Ayuso wrote:

> On Tue, Nov 22, 2022 at 08:18:58PM +0100, Jozsef Kadlecsik wrote:
> > The patch "netfilter: ipset: enforce documented limit to prevent allocating
> > huge memory" was too strict and prevented to add up to 64 clashing elements
> > to a hash:net,iface type of set. This patch fixes the issue and now the type
> > behaves as documented.
> 
> I have manually applied, this to add the Fixes: tag, upstream 
> maintainers usually require this and it also helps robots to identify 
> patches which should go into -stable.

I forgot to add the Fixes: tag, thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
