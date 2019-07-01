Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C50EC0650E
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 18:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36CD42146F
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 18:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfGASXT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 14:23:19 -0400
Received: from mail.us.es ([193.147.175.20]:52838 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfGASXS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 14:23:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1D1F96EF3F
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2019 20:23:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D7A9DA4D0
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2019 20:23:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 032F8DA708; Mon,  1 Jul 2019 20:23:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A7D5DA708;
        Mon,  1 Jul 2019 20:23:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 01 Jul 2019 20:23:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DAC6A4265A2F;
        Mon,  1 Jul 2019 20:23:13 +0200 (CEST)
Date:   Mon, 1 Jul 2019 20:23:13 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 1/3] nft: don't use xzalloc()
Message-ID: <20190701182313.s73hnmyrkg5krgfq@salvia>
References: <156197834773.14440.15033673835278456059.stgit@endurance>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156197834773.14440.15033673835278456059.stgit@endurance>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 01, 2019 at 12:52:48PM +0200, Arturo Borrero Gonzalez wrote:
> In the current setup, nft (the frontend object) is using the xzalloc() function
> from libnftables, which does not makes sense, as this is typically an internal
> helper function.
> 
> In order to don't use this public libnftables symbol (a later patch just
> removes it), let's use calloc() directly in the nft frontend.

Applied, thanks Arturo.
