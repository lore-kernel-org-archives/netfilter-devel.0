Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7027C433E9
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Jan 2021 08:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B00A0239EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Jan 2021 08:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbhAJIkm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Jan 2021 03:40:42 -0500
Received: from correo.us.es ([193.147.175.20]:38938 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbhAJIkl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Jan 2021 03:40:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BA856D2B04
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Jan 2021 09:39:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE0E6DA72F
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Jan 2021 09:39:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 93A2DDA78C; Sun, 10 Jan 2021 09:39:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71790DA73D;
        Sun, 10 Jan 2021 09:39:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 10 Jan 2021 09:39:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3F65F426CC84;
        Sun, 10 Jan 2021 09:39:16 +0100 (CET)
Date:   Sun, 10 Jan 2021 09:39:57 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Fix memleak in nf_nat_init
Message-ID: <20210110083957.GA28820@salvia>
References: <20210109120121.15938-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210109120121.15938-1-dinghao.liu@zju.edu.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jan 09, 2021 at 08:01:21PM +0800, Dinghao Liu wrote:
> When register_pernet_subsys() fails, nf_nat_bysource
> should be freed just like when nf_ct_extend_register()
> fails.

Applied, thanks.
