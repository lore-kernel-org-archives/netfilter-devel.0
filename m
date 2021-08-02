Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FFEC4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 09:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE461610A7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 09:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhHBJMs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 05:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhHBJMr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 05:12:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83657C06175F
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Aug 2021 02:12:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mATzw-0002ck-R3; Mon, 02 Aug 2021 11:12:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH] conntrack-tools: support conntrack dump status filtering
Date:   Mon,  2 Aug 2021 11:12:27 +0200
Message-Id: <20210802091231.1486-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These changes to libnetfilter-conntrack and conntrack-tools allow to
dump  the connection tracking table while suppressing entries that
lack the given status bits.

This allows for example to limit the dump rquest to only contain
entries that did not yet see a reply.

First patch syncs the embedded uapi header with that of nf-next,
second patch adds the status dump filter glue to libnetfilter-conntrack.

Patch 3 is the main change.
Patch 4 adds support for the simpler 'UNREPLIED' keyword, this seems
easier to use than to ask for '!SEEN_REPLY'.


