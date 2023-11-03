Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09759C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 11:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbjKCLi6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 07:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbjKCLiv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 07:38:51 -0400
Received: from smtp.gentoo.org (smtp.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB025134
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 04:38:45 -0700 (PDT)
User-agent: mu4e 1.10.7; emacs 30.0.50
From:   Sam James <sam@gentoo.org>
To:     thaller@redhat.com
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH nft v2 4/7] build: no recursive make for
 "files/**/Makefile.am"
In-Reply-To: <174b4dbc0df7fec4d0fdbe2c9cb96d4fca5ecd5b.camel@redhat.com>
Date:   Fri, 03 Nov 2023 11:37:16 +0000
Organization: Gentoo
Message-ID: <87cywrrrse.fsf@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Keep in mind for the concerns wrt large Makefiles, you can do 'include'
with automake too which keeps things flat in terms of what automake
generates and what make ultimately runs.
