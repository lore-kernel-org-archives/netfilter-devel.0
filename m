Return-Path: <SRS0=ovZY=5R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B2FC43331
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 10:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 512882078B
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 10:41:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732067AbgDAKlH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 06:41:07 -0400
Received: from correo.us.es ([193.147.175.20]:32834 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgDAKlH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 06:41:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6E5861878A0
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2020 12:41:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D76E100799
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2020 12:41:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 52C9410078F; Wed,  1 Apr 2020 12:41:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3ECEDFA551;
        Wed,  1 Apr 2020 12:41:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 01 Apr 2020 12:40:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2A72D4301DF6;
        Wed,  1 Apr 2020 12:41:03 +0200 (CEST)
Date:   Wed, 1 Apr 2020 12:41:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Luis Ressel <aranea@aixah.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] netlink: Show the handles of unknown rules in "nft
 monitor trace"
Message-ID: <20200401104102.jke6ixvhfwqkz7il@salvia>
References: <20200326152229.5923-1-aranea@aixah.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326152229.5923-1-aranea@aixah.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 26, 2020 at 03:22:29PM +0000, Luis Ressel wrote:
> When "nft monitor trace" doesn't know a rule (because it was only added
> to the ruleset after nft was invoked), that rule is silently omitted in
> the trace output, which can come as a surprise when debugging issues.
> 
> Instead, we can at least show the information we got via netlink, i.e.
> the family, table and chain name, rule handle and verdict.

Applied, thanks.
