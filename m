Return-Path: <SRS0=eCuo=7L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A297C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 18:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CEF22073B
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 18:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgE2SEa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 May 2020 14:04:30 -0400
Received: from correo.us.es ([193.147.175.20]:36696 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgE2SE3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 May 2020 14:04:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2469D7E4C4
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 20:04:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17664DA712
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 20:04:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0CEA1DA707; Fri, 29 May 2020 20:04:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A14ADA707;
        Fri, 29 May 2020 20:04:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 20:04:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6B07E42EE38E;
        Fri, 29 May 2020 20:04:25 +0200 (CEST)
Date:   Fri, 29 May 2020 20:04:25 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     Romain Bellan <romain.bellan@wifirst.fr>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v5 1/1] netfilter: ctnetlink: add kernel side
 filtering for dump
Message-ID: <20200529180425.GA30992@salvia>
References: <20200330204637.11472-1-romain.bellan@wifirst.fr>
 <20200426214338.GA2276@salvia>
 <66100a4b-a879-a8f4-f684-2b098a89cdc8@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66100a4b-a879-a8f4-f684-2b098a89cdc8@wifirst.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Just a followed up after including your ctnetlink update in the last
upstream pull request for net-next.

I think you already mentioned, but it should be possible to extend
the conntrack utility to support for kernel side filtering seamlessly.

The idea is to keep the userspace filtering as a fallback, regardless
the kernel supports for CTA_FILTER or not.

I'm missing one feature in the CTA_FILTER, that is the netmask
filtering for IP addresses. It would be also good to make this fit
into libnetfilter_conntrack.

Probably this patch can be extended to include two objects, the
conntrack object that represents the exact matching (values) and
another one that represent the mask:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200129094719.670-1-romain.bellan@wifirst.fr/

The mask object would only work for the IP address and mark.

Probably rename NFCT_FILTER_DUMP_TUPLE to NFCT_FILTER_DUMP, which
would provide the most generic version to request kernel side
filtering.

Thanks.
