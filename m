Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA757C43334
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Jul 2022 14:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiGJOpm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Jul 2022 10:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJOpl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Jul 2022 10:45:41 -0400
X-Greylist: delayed 318 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 10 Jul 2022 07:45:37 PDT
Received: from buexe.b-5.de (buexe.b-5.de [IPv6:2a00:f820:14::89d1:8364])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50677AE46
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Jul 2022 07:45:37 -0700 (PDT)
Received: from alanya.lupe-christoph.de (alanya.lupe-christoph.de [172.17.0.19])
        by buexe.b-5.de (8.15.2/8.15.2/b-5/buexe-3.6.3) with ESMTP id 26AEeFhe035432;
        Sun, 10 Jul 2022 16:40:16 +0200
Received: from localhost (localhost [127.0.0.1])
        by alanya.lupe-christoph.de (Postfix) with ESMTP id E22F03E2;
        Sun, 10 Jul 2022 16:40:15 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at lupe-christoph.de
Received: from alanya.lupe-christoph.de ([127.0.0.1])
        by localhost (alanya.lupe-christoph.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AL1nw726ejSa; Sun, 10 Jul 2022 16:40:15 +0200 (CEST)
Received: by alanya.lupe-christoph.de (Postfix, from userid 1000)
        id C8514420; Sun, 10 Jul 2022 16:40:15 +0200 (CEST)
Date:   Sun, 10 Jul 2022 16:40:15 +0200
From:   Lupe Christoph <lupe@lupe-christoph.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Robert Kirmayer <kiri@kiri.de>
Subject: FTBS on Debian  Bullseye with xtables-addons-dkms 3.13-1 and kernel
 5.10.0-16-amd64
Message-ID: <Ysrkz8OHUK8TbPCs@lupe-christoph.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi!

In case you're not already aware of this, please have a look at
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1014680

Thank you!
Lupe Christoph
-- 
| Demokratie kann man bloß nicht exportieren, sie ist kein Werkzeug           |
| zur Veränderung der Gesellschaft, sondern ein Produkt ihrer                 |
| Entwicklung. Demokratien sind wie Gurken, manche reifen früher und die      |
| anderen später, man muss nur Geduld haben und zeitig gießen.                |
| Wladimir Kaminer in der taz "Die Russen und der Ukrainekrieg"               |
