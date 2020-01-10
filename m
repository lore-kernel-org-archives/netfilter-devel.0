Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92565C33CA2
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AF8C20721
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:34:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="SnQZwFBk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgAJMei (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:34:38 -0500
Received: from kadath.azazel.net ([81.187.231.250]:39664 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbgAJMeh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 07:34:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZioYoCDEDlDYpFccBG9MluLacQpeOFNWhWJdyrnGCzc=; b=SnQZwFBk9l20niZ5o/9DJ0pRMv
        oRSO4nnLjD24QcbAG9SJdE9r/YTbIGDJq5YPB+CDUqbXtSMjTgtfpRxLTtfrT2GgBWvGeM14jMEeg
        o4+cT31EbGlALeBAYnEqfti7Y1k9in3CnhUXDig6HV007lTfRHOK9KOCRZP8YpSKNXEnLWhwp1yss
        u2XG/UD6rYW8JChZiG7Env54UOJmzih7YxVcXp7alJsTS8rLKwOounVxYVuQd9qjdZZOyIyjhnAZV
        vhi/TmNM5vGPXjGYpx+bsGQZlGa8rjGGF7hljxARbodnnjCMd1dKIbuUd+O1oiICSfxxH8Z/cU9fL
        anpgFkCg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iptUq-0003du-Ka
        for netfilter-devel@vger.kernel.org; Fri, 10 Jan 2020 12:34:36 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl 0/2] bitwise shift support
Date:   Fri, 10 Jan 2020 12:34:34 +0000
Message-Id: <20200110123436.106488-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kernel supports bitwise shift operations.  This patch-set adds the
netlink support.

There is a preliminary patch adding some editor artefacts to .gitignore.

Jeremy Sowden (2):
  gitignore: add tag and Emacs back-up files.
  bitwise: add support for left and right shifts.

 .gitignore                          |   9 ++
 include/libnftnl/expr.h             |   2 +
 include/linux/netfilter/nf_tables.h |   4 +
 src/expr/bitwise.c                  |  68 ++++++++--
 tests/nft-expr_bitwise-test.c       | 186 +++++++++++++++++++++++++---
 5 files changed, 241 insertions(+), 28 deletions(-)

-- 
2.24.1

