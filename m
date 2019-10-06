Return-Path: <SRS0=ECQ/=X7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBAFC10F14
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Oct 2019 17:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DA1420835
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Oct 2019 17:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfJFRus (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 6 Oct 2019 13:50:48 -0400
Received: from correo.us.es ([193.147.175.20]:55122 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbfJFRur (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Oct 2019 13:50:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18FA58140D
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Oct 2019 19:50:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07E19D2B1F
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Oct 2019 19:50:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F0050DA4CA; Sun,  6 Oct 2019 19:50:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7E25B7FF2;
        Sun,  6 Oct 2019 19:50:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 06 Oct 2019 19:50:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B64044251480;
        Sun,  6 Oct 2019 19:50:39 +0200 (CEST)
Date:   Sun, 6 Oct 2019 19:50:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] src: fix doxygen function documentation
Message-ID: <20191006175041.gfn3n2df3fzo6fzk@salvia>
References: <20190925131418.7711-1-ffmancera@riseup.net>
 <20190930141753.6wxuweyyspeldfx4@salvia>
 <20191006105525.GA15026@dimstar.local.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="z4va2zedv5mvozbh"
Content-Disposition: inline
In-Reply-To: <20191006105525.GA15026@dimstar.local.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--z4va2zedv5mvozbh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Sun, Oct 06, 2019 at 09:55:25PM +1100, Duncan Roe wrote:
> Hi Pablo,
> 
> On Mon, Sep 30, 2019 at 04:17:53PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 25, 2019 at 03:14:19PM +0200, Fernando Fernandez Mancera wrote:
> > > Currently clang requires EXPORT_SYMBOL() to be above the function
> > > implementation. At the same time doxygen is not generating the proper
> > > documentation because of that.
> > >
> > > This patch solves that problem but EXPORT_SYMBOL looks less like the Linux
> > > kernel way exporting symbols.
> >
> > Applied, thanks.
> 
> I missed this earlier - take a look at the man pages / html doc with this patch.
> 
> E.g. man attr:
> 
> > attr(3)                             libmnl                            attr(3)
> >
> >
> >
> > NAME
> >        attr - Netlink attribute helpers
> >
> >    Functions
> >        EXPORT_SYMBOL uint16_t mnl_attr_get_type (const struct nlattr *attr)
> >        EXPORT_SYMBOL uint16_t mnl_attr_get_len (const struct nlattr *attr)
> >        EXPORT_SYMBOL uint16_t mnl_attr_get_payload_len (const struct nlattr
> >            *attr)
> >        EXPORT_SYMBOL void * mnl_attr_get_payload (const struct nlattr *attr)
> >        EXPORT_SYMBOL bool mnl_attr_ok (const struct nlattr *attr, int len)
> 
> The web pages are the same.
> 
> Shunting all the EXPORT_SYMBOL lines to the start of the file as in my rejected
> patch might have been ugly, but at least it left the documentation looking as it
> should.
> 
> I just finished making a patch for libnetfilter_queue using the redefined
> EXPORT_SYMBOL as above but taking care to avoid generating lines over 80 chars
> and preserving (or fixing!) alignment of subsequent parameter lines. But I won't
> submit it, because it results in the same horrible documentation.
> 
> I think it should be not too onerous to move the EXPORT_SYMBOL lines to before
> the start of documentation, which should satisfy both doxygen adn clang. Would
> you like me to go ahead with that?

Just sent you a patch for libmnl to remove the EXPORT_SYMBOL from the
doxygen output.

--z4va2zedv5mvozbh
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-libmnl-doxygen-remove-EXPORT_SYMBOL-from-the-output.patch"

From f8b59f25120d992ceb31b153ff297f308cf517f0 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun, 6 Oct 2019 19:45:29 +0200
Subject: [PATCH] libmnl: doxygen: remove EXPORT_SYMBOL from the output

Add input filter to remove the internal EXPORT_SYMBOL macro that turns
on the compiler visibility attribute.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doxygen.cfg.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index ee8fdfae97ce..31f01028aff6 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -77,7 +77,7 @@ EXAMPLE_PATH           =
 EXAMPLE_PATTERNS       = 
 EXAMPLE_RECURSIVE      = NO
 IMAGE_PATH             = 
-INPUT_FILTER           = 
+INPUT_FILTER           = "sed 's/EXPORT_SYMBOL//g'"
 FILTER_PATTERNS        = 
 FILTER_SOURCE_FILES    = NO
 SOURCE_BROWSER         = YES
-- 
2.11.0


--z4va2zedv5mvozbh--
