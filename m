Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0A3C32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 10:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CF6E20665
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 10:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbfHMKEt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 06:04:49 -0400
Received: from correo.us.es ([193.147.175.20]:37794 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728410AbfHMKEt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 06:04:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 43378DA708
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 12:04:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 35BDD1150CB
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 12:04:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2B6734CA35; Tue, 13 Aug 2019 12:04:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 315011150B9;
        Tue, 13 Aug 2019 12:04:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 12:04:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0506F4265A2F;
        Tue, 13 Aug 2019 12:04:44 +0200 (CEST)
Date:   Tue, 13 Aug 2019 12:04:44 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: connlabels: prefer static lock
 initialiser
Message-ID: <20190813100444.xl4yqookc3pnfkgc@salvia>
References: <20190812114004.23746-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812114004.23746-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 12, 2019 at 01:40:04PM +0200, Florian Westphal wrote:
> seen during boot:
> BUG: spinlock bad magic on CPU#2, swapper/0/1
>  lock: nf_connlabels_lock+0x0/0x60, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> Call Trace:
>  do_raw_spin_lock+0x14e/0x1b0
>  nf_connlabels_get+0x15/0x40
>  ct_init_net+0xc4/0x270
>  ops_init+0x56/0x1c0
>  register_pernet_operations+0x1c8/0x350
>  register_pernet_subsys+0x1f/0x40
>  tcf_register_action+0x7c/0x1a0
>  do_one_initcall+0x13d/0x2d9
> 
> Problem is that ct action init function can run before
> connlabels_init().  Lock has not been initialised yet.
> 
> Fix it by using a static initialiser.

Applied, thanks Florian.
