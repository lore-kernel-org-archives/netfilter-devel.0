Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30AABC54EBC
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Jan 2023 00:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbjAKAFh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Jan 2023 19:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbjAKAFf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Jan 2023 19:05:35 -0500
X-Greylist: delayed 310 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 Jan 2023 16:05:33 PST
Received: from mail.sysmocom.de (mail.sysmocom.de [176.9.212.161])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22325FD9
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jan 2023 16:05:33 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.sysmocom.de (Postfix) with ESMTP id 377811994CDA
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 00:00:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at sysmocom.de
Received: from mail.sysmocom.de ([127.0.0.1])
        by localhost (mail.sysmocom.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ce7Tg_JYUqKj; Wed, 11 Jan 2023 00:00:18 +0000 (UTC)
Received: from my.box (i59F7ADA6.versanet.de [89.247.173.166])
        by mail.sysmocom.de (Postfix) with ESMTPSA id AFC7919808BB
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 00:00:18 +0000 (UTC)
Date:   Wed, 11 Jan 2023 01:00:17 +0100
From:   Neels Hofmeyr <nhofmeyr@sysmocom.de>
To:     netfilter-devel@vger.kernel.org
Subject: build failure since commit 'xt: Rewrite unsupported compat
 expression dumping'
Message-ID: <Y738EXSaHcvYLnoH@my.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

building current master of https://git.netfilter.org/nftables i get a build
error that i didn't see a few weeks ago. I thought I'd report it here.

I bisected to identify this commit to be the start of build failures for me:

 commit 79195a8cc9e9d9cf2d17165bf07ac4cc9d55539f
 Author: Phil Sutter <phil@nwl.cc>
 Date:   Thu Nov 24 14:17:17 2022 +0100
 "xt: Rewrite unsupported compat expression dumping"

This is the build error at above commit:

   CC       xt.lo
   CC       libparser_la-scanner.lo
 ../src/nftables/src/scanner.l: In function 'nft_lex':
 ../src/nftables/src/scanner.l:804:60: error: 'XT' undeclared (first use in this function); did you mean 'CT'?
 ../src/nftables/src/scanner.l:804:60: note: each undeclared identifier is reported only once for each function it appears in

On 'master', the build error is different:

   CC       libparser_la-scanner.lo
 ../src/nftables/src/scanner.l: In function 'nft_lex':
 ../src/nftables/src/scanner.l:625:10: error: 'VXLAN' undeclared (first use in this function); did you mean 'VLAN'?
 ../src/nftables/src/scanner.l:625:10: note: each undeclared identifier is reported only once for each function it appears in
 ../src/nftables/src/scanner.l:626:10: error: 'VNI' undeclared (first use in this function)
 ../src/nftables/src/scanner.l:628:10: error: 'GENEVE' undeclared (first use in this function)
 ../src/nftables/src/scanner.l:630:61: error: 'GRE' undeclared (first use in this function); did you mean 'GTE'?
 ../src/nftables/src/scanner.l:631:61: error: 'GRETAP' undeclared (first use in this function)
 ../src/nftables/src/scanner.l:812:60: error: 'XT' undeclared (first use in this function); did you mean 'CT'?

~N
