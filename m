Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FD8C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 08:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F7AF61186
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 08:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235226AbhIPIra (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Sep 2021 04:47:30 -0400
Received: from ipc242.gw2.pvfree.net ([185.138.46.242]:50627 "EHLO
        ipc242.gw2.pvfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235193AbhIPIr3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Sep 2021 04:47:29 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2021 04:47:29 EDT
Received: from [192.168.88.150] (unknown [10.133.67.66])
        by ipc242.gw2.pvfree.net (Postfix) with ESMTPSA id A11C425E
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Sep 2021 10:38:03 +0200 (CEST)
To:     netfilter-devel@vger.kernel.org
From:   Martin Zatloukal <slezi2@pvfree.net>
Subject: list vmap counter errot
Message-ID: <ec914466-169b-b146-c216-e1faf1159068@pvfree.net>
Date:   Thu, 16 Sep 2021 10:38:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Language: cs
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


hi. i am trying nftables for our igw and i ran into a problem.



add map ip filter forwport { type ipv4_addr . inet_proto . 
inet_service: verdict; flags interval; counter;  }

add rule ip filter FORWARD iifname $INET_IFACE ip daddr . ip protocol  . 
th dport vmap @forwport counter

if I enter

nft list ruleset

then cli send : Unauthorized Memory Access (SIGSEGV)


dmesg

[ 1056.857354] nft[1069]: segfault at 10 ip 00007f44edde176d sp 
00007ffc2cdb8fa0 error 4 in libnftables.so.1.1.0[7f44eddd8000+62000]

[ 1056.857362] Code: 89 68 10 48 89 50 38 48 83 c4 08 5b 5d c3 66 66 2e 
0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 85 ff 74 23 55 48 8b 47 10 48 89 
fd <48> 8b 40 10 48 85 c0 74 02 ff d0 48 89 ef 5d e9 2f a4 02 00 0f 1f

if map not use flags counter,is listing ok

debian 11

libnftables1_1.0.0-1_amd64.deb
nftables_1.0.0-1_amd64.deb
