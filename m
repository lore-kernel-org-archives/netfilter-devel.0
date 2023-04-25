Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55137C77B61
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Apr 2023 09:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbjDYJPA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Apr 2023 05:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjDYJO7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2023 05:14:59 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE6C40E0;
        Tue, 25 Apr 2023 02:14:58 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id BB4605873429B; Tue, 25 Apr 2023 11:14:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id B95A060C43A4C;
        Tue, 25 Apr 2023 11:14:55 +0200 (CEST)
Date:   Tue, 25 Apr 2023 11:14:55 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Kai Liu <kai.liu@suse.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] selftests: netfilter: fix a build error on openSUSE
In-Reply-To: <Yh+wulh/nIkFeFmz@salvia>
Message-ID: <sr67066-o9or-1s32-pp7-s764r386n55q@vanv.qr>
References: <5ee95e93a11a239df8e09d059da25a4eaa5725ba.1646198836.git.geliang.tang@suse.com> <8cbf1231-0da5-c8a0-d66b-1488633d9895@linuxfoundation.org> <Yh+wulh/nIkFeFmz@salvia>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday ** 2022-03-02 19:00 **, Pablo Neira Ayuso wrote:


>On Wed, Mar 02, 2022 at 10:11:11AM -0700, Shuah Khan wrote:
>> On 3/1/22 10:29 PM, Geliang Tang wrote:
>> > This patch fixed the following build error on openSUSE Leap 15.3:
>> >   nf-queue.c:13:10: fatal error: libmnl/libmnl.h: No such file or directory
>> >    #include <libmnl/libmnl.h>
>> > diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
>> > index e4f845dd942b..8136c1fab7ab 100644
>> > --- a/tools/testing/selftests/netfilter/Makefile
>> > +++ b/tools/testing/selftests/netfilter/Makefile
>> > @@ -8,6 +8,7 @@ TEST_PROGS := nft_trans_stress.sh nft_fib.sh nft_nat.sh bridge_brouter.sh \
>> >   	ipip-conntrack-mtu.sh conntrack_tcp_unreplied.sh \
>> >   	conntrack_vrf.sh nft_synproxy.sh
>> > +CFLAGS += $(shell pkg-config --cflags libmnl 2>/dev/null || echo "-I/usr/include/libmnl")
>> >   LDLIBS = -lmnl
>> >   TEST_GEN_FILES =  nf-queue
>> 
>> Adding Pablo to the thread.
>> This looks good to me. I can take this through linux-kselftest tree.
>> Or if it is going through netfilter tree:
>> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
>
>If this does not cause any issue when running tests in any other
>distros, then it is fine with me.

Since a pkgconfig file exists, it ought to be used. That also means
you need the same/similar incantation in LDLIBS, with
`pkg-config --libs libmnl`.
