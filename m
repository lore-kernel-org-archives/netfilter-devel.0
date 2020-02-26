Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC2EC4BA10
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 13:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD9C324683
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 13:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgBZNeE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 08:34:04 -0500
Received: from correo.us.es ([193.147.175.20]:58944 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbgBZNeE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 08:34:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6468965B05
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 14:33:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57D1ADA3A4
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 14:33:54 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4D5ABDA39F; Wed, 26 Feb 2020 14:33:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6DFC4DA38D;
        Wed, 26 Feb 2020 14:33:52 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Feb 2020 14:33:52 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 459D442EF42A;
        Wed, 26 Feb 2020 14:33:52 +0100 (CET)
Date:   Wed, 26 Feb 2020 14:33:59 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling entries
 in mapping table
Message-ID: <20200226133359.7tpvilhypzsknwgt@salvia>
References: <cover.1582250437.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1582250437.git.sbrivio@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 21, 2020 at 03:04:20AM +0100, Stefano Brivio wrote:
> Patch 1/2 fixes the issue recently reported by Phil on a sequence of
> add/flush/add operations, and patch 2/2 introduces a test case
> covering that.

Applied, thanks.
