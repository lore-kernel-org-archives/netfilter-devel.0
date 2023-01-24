Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30736C38142
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Jan 2023 15:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjAXPVQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Jan 2023 10:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbjAXPVP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2023 10:21:15 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6E8B46727
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2023 07:21:09 -0800 (PST)
Date:   Tue, 24 Jan 2023 16:21:05 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>
Subject: Re: [PATCH v4 0/4] sctp conntrack fixes
Message-ID: <Y8/3YbLz+MIM24kV@salvia>
References: <20230124014721.6058-1-sriram.yagnaraman@est.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230124014721.6058-1-sriram.yagnaraman@est.tech>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 24, 2023 at 02:47:17AM +0100, Sriram Yagnaraman wrote:
> A less diruptive change as opposed to below RFC patch:
> https://lore.kernel.org/netfilter-devel/20230104113143.21769-1-sriram.yagnaraman@est.tech/
> 
> This contains a couple of bug fixes to existing bugs that were found
> during the review of the above patch series, and also a patch that
> unifies the ESTABLISHED states for primary and secondary paths.

Applied to nf, thanks
