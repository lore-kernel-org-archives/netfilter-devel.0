Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36A8C352A1
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 18:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiLGSpe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 13:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLGSpe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 13:45:34 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E864FFA6
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 10:45:32 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id B1EC05872649A; Wed,  7 Dec 2022 19:45:30 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id AFD3260C29140;
        Wed,  7 Dec 2022 19:45:30 +0100 (CET)
Date:   Wed, 7 Dec 2022 19:45:30 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 08/11] Makefile: Generate .tar.bz2 archive with
 'make dist'
In-Reply-To: <20221207174430.4335-9-phil@nwl.cc>
Message-ID: <p1286pq3-rprq-p2pq-3172-22p6s42pq3r1@vanv.qr>
References: <20221207174430.4335-1-phil@nwl.cc> <20221207174430.4335-9-phil@nwl.cc>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wednesday 2022-12-07 18:44, Phil Sutter wrote:

>Instead of the default .tar.gz one.

I get the feeling that at this point (in time), bzip2 as compression 
does not make much sense anymore. If targeting size, the win goes to 
LZMA-class compressors (e.g. xz), if targeting speed, the win goes to 
LZ/deflate-ish compressors (e.g. gzip, zstd).
