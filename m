Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D7FC8300A
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 13:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38DFB2076D
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 13:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgD3NIZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:08:25 -0400
Received: from correo.us.es ([193.147.175.20]:55656 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgD3NIY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 09:08:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 23643F258F
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 15:08:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15FCDBAAA1
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 15:08:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 15588DA736; Thu, 30 Apr 2020 15:08:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D599615CF;
        Thu, 30 Apr 2020 15:08:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 Apr 2020 15:08:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 02E6242EFB80;
        Thu, 30 Apr 2020 15:08:20 +0200 (CEST)
Date:   Thu, 30 Apr 2020 15:08:20 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: Re: [PATCH nft] rule: memleak in __do_add_setelems()
Message-ID: <20200430130820.GA11056@salvia>
References: <20200430121845.10388-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430121845.10388-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 30, 2020 at 02:18:45PM +0200, Pablo Neira Ayuso wrote:
> This patch invokes interval_map_decompose() with named sets:
> 
> ==3402== 2,352 (128 direct, 2,224 indirect) bytes in 1 blocks are definitely lost in loss record 9 of 9
> ==3402==    at 0x483577F: malloc (vg_replace_malloc.c:299)
> ==3402==    by 0x48996A8: xmalloc (utils.c:36)
> ==3402==    by 0x4899778: xzalloc (utils.c:65)
> ==3402==    by 0x487CB46: expr_alloc (expression.c:45)
> ==3402==    by 0x487E2A0: mapping_expr_alloc (expression.c:1140)
> ==3402==    by 0x4898AA8: interval_map_decompose (segtree.c:1095)
> ==3402==    by 0x4872BDF: __do_add_setelems (rule.c:1569)
> ==3402==    by 0x4872BDF: __do_add_setelems (rule.c:1559)
> ==3402==    by 0x4877936: do_command (rule.c:2710)
> ==3402==    by 0x489F1CB: nft_netlink.isra.5 (libnftables.c:42)
> ==3402==    by 0x489FB07: nft_run_cmd_from_filename (libnftables.c:508)
> ==3402==    by 0x10A9AA: main (main.c:455)
> 
> Fixes: dd44081d91ce ("segtree: Fix add and delete of element in same batch")

This fixes the problem for anonymous sets, still named sets are
showing a memleak.
