Return-Path: <SRS0=Os75=56=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 118E0C2BB1D
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Apr 2020 22:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4D062074D
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Apr 2020 22:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633677AbgDNWyf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Apr 2020 18:54:35 -0400
Received: from correo.us.es ([193.147.175.20]:36062 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729551AbgDNWye (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Apr 2020 18:54:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EB6E7172C87
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2020 00:54:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE887FF6FC
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2020 00:54:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D3E9AFF6F2; Wed, 15 Apr 2020 00:54:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0CD28DA736;
        Wed, 15 Apr 2020 00:54:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 15 Apr 2020 00:54:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D700B4301DE0;
        Wed, 15 Apr 2020 00:54:30 +0200 (CEST)
Date:   Wed, 15 Apr 2020 00:54:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, Jiri Pirko <jiri@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net] netfilter: flowtable: Free block_cb when being
 deleted
Message-ID: <20200414225430.a5zsluo6pzsvdvcn@salvia>
References: <20200412084547.2217-1-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412084547.2217-1-roid@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Apr 12, 2020 at 11:45:47AM +0300, Roi Dayan wrote:
> Free block_cb memory when asked to be deleted.

Applied, thanks.
