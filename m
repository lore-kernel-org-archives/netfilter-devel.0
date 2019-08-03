Return-Path: <SRS0=mIA1=V7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F51CC31E40
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Aug 2019 16:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 240F720679
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Aug 2019 16:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387950AbfHCQkF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Aug 2019 12:40:05 -0400
Received: from correo.us.es ([193.147.175.20]:36730 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbfHCQkF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Aug 2019 12:40:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 378B1C39E0
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Aug 2019 18:40:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26656DA704
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Aug 2019 18:40:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1C08FDA72F; Sat,  3 Aug 2019 18:40:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D3FEDA704;
        Sat,  3 Aug 2019 18:40:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 03 Aug 2019 18:40:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.192.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E3F254265A2F;
        Sat,  3 Aug 2019 18:40:00 +0200 (CEST)
Date:   Sat, 3 Aug 2019 18:39:59 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/2 nf-next] netfilter: synproxy: rename mss
 synproxy_options field
Message-ID: <20190803163959.zlcwyoghj7wpwzyv@salvia>
References: <20190710100556.25307-1-ffmancera@riseup.net>
 <20190710100556.25307-3-ffmancera@riseup.net>
 <20190716112243.3zd2xlanmpvp5dbx@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716112243.3zd2xlanmpvp5dbx@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 16, 2019 at 01:22:43PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 10, 2019 at 12:05:59PM +0200, Fernando Fernandez Mancera wrote:
> > After introduce "mss_encode" field in the synproxy_options struct the field
> > "mss" is a little confusing. It has been renamed to "mss_option".
> 
> This patch 2/2 will be sitting in the queue until until nf-next merge
> window opens up again. I'll leave it here in patchwork so I don't
> forget.

Patch is applied, thanks.
