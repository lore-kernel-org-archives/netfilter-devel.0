Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA153C76186
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 19:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BA30229EB
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 19:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbfGWTYE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 15:24:04 -0400
Received: from mail.us.es ([193.147.175.20]:36890 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfGWTYE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 15:24:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2C667F2623
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 21:24:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E56FCE158
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 21:24:02 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 13F50D1911; Tue, 23 Jul 2019 21:24:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20396DA4D1;
        Tue, 23 Jul 2019 21:24:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 23 Jul 2019 21:24:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B70D04265A32;
        Tue, 23 Jul 2019 21:23:59 +0200 (CEST)
Date:   Tue, 23 Jul 2019 21:23:58 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Brett Mastbergen <bmastbergen@untangle.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: Sync comments with current expr definition
Message-ID: <20190723192358.osvd3vysmbcvhui7@salvia>
References: <20190723173649.3855-1-bmastbergen@untangle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723173649.3855-1-bmastbergen@untangle.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 23, 2019 at 01:36:49PM -0400, Brett Mastbergen wrote:
> ops has been removed, and etype has been added

Applied, thanks Brett.
