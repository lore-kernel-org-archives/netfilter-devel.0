Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F88C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 033A3206E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:59:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="tlk7Qpmo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfDZQ7q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:59:46 -0400
Received: from smtp-out.kfki.hu ([148.6.0.46]:50617 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfDZQ7q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 12:59:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id BE91C3C800D7;
        Fri, 26 Apr 2019 18:59:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1556297980; x=1558112381; bh=5W1Xnoa0qz
        vIR6JNeR0Fu72PMYhT7IYR4cdIGDsqmKs=; b=tlk7Qpmoty6R+iNd+lzzU3j2FT
        AI+TCY1nhunnuoaDtwHC6VQvzMa1uGiRa2DDVYMl8KYsKWVQLiB3k4w5N0qd9dAX
        Tgu+WoFXpnI31rHwdaEj53HWpFms3aelRjHBUoYKulKG0BD6J+vihcdtY3uSkB1d
        NFCotTzhgkXkwFEaQ=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 26 Apr 2019 18:59:40 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp1.kfki.hu (Postfix) with ESMTP id ACE033C800D2;
        Fri, 26 Apr 2019 18:59:39 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 52A98211B0; Fri, 26 Apr 2019 18:59:39 +0200 (CEST)
Date:   Fri, 26 Apr 2019 18:59:39 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     Michal Kubecek <mkubecek@suse.cz>
cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] ipset: drop ipset_nest_start() and
 ipset_nest_end()
In-Reply-To: <c3ece29a62e1b35fa715e38f7dafb68b80e0057d.1556269635.git.mkubecek@suse.cz>
Message-ID: <alpine.DEB.2.20.1904261857520.27824@blackhole.kfki.hu>
References: <cover.1556269635.git.mkubecek@suse.cz> <c3ece29a62e1b35fa715e38f7dafb68b80e0057d.1556269635.git.mkubecek@suse.cz>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 26 Apr 2019, Michal Kubecek wrote:

> After the previous commit, both ipset_nest_start() and ipset_nest_end() are
> just aliases for nla_nest_start() and nla_nest_end() so that there is no
> need to keep them.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> ---
>  include/linux/netfilter/ipset/ip_set.h  | 11 ++++-------
>  net/netfilter/ipset/ip_set_bitmap_gen.h | 14 +++++++-------
>  net/netfilter/ipset/ip_set_hash_gen.h   | 14 +++++++-------
>  net/netfilter/ipset/ip_set_list_set.c   | 14 +++++++-------
>  4 files changed, 25 insertions(+), 28 deletions(-)

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
