Return-Path: <SRS0=A3Nh=UF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A79C28D1C
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 09:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97CB72083E
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 09:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfFFJVn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 05:21:43 -0400
Received: from mail.us.es ([193.147.175.20]:37908 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727540AbfFFJVn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 05:21:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1F911C424B
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2019 11:21:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12FABDA707
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2019 11:21:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0875DDA711; Thu,  6 Jun 2019 11:21:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0BC8CDA709;
        Thu,  6 Jun 2019 11:21:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 06 Jun 2019 11:21:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DA61B4265A32;
        Thu,  6 Jun 2019 11:21:38 +0200 (CEST)
Date:   Thu, 6 Jun 2019 11:21:38 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nft PATCH v5 03/10] libnftables: Drop cache in error case
Message-ID: <20190606092138.o5wwfszss2rf56pf@salvia>
References: <20190604173158.1184-1-phil@nwl.cc>
 <20190604173158.1184-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604173158.1184-4-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 04, 2019 at 07:31:51PM +0200, Phil Sutter wrote:
> If a transaction is rejected by the kernel (for instance due to a
> semantic error), cache contents are potentially invalid. Release the
> cache in that case to avoid the inconsistency.
> 
> The problem is easy to reproduce in an interactive session:
> 
> | nft> list ruleset
> | table ip t {
> | 	chain c {
> | 	}
> | }
> | nft> flush ruleset; add rule ip t c accept
> | Error: No such file or directory
> | flush ruleset; add rule ip t c accept
> |                            ^
> | nft> list ruleset
> | nft>

Also applied, thanks Phil.
