Return-Path: <SRS0=FqmY=XS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_SBL,URIBL_SBL_A,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E706DC3A5A6
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Sep 2019 09:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BED5220673
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Sep 2019 09:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404358AbfIWJ2F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Sep 2019 05:28:05 -0400
Received: from correo.us.es ([193.147.175.20]:59894 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387962AbfIWJ2F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Sep 2019 05:28:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 725C6E34C5
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Sep 2019 11:28:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5612BFB362
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Sep 2019 11:28:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 538F1ADC4; Mon, 23 Sep 2019 11:28:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACEE7B8011;
        Mon, 23 Sep 2019 11:27:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 23 Sep 2019 11:27:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 56F4342EE38F;
        Mon, 23 Sep 2019 11:27:57 +0200 (CEST)
Date:   Mon, 23 Sep 2019 11:27:56 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH nftables 1/3] src, include: add upstream linenoise source.
Message-ID: <20190923092756.p5563jdmp2wljnex@salvia>
References: <20190921122100.3740-1-jeremy@azazel.net>
 <20190921122100.3740-2-jeremy@azazel.net>
 <nycvar.YFH.7.76.1909212114010.6443@n3.vanv.qr>
 <20190922070924.uzfjofvga3nufulb@salvia>
 <nycvar.YFH.7.76.1909231041310.14433@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1909231041310.14433@n3.vanv.qr>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 23, 2019 at 10:47:40AM +0200, Jan Engelhardt wrote:
> 
> On Sunday 2019-09-22 09:09, Pablo Neira Ayuso wrote:
> 
> >> > src/linenoise.c     | 1201 +++++++++++++++++++++++++++++++++++++++++++
> >> 
> >> That seems like a recipe to end up with stale code. For a distribution,
> >> it's static linking worsened by another degree.
> >> 
> >> (https://fedoraproject.org/wiki/Bundled_Libraries?rd=Packaging:Bundled_Libraries)
> >
> >I thought this is like mini-gmp.c? Are distributors packaging this as
> >a library?
> 
> Yes; No.
> 
> After an update to a static library, a distro would have to rebuild
> dependent packages and then distribute that. Doable, but cumbersome.
> 
> But bundled code evades even that. If there is a problem, all instances
> of the "static library" would need updating. Doable, but even more cumbersome.
> 
> Basically the question is: how is NF going to guarantee that linenoise (or
> mini-gmp for that matter) are always up to date?

It seems to me that mini-gmp.c was designed to be used like we do.

For the linenoise case, given that there's already a package in
Fedora, I'm fine to go for AC_CHECK_LIB([linenoise], ...) and _not_
including the copy in our tree. Probably other distributions might
provide a package soon for this library.
