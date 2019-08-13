Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8105C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 09:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ED1D20663
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 09:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbfHMJ7A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 05:59:00 -0400
Received: from correo.us.es ([193.147.175.20]:35554 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728593AbfHMJ7A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 05:59:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 20D75FC5EC
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 11:58:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FE66DA730
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 11:58:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E7E331150CB; Tue, 13 Aug 2019 11:58:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E81A4DA730;
        Tue, 13 Aug 2019 11:58:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 11:58:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BB08A4265A2F;
        Tue, 13 Aug 2019 11:58:55 +0200 (CEST)
Date:   Tue, 13 Aug 2019 11:58:55 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/netfilter/nf_nat_proto.c - make tables static
Message-ID: <20190813095855.hcxlzzuadvgwfzw7@salvia>
References: <55481.1565243002@turing-police>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <55481.1565243002@turing-police>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 08, 2019 at 01:43:22AM -0400, Valdis Klētnieks wrote:
> Sparse warns about two tables not being declared.
> 
>   CHECK   net/netfilter/nf_nat_proto.c
> net/netfilter/nf_nat_proto.c:725:26: warning: symbol 'nf_nat_ipv4_ops' was not declared. Should it be static?
> net/netfilter/nf_nat_proto.c:964:26: warning: symbol 'nf_nat_ipv6_ops' was not declared. Should it be static?
> 
> And in fact they can indeed be static.

Applied, thanks.
