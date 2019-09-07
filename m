Return-Path: <SRS0=QWtc=XC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDB3C43331
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Sep 2019 18:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B0EC21835
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Sep 2019 18:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394373AbfIGSwp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Sep 2019 14:52:45 -0400
Received: from correo.us.es ([193.147.175.20]:44710 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394362AbfIGSwp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Sep 2019 14:52:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5418011EB25
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Sep 2019 20:52:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44B5AFF6DE
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Sep 2019 20:52:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2DA92B8019; Sat,  7 Sep 2019 20:52:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09FE7B7FF6;
        Sat,  7 Sep 2019 20:52:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 07 Sep 2019 20:52:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D7E514265A5A;
        Sat,  7 Sep 2019 20:52:38 +0200 (CEST)
Date:   Sat, 7 Sep 2019 20:52:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        wenxu <wenxu@ucloud.cn>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] netfilter: nf_tables: avoid excessive stack
 usage
Message-ID: <20190907185240.goswawbhq4tbmyox@salvia>
References: <20190906151242.1115282-1-arnd@arndb.de>
 <20190907180754.dz7gstqfj7djlbrs@salvia>
 <CAK8P3a04ic_VP6L_=N5P7vfQG1VDV25g3KvUpuCVdX483hx_cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a04ic_VP6L_=N5P7vfQG1VDV25g3KvUpuCVdX483hx_cA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Sep 07, 2019 at 08:41:22PM +0200, Arnd Bergmann wrote:
> On Sat, Sep 7, 2019 at 8:07 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Hi Arnd,
> >
> > On Fri, Sep 06, 2019 at 05:12:30PM +0200, Arnd Bergmann wrote:
> > > The nft_offload_ctx structure is much too large to put on the
> > > stack:
> > >
> > > net/netfilter/nf_tables_offload.c:31:23: error: stack frame size of 1200 bytes in function 'nft_flow_rule_create' [-Werror,-Wframe-larger-than=]
> > >
> > > Use dynamic allocation here, as we do elsewhere in the same
> > > function.
> > >
> > > Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > > Since we only really care about two members of the structure, an
> > > alternative would be a larger rewrite, but that is probably too
> > > late for v5.4.
> >
> > Thanks for this patch.
> >
> > I'm attaching a patch to reduce this structure size a bit. Do you
> > think this alternative patch is ok until this alternative rewrite
> > happens?
> 
> I haven't tried it yet, but it looks like that would save 8 of the
> 48 bytes in each for each of the 24 registers (12 bytes on m68k
> or i386, which only use 4 byte alignment for nft_data), so
> this wouldn't make too much difference.

I'll take your patch as is.

> > Anyway I agree we should to get this structure away from the
> > stack, even after this is still large, so your patch (or a variant of
> > it) will be useful sooner than later I think.
> 
> What I was thinking for a possible smaller fix would be to not
> pass the ctx into the expr->ops->offload callback but
> only pass the 'dep' member. Since I've never seen this code
> before, I have no idea if that would be an improvement
> in the end.

We might need this more fields of this context structure, this code is
very new, still under development, let's revisit this later.

Thanks.
