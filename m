Return-Path: <SRS0=AKzi=VV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAD3C7618B
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jul 2019 09:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63CD2229F3
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jul 2019 09:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfGXJhg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jul 2019 05:37:36 -0400
Received: from mail.us.es ([193.147.175.20]:35926 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbfGXJhg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 05:37:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E4A1AFC5EE
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jul 2019 11:37:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF6E95765B
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jul 2019 11:37:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CE507202B8; Wed, 24 Jul 2019 11:37:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DBFDDDA704;
        Wed, 24 Jul 2019 11:37:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 24 Jul 2019 11:37:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 787A540705C3;
        Wed, 24 Jul 2019 11:37:31 +0200 (CEST)
Date:   Wed, 24 Jul 2019 11:37:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] net: netfilter: nft_meta_bridge: Eliminate 'out'
 label
Message-ID: <20190724093728.irqg7f52pbimlrgp@salvia>
References: <20190723132753.13781-1-phil@nwl.cc>
 <20190723132753.13781-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723132753.13781-2-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 23, 2019 at 03:27:53PM +0200, Phil Sutter wrote:
> The label is used just once and the code it points at is not reused, no
> point in keeping it.

Also applied, thanks.
