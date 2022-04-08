Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643E7C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 12:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbiDHMmS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 08:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiDHMmR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 08:42:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29376280EE1
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 05:40:14 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 752716304A;
        Fri,  8 Apr 2022 14:36:23 +0200 (CEST)
Date:   Fri, 8 Apr 2022 14:40:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH 2/2] netfilter: nf_log_syslog: Don't ignore
 unknown protocols
Message-ID: <YlAtKv3bmXQ+WSYM@salvia>
References: <20220324140341.24259-1-phil@nwl.cc>
 <20220324140341.24259-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220324140341.24259-2-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 24, 2022 at 03:03:41PM +0100, Phil Sutter wrote:
> With netdev and bridge nfprotos, loggers may see arbitrary ethernet
> frames. Print at least basic info like interfaces and MAC header data.

Applied, thanks
