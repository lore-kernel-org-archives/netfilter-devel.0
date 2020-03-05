Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D7CC3F2D1
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 14:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E987B20732
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 14:48:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="dYgTyuL3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgCEOsH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 09:48:07 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55992 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgCEOsH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 09:48:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fSCDfHvPxXFAAALRP47QopB5uT/5IH2M1/JDplI5fYU=; b=dYgTyuL3XzJ1GF3tL1WgUNEKja
        VWFDYDt5N0cluNjAlNahBNfl9YjWJHGEBlx+icoZuoQSqJdTNBGf0gY1cW5UTDJEnqMbc7muHNuPz
        TfB7m/oZZPyRKa1rqOJGgrjMMKs7rV4l48R7DTifs+LOiXbVJOWPkzpsgsKftvYQE4VDRFe58lw3z
        6tmxAEsQ0Z5EdzbcljUsNBEgPQcrdSAKqOZxxVb9aXDn5sWksejz0WUAqDFmbmrlbdt/GL9EbBOXF
        o+rYq0pLomZAvui8zuILKrNvA2F6vwSJh2UHHaN3H6u5c7AKLgu65bFMmP9KohSnrvOmPqgx3H/T7
        MmFCCp+g==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j9rnB-0006kU-A0; Thu, 05 Mar 2020 14:48:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 0/4] Help and getopt improvements
Date:   Thu,  5 Mar 2020 14:48:01 +0000
Message-Id: <20200305144805.143783-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I spotted a couple more mistakes in the help.  The first two patches fix
them.  The last patch generates the getopt_long(3) optstring and
options, and the help from one data-structure in a bid to keep them all
in sync.

Jeremy Sowden (4):
  main: include '-d' in help.
  main: include '--reversedns' in help.
  main: interpolate default include path into help format-string.
  main: use one data-structure to initialize getopt_long(3) arguments
    and help.

 src/main.c | 251 +++++++++++++++++++++++++++++------------------------
 1 file changed, 138 insertions(+), 113 deletions(-)

-- 
2.25.1

