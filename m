Return-Path: <SRS0=fPey=XB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D4E7C43331
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Sep 2019 08:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6518120842
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Sep 2019 08:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387946AbfIFIik (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Sep 2019 04:38:40 -0400
Received: from a3.inai.de ([88.198.85.195]:49796 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732683AbfIFIik (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Sep 2019 04:38:40 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id 7D3BD3B72D4E; Fri,  6 Sep 2019 10:38:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 788673BACCAB;
        Fri,  6 Sep 2019 10:38:39 +0200 (CEST)
Date:   Fri, 6 Sep 2019 10:38:39 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        =?UTF-8?Q?Franta_Hanzl=C3=ADk?= <franta@hanzlici.cz>
Subject: Re: [PATCH xtables-addons v2 1/2] xt_pknock, xt_SYSRQ: don't set
 shash_desc::flags.
In-Reply-To: <20190812115742.21770-2-jeremy@azazel.net>
Message-ID: <nycvar.YFH.7.76.1909061038240.16078@n3.vanv.qr>
References: <20190811113826.5e594d8f@franta.hanzlici.cz> <20190812115742.21770-1-jeremy@azazel.net> <20190812115742.21770-2-jeremy@azazel.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Monday 2019-08-12 13:57, Jeremy Sowden wrote:

>shash_desc::flags was removed from the kernel in 5.1.

Applied this. The DHCPMAC update I happened to take from SF.
