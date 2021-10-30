Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15859C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1DE060F9B
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhJ3Ro6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhJ3Ro5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:44:57 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F214FC061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:42:26 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 93B805872AC41; Sat, 30 Oct 2021 19:42:25 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 8FC656168E381;
        Sat, 30 Oct 2021 19:42:25 +0200 (CEST)
Date:   Sat, 30 Oct 2021 19:42:25 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 15/26] input: UNIXSOCK: prevent unaligned pointer
 access.
In-Reply-To: <20211030164432.1140896-16-jeremy@azazel.net>
Message-ID: <5op325n6-6077-p0n2-r33o-npr9905n47s3@vanv.qr>
References: <20211030164432.1140896-1-jeremy@azazel.net> <20211030164432.1140896-16-jeremy@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Saturday 2021-10-30 18:44, Jeremy Sowden wrote:

>`struct ulogd_unixsock_packet_t` is packed, so taking the address of its
>`struct iphdr payload` member may yield an unaligned pointer value.

That may not be a problem. Dereferencing through a pointer to
a packed struct generates very pessimistic code even when there is no
padding internally:

» cat >>x.cpp <<-EOF
struct ethhdr { unsigned long long a, b; } __attribute__((packed));
unsigned long f(const struct ethhdr *p) { return p->b; }
EOF
» sparc64-linux-gcc -c x.cpp -O2
» objdump -d x.o
_Z1fPK6ethhdr:
        save %sp, -144, %sp
        stx %i0, [%fp+2039]
        ldx [%fp+2039], %i0
        ldub [%i0+15], %i2
        ldub [%i0+14], %i1
        sllx %i1, 8, %i1
        or %i1, %i2, %i2
        ldub [%i0+13], %i3
...

