Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01367C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Jul 2022 06:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiGNGJH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Jul 2022 02:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbiGNGI7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Jul 2022 02:08:59 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C7D1125
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Jul 2022 23:08:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 88F54CC00F3;
        Thu, 14 Jul 2022 08:08:49 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 14 Jul 2022 08:08:47 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 0CB4FCC00EA;
        Thu, 14 Jul 2022 08:08:47 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id F19CD3431DE; Thu, 14 Jul 2022 08:08:46 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id EFF00343155;
        Thu, 14 Jul 2022 08:08:46 +0200 (CEST)
Date:   Thu, 14 Jul 2022 08:08:46 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Vishwanath Pai <vpai@akamai.com>
cc:     pablo@netfilter.org, fw@strlen.de, johunt@akamai.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: ipset list may return wrong member
 count on bitmap types
In-Reply-To: <b7264c2a-dc7e-dd60-ee04-f2cd87ec761a@akamai.com>
Message-ID: <5e494928-aeb8-2b71-d28e-1f4aad7c38e@netfilter.org>
References: <20220629212109.3045794-1-vpai@akamai.com> <73de8f7a-365-ef8c-77fa-52c6ad94cde@netfilter.org> <b7264c2a-dc7e-dd60-ee04-f2cd87ec761a@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 13 Jul 2022, Vishwanath Pai wrote:

> On 7/12/22 17:06, Jozsef Kadlecsik wrote:
> > 
> > On Wed, 29 Jun 2022, Vishwanath Pai wrote:
> > 
> >> We fixed a similar problem before in commit 7f4f7dd4417d ("netfilter:
> >> ipset: ipset list may return wrong member count for set with timeout").
> >> The same issue exists in ip_set_bitmap_gen.h as well.
> > 
> > Could you rework the patch to solve the issue the same way as for the hash 
> > types (i.e. scanning the set without locking) like in the commit 
> > 33f08da28324 (netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" 
> > reports)? I know the bitmap types have got a limited size but it'd be 
> > great if the general method would be the same across the different types.
>
> Sure, I'll give it a try. It might take me a bit longer cause it looks like a
> complex set of changes.

I meant not the whole commit 33f08da28324, of course there is no need for 
region locking at the bitmap types. Just to count non-expired elements 
(and extension size) so that it's a reader function and doesn't need 
locking.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
