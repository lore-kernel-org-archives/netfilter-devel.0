Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84CF2C28CC0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 20:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 657D326177
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 20:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfE3UpI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 16:45:08 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57486 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726355AbfE3UpI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 16:45:08 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hWRv5-00082e-A4; Thu, 30 May 2019 22:45:05 +0200
Date:   Thu, 30 May 2019 22:45:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] build: remove -Wl,--no-as-needed and libiptc.so
Message-ID: <20190530204503.y5efydasqs7hoysl@breakpoint.cc>
References: <20190528090354.10663-1-jengelh@inai.de>
 <20190528091832.32164-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528091832.32164-1-jengelh@inai.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jan Engelhardt <jengelh@inai.de> wrote:
> Despite the presence of --no-as-needed, the libiptc.so library as
> produced inside the openSUSE Build Service has no links to
> libip4tc.so or libip6tc.so. I have not looked into why --no-as-needed
> is ignored in this instance, but likewise, the situation must have
> been like that ever since openSUSE made as-needed a distro-wide
> default (gcc 4.8 timeframe or so).
> 
> Since I am not aware of any problem reports within SUSE/openSUSE
> about this whole situation, it seems safe to assume no one in the
> larger scope is still using a bare "-liptc" on the linker command
> line and that all parties have moved on to using pkg-config.
> 
> Therefore, libiptc.la/so is hereby removed, as are all parts
> related to the -Wl,--no-as-needed flag.

Applied, thanks Jan.
