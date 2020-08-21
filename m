Return-Path: <SRS0=c8az=B7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62C2C433E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Aug 2020 15:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1F482063A
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Aug 2020 15:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgHUPld (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Aug 2020 11:41:33 -0400
Received: from correo.us.es ([193.147.175.20]:33320 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgHUPlc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Aug 2020 11:41:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A19481022A2
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 17:41:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94351DA722
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 17:41:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 89972DA73F; Fri, 21 Aug 2020 17:41:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 67018DA722;
        Fri, 21 Aug 2020 17:41:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 21 Aug 2020 17:41:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 46A5A42EE38F;
        Fri, 21 Aug 2020 17:41:28 +0200 (CEST)
Date:   Fri, 21 Aug 2020 17:41:27 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: nf_tables: fix destination register
 zeroing
Message-ID: <20200821154127.GA31079@salvia>
References: <20200820190550.7736-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820190550.7736-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 20, 2020 at 09:05:50PM +0200, Florian Westphal wrote:
> Following bug was reported via irc:
> nft list ruleset
>    set knock_candidates_ipv4 {
>       type ipv4_addr . inet_service
>       size 65535
>       elements = { 127.0.0.1 . 123,
>                    127.0.0.1 . 123 }
>       }
>  ..
>    udp dport 123 add @knock_candidates_ipv4 { ip saddr . 123 }
>    udp dport 123 add @knock_candidates_ipv4 { ip saddr . udp dport }
> 
> It should not have been possible to add a duplicate set entry.
> 
> After some debugging it turned out that the problem is the immediate
> value (123) in the second-to-last rule.
> 
> Concatenations use 32bit registers, i.e. the elements are 8 bytes each,
> not 6 and it turns out the kernel inserted
> 
> inet firewall @knock_candidates_ipv4
>         element 0100007f ffff7b00  : 0 [end]
>         element 0100007f 00007b00  : 0 [end]
> 
> Note the non-zero upper bits of the first element.  It turns out that
> nft_immediate doesn't zero the destination register, but this is needed
> when the length isn't a multiple of 4.
> 
> Furthermore, the zeroing in nft_payload is broken.  We can't use
> [len / 4] = 0 -- if len is a multiple of 4, index is off by one.
> 
> Skip zeroing in this case and use a conditional instead of (len -1) / 4.

Applied, thanks.
