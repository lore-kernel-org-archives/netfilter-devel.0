Return-Path: <SRS0=F+rW=57=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8399BC2BA19
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Apr 2020 09:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61BAB2074F
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Apr 2020 09:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895595AbgDOJd1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Apr 2020 05:33:27 -0400
Received: from correo.us.es ([193.147.175.20]:48472 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895564AbgDOJd0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Apr 2020 05:33:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7171F20A52D
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2020 11:33:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F192179E45
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2020 11:33:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 519E0179E37; Wed, 15 Apr 2020 11:33:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64DEA179E2D;
        Wed, 15 Apr 2020 11:33:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 15 Apr 2020 11:33:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 374B042EE38E;
        Wed, 15 Apr 2020 11:33:22 +0200 (CEST)
Date:   Wed, 15 Apr 2020 11:33:21 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     manojbm@codeaurora.org
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        sharathv@qti.qualcomm.com, ssaha@qti.qualcomm.com,
        vidulak@qti.qualcomm.com, manojbm@qti.qualcomm.com,
        subashab@codeaurora.org, Sauvik Saha <ssaha@codeaurora.org>
Subject: Re: [PATCH] idletimer extension :  Add alarm timer option
Message-ID: <20200415093321.sct4lk6pagu5gjcz@salvia>
References: <20200415072411.20950-1-manojbm@codeaurora.org>
 <20200415075954.bujipzq2xorbit36@salvia>
 <5680a2662bb24d61b7714edb3ad23950@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5680a2662bb24d61b7714edb3ad23950@codeaurora.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 15, 2020 at 02:08:53PM +0530, manojbm@codeaurora.org wrote:
[...]
> Can you please give me more details on how to include Maciej commit here.

Wrong commit, sorry:

commit bc9fe6143de5df8fb36cf1532b48fecf35868571
Author: Maciej Żenczykowski <maze@google.com>
Date:   Tue Mar 31 09:35:59 2020 -0700

    netfilter: xt_IDLETIMER: target v1 - match Android layout
