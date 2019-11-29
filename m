Return-Path: <SRS0=nYb5=ZV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FDDC432C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Nov 2019 08:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92F4521721
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Nov 2019 08:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfK2ICW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 03:02:22 -0500
Received: from correo.us.es ([193.147.175.20]:33958 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbfK2ICV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 03:02:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 939F1120845
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Nov 2019 09:02:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 861E1DA705
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Nov 2019 09:02:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7B9F0DA701; Fri, 29 Nov 2019 09:02:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D77ADA713;
        Fri, 29 Nov 2019 09:02:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 Nov 2019 09:02:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6B8244265A5A;
        Fri, 29 Nov 2019 09:02:16 +0100 (CET)
Date:   Fri, 29 Nov 2019 09:02:17 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ctnetlink: netns exit must wait for
 callbacks
Message-ID: <20191129080217.rsnwvdxquodwmbjn@salvia>
References: <20191115113923.17244-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115113923.17244-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Applied, thanks.
