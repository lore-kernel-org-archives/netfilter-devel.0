Return-Path: <SRS0=suf1=VM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D89C76190
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 08:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9720020C01
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 08:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfGOIHv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 04:07:51 -0400
Received: from mail.us.es ([193.147.175.20]:45304 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbfGOIHv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 04:07:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 69779B5AA1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 10:07:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5AE4BD190F
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 10:07:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 50ABFD1929; Mon, 15 Jul 2019 10:07:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D82ED190F;
        Mon, 15 Jul 2019 10:07:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Jul 2019 10:07:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1A1134265A2F;
        Mon, 15 Jul 2019 10:07:47 +0200 (CEST)
Date:   Mon, 15 Jul 2019 10:07:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] proto: add pseudo th protocol to match d/sport in
 generic way
Message-ID: <20190715080746.la2ujeu5achauf6f@salvia>
References: <20190713172327.13928-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713172327.13928-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jul 13, 2019 at 07:23:27PM +0200, Florian Westphal wrote:
> Problem: Its not possible to easily match both udp and tcp in a single
> rule.
> 
> ... input ip protocol { tcp,udp } dport 53
> 
> will not work, as bison expects "tcp dport" or "sctp dport", or any
> other transport protocol name.
> 
> Its possible to match the sport and dport via raw payload expressions,
> e.g.:
> ... input ip protocol { tcp,udp } @th,16,16 53
> 
> but its not very readable.
> Furthermore, its not possible to use this for set definitions:
> 
> table inet filter {
>         set myset {
>                 type ipv4_addr . inet_proto . inet_service
>         }
> 
>         chain forward {
>                 type filter hook forward priority filter; policy accept;
>                 ip daddr . ip protocol . @th,0,16 @myset
>         }
> }
>  # nft -f test
>  test:7:26-35: Error: can not use variable sized data types (integer) in concat expressions
> 
> During the netfilter workshop Pablo suggested to add an alias to do raw
> sport/dport matching more readable, and make it use the inet_service
> type automatically.
> 
> So, this change makes @th,0,16 work for the set definition case by
> setting the data type to inet_service.
> 
> A new "th s|dport" syntax is provided as readable alternative:
> 
> ip protocol { tcp, udp } th dport 53
> 
> As "th" is an alias for the raw expression, no dependency is
> generated -- its the users responsibility to add a suitable test to
> select the l4 header types that should be matched.
> 
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks Florian.
