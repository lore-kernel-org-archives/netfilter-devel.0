Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D07C00140
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Aug 2022 14:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243144AbiHHOMb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Aug 2022 10:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236032AbiHHOMa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Aug 2022 10:12:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 501043BF
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2022 07:12:30 -0700 (PDT)
Date:   Mon, 8 Aug 2022 16:12:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Duncan Roe <duncan_roe@optusnet.com.au>,
        Duncan Roe <duncan.roe2@gmail.com>
Subject: Re: [PATCH libmnl v2 1/2] libmnl: update attribute function comments
 to use \return
Message-ID: <YvEZyrPjulT+dlCg@salvia>
References: <20220805210040.2827875-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220805210040.2827875-1-jacob.e.keller@intel.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 05, 2022 at 02:00:39PM -0700, Jacob Keller wrote:
> Update the function comments in lib/attr.c to use the \return notation,
> which produces better man page output.

Applied this 1/2 patch, thanks for addressing feedback.
