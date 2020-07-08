Return-Path: <SRS0=D3ak=AT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A03C433E1
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jul 2020 16:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B82A32078D
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jul 2020 16:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730637AbgGHQMv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jul 2020 12:12:51 -0400
Received: from correo.us.es ([193.147.175.20]:50106 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730471AbgGHQMu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jul 2020 12:12:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3B9FA1BFA8F
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2020 18:12:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B199DA722
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2020 18:12:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1DF9EDA793; Wed,  8 Jul 2020 18:12:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30EC7DA72F;
        Wed,  8 Jul 2020 18:12:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jul 2020 18:12:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 094194265A32;
        Wed,  8 Jul 2020 18:12:46 +0200 (CEST)
Date:   Wed, 8 Jul 2020 18:12:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Andrew Sy Kim <kim.andrewsy@gmail.com>
Cc:     Julian Anastasov <ja@ssi.bg>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCHv2 net-next] ipvs: queue delayed work to expire no
 destination connections if expire_nodest_conn=1
Message-ID: <20200708161245.GB14873@salvia>
References: <alpine.LFD.2.23.451.2007081847310.3373@ja.home.ssi.bg>
 <20200708160618.13013-1-kim.andrewsy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708160618.13013-1-kim.andrewsy@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 08, 2020 at 12:06:18PM -0400, Andrew Sy Kim wrote:
> When expire_nodest_conn=1 and a destination is deleted, IPVS does not
> expire the existing connections until the next matching incoming packet.
> If there are many connection entries from a single client to a single
> destination, many packets may get dropped before all the connections are
> expired (more likely with lots of UDP traffic). An optimization can be
> made where upon deletion of a destination, IPVS queues up delayed work
> to immediately expire any connections with a deleted destination. This
> ensures any reused source ports from a client (within the IPVS timeouts)
> are scheduled to new real servers instead of silently dropped.

Is this the same patch ?

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200708135854.28944-1-kim.andrewsy@gmail.com/

Julian has "Signed-off-by:" previous patch and this v2 does not say
what has been updated.

Thanks.
