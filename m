Return-Path: <SRS0=xASF=3C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A97C33CAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 15:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E43C0207FD
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 15:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgAMPXN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jan 2020 10:23:13 -0500
Received: from correo.us.es ([193.147.175.20]:36310 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727494AbgAMPXM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 10:23:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5B3B7C515D
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 16:23:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4ACBCDA710
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 16:23:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3FF06DA70E; Mon, 13 Jan 2020 16:23:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27C7FDA716;
        Mon, 13 Jan 2020 16:23:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 Jan 2020 16:23:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0A76D42EF52A;
        Mon, 13 Jan 2020 16:23:08 +0100 (CET)
Date:   Mon, 13 Jan 2020 16:23:07 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] monitor: Fix output for ranges in anonymous sets
Message-ID: <20200113152307.hgfvycka4666gqis@salvia>
References: <20200113135911.22740-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113135911.22740-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 13, 2020 at 02:59:11PM +0100, Phil Sutter wrote:
> Previous fix for named interval sets was simply wrong: Instead of
> limiting decomposing to anonymous interval sets, it effectively disabled
> it entirely.
> 
> Since code needs to check for both interval and anonymous bits
> separately, introduce set_is_interval() helper to keep the code
> readable.
> 
> Also extend test case to assert ranges in anonymous sets are correctly
> printed by echo or monitor modes. Without this fix, range boundaries are
> printed as individual set elements.
> 
> Fixes: 5d57fa3e99bb9 ("monitor: Do not decompose non-anonymous sets")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
