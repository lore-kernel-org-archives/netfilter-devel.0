Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A15C76188
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 11:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D75A2145D
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 11:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387582AbfGPLVR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 07:21:17 -0400
Received: from mail.us.es ([193.147.175.20]:44332 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733200AbfGPLVR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 07:21:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BD3F327F8AD
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 13:21:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF19820028
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 13:21:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A4A5618524; Tue, 16 Jul 2019 13:21:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF4771150D8;
        Tue, 16 Jul 2019 13:21:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 13:21:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8C39C4265A2F;
        Tue, 16 Jul 2019 13:21:13 +0200 (CEST)
Date:   Tue, 16 Jul 2019 13:21:13 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/2 nf-next] netfilter: synproxy: fix erroneous tcp mss
 option
Message-ID: <20190716112113.kr3fcvrnqg5xz6wx@salvia>
References: <20190710100556.25307-1-ffmancera@riseup.net>
 <20190710100556.25307-2-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710100556.25307-2-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 10, 2019 at 12:05:57PM +0200, Fernando Fernandez Mancera wrote:
> Now synproxy sends the mss value set by the user on client syn-ack packet
> instead of the mss value that client announced.

Applied to nf.git, thanks Fernando.

Could you also make a backport of this patch? Use kernel 5.1 as
reference, you should take Ibrahim's patch and adapt it to place the
mss_encode in the synproxy_options.
