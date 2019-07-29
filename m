Return-Path: <SRS0=chdK=V2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C4CC7618B
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 13:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29EAF2070B
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 13:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387531AbfG2NSh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 09:18:37 -0400
Received: from correo.us.es ([193.147.175.20]:40752 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387402AbfG2NSh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 09:18:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E8426114561
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jul 2019 15:18:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB5759D563
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jul 2019 15:18:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D0FE4961C5; Mon, 29 Jul 2019 15:18:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E3267203F3;
        Mon, 29 Jul 2019 15:18:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 29 Jul 2019 15:18:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.40.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A7FA74265A31;
        Mon, 29 Jul 2019 15:18:33 +0200 (CEST)
Date:   Mon, 29 Jul 2019 15:18:32 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/2] nft: Set errno in nft_rule_flush()
Message-ID: <20190729131831.mkrfs4lhyhj36snd@salvia>
References: <20190725151914.28723-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725151914.28723-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 25, 2019 at 05:19:13PM +0200, Phil Sutter wrote:
> When trying to flush a non-existent chain, errno gets set in
> nft_xtables_config_load(). That is an unintended side-effect and when
> support for xtables.conf is later removed, iptables-nft will emit the
> generic "Incompatible with this kernel." error message instead of "No
> chain/target/match by that name." as it should.

Applied, thanks Phil.
