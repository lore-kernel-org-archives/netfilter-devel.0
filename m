Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6B0C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Dec 2021 00:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242351AbhLHAdW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 19:33:22 -0500
Received: from mail.netfilter.org ([217.70.188.207]:38954 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhLHAdW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 19:33:22 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4EC0E605BA;
        Wed,  8 Dec 2021 01:27:28 +0100 (CET)
Date:   Wed, 8 Dec 2021 01:29:47 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] selftests: netfilter: switch zone stress to socat
Message-ID: <Ya/8e2vVQV7TSiE4@salvia>
References: <20211203143323.4159-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211203143323.4159-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 03, 2021 at 03:33:23PM +0100, Florian Westphal wrote:
> centos9 has nmap-ncat which doesn't like the '-q' option, use socat.
> While at it, mark test skipped if needed tools are missing.

Applied, thanks
