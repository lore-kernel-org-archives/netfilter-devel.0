Return-Path: <SRS0=NOIG=XP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2116EC49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 09:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1B4D2086A
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 09:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408526AbfITJg2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 05:36:28 -0400
Received: from correo.us.es ([193.147.175.20]:37872 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405989AbfITJg2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 05:36:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E0A61EBAC3
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 11:36:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D11FFFB362
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 11:36:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C6C532DC79; Fri, 20 Sep 2019 11:36:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9AD92DA4D0;
        Fri, 20 Sep 2019 11:36:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Sep 2019 11:36:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [5.182.56.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 432B14265A5A;
        Fri, 20 Sep 2019 11:36:21 +0200 (CEST)
Date:   Fri, 20 Sep 2019 11:36:21 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Fix add_bitwise_u16() on Big Endian
Message-ID: <20190920093621.w3q36jj2joku43qa@salvia>
References: <20190920093020.458-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920093020.458-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 20, 2019 at 11:30:20AM +0200, Phil Sutter wrote:
> Type used for 'mask' and 'xor' parameters was wrong, 'int' is four bytes
> on 32 or 64 bit architectures. After casting a uint16_t to int, on Big
> Endian the first two bytes of data are (the leading) zero which libnftnl
> then copies instead of the actual value.
> 
> This problem was noticed when using '--fragment' option:
> 
> | # iptables-nft -A FORWARD --fragment -j ACCEPT
> | # nft list ruleset | grep frag-off
> | ip frag-off & 0 != 0 counter packets 0 bytes 0 accept
> 
> With this fix in place, the resulting nft rule is correct:
> 
> | ip frag-off & 8191 != 0 counter packets 0 bytes 0 accept
> 
> Fixes: 2f1fbab671576 ("iptables: nft: add -f support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
