Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB54BC76192
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 11:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9D40205C9
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 11:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387746AbfGPLYG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 07:24:06 -0400
Received: from mail.us.es ([193.147.175.20]:45636 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387632AbfGPLYG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 07:24:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 375C1E34C6
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 13:24:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28D721150CC
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 13:24:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 285121150CB; Tue, 16 Jul 2019 13:24:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1BEEC91F4;
        Tue, 16 Jul 2019 13:24:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 13:24:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EE7214265A32;
        Tue, 16 Jul 2019 13:24:01 +0200 (CEST)
Date:   Tue, 16 Jul 2019 13:24:01 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laura Garcia Liebana <nevola@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: fix symhash with modulus one
Message-ID: <20190716112401.tutvnmskzbuksdr7@salvia>
References: <20190715112337.gobsm3ljlmgtarnf@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715112337.gobsm3ljlmgtarnf@nevthink>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 15, 2019 at 01:23:37PM +0200, Laura Garcia Liebana wrote:
> The rule below doesn't work as the kernel raises -ERANGE.
> 
> nft add rule netdev nftlb lb01 ip daddr set \
> 	symhash mod 1 map { 0 : 192.168.0.10 } fwd to "eth0"
> 
> This patch allows to use the symhash modulus with one
> element, in the same way that the other types of hashes and
> algorithms that uses the modulus parameter.

Applied, thanks Laura.
