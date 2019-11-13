Return-Path: <SRS0=8p/T=ZF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC628C432C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 23:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96CD7206DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 23:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfKMXL5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Nov 2019 18:11:57 -0500
Received: from correo.us.es ([193.147.175.20]:39406 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfKMXL5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 18:11:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C9C42EBAC5
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2019 00:11:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2DCED2B1E
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2019 00:11:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A7E12DA3A9; Thu, 14 Nov 2019 00:11:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B37B2DA7B6;
        Thu, 14 Nov 2019 00:11:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Nov 2019 00:11:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8D64542EE38E;
        Thu, 14 Nov 2019 00:11:50 +0100 (CET)
Date:   Thu, 14 Nov 2019 00:11:52 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] segtree: Check ranges when deleting elements
Message-ID: <20191113231152.52n2wh7s672q3nr2@salvia>
References: <20191112191007.9752-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112191007.9752-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 12, 2019 at 08:10:07PM +0100, Phil Sutter wrote:
> Make sure any intervals to delete actually exist, otherwise reject the
> command. Without this, it is possible to mess up rbtree contents:
> 
> | # nft list ruleset
> | table ip t {
> | 	set s {
> | 		type ipv4_addr
> | 		flags interval
> | 		auto-merge
> | 		elements = { 192.168.1.0-192.168.1.254, 192.168.1.255 }
> | 	}
> | }
> | # nft delete element t s '{ 192.168.1.0/24 }'
> | # nft list ruleset
> | table ip t {
> | 	set s {
> | 		type ipv4_addr
> | 		flags interval
> | 		auto-merge
> | 		elements = { 192.168.1.255-255.255.255.255 }
> | 	}
> | }
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
