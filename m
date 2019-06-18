Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F24C31E5D
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 15:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65DF420873
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 15:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbfFRPEu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 11:04:50 -0400
Received: from mail.us.es ([193.147.175.20]:33554 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729242AbfFRPEt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 11:04:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 01E61B5AA5
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 17:04:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5625DA709
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 17:04:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DA913DA707; Tue, 18 Jun 2019 17:04:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6DA2DA70B;
        Tue, 18 Jun 2019 17:04:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 17:04:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C487E4265A2F;
        Tue, 18 Jun 2019 17:04:43 +0200 (CEST)
Date:   Tue, 18 Jun 2019 17:04:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Igor Ryzhov <iryzhov@nfware.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix ct_sip_walk_headers
Message-ID: <20190618150443.pnztovpsbfxjc6fc@salvia>
References: <20190605093240.23212-1-iryzhov@nfware.com>
 <20190617222507.tzizsd6dfxm6zozs@salvia>
 <CAF+s_Fx=b07S54_Nr7PpKjHYtwkf55Tw+WztZks5SZXtkxWLHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+s_Fx=b07S54_Nr7PpKjHYtwkf55Tw+WztZks5SZXtkxWLHg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 12:51:13PM +0300, Igor Ryzhov wrote:
> Hi Pablo,
> 
> This issue can be seen in the scenario when there are multiple
> Contact headers and the first one is using a hostname and other
> headers use IP addresses. In this case, ct_sip_walk_headers will
> work the following way:
> 
> The first ct_sip_get_header call to will find the first Contact header
> but will return -1 as the header uses a hostname. But matchoff will
> be changed to the offset of this header. After that, dataoff should be
> set to matchoff, so that the next ct_sip_get_header call find the next
> Contact header. But instead of assigning dataoff to matchoff, it is
> incremented by it, which is not correct, as matchoff is an absolute
> value of the offset. So on the next call to the ct_sip_get_header,
> dataoff will be incorrect, and the next Contact header may not be
> found at all.

Thanks for explaining. Would you resubmit a v2 including this
description in the patch?

Thanks.
