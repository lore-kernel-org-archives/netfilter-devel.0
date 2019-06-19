Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EDAC31E5B
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 17:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A684C20657
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 17:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfFSRVn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 13:21:43 -0400
Received: from mail.us.es ([193.147.175.20]:34592 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfFSRVn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 13:21:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3527EC1D51
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2019 19:21:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24409DA70C
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2019 19:21:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 19BCDDA702; Wed, 19 Jun 2019 19:21:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E846BDA702;
        Wed, 19 Jun 2019 19:21:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Jun 2019 19:21:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C39014265A2F;
        Wed, 19 Jun 2019 19:21:38 +0200 (CEST)
Date:   Wed, 19 Jun 2019 19:21:38 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] netlink_delinerize: remove network header dep
 for reject statement also in bridge family
Message-ID: <20190619172138.ruzzdkstzkoqhses@salvia>
References: <20190618184359.29760-1-fw@strlen.de>
 <20190618184359.29760-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618184359.29760-2-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 08:43:57PM +0200, Florian Westphal wrote:
> add rule bridge test-bridge input reject with icmp type ...
> 
> is shown as
> 
> ether type ip reject type ...
> 
> i.e., the dependency is not removed.
> 
> Allow dependency removal -- this adds a problem where some icmp types
> will be shortened to 'reject', losing the icmp ipv4 dependency.
> 
> Next patch resolves this problem by disabling short-hand abbreviations
> for bridge reject statements.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
