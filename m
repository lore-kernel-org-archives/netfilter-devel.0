Return-Path: <SRS0=M1Ox=YC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FB1C47404
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Oct 2019 09:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E0A220B7C
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Oct 2019 09:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbfJIJcf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Oct 2019 05:32:35 -0400
Received: from correo.us.es ([193.147.175.20]:59146 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbfJIJcf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Oct 2019 05:32:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B3AE31291835
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2019 11:32:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A727F4C3BF
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2019 11:32:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9CD77DA4CA; Wed,  9 Oct 2019 11:32:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 062DBB8014;
        Wed,  9 Oct 2019 11:32:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Oct 2019 11:32:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D12C041E4800;
        Wed,  9 Oct 2019 11:32:28 +0200 (CEST)
Date:   Wed, 9 Oct 2019 11:32:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v3 03/11] nft: Extract cache routines into
 nft-cache.c
Message-ID: <20191009093230.2papknaxzr5gjrdu@salvia>
References: <20191008161447.6595-1-phil@nwl.cc>
 <20191008161447.6595-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008161447.6595-4-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 08, 2019 at 06:14:39PM +0200, Phil Sutter wrote:
> The amount of code dealing with caching only is considerable and hence
> deserves an own source file.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
