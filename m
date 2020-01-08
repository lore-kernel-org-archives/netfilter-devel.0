Return-Path: <SRS0=uN83=25=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 253DAC282DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 22:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0A2A20692
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 22:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgAHWfz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 17:35:55 -0500
Received: from correo.us.es ([193.147.175.20]:56948 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgAHWfz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 17:35:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7D965C514C
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jan 2020 23:35:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72B21DA70E
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jan 2020 23:35:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 65ADFDA709; Wed,  8 Jan 2020 23:35:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 707B0DA701;
        Wed,  8 Jan 2020 23:35:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jan 2020 23:35:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 50727426CCB9;
        Wed,  8 Jan 2020 23:35:51 +0100 (CET)
Date:   Wed, 8 Jan 2020 23:35:51 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3] evaluate: fix expr_set_context call for shift
 binops.
Message-ID: <20200108223551.g33ci5nwkvez6moo@salvia>
References: <20200106092842.tp2pxubgmfcptthq@salvia>
 <20200106223510.496948-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106223510.496948-1-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 06, 2020 at 10:35:10PM +0000, Jeremy Sowden wrote:
> expr_evaluate_binop calls expr_set_context for shift expressions to set
> the context data-type to `integer`.  This clobbers the byte-order of the
> context, resulting in unexpected conversions to NBO.  For example:
> 
>   $ sudo nft flush ruleset
>   $ sudo nft add table t
>   $ sudo nft add chain t c '{ type filter hook output priority mangle; }'
>   $ sudo nft add rule t c oif lo tcp dport ssh ct mark set '0x10 | 0xe'
>   $ sudo nft add rule t c oif lo tcp dport ssh ct mark set '0xf << 1'
>   $ sudo nft list table t
>   table ip t {
>           chain c {
>                   type filter hook output priority mangle; policy accept;
>                   oif "lo" tcp dport 22 ct mark set 0x0000001e
>                   oif "lo" tcp dport 22 ct mark set 0x1e000000
>           }
>   }
> 
> Replace it with a call to __expr_set_context and set the byteorder to
> that of the left operand since this is the value being shifted.

Looks good, applied, thanks Jeremy.
