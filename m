Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FF3C352A1
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 19:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiLGTOA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 14:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiLGTN7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 14:13:59 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E0754353
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 11:13:58 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 94E825872649A; Wed,  7 Dec 2022 20:13:56 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 8ED6060C29140;
        Wed,  7 Dec 2022 20:13:56 +0100 (CET)
Date:   Wed, 7 Dec 2022 20:13:56 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 08/11] Makefile: Generate .tar.bz2 archive with
 'make dist'
In-Reply-To: <Y5DhxWh+2qpixI5O@orbyte.nwl.cc>
Message-ID: <1845617o-3434-5r8r-o0p8-sp96q83rno51@vanv.qr>
References: <20221207174430.4335-1-phil@nwl.cc> <20221207174430.4335-9-phil@nwl.cc> <p1286pq3-rprq-p2pq-3172-22p6s42pq3r1@vanv.qr> <Y5DhxWh+2qpixI5O@orbyte.nwl.cc>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2022-12-07 19:56, Phil Sutter wrote:
>On Wed, Dec 07, 2022 at 07:45:30PM +0100, Jan Engelhardt wrote:
>
>| 984K	iptables-1.8.8.tar.gz
>| 772K	iptables-1.8.8.tar.bz2
>| 636K	iptables-1.8.8.tar.xz
>
>Moving to LZMA is trivial from a Makefile's point of view, but
>most packagers will have extra work adjusting for the new file name

How hard could it be? Surely they'll manage to change _three
characters_ (or perhaps even ten, to manually run /usr/bin/<thing> if
there's no suffix autodetection) in their build recipe, right?
