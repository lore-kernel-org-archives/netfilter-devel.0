Return-Path: <SRS0=Ar4o=WT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E27C3A5A2
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Aug 2019 12:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C366C21897
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Aug 2019 12:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbfHWMew (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Aug 2019 08:34:52 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:43515 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbfHWMew (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Aug 2019 08:34:52 -0400
Received: from [31.4.212.198] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <pablo@gnumonks.org>)
        id 1i18mD-0006om-6W; Fri, 23 Aug 2019 14:34:51 +0200
Date:   Fri, 23 Aug 2019 14:34:42 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_ftp: Fix debug output
Message-ID: <20190823123442.366wk6yoyct4b35m@salvia>
References: <20190821141428.cjb535xrhpgry5zd@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821141428.cjb535xrhpgry5zd@intra2net.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Thomas,

On Wed, Aug 21, 2019 at 04:14:28PM +0200, Thomas Jarosch wrote:
> The find_pattern() debug output was printing the 'skip' character.
> This can be a NULL-byte and messes up further pr_debug() output.
> 
> Output without the fix:
> kernel: nf_conntrack_ftp: Pattern matches!
> kernel: nf_conntrack_ftp: Skipped up to `<7>nf_conntrack_ftp: find_pattern `PORT': dlen = 8
> kernel: nf_conntrack_ftp: find_pattern `EPRT': dlen = 8
> 
> Output with the fix:
> kernel: nf_conntrack_ftp: Pattern matches!
> kernel: nf_conntrack_ftp: Skipped up to 0x0 delimiter!
> kernel: nf_conntrack_ftp: Match succeeded!
> kernel: nf_conntrack_ftp: conntrack_ftp: match `172,17,0,100,200,207' (20 bytes at 4150681645)
> kernel: nf_conntrack_ftp: find_pattern `PORT': dlen = 8

Do you use this debugging? I haven't use it for years.

Asking because an alternative patch would be to remove this.
