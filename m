Return-Path: <SRS0=8OCJ=4F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D509C35254
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 09:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19418206F4
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 09:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgBQJyI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 04:54:08 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39856 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729025AbgBQJyI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 04:54:08 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j3d6N-0008Lv-M3; Mon, 17 Feb 2020 10:54:07 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 0/2] netfilter: nf_tables: make sets built-in
Date:   Mon, 17 Feb 2020 10:53:57 +0100
Message-Id: <20200217095359.22791-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is little to no technical reason to have an extra kconfig knob for
this; nf_tables main use case it levaraging set infrastructure for
decisions/packet classification.

Also there were number of bug reports that turned out to be
caused by builds with nftables enabled and sets disabled.

This removes the set kconfig knob and places set infra in the nf_tables
core.

