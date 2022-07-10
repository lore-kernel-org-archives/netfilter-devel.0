Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF120C43334
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Jul 2022 15:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiGJPLB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Jul 2022 11:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJPLA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Jul 2022 11:11:00 -0400
Received: from buexe.b-5.de (buexe.b-5.de [IPv6:2a00:f820:14::89d1:8364])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA27BC99
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Jul 2022 08:10:58 -0700 (PDT)
Received: from alanya.lupe-christoph.de (alanya.lupe-christoph.de [172.17.0.19])
        by buexe.b-5.de (8.15.2/8.15.2/b-5/buexe-3.6.3) with ESMTP id 26AFAru0035776;
        Sun, 10 Jul 2022 17:10:53 +0200
Received: from localhost (localhost [127.0.0.1])
        by alanya.lupe-christoph.de (Postfix) with ESMTP id 4130C3E2;
        Sun, 10 Jul 2022 17:10:53 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at lupe-christoph.de
Received: from alanya.lupe-christoph.de ([127.0.0.1])
        by localhost (alanya.lupe-christoph.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id k5iohuQUTijd; Sun, 10 Jul 2022 17:10:53 +0200 (CEST)
Received: by alanya.lupe-christoph.de (Postfix, from userid 1000)
        id 16D12420; Sun, 10 Jul 2022 17:10:53 +0200 (CEST)
Date:   Sun, 10 Jul 2022 17:10:53 +0200
From:   Lupe Christoph <lupe@lupe-christoph.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     netfilter-devel@vger.kernel.org, Robert Kirmayer <kiri@kiri.de>
Subject: Re: FTBS on Debian  Bullseye with xtables-addons-dkms 3.13-1 and
 kernel 5.10.0-16-amd64
Message-ID: <Ysrr/Xip+Q2J28Z+@lupe-christoph.de>
References: <Ysrkz8OHUK8TbPCs@lupe-christoph.de>
 <YsrrkeKKS1wE4jk3@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YsrrkeKKS1wE4jk3@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sunday, 2022-07-10 at 16:09:05 +0100, Jeremy Sowden wrote:
> On 2022-07-10, at 16:40:15 +0200, Lupe Christoph wrote:
> > In case you're not already aware of this, please have a look at
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1014680

> I am working on it.

This patch seems to work (from 3.15):
--- extensions/xt_ECHO.c.orig   2020-11-26 09:57:43.000000000 +0100
+++ extensions/xt_ECHO.c        2022-07-10 17:10:14.129598097 +0200
@@ -97,7 +97,7 @@
        memcpy(&fl.daddr, &newip->daddr, sizeof(fl.daddr));
        fl.fl6_sport = newudp->source;
        fl.fl6_dport = newudp->dest;
-       security_skb_classify_flow((struct sk_buff *)oldskb, flowi6_to_flowi(&fl));
+       security_skb_classify_flow((struct sk_buff *)oldskb, flowi6_to_flowi_common(&fl));
        dst = ip6_route_output(net, NULL, &fl);
        if (dst == NULL || dst->error != 0) {
                dst_release(dst);

HTH,
Lupe Christoph
-- 
| Demokratie kann man bloß nicht exportieren, sie ist kein Werkzeug           |
| zur Veränderung der Gesellschaft, sondern ein Produkt ihrer                 |
| Entwicklung. Demokratien sind wie Gurken, manche reifen früher und die      |
| anderen später, man muss nur Geduld haben und zeitig gießen.                |
| Wladimir Kaminer in der taz "Die Russen und der Ukrainekrieg"               |
