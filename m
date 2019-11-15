Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20825C432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 21:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9A5D20729
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 21:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfKOVyz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 16:54:55 -0500
Received: from correo.us.es ([193.147.175.20]:33948 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbfKOVyz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 16:54:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9AC89EBAC2
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 22:54:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 885FFCA0F3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 22:54:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7E077DA72F; Fri, 15 Nov 2019 22:54:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62FE1DA4CA;
        Fri, 15 Nov 2019 22:54:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Nov 2019 22:54:49 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 40CBA4251481;
        Fri, 15 Nov 2019 22:54:49 +0100 (CET)
Date:   Fri, 15 Nov 2019 22:54:50 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org
Subject: Re: libnftnl: NFTA_FLOWTABLE_SIZE missing from kernel uapi headers
Message-ID: <20191115215450.uu6tu2b4q7nbbrtw@salvia>
References: <20191115150233.fnlhnlbn2k6qvqwi@egarver>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115150233.fnlhnlbn2k6qvqwi@egarver>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 15, 2019 at 10:02:33AM -0500, Eric Garver wrote:
> Hi Pablo,
> 
> libnftnl commit cdaea7f1ced0 ("flowtable: allow to specify size") added
> the enum value NFTA_FLOWTABLE_SIZE, but this was not first added to the
> kernel. As such, libnftnl's header and the kernel are out of sync.
> 
> Since then, NFTA_FLOWTABLE_FLAGS has been added to the kernel. This
> means NFTA_FLOWTABLE_SIZE in libnftnl and NFTA_FLOWTABLE_FLAGS in the
> kernel have the same enum value.
> 
> Luckily NFTA_FLOWTABLE_FLAGS was just recently added to -next, so we
> should be able to fix this without too much headache.

Thanks a lot for reminding me about this issue:

https://patchwork.ozlabs.org/patch/1195873/
