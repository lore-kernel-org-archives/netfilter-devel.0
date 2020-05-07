Return-Path: <SRS0=DUCC=6V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE045C38A24
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 May 2020 07:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3BBE20753
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 May 2020 07:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgEGHQ0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 May 2020 03:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725834AbgEGHQ0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 May 2020 03:16:26 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3837C061A10
        for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2020 00:16:25 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id D3DEA5872D20B; Thu,  7 May 2020 09:16:22 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id CF33B60DB4E43
        for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2020 09:16:22 +0200 (CEST)
Date:   Thu, 7 May 2020 09:16:22 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Subject: nft: crash parsing cmd line
Message-ID: <nycvar.YFH.7.76.2005070913540.15894@n3.vanv.qr>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


It was reported via                                                                                                                                
http://bugzilla.opensuse.org/show_bug.cgi?id=1171321                                                                            
that nft exhibits a crash parsing the command line. This problem still 
exists as of 93eeceb50078e6ca54636017ee843cbeffbb4179.

» nft add rule inet traffic-filter input tcp dport { 22, 80, 443 } accept

Program received signal SIGSEGV, Segmentation fault.
0x00007ffff7f64f1e in erec_print (octx=0x55555555d2c0, erec=0x55555555fcf0, debug_mask=0) at erec.c:95
95              switch (indesc->type) {
(gdb) bt
#0  0x00007ffff7f64f1e in erec_print (octx=0x55555555d2c0, erec=0x55555555fcf0, debug_mask=0) at erec.c:95
#1  0x00007ffff7f65523 in erec_print_list (octx=0x55555555d2c0, list=0x7fffffffdd20, debug_mask=0) at erec.c:190
#2  0x00007ffff7f6d7d6 in nft_run_cmd_from_buffer (nft=0x55555555d2a0, 
    buf=0x55555555db20 "add rule inet traffic-filter input tcp dport { 22, 80, 443 } accept") at libnftables.c:459
#3  0x0000555555556ef0 in main (argc=14, argv=0x7fffffffded8) at main.c:455
(gdb) p indesc
$1 = (const struct input_descriptor *) 0x0
