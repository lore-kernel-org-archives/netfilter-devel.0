Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C42C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 19:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E62E20643
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 19:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfCKTEI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 15:04:08 -0400
Received: from mail.us.es ([193.147.175.20]:37716 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbfCKTEH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 15:04:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BBD4718D00E
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 20:04:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6F6F9BAAC2
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 20:04:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 16960DA87F; Mon, 11 Mar 2019 20:03:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 47240DA864;
        Mon, 11 Mar 2019 20:03:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 Mar 2019 20:03:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1B5404265A2F;
        Mon, 11 Mar 2019 20:03:53 +0100 (CET)
Date:   Mon, 11 Mar 2019 20:03:52 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: return immediately on empty
 commit
Message-ID: <20190311190352.y5zxr7pwirc7rbty@salvia>
References: <20190307222011.25091-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190307222011.25091-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 07, 2019 at 11:20:11PM +0100, Florian Westphal wrote:
> When running 'nft flush ruleset' while no rules exist, we will increment
> the generation counter and announce a new genid to userspace, yet
> nothing had changed in the first place.

Applied, thanks Florian.
