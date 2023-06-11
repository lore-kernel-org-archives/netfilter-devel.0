Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFE9C7EE23
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Jun 2023 12:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjFKMIB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Jun 2023 08:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjFKMIB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Jun 2023 08:08:01 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687DFE71
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jun 2023 05:07:59 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 311015872589A; Sun, 11 Jun 2023 14:07:57 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 3070660C28BA7;
        Sun, 11 Jun 2023 14:07:57 +0200 (CEST)
Date:   Sun, 11 Jun 2023 14:07:57 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables v2] man: string: document BM false negatives
In-Reply-To: <20230611113429.633616-1-jeremy@azazel.net>
Message-ID: <6n8s5ns3-768n-q58p-9798-p67s64502358@vanv.qr>
References: <20230611083805.622038-1-jeremy@azazel.net> <20230611113429.633616-1-jeremy@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sunday 2023-06-11 13:34, Jeremy Sowden wrote:

> iptables \-p udp \-\-dport 53 \-m string \-\-algo bm \-\-from 40 \-\-to 57 \-\-hex\-string '|03|www|09|netfilter|03|org|00|'
>+.P
>+NB since Boyer-Moore (BM) performs searches for matches from right to left and
>+the kernel may store a packet in multiple discontiguous blocks, it's possible
>+that a match could be spread over multiple blocks, in which case this algorithm
>+won't find it.

It was better when it just said "Note" instead of NB (notebook, nota bene)
