Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79685C432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 08:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A5E62082F
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 08:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731830AbfIYI6L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 04:58:11 -0400
Received: from correo.us.es ([193.147.175.20]:53450 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730048AbfIYI6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 04:58:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C21D01F0D1A
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 10:57:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD41BD2B1F
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2019 10:57:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AC706DA4D0; Wed, 25 Sep 2019 10:57:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA785D1DBB;
        Wed, 25 Sep 2019 10:57:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 25 Sep 2019 10:57:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 81C384265A5A;
        Wed, 25 Sep 2019 10:57:55 +0200 (CEST)
Date:   Wed, 25 Sep 2019 10:57:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laura Garcia Liebana <nevola@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf] netfilter: nf_tables: bogus EBUSY when deleting
 flowtable after flush
Message-ID: <20190925085757.r45vxotb6eoxkywq@salvia>
References: <20190924124244.3wrbb5ba7nc6cj2o@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924124244.3wrbb5ba7nc6cj2o@nevthink>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 24, 2019 at 02:42:44PM +0200, Laura Garcia Liebana wrote:
> The deletion of a flowtable after a flush in the same transaction
> results in EBUSY. This patch adds an activation and deactivation of
> flowtables in order to update the _use_ counter.

Applied, thanks Laura.
