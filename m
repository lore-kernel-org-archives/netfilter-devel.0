Return-Path: <SRS0=f4Jo=7A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137AFC433E1
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 10:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4FC220787
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 10:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgERKhD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 May 2020 06:37:03 -0400
Received: from correo.us.es ([193.147.175.20]:38664 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgERKhC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 May 2020 06:37:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1B493DA883
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2020 12:37:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0CAAEDA721
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2020 12:37:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 02435DA711; Mon, 18 May 2020 12:37:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F81DDA707;
        Mon, 18 May 2020 12:36:59 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 May 2020 12:36:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E4F5642EF42A;
        Mon, 18 May 2020 12:36:58 +0200 (CEST)
Date:   Mon, 18 May 2020 12:36:58 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laura Garcia Liebana <nevola@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, mattst88@gmail.com,
        devel@zevenet.com
Subject: Re: [PATCH nft] build: fix tentative generation of nft.8 after
 disabled doc
Message-ID: <20200518103658.GA24598@salvia>
References: <20200515163151.GA19398@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515163151.GA19398@nevthink>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 15, 2020 at 06:31:51PM +0200, Laura Garcia Liebana wrote:
> Despite doc generation is disabled, the makefile is trying to build it.
> 
> $ ./configure --disable-man-doc
> $ make
> Making all in doc
> make[2]: Entering directory '/workdir/build-pkg/workdir/doc'
> make[2]: *** No rule to make target 'nft.8', needed by 'all-am'.  Stop.
> make[2]: Leaving directory '/workdir/build-pkg/workdir/doc'
> make[1]: *** [Makefile:479: all-recursive] Error 1
> make[1]: Leaving directory '/workdir/build-pkg/workdir'
> make: *** [Makefile:388: all] Error 2
> 
> Fixes: 4f2813a313ae0 ("build: Include generated man pages in dist tarball")

Applied, thanks.
