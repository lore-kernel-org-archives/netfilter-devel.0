Return-Path: <SRS0=Rfup=U7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CEAC06510
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 18:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1401E206A3
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jul 2019 18:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfGBSKT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 14:10:19 -0400
Received: from mail.us.es ([193.147.175.20]:36300 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbfGBSKT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 14:10:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D07781228C3
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Jul 2019 20:10:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C270A10219C
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Jul 2019 20:10:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B8055DA732; Tue,  2 Jul 2019 20:10:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BFA53CE158;
        Tue,  2 Jul 2019 20:10:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 02 Jul 2019 20:10:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 63F0A4265A2F;
        Tue,  2 Jul 2019 20:10:15 +0200 (CEST)
Date:   Tue, 2 Jul 2019 20:10:14 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Set socket receive buffer
Message-ID: <20190702181014.ybjhgjkraloxmcy2@salvia>
References: <20190702172615.t4lwms6zu4acq63e@salvia>
 <20190702180319.18459-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702180319.18459-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 02, 2019 at 08:03:19PM +0200, Phil Sutter wrote:
> When trying to delete user-defined chains in a large ruleset,
> iptables-nft aborts with "No buffer space available". This can be
> reproduced using the following script:
> 
> | #! /bin/bash
> | iptables-nft-restore <(
> |
> | echo "*filter"
> | for i in $(seq 0 200000);do
> |         printf ":chain_%06x - [0:0]\n" $i
> | done
> | for i in $(seq 0 200000);do
> |         printf -- "-A INPUT -j chain_%06x\n" $i
> |         printf -- "-A INPUT -j chain_%06x\n" $i
> | done
> | echo COMMIT
> |
> | )
> | iptables-nft -X
> 
> The problem seems to be the sheer amount of netlink error messages sent
> back to user space (one EBUSY for each chain). To solve this, set
> receive buffer size depending on number of commands sent to kernel.

LGTM. One more change, make sure you reset:

        nlbuffsiz = 0

from nft_restart().

Thanks.

P.S: It would be good a follow up to place this global variables into
the nft_handle object at some point.
