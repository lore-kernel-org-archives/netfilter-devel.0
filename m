Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F76C46499
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 18:26:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF409216FD
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 18:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfGES01 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 14:26:27 -0400
Received: from mail.us.es ([193.147.175.20]:49924 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfGES01 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 14:26:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 47273BAE8A
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2019 20:26:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36798DA3F4
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2019 20:26:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2A5E2DA4CA; Fri,  5 Jul 2019 20:26:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3957DA708;
        Fri,  5 Jul 2019 20:26:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Jul 2019 20:26:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CBAAE4265A2F;
        Fri,  5 Jul 2019 20:26:22 +0200 (CEST)
Date:   Fri, 5 Jul 2019 20:26:22 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH libnftnl v2] Add Requires.private field to libnftnl.pc
Message-ID: <20190705182622.dsn6kjrs2yrwsn3g@salvia>
References: <38ab4cd887af863846c651ba8fb2deef0dc770d9.1562315659.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38ab4cd887af863846c651ba8fb2deef0dc770d9.1562315659.git.baruch@tkos.co.il>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 05, 2019 at 11:34:19AM +0300, Baruch Siach wrote:
> From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
> 
> Static linking userspace programs such as nftables against libnftnl
> currently doesn't work out of the box, because libnftnl is linked
> against libmnl, but this isn't expressed in libnftnl pkg-config
> file:
> 
>   CCLD   nft
> [...]/bfin-buildroot-uclinux-uclibc/sysroot/usr/lib/libnftnl.a(table.o): In function `_nft_table_nlmsg_parse':
> table.c:(.text+0x480): undefined reference to `_mnl_attr_parse'
> table.c:(.text+0x492): undefined reference to `_mnl_attr_get_str'
> table.c:(.text+0x4a8): undefined reference to `_mnl_attr_get_u32'
> table.c:(.text+0x4ca): undefined reference to `_mnl_attr_get_u32'
> [...]
> 
> The Libs.private field is specifically designed for such usage:
> 
> From pkg-config documentation:
> 
>   Requires.private:
> 
>     A list of packages required by this package. The difference from
>     Requires is that the packages listed under Requires.private are not
>     taken into account when a flag list is computed for dynamically
>     linked executable (i.e., when --static was not specified). In the
>     situation where each .pc file corresponds to a library,
>     Requires.private shall be used exclusively to specify the
>     dependencies between the libraries.
> 
> Therefore, this patch adds a reference to libmnl in the Requires.private
> field of libnftnl pkg-config file.

Applied, thanks.
