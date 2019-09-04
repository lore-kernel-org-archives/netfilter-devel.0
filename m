Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154B2C3A5A7
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 09:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E73CB2339E
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 09:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfIDJ4C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 05:56:02 -0400
Received: from correo.us.es ([193.147.175.20]:44936 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbfIDJ4C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 05:56:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A6BA7DA70A
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2019 11:55:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9685AFF2C8
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Sep 2019 11:55:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8C5BAB8017; Wed,  4 Sep 2019 11:55:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89823B8004;
        Wed,  4 Sep 2019 11:55:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Sep 2019 11:55:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 68C8C4265A5A;
        Wed,  4 Sep 2019 11:55:56 +0200 (CEST)
Date:   Wed, 4 Sep 2019 11:55:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [conntrack-tools PATCH v2] conntrack: Fix CIDR to mask
 conversion on Big Endian
Message-ID: <20190904095557.oezo2ovlpyps6nqb@salvia>
References: <20190904093732.2486-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904093732.2486-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 04, 2019 at 11:37:32AM +0200, Phil Sutter wrote:
> Code assumed host architecture to be Little Endian. Instead produce a
> proper mask by pushing the set bits into most significant position and
> apply htonl() on the result.
> 
> Fixes: 3f6a2e90936bb ("conntrack: add support for CIDR notation")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
