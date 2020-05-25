Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DADB2C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 20:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B92102071A
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 20:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgEYUEV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 16:04:21 -0400
Received: from correo.us.es ([193.147.175.20]:34404 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgEYUEV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 16:04:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 602F3F7A8A
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 22:04:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5087DDA714
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 22:04:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 44AE5DA712; Mon, 25 May 2020 22:04:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3AF86DA705;
        Mon, 25 May 2020 22:04:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 May 2020 22:04:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1E86F42EFB80;
        Mon, 25 May 2020 22:04:16 +0200 (CEST)
Date:   Mon, 25 May 2020 22:04:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Matt Turner <mattst88@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] build: Fix doc build, restore A2X assignment for
 doc/Makefile
Message-ID: <20200525200415.GA14991@salvia>
References: <8ef909eedea05cdd3072bea59d664e3a52e28dcd.1590320436.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ef909eedea05cdd3072bea59d664e3a52e28dcd.1590320436.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 24, 2020 at 02:59:36PM +0200, Stefano Brivio wrote:
> Commit 4f2813a313ae ("build: Include generated man pages in dist
> tarball") skips AC_CHECK_PROG for A2X altogether if doc/nft.8 is
> already present.

> 
> Now, starting from a clean situation, we can have this sequence:
>   ./configure	# doc/nft.8 not there, A2X set in doc/Makefile
>   make		# builds doc/nft.8
>   ./configure	# doc/nft.8 is there, A2X left empty in doc/Makefile
>   make clean	# removes doc/nft.8
>   make
> 
> resulting in:
> 
>   [...]
>     GEN      nft.8
>   /bin/sh: -L: command not found
>   make[2]: *** [Makefile:639: nft.8] Error 127
>
> and the only way to get out of this is to issue ./configure again
> after make clean, which is rather unexpected.
> 
> Instead of skipping AC_CHECK_PROG when doc/nft.8 is present, keep
> it and simply avoid returning failure if a2x(1) is not available but
> doc/nft.8 was built, so that A2X is properly set in doc/Makefile
> whenever needed.

Applied, thanks.
