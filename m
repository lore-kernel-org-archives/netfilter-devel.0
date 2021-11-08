Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78CF5C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5628B6112D
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbhKHK6U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 05:58:20 -0500
Received: from mail.netfilter.org ([217.70.188.207]:46998 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238855AbhKHK6U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 05:58:20 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 638F66063C;
        Mon,  8 Nov 2021 11:53:36 +0100 (CET)
Date:   Mon, 8 Nov 2021 11:55:30 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Will Mortensen <willmo@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, wenxu <wenxu@ucloud.cn>
Subject: Re: [PATCH] netfilter: flowtable: fix IPv6 tunnel addr match
Message-ID: <YYkCIpa0v/AWyv4t@salvia>
References: <20211107012821.629933-1-willmo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211107012821.629933-1-willmo@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Nov 06, 2021 at 06:28:21PM -0700, Will Mortensen wrote:
> Previously the IPv6 addresses in the key were clobbered and the mask was
> left unset.
> 
> I haven't tested this; I noticed it while skimming the code to
> understand an unrelated issue.

Applied.
