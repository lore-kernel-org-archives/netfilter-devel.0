Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA13C432C3
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 19:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 823A520833
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 19:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfLBTa1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 14:30:27 -0500
Received: from a3.inai.de ([88.198.85.195]:38730 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbfLBTa1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 14:30:27 -0500
Received: by a3.inai.de (Postfix, from userid 25121)
        id A8A2159842AE8; Mon,  2 Dec 2019 20:30:25 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id A2FAA616BF304;
        Mon,  2 Dec 2019 20:30:25 +0100 (CET)
Date:   Mon, 2 Dec 2019 20:30:25 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-announce@lists.netfilter.org, lwn@lwn.net
Subject: Re: [ANNOUNCE] ebtables 2.0.11 release
In-Reply-To: <20191202153356.xowrrxn26jlm5v4f@salvia>
Message-ID: <nycvar.YFH.7.76.1912022027520.18991@n3.vanv.qr>
References: <20191202153356.xowrrxn26jlm5v4f@salvia>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Monday 2019-12-02 16:33, Pablo Neira Ayuso wrote:

>You can download it from:
>
>ftp://ftp.netfilter.org/pub/ebtables/

There is a file called ebtables-2.0.11.tar.bz2 in there, but this is 
actually a gz encoded object. (This confuses rpmbuild, which tries 
to `bzip2 -d` it.)

(Isn't it time to do xz or zstd anyway?)
