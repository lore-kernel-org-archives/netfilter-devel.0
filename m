Return-Path: <SRS0=mmf4=EG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E18C388F7
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Oct 2020 15:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE9BC22284
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Oct 2020 15:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgJaPs5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 31 Oct 2020 11:48:57 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:41303 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgJaPs5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 31 Oct 2020 11:48:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 7B6F96740196;
        Sat, 31 Oct 2020 16:48:55 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sat, 31 Oct 2020 16:48:53 +0100 (CET)
Received: from localhost.kfki.hu (host-94-248-219-124.kabelnet.hu [94.248.219.124])
        (Authenticated sender: kadlecsik.jozsef@wigner.mta.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id 44A976740184;
        Sat, 31 Oct 2020 16:48:53 +0100 (CET)
Received: by localhost.kfki.hu (Postfix, from userid 1000)
        id 9F7F430095C; Sat, 31 Oct 2020 16:48:52 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by localhost.kfki.hu (Postfix) with ESMTP id 9C83A3000D3;
        Sat, 31 Oct 2020 16:48:52 +0100 (CET)
Date:   Sat, 31 Oct 2020 16:48:52 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@localhost
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] netfilter: ipset: Update byte and packet counters
 regardless of whether they match
In-Reply-To: <20201031101348.GA1459@salvia>
Message-ID: <alpine.DEB.2.23.453.2010311648180.23561@localhost>
References: <20201029153949.6567-1-kadlec@netfilter.org> <20201029153949.6567-2-kadlec@netfilter.org> <20201031101348.GA1459@salvia>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sat, 31 Oct 2020, Pablo Neira Ayuso wrote:

> On Thu, Oct 29, 2020 at 04:39:46PM +0100, Jozsef Kadlecsik wrote:
> > From: Stefano Brivio <sbrivio@redhat.com>
> > 
> > In ip_set_match_extensions(), for sets with counters, we take care of
> > updating counters themselves by calling ip_set_update_counter(), and of
> > checking if the given comparison and values match, by calling
> > ip_set_match_counter() if needed.
> > 
> > However, if a given comparison on counters doesn't match the configured
> > values, that doesn't mean the set entry itself isn't matching.
> > 
> > This fix restores the behaviour we had before commit 4750005a85f7
> > ("netfilter: ipset: Fix "don't update counters" mode when counters used
> > at the matching"), without reintroducing the issue fixed there: back
> > then, mtype_data_match() first updated counters in any case, and then
> > took care of matching on counters.
> > 
> > Now, if the IPSET_FLAG_SKIP_COUNTER_UPDATE flag is set,
> > ip_set_update_counter() will anyway skip counter updates if desired.
> > 
> > The issue observed is illustrated by this reproducer:
> > 
> >   ipset create c hash:ip counters
> >   ipset add c 192.0.2.1
> >   iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP
> > 
> > if we now send packets from 192.0.2.1, bytes and packets counters
> > for the entry as shown by 'ipset list' are always zero, and, no
> > matter how many bytes we send, the rule will never match, because
> > counters themselves are not updated.
> 
> If possible, let me split this batch.
> 
> I'll apply this fix (1/4) to nf.git instead, so this shows up in
> 5.10 swiftly.
> 
> My understanding is that 2/4, 3/4 and 4/4 have no dependency on this
> one, so I'll apply these three remaining patches in the batch to
> nf-next.git

Yes, it's better that way. Thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
