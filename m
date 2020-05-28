Return-Path: <SRS0=RvX8=7K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4099CC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 05:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1707920C56
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 05:40:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uz5if4/h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgE1Fkw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 May 2020 01:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgE1Fkw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 May 2020 01:40:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F65C08C5C2;
        Wed, 27 May 2020 22:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=09LJUpm7nzPF/bKa8M2EEZqKf+9ZsGOUceQSna/ydV4=; b=uz5if4/hZ2k5rJTNIi7csXxqo1
        dmt5Q8gaNaUEb05QEp8Q8zINfhQREVRBgCTHBibgQWnZX/cg2MXif06uI6mKBaLu+4gCF++2oOxM0
        /KPputfDenY4oEe63fLhR3qlWVwX3uPEjF2g76Fxb6ZX8wJ79HsYEtfUn1fB3ArtVUZ423aaNxPWC
        CW3ZJM3bCngdxsaUJSmg6sNUPcZgPGjDc/n9AsJhVk0pO9gFlsckV6SDLgscKVU0ICBGtJhc33k78
        +laFyVBDvtA9POPoJqaRTv9WVsxSbRbkuCMLQNLxLtWUBX72VC+uGRzII2tvmTLWB0Ac9INJG378o
        P9crCh3Q==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeBHZ-0002JF-IY; Thu, 28 May 2020 05:40:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: clean up kernel_{read,write} & friends v2
Date:   Thu, 28 May 2020 07:40:29 +0200
Message-Id: <20200528054043.621510-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Al,

this series fixes a few issues and cleans up the helpers that read from
or write to kernel space buffers, and ensures that we don't change the
address limit if we are using the ->read_iter and ->write_iter methods
that don't need the changed address limit.

Changes since v2:
 - picked up a few ACKs

Changes since v1:
 - __kernel_write must not take sb_writers
 - unexport __kernel_write
