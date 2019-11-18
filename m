Return-Path: <SRS0=asLr=ZK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9521EC432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 18:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ED31222C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 18:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfKRSnT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 13:43:19 -0500
Received: from correo.us.es ([193.147.175.20]:52590 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbfKRSnT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 13:43:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18BFB4DE74E
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 19:43:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09AD4A7EC1
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 19:43:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F3497DA72F; Mon, 18 Nov 2019 19:43:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06A5FA7EC0;
        Mon, 18 Nov 2019 19:43:13 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 19:43:13 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CA7C542EE38E;
        Mon, 18 Nov 2019 19:43:12 +0100 (CET)
Date:   Mon, 18 Nov 2019 19:43:14 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/2] files: Install sample scripts from files/examples
Message-ID: <20191118184314.f5tqtff3vydizs5p@salvia>
References: <20191107114516.9258-1-phil@nwl.cc>
 <20191107114516.9258-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107114516.9258-2-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 07, 2019 at 12:45:16PM +0100, Phil Sutter wrote:
> Assuming these are still relevant and useful as a source of inspiration,
> install them into DATAROOTDIR/doc/nftables/examples.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
