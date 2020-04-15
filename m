Return-Path: <SRS0=F+rW=57=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4241FC2BB85
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Apr 2020 16:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 282622064A
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Apr 2020 16:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416163AbgDOQfQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Apr 2020 12:35:16 -0400
Received: from correo.us.es ([193.147.175.20]:39016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1416090AbgDOQfO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Apr 2020 12:35:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1A716DFD6
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2020 18:35:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93DE8DA3C4
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2020 18:35:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 87FAE2067D; Wed, 15 Apr 2020 18:35:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A9F310078F;
        Wed, 15 Apr 2020 18:35:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 15 Apr 2020 18:35:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6BCE442EF42B;
        Wed, 15 Apr 2020 18:35:11 +0200 (CEST)
Date:   Wed, 15 Apr 2020 18:35:11 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Manoj Basapathi <manojbm@codeaurora.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        sharathv@qti.qualcomm.com, ssaha@qti.qualcomm.com,
        vidulak@qti.qualcomm.com, manojbm@qti.qualcomm.com,
        subashab@codeaurora.org, Sauvik Saha <ssaha@codeaurora.org>
Subject: Re: [PATCH] [nf,v2] idletimer extension :  Add alarm timer option
Message-ID: <20200415163511.7l466od6zzs3nvzr@salvia>
References: <20200415103646.3418-1-manojbm@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415103646.3418-1-manojbm@codeaurora.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 15, 2020 at 04:06:46PM +0530, Manoj Basapathi wrote:
> Introduce "--alarm" option for idletimer rule.
> If it is present, hardidle-timer is used, else default timer.
> The default idletimer starts a deferrable timer or in other
> words the timer will cease to run when cpu is in suspended
> state. This change introduces the option to start a
> non-deferrable or alarm timer which will continue to run even
> when the cpu is in suspended state.

One more request. Would you mind to add tests? See:

        extensions/libxt_IDLETIMER.t

Thanks.
