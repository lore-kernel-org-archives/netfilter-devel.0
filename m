Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974ADC432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 13:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 750BD2070A
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 13:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKUNp0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 08:45:26 -0500
Received: from correo.us.es ([193.147.175.20]:47206 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbfKUNp0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 08:45:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 378FA10FB05
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2019 14:45:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A232DA7B6
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2019 14:45:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1FCD1B8004; Thu, 21 Nov 2019 14:45:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 39834DA4D0;
        Thu, 21 Nov 2019 14:45:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 21 Nov 2019 14:45:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0F28E42EF4E2;
        Thu, 21 Nov 2019 14:45:20 +0100 (CET)
Date:   Thu, 21 Nov 2019 14:45:21 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [arptables PATCH 2/3] Eliminate compiler warning about size
 passed to strncmp()
Message-ID: <20191121134521.f6dl5ny4r3tdl7rl@salvia>
References: <20191121111559.27066-1-phil@nwl.cc>
 <20191121111559.27066-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121111559.27066-3-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 21, 2019 at 12:15:58PM +0100, Phil Sutter wrote:
> Gcc complains about the size being equal to destination size, despite
> the nul character being explicitly set in following line.
> 
> Reduce size by one to make gcc happy. While being at it, drop the
> explicit nul character assignment - it is not needed as the buffer was
> allocated by calloc().
> 
> Fixes: 8f586939999e0 ("fix potential buffer overflows reported by static analysis")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
