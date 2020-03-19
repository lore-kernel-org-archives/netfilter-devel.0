Return-Path: <SRS0=bD7Q=5E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7B2C4332B
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Mar 2020 20:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C75EA206D7
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Mar 2020 20:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgCSUEM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Mar 2020 16:04:12 -0400
Received: from correo.us.es ([193.147.175.20]:51552 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbgCSUEM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 16:04:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AB5B111EB90
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2020 21:03:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9AC71FC5E4
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2020 21:03:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 901ADFC5E7; Thu, 19 Mar 2020 21:03:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B85F1FC5EC;
        Thu, 19 Mar 2020 21:03:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Mar 2020 21:03:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9BC0D42EFB80;
        Thu, 19 Mar 2020 21:03:37 +0100 (CET)
Date:   Thu, 19 Mar 2020 21:04:08 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Majd Dibbiny <majd@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: flowtable: Fix flushing of offloaded
 flows on free
Message-ID: <20200319200408.4pnbiesdphbq6asp@salvia>
References: <1584611545-926-1-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584611545-926-1-git-send-email-paulb@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 19, 2020 at 11:52:25AM +0200, Paul Blakey wrote:
> Freeing a flowtable with offloaded flows, the flow are deleted from
> hardware but are not deleted from the flow table, leaking them,
> and leaving their offload bit on.
> 
> Add a second pass of the disabled gc to delete the these flows from
> the flow table before freeing it.

Applied, thanks.
