Return-Path: <SRS0=okMr=EL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836A7C4742C
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 355D7206DB
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgKEOLy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 09:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgKEOLy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 09:11:54 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FAFC0613CF
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2020 06:11:54 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kafzS-0006G4-L8; Thu, 05 Nov 2020 15:11:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 0/7] rework tcp option handling
Date:   Thu,  5 Nov 2020 15:11:37 +0100
Message-Id: <20201105141144.31430-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reworks how tcp options are handled in nft internally.
First patches refactor and condense code.

In particular, it removes the duplication of 'sack-perm'/permitted
maxseg/mss lexer keys -- synproxy and tcp option used different tokens,
leading to confusing sytax errors when using the 'wrong' word in the
'wrong' place.

patch 5 is the first one with a new feature: it allows to check for
presence of any tcp option kind, i.e. 'tcp option $number'.
patch 6 and 7 add 'raw' payload matching for tcp options to allow
testing for tcp options that do not have an internal template.


