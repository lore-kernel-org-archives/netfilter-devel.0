Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96187C2BCA1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 21:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CF7F20868
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 21:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbfFGV7m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 17:59:42 -0400
Received: from mail.us.es ([193.147.175.20]:35848 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729577AbfFGV7m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 17:59:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BF99880768
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 23:59:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC029DA701
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2019 23:59:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A1B4DDA703; Fri,  7 Jun 2019 23:59:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98512DA701;
        Fri,  7 Jun 2019 23:59:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Jun 2019 23:59:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 78A1E4265A2F;
        Fri,  7 Jun 2019 23:59:37 +0200 (CEST)
Date:   Fri, 7 Jun 2019 23:59:37 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Eric Garver <e@erig.me>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v6 0/5] Support intra-transaction rule references
Message-ID: <20190607215937.vrs6ljvgnlagvm27@salvia>
References: <20190607172121.21752-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607172121.21752-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 07, 2019 at 07:21:16PM +0200, Phil Sutter wrote:
> After Pablo's evaluation sequence rework, this series (formerly fixing
> cache updates as well) has shrunken considerably:
> 
> Patch 1 contains a proper fix for that workaround in
> evaluate_cache_add().
> 
> Patch 2 removes the cache-related workaround in tests/json_echo.
> 
> Patches 3 and 4 contain prerequisites for the last one, which actually
> implements the support for referencing rules of the same transation with
> 'index' keyword.

Series applied, thanks Phil.
