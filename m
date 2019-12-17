Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCFEC2D0BF
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 21:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 316C82082E
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 21:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfLQVjv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 16:39:51 -0500
Received: from correo.us.es ([193.147.175.20]:34836 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbfLQVju (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 16:39:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 87CAEC481F
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 22:39:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7CB44DA701
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 22:39:47 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 724FBDA710; Tue, 17 Dec 2019 22:39:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 779E1DA703;
        Tue, 17 Dec 2019 22:39:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 22:39:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5977C4265A5A;
        Tue, 17 Dec 2019 22:39:45 +0100 (CET)
Date:   Tue, 17 Dec 2019 22:39:45 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCHv2 nf-next 2/5] netfilter: nft_tunnel: add the missing
 ERSPAN_VERSION nla_policy
Message-ID: <20191217213945.5ti7ktxc725emec3@salvia>
References: <cover.1576226965.git.lucien.xin@gmail.com>
 <7bcaa9e0507fa9a5b6a48f56768a179281bf4ab2.1576226965.git.lucien.xin@gmail.com>
 <20191214082630.GB5926@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191214082630.GB5926@netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Dec 14, 2019 at 09:26:31AM +0100, Simon Horman wrote:
> On Fri, Dec 13, 2019 at 04:53:06PM +0800, Xin Long wrote:
> > ERSPAN_VERSION is an attribute parsed in kernel side, nla_policy
> > type should be added for it, like other attributes.
> > 
> > Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
> 
> Is this really a fix?

I think so. Netlink attribute validation for
NFTA_TUNNEL_KEY_ERSPAN_VERSION is missing.
