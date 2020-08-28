Return-Path: <SRS0=v1Ge=CG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1D8C433E6
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Aug 2020 16:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A7E22080C
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Aug 2020 16:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgH1QUv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Aug 2020 12:20:51 -0400
Received: from correo.us.es ([193.147.175.20]:42064 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgH1QUt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Aug 2020 12:20:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2103A18D002
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2020 18:20:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1244DDA73D
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2020 18:20:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 07E92DA730; Fri, 28 Aug 2020 18:20:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05981DA704;
        Fri, 28 Aug 2020 18:20:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Aug 2020 18:20:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DB1B742EF4E1;
        Fri, 28 Aug 2020 18:20:45 +0200 (CEST)
Date:   Fri, 28 Aug 2020 18:20:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Balazs Scheidler <bazsi77@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 1/4] socket: add support for "wildcard" key
Message-ID: <20200828162045.GA29891@salvia>
References: <20200822062203.3617-1-bazsi77@gmail.com>
 <20200822062203.3617-2-bazsi77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822062203.3617-2-bazsi77@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Balazs,

One more comment for your upcoming v2 ;-)

On Sat, Aug 22, 2020 at 08:22:00AM +0200, Balazs Scheidler wrote:
[...]
>  src/evaluate.c     | 5 ++++-
>  src/parser_bison.y | 2 ++
>  src/parser_json.c  | 2 ++
>  src/scanner.l      | 1 +
>  src/socket.c       | 6 ++++++
>  5 files changed, 15 insertions(+), 1 deletion(-)

Please, update include/linux/netfilter/nf_tables.h to add
NFT_SOCKET_WILDCARD.

Thanks.
