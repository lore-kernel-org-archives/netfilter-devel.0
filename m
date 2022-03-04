Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDDFC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Mar 2022 18:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbiCDSyd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 13:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiCDSyc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 13:54:32 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408101D3D93
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2022 10:53:44 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 5332A58740D45; Fri,  4 Mar 2022 19:53:42 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 4DD5560C3B1AC;
        Fri,  4 Mar 2022 19:53:42 +0100 (CET)
Date:   Fri, 4 Mar 2022 19:53:42 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Francesco Colista <francesco@bsod.eu>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: nftables 1.0.2 building issues
In-Reply-To: <09e7a20bc7b49c23630bd131f499108b@bsod.eu>
Message-ID: <qrs34s7-79o-7r79-r6s4-45soo77413q@vanv.qr>
References: <09e7a20bc7b49c23630bd131f499108b@bsod.eu>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Friday 2022-03-04 17:04, Francesco Colista wrote:
>
>I'm the maintainer of nftables in Alpine Linux (www.alpinelinux.org).
>
>With the latest release (1.0.2), has been added an "examples" dir [1].
>The building phase fails because it search in the standard library nftables/libnftables.h which does not exists.
>
>Downstream we fixed this issue in this way:  https://git.alpinelinux.org/aports/commit/?id=d15572ba655e7c48622fa87aca1c1a29f12b883b

https://lore.kernel.org/netfilter-devel/d096f2ff-f1a9-45a3-c190-4c1ddd0ce277@netfilter.org/T/#m140c8076a73c701fd0fbbd81d9cce91221677fd9
http://git.netfilter.org/nftables/commit/?id=18a08fb7f0443f8bde83393bd6f69e23a04246b3
