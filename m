Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C735FC76196
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 11:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A91C52145D
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 11:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387649AbfGPLTF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 07:19:05 -0400
Received: from mail.us.es ([193.147.175.20]:43038 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733067AbfGPLTF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 07:19:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1F91920A528
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 13:19:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D72F115104
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 13:19:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0AE941150DE; Tue, 16 Jul 2019 13:19:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EB999DA4D1;
        Tue, 16 Jul 2019 13:19:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 13:19:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B8D644265A5B;
        Tue, 16 Jul 2019 13:19:00 +0200 (CEST)
Date:   Tue, 16 Jul 2019 13:19:00 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Christian Hesse <mail@eworm.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] netfilter: nf_tables: fix module autoload for redir
Message-ID: <20190716111900.znfgycp3lvhkg26s@salvia>
References: <20190710233112.3652-1-mail@eworm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710233112.3652-1-mail@eworm.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 11, 2019 at 01:31:12AM +0200, Christian Hesse wrote:
> Fix expression for autoloading.

Applied, thanks.
