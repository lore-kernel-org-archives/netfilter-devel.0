Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A556C47089
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 18:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiLGShC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 13:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiLGSg4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 13:36:56 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10DA450B0
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 10:36:51 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 09C8C5872649A; Wed,  7 Dec 2022 19:36:50 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 06B1960C29140;
        Wed,  7 Dec 2022 19:36:50 +0100 (CET)
Date:   Wed, 7 Dec 2022 19:36:50 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 03/11] Makefile: Generate ip6tables man pages
 on the fly
In-Reply-To: <20221207174430.4335-4-phil@nwl.cc>
Message-ID: <q9532812-p481-rsr1-44ns-559482nqrq@vanv.qr>
References: <20221207174430.4335-1-phil@nwl.cc> <20221207174430.4335-4-phil@nwl.cc>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2022-12-07 18:44, Phil Sutter wrote:
> 	${AM_VERBOSE_GEN} echo '.so man8/xtables-translate.8' >$@
> 
>+ip6tables.8 ip6tables-apply.8 ip6tables-restore.8 ip6tables-save.8:
>+	${AM_VERBOSE_GEN} sed 's|^ip6|.so man8/ip|' <<<$@ >$@

<<< is not sh-compatible

