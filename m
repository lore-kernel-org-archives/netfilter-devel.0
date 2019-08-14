Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DF9C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 13:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94762206C1
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 13:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfHNNZQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 09:25:16 -0400
Received: from correo.us.es ([193.147.175.20]:45236 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727654AbfHNNZQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 09:25:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3D335DA725
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 15:25:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30E7EDA72F
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 15:25:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 267C4DA704; Wed, 14 Aug 2019 15:25:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 14A35DA72F;
        Wed, 14 Aug 2019 15:25:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 15:25:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E22224265A2F;
        Wed, 14 Aug 2019 15:25:10 +0200 (CEST)
Date:   Wed, 14 Aug 2019 15:25:10 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] src: json: support json restore for "th"
 pseudoheader
Message-ID: <20190814132510.5wo7p4fggfmv2gr5@salvia>
References: <20190814113452.13244-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814113452.13244-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 14, 2019 at 01:34:52PM +0200, Florian Westphal wrote:
> Json output could not be restored back by nft because it did
> not recognize the new "th" pseudoheader.
> 
> Fixes: a43a696443a150f44 ("proto: add pseudo th protocol to match d/sport in generic way")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
