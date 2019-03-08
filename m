Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F41C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 15:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FB522087C
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 15:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfCHPxk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 10:53:40 -0500
Received: from mail.us.es ([193.147.175.20]:51976 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbfCHPxj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 10:53:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 042005E5398
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 16:53:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E392FDA85D
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 16:53:37 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D8E06DA797; Fri,  8 Mar 2019 16:53:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04158DA86A;
        Fri,  8 Mar 2019 16:53:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 08 Mar 2019 16:53:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D5E384265A2F;
        Fri,  8 Mar 2019 16:53:35 +0100 (CET)
Date:   Fri, 8 Mar 2019 16:53:35 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Backport of iptables TEE target fixes to 4.19
Message-ID: <20190308155335.5fnamlzkspmhv7q4@salvia>
References: <8c2d25757db34ea82aef536d2337ef72@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c2d25757db34ea82aef536d2337ef72@codeaurora.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Subash,

On Thu, Mar 07, 2019 at 06:28:34PM -0700, Subash Abhinov Kasiviswanathan wrote:
> Hi Pablo
> 
> We noticed that iptables TEE target is broken on 4.19 but are subsequently
> fixed now by -
> 18c0ab87364ac5128a152055fdcb1d27e01caf01 netfilter: xt_TEE: add missing code
> to get interface index in checkentry.
> f24d2d4f9586985509320f90308723d3d0c4e47f netfilter: xt_TEE: fix wrong
> interface selection
> 
> Could these changes be pushed to 4.19 through linux-stable?

Please, request this to -stable maintainer via email and Cc me and
netfilter-devel too. I will ack your request. Thanks!
