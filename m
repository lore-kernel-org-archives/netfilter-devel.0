Return-Path: <SRS0=suf1=VM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F560C76195
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 17:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8BC1206B8
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 17:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731732AbfGORds (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 13:33:48 -0400
Received: from mail.us.es ([193.147.175.20]:58640 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731574AbfGORds (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 13:33:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A0BF662326
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 19:33:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9446C203F3
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 19:33:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 86916DA732; Mon, 15 Jul 2019 19:33:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 585CB6DA95;
        Mon, 15 Jul 2019 19:33:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Jul 2019 19:33:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 29EFB4265A31;
        Mon, 15 Jul 2019 19:33:42 +0200 (CEST)
Date:   Mon, 15 Jul 2019 19:33:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laura Garcia <nevola@gmail.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Subject: Re: linux-next: Tree for Jul 15 (HEADERS_TEST w/ netfilter tables
 offload)
Message-ID: <20190715173341.zth4na7zekjsesaa@salvia>
References: <20190715144848.4cc41e07@canb.auug.org.au>
 <ccb5b818-c191-2d9e-311f-b2c79b7f6823@infradead.org>
 <CAF90-WirEMg7arNOTmo+tyJ20rt_zeN=nr0OO6Qk0Ss8J4QrUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF90-WirEMg7arNOTmo+tyJ20rt_zeN=nr0OO6Qk0Ss8J4QrUA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 15, 2019 at 07:28:04PM +0200, Laura Garcia wrote:
> CC'ing netfilter.
> 
> On Mon, Jul 15, 2019 at 6:45 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> >
> > On 7/14/19 9:48 PM, Stephen Rothwell wrote:
> > > Hi all,
> > >
> > > Please do not add v5.4 material to your linux-next included branches
> > > until after v5.3-rc1 has been released.
> > >
> > > Changes since 20190712:
> > >
> >
> > Hi,
> >
> > I am seeing these build errors from HEADERS_TEST (or KERNEL_HEADERS_TEST)
> > for include/net/netfilter/nf_tables_offload.h.s:
> >
> >   CC      include/net/netfilter/nf_tables_offload.h.s
[...]
> > Should this header file not be tested?

Yes, it should indeed be added.
