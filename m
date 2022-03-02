Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F6FC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 18:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244352AbiCBSBX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 13:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiCBSBX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 13:01:23 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54EFFD5DF4;
        Wed,  2 Mar 2022 10:00:39 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 83C50625FA;
        Wed,  2 Mar 2022 18:59:07 +0100 (CET)
Date:   Wed, 2 Mar 2022 19:00:26 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Geliang Tang <geliang.tang@suse.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Kai Liu <kai.liu@suse.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] selftests: netfilter: fix a build error on openSUSE
Message-ID: <Yh+wulh/nIkFeFmz@salvia>
References: <5ee95e93a11a239df8e09d059da25a4eaa5725ba.1646198836.git.geliang.tang@suse.com>
 <8cbf1231-0da5-c8a0-d66b-1488633d9895@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8cbf1231-0da5-c8a0-d66b-1488633d9895@linuxfoundation.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 02, 2022 at 10:11:11AM -0700, Shuah Khan wrote:
> On 3/1/22 10:29 PM, Geliang Tang wrote:
> > This patch fixed the following build error on openSUSE Leap 15.3:
> > 
> > =======================================================================
> >   gcc     nf-queue.c -lmnl -o tools/testing/selftests/netfilter/nf-queue
> >   nf-queue.c:13:10: fatal error: libmnl/libmnl.h: No such file or directory
> >    #include <libmnl/libmnl.h>
> >             ^~~~~~~~~~~~~~~~~
> >   compilation terminated.
> > =======================================================================
> > 
> > It is because libmnl.h is put in the directory of
> > "/usr/include/libmnl/libmnl/" on openSUSE, not "/usr/include/libmnl/":
> > 
> >   > rpm -ql libmnl-devel
> >   /usr/include/libmnl
> >   /usr/include/libmnl/libmnl
> >   /usr/include/libmnl/libmnl/libmnl.h
> >   /usr/lib64/libmnl.so
> >   /usr/lib64/pkgconfig/libmnl.pc
> > 
> > Suggested-by: Kai Liu <kai.liu@suse.com>
> > Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> > ---
> > v2:
> >   - use pkg-config
> > ---
> >   tools/testing/selftests/netfilter/Makefile | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
> > index e4f845dd942b..8136c1fab7ab 100644
> > --- a/tools/testing/selftests/netfilter/Makefile
> > +++ b/tools/testing/selftests/netfilter/Makefile
> > @@ -8,6 +8,7 @@ TEST_PROGS := nft_trans_stress.sh nft_fib.sh nft_nat.sh bridge_brouter.sh \
> >   	ipip-conntrack-mtu.sh conntrack_tcp_unreplied.sh \
> >   	conntrack_vrf.sh nft_synproxy.sh
> > +CFLAGS += $(shell pkg-config --cflags libmnl 2>/dev/null || echo "-I/usr/include/libmnl")
> >   LDLIBS = -lmnl
> >   TEST_GEN_FILES =  nf-queue
> > 
> 
> Adding Pablo to the thread.
> 
> Pablo,
> 
> This looks good to me. I can take this through linux-kselftest tree.
> Let me know either way.
> 
> Or if it is going through netfilter tree:
> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

If this does not cause any issue when running tests in any other
distros, then it is fine with me.
