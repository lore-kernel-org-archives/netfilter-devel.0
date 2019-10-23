Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5F4CA9EB9
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 20:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47FDB20679
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 20:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388677AbfJWUly (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:41:54 -0400
Received: from correo.us.es ([193.147.175.20]:41670 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732293AbfJWUlx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 16:41:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6173BE8639
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 22:41:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51ED1CA0F3
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 22:41:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 476E8CA0F1; Wed, 23 Oct 2019 22:41:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 106C7DA801;
        Wed, 23 Oct 2019 22:41:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 23 Oct 2019 22:41:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E1FE241E4802;
        Wed, 23 Oct 2019 22:41:46 +0200 (CEST)
Date:   Wed, 23 Oct 2019 22:41:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Use ARRAY_SIZE() macro in nft_strerror()
Message-ID: <20191023204149.vushra6ipmjqqd7c@salvia>
References: <20191018155114.7423-1-phil@nwl.cc>
 <20191023112024.gd4dqe6qqv46hufe@salvia>
 <20191023112311.qrglbzhqad4vfqvo@salvia>
 <20191023121627.GM26123@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023121627.GM26123@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 23, 2019 at 02:16:27PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Wed, Oct 23, 2019 at 01:23:11PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Oct 23, 2019 at 01:20:24PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Oct 18, 2019 at 05:51:14PM +0200, Phil Sutter wrote:
> > > > Variable 'table' is an array of type struct table_struct, so this is a
> > > > classical use-case for ARRAY_SIZE() macro.
> > > > 
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > 
> > > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > BTW, probably good to add the array check?
> > 
> > https://sourceforge.net/p/libhx/libhx/ci/master/tree/include/libHX/defs.h#l152
> 
> Copying from kernel sources, do you think that's fine?
> 
> |  #      ifndef ARRAY_SIZE
> | -#              define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
> | +#              define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:(-!!(e)); }))
> | +#              define __same_type(a, b) \
> | +                       __builtin_types_compatible_p(typeof(a), typeof(b))
> | +/*             &a[0] degrades to a pointer: a different type from an array */
> | +#              define __must_be_array(a) \
> | +                       BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
> | +#              define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x))) + __must_be_array(x)
> |  #      endif

At quick glance I would say that's fine.
