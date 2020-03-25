Return-Path: <SRS0=4amC=5K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A57CC43331
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Mar 2020 10:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2424C2077D
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Mar 2020 10:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgCYKzW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Mar 2020 06:55:22 -0400
Received: from correo.us.es ([193.147.175.20]:51682 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgCYKzV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Mar 2020 06:55:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4D936F2DF6
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2020 11:54:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40880FC5F2
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2020 11:54:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 357AAFC5F1; Wed, 25 Mar 2020 11:54:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 230DBFC5E5;
        Wed, 25 Mar 2020 11:54:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 25 Mar 2020 11:54:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F398642EF42A;
        Wed, 25 Mar 2020 11:54:40 +0100 (CET)
Date:   Wed, 25 Mar 2020 11:55:17 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Majd Dibbiny <majd@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: flowtable: Fix accessing null dst
 entry
Message-ID: <20200325105517.exoasd3vbzx2r3qh@salvia>
References: <1585133608-25295-1-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585133608-25295-1-git-send-email-paulb@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 25, 2020 at 12:53:28PM +0200, Paul Blakey wrote:
> Unlink nft flow table flows, flows from act_ct tables don't have route,
> and so don't have a dst_entry. nf_flow_rule_match() tries to deref
> this null dst_entry regardless.
> 
> Fix that by checking for dst entry exists, and if not, skip
> tunnel match.

This is fixed in nf-next:

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/

I'll get this merged into net-next asap.
