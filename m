Return-Path: <SRS0=NFxu=6Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120AFC47255
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 14:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED6AB206D6
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 14:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbgEKOiC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 May 2020 10:38:02 -0400
Received: from correo.us.es ([193.147.175.20]:47374 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730179AbgEKOiC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 May 2020 10:38:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3DF0C18FD86
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 16:38:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3182B115409
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 16:38:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 24B5A11541A; Mon, 11 May 2020 16:38:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B1641158E3;
        Mon, 11 May 2020 16:37:59 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 May 2020 16:37:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0F27142EF532;
        Mon, 11 May 2020 16:37:59 +0200 (CEST)
Date:   Mon, 11 May 2020 16:37:58 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: flowtable: Add pending bit for offload
 work
Message-ID: <20200511143758.GA24761@salvia>
References: <1588764279-12166-1-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588764279-12166-1-git-send-email-paulb@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 06, 2020 at 02:24:39PM +0300, Paul Blakey wrote:
> Gc step can queue offloaded flow del work or stats work.
> Those work items can race each other and a flow could be freed
> before the stats work is executed and querying it.
> To avoid that, add a pending bit that if a work exists for a flow
> don't queue another work for it.
> This will also avoid adding multiple stats works in case stats work
> didn't complete but gc step started again.

Applied to nf, thanks.
