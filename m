Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E423BC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Nov 2021 13:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbhKWNc3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 08:32:29 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60406 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbhKWNc3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 08:32:29 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A849F64704
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Nov 2021 14:27:09 +0100 (CET)
Date:   Tue, 23 Nov 2021 14:29:16 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] Revert "configure: default to libedit for cli"
Message-ID: <YZzsrKs0QwB3KOkY@salvia>
References: <20211118221044.432552-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211118221044.432552-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 18, 2021 at 11:10:44PM +0100, Pablo Neira Ayuso wrote:
> Revert b4dded0ca78d ("configure: default to libedit for cli"), it seems
> editline/history.h is not packaged by all distros, leading to
> compilation breakage unless you explicitly select readline.

For the record, it turns out the problem is solved by:

http://git.netfilter.org/nftables/commit/?id=3847fccf004525ceb97db6fbc681835b0ac9a61a
