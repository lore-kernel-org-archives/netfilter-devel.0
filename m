Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D347C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 11:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16FE661BD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 11:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbhKQLit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 06:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbhKQLit (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 06:38:49 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2511C061570
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Nov 2021 03:35:50 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mnJEC-0000NN-A5; Wed, 17 Nov 2021 12:35:48 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] netfilter: conntrack: speed up netns dismantle
Date:   Wed, 17 Nov 2021 12:23:43 +0100
Message-Id: <20211117112345.6741-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On netns exit the conntrack table is iterated once for every netns on
the exit list.  We can use same 'trick' as tcp metrics and use the netns
refcount to detect which net namespaces are exiting instead.

This allows to iterate the table only once regardless of how many net
namespaces require cleanup.

Florian Westphal (2):
  netfilter: conntrack: split nf_conntrack_cleanup_net_list
  netfilter: conntrack: speed up netns cleanup

 net/netfilter/nf_conntrack_core.c | 40 +++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 10 deletions(-)

-- 
2.32.0

