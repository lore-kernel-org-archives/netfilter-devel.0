Return-Path: <SRS0=7PQj=WB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ADBEC433FF
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Aug 2019 09:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8837F20880
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Aug 2019 09:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfHEJbE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Aug 2019 05:31:04 -0400
Received: from correo.us.es ([193.147.175.20]:57644 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbfHEJbE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Aug 2019 05:31:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 92F7CFB389
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Aug 2019 11:31:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 82B8C64497
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Aug 2019 11:31:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4BDD8A8EF; Mon,  5 Aug 2019 11:31:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E283909D1;
        Mon,  5 Aug 2019 11:30:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 05 Aug 2019 11:30:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 78E7F4265A2F;
        Mon,  5 Aug 2019 11:30:57 +0200 (CEST)
Date:   Mon, 5 Aug 2019 11:30:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, steffen.klassert@secunet.com
Subject: Re: [PATCH nf 2/2] netfilter: nf_flow_table: fix offload for flows
 that are subject to xfrm
Message-ID: <20190805093053.cajawrvnbgmczclm@salvia>
References: <20190730125719.23553-1-fw@strlen.de>
 <20190730125719.23553-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730125719.23553-2-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 30, 2019 at 02:57:19PM +0200, Florian Westphal wrote:
> This makes the previously added 'encap test' pass.
> Because its possible that the xfrm dst entry becomes stale while such
> a flow is offloaded, we need to call dst_check() -- the notifier that
> handles this for non-tunneled traffic isn't sufficient, because SA or
> or policies might have changed.
> 
> If dst becomes stale the flow offload entry will be tagged for teardown
> and packets will be passed to 'classic' forwarding path.
> 
> Removing the entry right away is problematic, as this would
> introduce a race condition with the gc worker.
> 
> In case flow is long-lived, it could eventually be offloaded again
> once the gc worker removes the entry from the flow table.

Also applied, thanks.
