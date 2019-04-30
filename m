Return-Path: <SRS0=Ro/3=TA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585D3C43219
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 10:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 293D721670
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 10:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfD3Kwd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 06:52:33 -0400
Received: from mail.us.es ([193.147.175.20]:40260 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727463AbfD3Kwc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 06:52:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 29FEDE7BAB
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 12:52:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 19811DA79F
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 12:52:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1317EDA79B; Tue, 30 Apr 2019 12:52:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F618DA701;
        Tue, 30 Apr 2019 12:52:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Apr 2019 12:52:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CBC7F4265A31;
        Tue, 30 Apr 2019 12:52:25 +0200 (CEST)
Date:   Tue, 30 Apr 2019 12:52:25 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     shuah <shuah@kernel.org>,
        Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>,
        linu-kselftest@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] selftests : netfilter: Wrote a error and exit code for a
 command which needed veth kernel module.
Message-ID: <20190430105225.bu5pil5fjxkltu4q@salvia>
References: <20190405163126.7278-1-jeffrin@rajagiritech.edu.in>
 <20190405164746.pfc6wxj4nrynjma4@breakpoint.cc>
 <CAG=yYwnN37OoL1DSN8qPeKWhzVJOcUFtR-7Q9fVT5AULk5S54w@mail.gmail.com>
 <c4660969-1287-0697-13c0-e598327551fb@kernel.org>
 <20190430100256.mfgerggoccagi2hc@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430100256.mfgerggoccagi2hc@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cc'ing netfilter-devel@vger.kernel.org

On Tue, Apr 30, 2019 at 12:02:56PM +0200, Florian Westphal wrote:
> shuah <shuah@kernel.org> wrote:
> > Would you like me to take this patch through ksleftest tree?
> 
> Please do, this patch is neither in nf nor nf-next and it looks fine to
> me.

Indeed, thanks.
