Return-Path: <SRS0=bd9C=D3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5308DC388F2
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 15:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A992B2224B
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 15:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408652AbgJTPUd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Oct 2020 11:20:33 -0400
Received: from correo.us.es ([193.147.175.20]:51128 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408646AbgJTPUd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Oct 2020 11:20:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 78B791761AF
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 17:20:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6BDB1E1506
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 17:20:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 610D7FF134; Tue, 20 Oct 2020 17:20:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C5E8F733A;
        Tue, 20 Oct 2020 17:20:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Oct 2020 17:20:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 136614301DE0;
        Tue, 20 Oct 2020 17:20:29 +0200 (CEST)
Date:   Tue, 20 Oct 2020 17:20:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org
Subject: Re: [PATCH net V2] netfilter: Drop fragmented ndisc packets
 assembled in netfilter
Message-ID: <20201020152028.GA19892@salvia>
References: <20201013122312.8761-1-geokohma@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201013122312.8761-1-geokohma@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 13, 2020 at 02:23:12PM +0200, Georg Kohmann wrote:
> Fragmented ndisc packets assembled in netfilter not dropped as specified
> in RFC 6980, section 5. This behaviour breaks TAHI IPv6 Core Conformance
> Tests v6LC.2.1.22/23, V6LC.2.2.26/27 and V6LC.2.3.18.
> 
> Setting IP6SKB_FRAGMENTED flag during reassembly.

Applied, thanks.
