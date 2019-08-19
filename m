Return-Path: <SRS0=DEFU=WP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7F8C3A5A0
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 18:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21EF522CF4
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 18:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbfHSS3c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Aug 2019 14:29:32 -0400
Received: from correo.us.es ([193.147.175.20]:34692 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727744AbfHSS3c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Aug 2019 14:29:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AD1DBF2627
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2019 20:29:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A005ACE17F
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2019 20:29:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 950B0D2B1E; Mon, 19 Aug 2019 20:29:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9CBF3DA840;
        Mon, 19 Aug 2019 20:29:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 19 Aug 2019 20:29:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.181.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3BF484265A2F;
        Mon, 19 Aug 2019 20:29:26 +0200 (CEST)
Date:   Mon, 19 Aug 2019 20:29:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>, coreteam@netfilter.org
Subject: Re: [PATCH] netfilter: add include guard to nf_conntrack_h323_types.h
Message-ID: <20190819182924.5tbrxqy2vq2ig6nf@salvia>
References: <20190819073927.12296-1-yamada.masahiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819073927.12296-1-yamada.masahiro@socionext.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 19, 2019 at 04:39:27PM +0900, Masahiro Yamada wrote:
> Add a header include guard just in case.

Applied.
