Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC6CC71156
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 14:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377832AbjHRO6a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 10:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377969AbjHRO63 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 10:58:29 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F250A30F3
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 07:58:27 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id A6306587264C0; Fri, 18 Aug 2023 16:58:26 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id A36CE60C28F47;
        Fri, 18 Aug 2023 16:58:26 +0200 (CEST)
Date:   Fri, 18 Aug 2023 16:58:26 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons] doc: fix version number in
 xtables-addons.8
In-Reply-To: <20230818142828.2807221-1-jeremy@azazel.net>
Message-ID: <n89pn421-p764-n7n5-4o0p-2pp1s177843q@vanv.qr>
References: <20230818142828.2807221-1-jeremy@azazel.net>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Friday 2023-08-18 16:28, Jeremy Sowden wrote:
> xtables-addons.8: ${srcdir}/xtables-addons.8.in matches.man targets.man
>-	${AM_V_GEN}sed -e '/@MATCHES@/ r matches.man' -e '/@TARGET@/ r targets.man' $< >$@;
>+	${AM_V_GEN}sed \
>+		-e 's/@PACKAGE'_'VERSION@/@PACKAGE_VERSION@/' \

I am surprised the normal escape stanza @@xyz@@ doesn't work..

6/6 applied.
