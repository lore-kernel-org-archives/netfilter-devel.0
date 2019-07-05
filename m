Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F03C46499
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 18:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2630121670
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 18:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfGESHy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 14:07:54 -0400
Received: from mail.us.es ([193.147.175.20]:46482 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfGESHy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 14:07:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 26239BAE86
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2019 20:07:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1604EDA4D0
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2019 20:07:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0B7F7DA732; Fri,  5 Jul 2019 20:07:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B235DDA7B6;
        Fri,  5 Jul 2019 20:07:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Jul 2019 20:07:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8F8AF4265A31;
        Fri,  5 Jul 2019 20:07:49 +0200 (CEST)
Date:   Fri, 5 Jul 2019 20:07:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?iso-8859-1?Q?St=E9phane?= Veyret <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables v4 1/1] add ct expectations support
Message-ID: <20190705180749.fku5r3tnt4jzskpp@salvia>
References: <20190605092818.13844-1-sveyret@gmail.com>
 <20190605092818.13844-2-sveyret@gmail.com>
 <20190702231247.qoqcq5lynsb4xs5h@salvia>
 <CAFs+hh6TcVM1HbK=iZF5vfSnnGYdtpSTTy=DR3LizSgkuYQghA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFs+hh6TcVM1HbK=iZF5vfSnnGYdtpSTTy=DR3LizSgkuYQghA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stéphane,

On Thu, Jul 04, 2019 at 08:48:50PM +0200, Stéphane Veyret wrote:
> Le mer. 3 juil. 2019 à 01:12, Pablo Neira Ayuso <pablo@netfilter.org> a écrit :
> > Please, make sure you run ./configure with --with-json.
> 
> I'm sorry, but I don't manage to compile it anymore.
> 
> I took latest versions of kernel/lib/nft and merged my modifications
> to nft. But when I try to compile nft, even if the configure goes
> well, the make fails. The message is that it needs libnftnl > 1.1.3
> whereas configure only requires version 1.1.1, and the lib creates a
> package with version 1.1.2.

Make sure you install a fresh libnftnl from git.netfilter.org.

> If I cheat (and update the libnftnl.pc
> file by hand), then make fails later, when compiling libnftables.c
> with the following messages :
> libnftables.c:112:14: warning: data definition has no type or storage class
>  EXPORT_SYMBOL(nft_ctx_add_include_path);
>               ^
> libnftables.c:112:15: warning: type defaults to ‘int’ in declaration
> of « nft_ctx_add_include_path » [-Wimplicit-int]
>  EXPORT_SYMBOL(nft_ctx_add_include_path);
>                ^~~~~~~~~~~~~~~~~~~~~~~~
> libnftables.c:112:15: error: « nft_ctx_add_include_path » redeclared
> as different kind of symbol
> In file included from libnftables.c:9:
> ../include/nftables/libnftables.h:76:5: note: previous definition of «
> nft_ctx_add_include_path » was here
>  int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path);
>      ^~~~~~~~~~~~~~~~~~~~~~~~
> libnftables.c:113:5: warning: no previous prototype for function «
> nft_ctx_add_include_path » [-Wmissing-prototypes]
>  int nft_ctx_add_include_path(struct nft_ctx *ctx, const char *path)
>      ^~~~~~~~~~~~~~~~~~~~~~~~
> 
> Does someone have a clue ?

From the nftables tree, after pulling latest changes from
git.netfilter.org, run:

        autoreconf -fi

before ./configure.
