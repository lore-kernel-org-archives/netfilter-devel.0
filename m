Return-Path: <SRS0=lkya=TV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534CDC04AAF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 18:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3326B2173C
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 18:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbfEUSLa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 May 2019 14:11:30 -0400
Received: from mail.us.es ([193.147.175.20]:49516 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbfEUSLa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 May 2019 14:11:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 13FFEEA469
        for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2019 20:11:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0555CDA709
        for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2019 20:11:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ED2EEDA70E; Tue, 21 May 2019 20:11:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9F37DA702;
        Tue, 21 May 2019 20:11:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 May 2019 20:11:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A47C54265A32;
        Tue, 21 May 2019 20:11:25 +0200 (CEST)
Date:   Tue, 21 May 2019 20:11:25 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     fw@strlen.de, shuah@kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] selftests: netfilter: missing error check when
 setting up veth interface
Message-ID: <20190521181125.anqj32v3gcwjxs3z@salvia>
References: <20190515064405.3981-1-jeffrin@rajagiritech.edu.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515064405.3981-1-jeffrin@rajagiritech.edu.in>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 15, 2019 at 12:14:04PM +0530, Jeffrin Jose T wrote:
> A test for  the basic NAT functionality uses ip command which
> needs veth device.There is a condition where the kernel support
> for veth is not compiled into the kernel and the test script
> breaks.This patch contains code for reasonable error display
> and correct code exit.

Applied, thanks.
