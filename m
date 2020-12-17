Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6227C4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 18:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DCA9238EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 18:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgLQSpC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 13:45:02 -0500
Received: from correo.us.es ([193.147.175.20]:60184 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728926AbgLQSpC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 13:45:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F3A4118CDCB
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 19:44:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5018DA78F
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 19:44:02 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DA876DA73F; Thu, 17 Dec 2020 19:44:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C899DDA722;
        Thu, 17 Dec 2020 19:44:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Dec 2020 19:44:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A4010426CC84;
        Thu, 17 Dec 2020 19:44:00 +0100 (CET)
Date:   Thu, 17 Dec 2020 19:44:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] netfilter: ipset: fixes possible oops in mtype_resize
Message-ID: <20201217184418.GC17365@salvia>
References: <bfeee41d-65f0-40b2-1139-b888627e34ef@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bfeee41d-65f0-40b2-1139-b888627e34ef@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 17, 2020 at 11:53:40AM +0300, Vasily Averin wrote:
> currently mtype_resize() can cause oops
> 
>         t = ip_set_alloc(htable_size(htable_bits));
>         if (!t) {
>                 ret = -ENOMEM;
>                 goto out;
>         }
>         t->hregion = ip_set_alloc(ahash_sizeof_regions(htable_bits));
> 
> Increased htable_bits can force htable_size() to return 0.
> In own turn ip_set_alloc(0) returns not 0 but ZERO_SIZE_PTR,
> so follwoing access to t->hregion should trigger an OOPS.

Applied, thanks.
