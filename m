Return-Path: <SRS0=d85k=XR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD5BC3A5A6
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 07:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 600CE2070C
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Sep 2019 07:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfIVHLT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Sep 2019 03:11:19 -0400
Received: from correo.us.es ([193.147.175.20]:36612 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727645AbfIVHLT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Sep 2019 03:11:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BA2C2E1227
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2019 09:11:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB0ACB8007
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2019 09:11:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A088FDA72F; Sun, 22 Sep 2019 09:11:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B8DED2B1E;
        Sun, 22 Sep 2019 09:11:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 22 Sep 2019 09:11:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D986B4265A5A;
        Sun, 22 Sep 2019 09:11:12 +0200 (CEST)
Date:   Sun, 22 Sep 2019 09:11:11 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: use __u8 instead of uint8_t in uapi header
Message-ID: <20190922071111.3gflycy6t4jnjpd4@salvia>
References: <20190921134648.1259-1-yamada.masahiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190921134648.1259-1-yamada.masahiro@socionext.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Sep 21, 2019 at 10:46:48PM +0900, Masahiro Yamada wrote:
> When CONFIG_UAPI_HEADER_TEST=y, exported headers are compile-tested to
> make sure they can be included from user-space.
> 
> Currently, linux/netfilter_bridge/ebtables.h is excluded from the test
> coverage. To make it join the compile-test, we need to fix the build
> errors attached below.
> 
> For a case like this, we decided to use __u{8,16,32,64} variable types
> in this discussion:
> 
>   https://lkml.org/lkml/2019/6/5/18
> 
> Build log:
> 
>   CC      usr/include/linux/netfilter_bridge/ebtables.h.s
> In file included from <command-line>:32:0:
> ./usr/include/linux/netfilter_bridge/ebtables.h:126:4: error: unknown type name ‘uint8_t’
>     uint8_t revision;
>     ^~~~~~~
> ./usr/include/linux/netfilter_bridge/ebtables.h:139:4: error: unknown type name ‘uint8_t’
>     uint8_t revision;
>     ^~~~~~~
> ./usr/include/linux/netfilter_bridge/ebtables.h:152:4: error: unknown type name ‘uint8_t’
>     uint8_t revision;
>     ^~~~~~~

Applied.
