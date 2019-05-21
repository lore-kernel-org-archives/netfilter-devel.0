Return-Path: <SRS0=lkya=TV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3426BC04AAF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 17:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D593021019
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 17:43:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="Xsrl9xPU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfEURnz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 May 2019 13:43:55 -0400
Received: from mout01.posteo.de ([185.67.36.65]:36931 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbfEURnz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 May 2019 13:43:55 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 9E9E016005D
        for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2019 19:43:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1558460633; bh=kaRqxR8AbpmgcuPraXkWGyzgDPkpRk4qUZ/9Lmk+PJE=;
        h=Date:From:To:Subject:From;
        b=Xsrl9xPUHfMGD7ZzS95+KnKr86uxUnXAIwfVxZ8x64HBjcjt3otqB7OOieG5LULLl
         SGgLDPYi/IwkzGsFzLXA5zL8tl1Br1qOm32AihxUlAlRBtYgrAYyJyqcH6eY8+RRLO
         7ME4LzXWc68jUVuFl9QMKJex3XD47Swt54v8Vkzs0ed4/IhpQmYNbyep4ftkG4npG0
         wB3rnrJyjwmq/XxdbR6tfRnlq6IJMCGUZ1gXER7Yyi3lkJO3C4G74Wjpa7MrtiQEaC
         YOtN87ZCD7mCZD+Sw6e20q68ek83WW80wdc11TRK76mV7ZJ9GNbyTAsu6wnawMs2LE
         Ni6d+/5OfepRg==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 457jmn0FNkz6tm7
        for <netfilter-devel@vger.kernel.org>; Tue, 21 May 2019 19:43:53 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 21 May 2019 19:43:52 +0200
From:   =?UTF-8?Q?M=2E_Schr=C3=B6der?= <nfdev.moschroe@posteo.de>
To:     netfilter-devel@vger.kernel.org
Subject: progress on connection tracking for bridge family
Message-ID: <20a4144f0516c947c1193fe7e37e09ce@posteo.net>
X-Sender: nfdev.moschroe@posteo.de
User-Agent: Posteo Webmail
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

I am currently setting up an IPS and would like to do so in-line using
NFQ. Example:

> add table bridge ips
> add chain bridge ips brfwd { type filter hook forward priority 0;=20
> policy drop; }
> add rule bridge ips brfwd counter queue num 0

Connection tracking with support for 'ct mark' would allow for
bypassing the IPS early.

I have seen that work is under way. Can any estimates be made as to when
CT might officially land in the kernel?

What steps would need to be taken/state needed to be reached for this to
happen?

Are there instructions on how to build a kernel with the preliminary
patches applied?

Kind regards
M. Schr=C3=B6der
