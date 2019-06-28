Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0915C4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 19:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62C23206A2
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 19:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="i42UUsJt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfF1TMN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 15:12:13 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:57753 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfF1TMN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 15:12:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 028F5CC00FA;
        Fri, 28 Jun 2019 21:12:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1561749126; x=1563563527; bh=PYw/VKHLk2
        YKkn9vKpXsKg+6NQ8EB5iCN0C4nF3A8N0=; b=i42UUsJtUawy0DyIZorBIpMsp2
        iu0NjnETH02nl1Axf0s73ZeIMV5yMZbnetrD7Mk0vrQRWRkJnNMUE9FnpBvxmp0J
        bHuFeQlfJ7dsK9+/t/UipPF0V92fd9BMCZObjXfdHMNZASTaRHi+NLy8Rac0ehvR
        NqdxhwUUsaWl/cHHE=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 28 Jun 2019 21:12:06 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id CDFB4CC00F9;
        Fri, 28 Jun 2019 21:12:05 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id A67602062A; Fri, 28 Jun 2019 21:12:05 +0200 (CEST)
Date:   Fri, 28 Jun 2019 21:12:05 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     Stefano Brivio <sbrivio@redhat.com>
cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Chen Yi <yiche@redhat.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/2] ipset: Two fixes for destination MAC address matches
 in ip,mac types
In-Reply-To: <cover.1561381646.git.sbrivio@redhat.com>
Message-ID: <alpine.DEB.2.20.1906282109420.21094@blackhole.kfki.hu>
References: <cover.1561381646.git.sbrivio@redhat.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Mon, 24 Jun 2019, Stefano Brivio wrote:

> Commit 8cc4ccf58379 ("ipset: Allow matching on destination MAC address for
> mac and ipmac sets"), ipset.git commit 1543514c46a7, properly allows
> destination matching for hash:mac set types, but missed to remove the
> previous restriction for type hash:ip,mac and introduced an obvious mistake
> in both bitmap:ip,mac and hash:ip,mac.
> 
> Drop the left-over check and correct the mistake, to fix the issue reported
> by Chen Yi.
> 
> Stefano Brivio (2):
>   ipset: Actually allow destination MAC address for hash:ip,mac sets too
>   ipset: Copy the right MAC address in bitmap:ip,mac and hash:ip,mac
>     sets
> 
>  kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 +-
>  kernel/net/netfilter/ipset/ip_set_hash_ipmac.c   | 6 +-----
>  2 files changed, 2 insertions(+), 6 deletions(-)

Both patches are applied, thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
