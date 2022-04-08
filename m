Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39EA0C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 12:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiDHMmJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 08:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiDHMmJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 08:42:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4775726FE9A
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 05:40:05 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 41E946304A;
        Fri,  8 Apr 2022 14:36:13 +0200 (CEST)
Date:   Fri, 8 Apr 2022 14:40:00 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH 1/2] netfilter: nf_log_syslog: Merge MAC header
 dumpers
Message-ID: <YlAtIOH+PDYuZXwH@salvia>
References: <20220324140341.24259-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220324140341.24259-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 24, 2022 at 03:03:40PM +0100, Phil Sutter wrote:
> The functions for IPv4 and IPv6 were almost identical apart from extra
> SIT tunnel device handling in the latter.

Applied, thanks
