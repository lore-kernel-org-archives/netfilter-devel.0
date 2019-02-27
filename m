Return-Path: <SRS0=q2Xo=RC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F84C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 09:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CAAE20643
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 09:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbfB0Jyd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Feb 2019 04:54:33 -0500
Received: from mail.us.es ([193.147.175.20]:46638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbfB0Jyd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Feb 2019 04:54:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BBC8F4DA720
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Feb 2019 10:54:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9FC7DA876
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Feb 2019 10:54:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9F484DA86A; Wed, 27 Feb 2019 10:54:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7AC0DA796;
        Wed, 27 Feb 2019 10:54:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 27 Feb 2019 10:54:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8A0664265A2F;
        Wed, 27 Feb 2019 10:54:29 +0100 (CET)
Date:   Wed, 27 Feb 2019 10:54:29 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4 nf-next 0/9] netfilter: nat: merge ipv4 and ipv6 nat
 modules
Message-ID: <20190227095429.jfxlqy2v7ulihtkx@salvia>
References: <20190219163828.26607-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219163828.26607-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 19, 2019 at 05:38:18PM +0100, Florian Westphal wrote:
> This series merges ipv4 and ipv6 nat functionality into the nat core.
> 
> This simplifies code, avoids indirect calls and it makes it possible
> to implement NAT support for the nft inet family as a followup.

Series applied, thanks Florian.
