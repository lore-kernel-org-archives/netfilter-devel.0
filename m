Return-Path: <SRS0=4amC=5K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFD3C2D0E5
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Mar 2020 20:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3997720740
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Mar 2020 20:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgCYURv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Mar 2020 16:17:51 -0400
Received: from correo.us.es ([193.147.175.20]:40598 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727316AbgCYURv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Mar 2020 16:17:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 690DDDA38B
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2020 21:17:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5DFD3DA788
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2020 21:17:49 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 510ACDA3C4; Wed, 25 Mar 2020 21:17:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7EC7EDA7B2;
        Wed, 25 Mar 2020 21:17:47 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 25 Mar 2020 21:17:47 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5EBF042EF4E2;
        Wed, 25 Mar 2020 21:17:47 +0100 (CET)
Date:   Wed, 25 Mar 2020 21:17:47 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Majd Dibbiny <majd@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] netfilter: flowtable: Use rw sem as flow
 block lock
Message-ID: <20200325201747.sfxquwllbb6bsrbi@salvia>
References: <1585055841-14256-1-git-send-email-paulb@mellanox.com>
 <1585055841-14256-2-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585055841-14256-2-git-send-email-paulb@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 24, 2020 at 03:17:19PM +0200, Paul Blakey wrote:
> Currently flow offload threads are synchronized by the flow block mutex.
> Use rw lock instead to increase flow insertion (read) concurrency.
> 
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
