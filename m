Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E9DC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jun 2022 08:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiFBIEB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Jun 2022 04:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiFBIEB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Jun 2022 04:04:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 461FC1117
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2022 01:04:00 -0700 (PDT)
Date:   Thu, 2 Jun 2022 10:03:57 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: rebasing libnftnl git
Message-ID: <Yphu7Utp6lyMMchd@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm going to move the following commits to a branch:

a5e9122b6908 expr: fib: missing #include <assert.h>
7576202723d1 expr: extend support for dynamic register allocation
e549f5b3239c include: missing libnftnl/regs.h
484ad4421a2e regs: do not assume 16 registers
b9e00458b9f3 src: add dynamic register allocation infrastructure

they refer to work in progress which I quickly pushed out which might
interfer with the next release.

new git HEAD will be the already existing commit:

        e2514c0eff4d (master) exthdr: tcp option reset support

Sorry for the inconvenience.
