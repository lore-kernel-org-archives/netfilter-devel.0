Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745B4C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Dec 2021 22:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358527AbhLFWoN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Dec 2021 17:44:13 -0500
Received: from mail.netfilter.org ([217.70.188.207]:36060 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358629AbhLFWnF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Dec 2021 17:43:05 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3CC6E605BE;
        Mon,  6 Dec 2021 23:37:13 +0100 (CET)
Date:   Mon, 6 Dec 2021 23:39:29 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH] build: bump libnetfilter_log dependency
Message-ID: <Ya6RISt0Yiw+w/f5@salvia>
References: <20211204205600.3570672-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211204205600.3570672-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Dec 04, 2021 at 08:56:00PM +0000, Jeremy Sowden wrote:
> Recent changes to add conntrack info to the NFLOG output plug-in rely on
> symbols only present in the headers provided by libnetfilter-log v1.0.2:
> 
>     CC       ulogd_inppkt_NFLOG.lo
>   ulogd_inppkt_NFLOG.c: In function 'build_ct':
>   ulogd_inppkt_NFLOG.c:346:34: error: 'NFULA_CT' undeclared (first use in this function); did you mean 'NFULA_GID'?
>      if (mnl_attr_get_type(attr) == NFULA_CT) {
>                                     ^~~~~~~~
>                                     NFULA_GID
>   ulogd_inppkt_NFLOG.c:346:34: note: each undeclared identifier is reported only once for each function it appears in
>   ulogd_inppkt_NFLOG.c: In function 'start':
>   ulogd_inppkt_NFLOG.c:669:12: error: 'NFULNL_CFG_F_CONNTRACK' undeclared (first use in this function); did you mean 'NFULNL_CFG_F_SEQ'?
>      flags |= NFULNL_CFG_F_CONNTRACK;
>               ^~~~~~~~~~~~~~~~~~~~~~
>               NFULNL_CFG_F_SEQ
> 
> Bump the pkg-config version accordingly.

Applied, thanks
