Return-Path: <SRS0=DEFU=WP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB31C3A5A0
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 19:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D1FD206C1
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 19:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfHSTeP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Aug 2019 15:34:15 -0400
Received: from fajn.hanzlici.cz ([46.13.76.95]:36406 "EHLO mail.hanzlici.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728375AbfHSTeP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Aug 2019 15:34:15 -0400
Received: from franta.hanzlici.cz (franta.hanzlici.cz [192.168.1.22])
        (Authenticated sender: franta@hanzlici.cz)
        by mail.hanzlici.cz (Postfix) with ESMTPSA id 49DF71909C0;
        Mon, 19 Aug 2019 21:34:13 +0200 (CEST)
Date:   Mon, 19 Aug 2019 21:34:11 +0200
From:   Franta =?UTF-8?B?SGFuemzDrWs=?= <franta@hanzlici.cz>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons v2 1/2] xt_pknock, xt_SYSRQ: don't set
 shash_desc::flags.
Message-ID: <20190819213411.6aaabd42@franta.hanzlici.cz>
In-Reply-To: <20190812165731.GC5190@azazel.net>
References: <20190811113826.5e594d8f@franta.hanzlici.cz>
        <20190812115742.21770-1-jeremy@azazel.net>
        <20190812115742.21770-2-jeremy@azazel.net>
        <nycvar.YFH.7.76.1908122317330.19510@n3.vanv.qr>
        <20190812165731.GC5190@azazel.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 12 Aug 2019 17:57:31 +0100
Jeremy Sowden <jeremy@azazel.net> wrote:

> On 2019-08-12, at 23:17:52 +0800, Jan Engelhardt wrote:
> > On Monday 2019-08-12 19:57, Jeremy Sowden wrote:  
> > >shash_desc::flags was removed from the kernel in 5.1.
> > >
> > >Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > >---
> > > extensions/pknock/xt_pknock.c | 1 -
> > > extensions/xt_SYSRQ.c         | 1 -
> > > 2 files changed, 2 deletions(-)
> > >
> > >diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pknock.c
> > >index c76901ac4c1a..8021ea07e1b9 100644
> > >--- a/extensions/pknock/xt_pknock.c
> > >+++ b/extensions/pknock/xt_pknock.c
> > >@@ -1125,7 +1125,6 @@ static int __init xt_pknock_mt_init(void)
> > >
> > > 	crypto.size = crypto_shash_digestsize(crypto.tfm);
> > > 	crypto.desc.tfm = crypto.tfm;
> > >-	crypto.desc.flags = 0;  
> >
> > But this will still be needed for 5.0 I guess, so it cannot just be
> > unconditionally removed.  
> 
> That assignment was actually superfluous anyway, because crypto.desc is
> zero-initialized when crypto is initialized (xt_pknock.c, ll. 110ff.):
> 
>   static struct {
>           const char *algo;
>           struct crypto_shash *tfm;
>           unsigned int size;
>           struct shash_desc desc;
>   } crypto = {
>           .algo	= "hmac(sha256)",
>           .tfm	= NULL,
>           .size	= 0
>   };
> 
> In fact the explicit zero-initialization of .tfm and .size is also
> superfluous and can be removed:
> 
>   static struct {
>           const char *algo;
>           struct crypto_shash *tfm;
>           unsigned int size;
>           struct shash_desc desc;
>   } crypto = {
>           .algo	= "hmac(sha256)",
>   };
> 
> Adding an initializer to the variable declaration in xt_SYSRQ.c will do
> the same thing.  Patch attached.
> 
> J.

Hi Jeremy, thanks for Your patches!
Please, they are only here in mail list, or also in any repo?
Or will be some new package release and I should wait?

My xtables-addons v3.3 package list SourceForge as project home site,
but I can't find there nothing newer than stuff from March 2019:
https://sourceforge.net/p/xtables-addons/xtables-addons/ci/master/tree/
Or am I wrong?
-- 
Thanks, Franta Hanzlik
