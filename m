Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49A5C0650E
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 11:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B012D2080C
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 11:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfGCLSH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 07:18:07 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48110 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbfGCLSH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 07:18:07 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hidH4-0003dh-4V; Wed, 03 Jul 2019 13:18:06 +0200
Date:   Wed, 3 Jul 2019 13:18:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Stefan Laufmann <stefan.laufmann@emlix.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Ease usage of libnetfilter_log with C++ applications
Message-ID: <20190703111806.qtygttpa34dmfghp@breakpoint.cc>
References: <784d6af7-9530-f2f3-6c46-5ae989b82838@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <784d6af7-9530-f2f3-6c46-5ae989b82838@emlix.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stefan Laufmann <stefan.laufmann@emlix.com> wrote:
> I just recently came across libnetfilter_log and used it inside a C++
> application. When compiling/linking the project I ran into problems and
> discovered that libnetfilter_log in contrast to e.g. libnetfilter_queue and
> libnetfilter_conntrack lacks `extern "C"` statements in the header files.
> 
> Are their reasons for that?

Noone sent a patch to add them.
