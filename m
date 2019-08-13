Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 023B8C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 15:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAFA920578
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 15:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfHMPyR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 11:54:17 -0400
Received: from correo.us.es ([193.147.175.20]:47588 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbfHMPyR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 11:54:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18AA6DA738
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 17:54:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0BC05519E5
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 17:54:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 018BCDA7E1; Tue, 13 Aug 2019 17:54:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B8A7576C8;
        Tue, 13 Aug 2019 17:54:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 17:54:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D6C3A4265A32;
        Tue, 13 Aug 2019 17:54:12 +0200 (CEST)
Date:   Tue, 13 Aug 2019 17:54:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dirk Morris <dmorris@metaloft.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net v3] Use consistent ct id hash calculation
Message-ID: <20190813155412.vygqqdo5fhn2ldfj@salvia>
References: <51ae3971-1374-c8d0-e848-6574a5cdf4c1@metaloft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ae3971-1374-c8d0-e848-6574a5cdf4c1@metaloft.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 08, 2019 at 01:57:51PM -0700, Dirk Morris wrote:
> Change ct id hash calculation to only use invariants.
> 
> Currently the ct id hash calculation is based on some fields that can
> change in the lifetime on a conntrack entry in some corner cases. The
> current hash uses the whole tuple which contains an hlist pointer
> which will change when the conntrack is placed on the dying list
> resulting in a ct id change.
> 
> This patch also removes the reply-side tuple and extension pointer
> from the hash calculation so that the ct id will will not change from
> initialization until confirmation.

Applied, thanks Dirk.
