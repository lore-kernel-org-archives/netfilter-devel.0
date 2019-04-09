Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA438C10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 10:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3EE62084F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 10:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbfDIKVO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 06:21:14 -0400
Received: from mail.us.es ([193.147.175.20]:58420 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfDIKVO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 06:21:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 576DD4A7067
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 12:21:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2301DDA7A1
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 12:21:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 98463DA79E; Tue,  9 Apr 2019 12:21:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 850E1FA53D;
        Tue,  9 Apr 2019 12:21:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Apr 2019 12:21:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 570834265A31;
        Tue,  9 Apr 2019 12:21:07 +0200 (CEST)
Date:   Tue, 9 Apr 2019 12:21:06 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org,
        gregkh@linuxfoundation.org, fhimpe@ai.vub.ac.be, fw@strlen.de
Subject: Re: netfilter fixes for 5.0.7 stable
Message-ID: <20190409102106.aa23i4bdzvbhvoxq@salvia>
References: <20190409101746.ovmtakjy3czzzz5q@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409101746.ovmtakjy3czzzz5q@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 09, 2019 at 12:17:46PM +0200, Pablo Neira Ayuso wrote:
> Hi Sasha,
> 
> Would you mind to cherry-pick these two patches into 5.0.y?
> 
> b8e204006340 ("netfilter: nft_compat: use .release_ops and remove list of extension")

This one too actually, as Florian mentioned:

3f3a390dbd59d2 ("netfilter: nf_tables: use-after-free in dynamic operations")

> b25a31bf0ca0 ("netfilter: nf_tables: add missing ->release_ops() in error path of newrule()")

Thanks.
