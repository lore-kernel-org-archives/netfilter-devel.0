Return-Path: <SRS0=ovZY=5R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBA6C2D0F0
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E86920784
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732877AbgDAQB2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 12:01:28 -0400
Received: from correo.us.es ([193.147.175.20]:49696 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732651AbgDAQB2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 12:01:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3C8DDE8628
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2020 18:01:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2F105132C91
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2020 18:01:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 23BCE132C90; Wed,  1 Apr 2020 18:01:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 519F5132C81;
        Wed,  1 Apr 2020 18:01:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 01 Apr 2020 18:01:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2A36C4301DE0;
        Wed,  1 Apr 2020 18:01:24 +0200 (CEST)
Date:   Wed, 1 Apr 2020 18:01:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laura Garcia Liebana <nevola@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: add hashing expressions description
Message-ID: <20200401160123.6k5czeajfuoxqq7q@salvia>
References: <20200401154813.GA12209@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401154813.GA12209@nevthink>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 01, 2020 at 05:48:13PM +0200, Laura Garcia Liebana wrote:
> The hashing expressions jhash and symhash are missing in the
> nft manual.

Applied, thanks.
