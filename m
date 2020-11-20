Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A06C56201
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 18:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C71E52242B
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Nov 2020 18:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbgKTSuI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 13:50:08 -0500
Received: from correo.us.es ([193.147.175.20]:39852 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728578AbgKTSuI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 13:50:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 200201C0227
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2020 19:50:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11580DA722
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2020 19:50:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 06AF8DA78E; Fri, 20 Nov 2020 19:50:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29E47DA722;
        Fri, 20 Nov 2020 19:50:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Nov 2020 19:50:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0A0B04265A5A;
        Fri, 20 Nov 2020 19:50:01 +0100 (CET)
Date:   Fri, 20 Nov 2020 19:50:00 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] tests: shell: Stabilize
 nft-only/0009-needless-bitwise_0
Message-ID: <20201120185000.GA17769@salvia>
References: <20201120175757.8063-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201120175757.8063-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 20, 2020 at 06:57:57PM +0100, Phil Sutter wrote:
> Netlink debug output varies depending on host's endianness and therefore
> the test fails on Big Endian machines. Since for the sake of asserting
> no needless bitwise expressions in output the actual data values are not
> relevant, simply crop the output to just the expression names.

Probably we can fix this in libnftnl before we apply patches like this
to nft as well?

> Fixes: 81a2e12851283 ("tests/shell: Add test for bitwise avoidance fixes")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  .../nft-only/0009-needless-bitwise_0          | 413 +++++++++---------
>  1 file changed, 208 insertions(+), 205 deletions(-)
> 
> diff --git a/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0 b/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
> index 41d765e537312..0254208bcf69f 100755
> --- a/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
> +++ b/iptables/tests/shell/testcases/nft-only/0009-needless-bitwise_0
> @@ -1,4 +1,4 @@
> -#!/bin/bash -x
> +#!/bin/bash
>  
>  [[ $XT_MULTI == *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
>  set -e
> @@ -53,287 +53,290 @@ ff:00:00:00:00:00
>  ) | $XT_MULTI ebtables-restore
>  
>  EXPECT="ip filter OUTPUT 4
> -  [ payload load 4b @ network header + 16 => reg 1 ]
> -  [ cmp eq reg 1 0x0302010a ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip filter OUTPUT 5 4
> -  [ payload load 4b @ network header + 16 => reg 1 ]
> -  [ cmp eq reg 1 0x0302010a ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip filter OUTPUT 6 5
> -  [ payload load 4b @ network header + 16 => reg 1 ]
> -  [ bitwise reg 1 = ( reg 1 & 0xfcffffff ) ^ 0x00000000 ]
> -  [ cmp eq reg 1 0x0002010a ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ bitwise ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip filter OUTPUT 7 6
> -  [ payload load 3b @ network header + 16 => reg 1 ]
> -  [ cmp eq reg 1 0x0002010a ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip filter OUTPUT 8 7
> -  [ payload load 2b @ network header + 16 => reg 1 ]
> -  [ cmp eq reg 1 0x0000010a ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip filter OUTPUT 9 8
> -  [ payload load 1b @ network header + 16 => reg 1 ]
> -  [ cmp eq reg 1 0x0000000a ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip filter OUTPUT 10 9
> -  [ counter pkts 0 bytes 0 ]
> +  [ counter ]
>  
>  ip6 filter OUTPUT 4
> -  [ payload load 16b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x0a090807 ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip6 filter OUTPUT 5 4
> -  [ payload load 16b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x0a090807 ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip6 filter OUTPUT 6 5
> -  [ payload load 16b @ network header + 24 => reg 1 ]
> -  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0xffffffff 0xffffffff 0xf0ffffff ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
> -  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x00090807 ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ bitwise ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip6 filter OUTPUT 7 6
> -  [ payload load 15b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x00090807 ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip6 filter OUTPUT 8 7
> -  [ payload load 14b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x06050403 0x00000807 ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip6 filter OUTPUT 9 8
> -  [ payload load 11b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x00050403 ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip6 filter OUTPUT 10 9
> -  [ payload load 10b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0xffc0edfe 0x020100ee 0x00000403 ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip6 filter OUTPUT 11 10
> -  [ payload load 8b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0xffc0edfe 0x020100ee ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip6 filter OUTPUT 12 11
> -  [ payload load 6b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0xffc0edfe 0x000000ee ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip6 filter OUTPUT 13 12
> -  [ payload load 2b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0x0000edfe ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip6 filter OUTPUT 14 13
> -  [ payload load 1b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0x000000fe ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  ip6 filter OUTPUT 15 14
> -  [ counter pkts 0 bytes 0 ]
> +  [ counter ]
>  
>  arp filter OUTPUT 3
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ payload load 4b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0x0302010a ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  arp filter OUTPUT 4 3
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ payload load 4b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0x0302010a ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  arp filter OUTPUT 5 4
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ payload load 4b @ network header + 24 => reg 1 ]
> -  [ bitwise reg 1 = ( reg 1 & 0xfcffffff ) ^ 0x00000000 ]
> -  [ cmp eq reg 1 0x0002010a ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ bitwise ]
> +  [ cmp ]
> +  [ counter ]
>  
>  arp filter OUTPUT 6 5
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ payload load 3b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0x0002010a ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  arp filter OUTPUT 7 6
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ payload load 2b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0x0000010a ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  arp filter OUTPUT 8 7
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ payload load 1b @ network header + 24 => reg 1 ]
> -  [ cmp eq reg 1 0x0000000a ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  arp filter OUTPUT 9 8
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  arp filter OUTPUT 10 9
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ payload load 6b @ network header + 18 => reg 1 ]
> -  [ cmp eq reg 1 0xc000edfe 0x0000eeff ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  arp filter OUTPUT 11 10
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ payload load 6b @ network header + 18 => reg 1 ]
> -  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0x0000f0ff ) ^ 0x00000000 0x00000000 ]
> -  [ cmp eq reg 1 0xc000edfe 0x0000e0ff ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ bitwise ]
> +  [ cmp ]
> +  [ counter ]
>  
>  arp filter OUTPUT 12 11
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ payload load 5b @ network header + 18 => reg 1 ]
> -  [ cmp eq reg 1 0xc000edfe 0x000000ff ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  arp filter OUTPUT 13 12
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ payload load 4b @ network header + 18 => reg 1 ]
> -  [ cmp eq reg 1 0xc000edfe ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  arp filter OUTPUT 14 13
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ payload load 3b @ network header + 18 => reg 1 ]
> -  [ cmp eq reg 1 0x0000edfe ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  arp filter OUTPUT 15 14
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ payload load 2b @ network header + 18 => reg 1 ]
> -  [ cmp eq reg 1 0x0000edfe ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  arp filter OUTPUT 16 15
> -  [ payload load 2b @ network header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x00000100 ]
> -  [ payload load 1b @ network header + 4 => reg 1 ]
> -  [ cmp eq reg 1 0x00000006 ]
> -  [ payload load 1b @ network header + 5 => reg 1 ]
> -  [ cmp eq reg 1 0x00000004 ]
> -  [ payload load 1b @ network header + 18 => reg 1 ]
> -  [ cmp eq reg 1 0x000000fe ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  bridge filter OUTPUT 4
> -  [ payload load 6b @ link header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0xc000edfe 0x0000eeff ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  bridge filter OUTPUT 5 4
> -  [ payload load 6b @ link header + 0 => reg 1 ]
> -  [ bitwise reg 1 = ( reg 1 & 0xffffffff 0x0000f0ff ) ^ 0x00000000 0x00000000 ]
> -  [ cmp eq reg 1 0xc000edfe 0x0000e0ff ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ bitwise ]
> +  [ cmp ]
> +  [ counter ]
>  
>  bridge filter OUTPUT 6 5
> -  [ payload load 5b @ link header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0xc000edfe 0x000000ff ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  bridge filter OUTPUT 7 6
> -  [ payload load 4b @ link header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0xc000edfe ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  bridge filter OUTPUT 8 7
> -  [ payload load 3b @ link header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x0000edfe ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  bridge filter OUTPUT 9 8
> -  [ payload load 2b @ link header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x0000edfe ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  
>  bridge filter OUTPUT 10 9
> -  [ payload load 1b @ link header + 0 => reg 1 ]
> -  [ cmp eq reg 1 0x000000fe ]
> -  [ counter pkts 0 bytes 0 ]
> +  [ payload ]
> +  [ cmp ]
> +  [ counter ]
>  "
>  
> -diff -u -Z <(echo "$EXPECT") <(nft --debug=netlink list ruleset | awk '/^table/{exit} {print}')
> +diff -u -Z <(echo "$EXPECT") <(nft --debug=netlink list ruleset | awk '
> +	/^table/{exit}
> +	{print gensub(/\[ ([^ ]+) .* ]/,"[ \\1 ]", "g")}'
> +)
> -- 
> 2.28.0
> 
