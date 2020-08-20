Return-Path: <SRS0=xTVu=B6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0633C433E3
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 12:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB4AB207FB
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 12:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgHTMOa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Aug 2020 08:14:30 -0400
Received: from correo.us.es ([193.147.175.20]:54764 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729840AbgHTMOO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Aug 2020 08:14:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1FF8B1C41C9
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 14:14:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11308DA798
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 14:14:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C7305DA78A; Thu, 20 Aug 2020 14:14:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0D77DA722;
        Thu, 20 Aug 2020 14:14:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Aug 2020 14:14:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CEE4B42EE38E;
        Thu, 20 Aug 2020 14:14:08 +0200 (CEST)
Date:   Thu, 20 Aug 2020 14:14:08 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: conntrack: allow sctp hearbeat after
 connection re-use
Message-ID: <20200820121408.GA25211@salvia>
References: <20200818141558.24232-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818141558.24232-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 18, 2020 at 04:15:58PM +0200, Florian Westphal wrote:
> If an sctp connection gets re-used, heartbeats are flagged as invalid
> because their vtag doesn't match.
> 
> Handle this in a similar way as TCP conntrack when it suspects that the
> endpoints and conntrack are out-of-sync.
> 
> When a HEARTBEAT request fails its vtag validation, flag this in the
> conntrack state and accept the packet.
> 
> When a HEARTBEAT_ACK is received with an invalid vtag in the reverse
> direction after we allowed such a HEARTBEAT through, assume we are
> out-of-sync and re-set the vtag info.
> 
> v2: remove left-over snippet from an older incarnation that moved
>     new_state/old_state assignments, thats not needed so keep that
>     as-is.

Applied, thanks.
