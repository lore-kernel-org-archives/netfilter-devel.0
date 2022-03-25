Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4045C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Mar 2022 10:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351115AbiCYKwE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 06:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350224AbiCYKwB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 06:52:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3573C694A3
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2022 03:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v7zmUirISUtKoDsU0GtbcSaRjYbM9qx1+FNZXkYB0IU=; b=pi0wjaKNmkfJZJ2y9hAM7Y8EhI
        dGlfIiX0fwSEerHH6ogUym3uXFZ7dtqPmOueX981qi4eiLUccgrBlEyxorxqpdzZNySKy5Fhu3lNc
        aluYRikooH7pWvYL5cNOIBhwmqt1NIbSepEh9cPsq6bJiCgptws27lVxOSaqh6YiU/cLSwfkHh/QT
        KPy+F+/l/4BWLoolvBDzMSzu80jTKp4Jsjp5Vor2GYBI1bqluCLWH6rsbbEi0+HNF1dyVn6WtBAgu
        4/f/Gpe3VNPOo+s99KMOmnuh8qV7N/MhbYbw9j62qR+/F1ne1xHY1quVJ6xtRIsIZWVADvkoXcP2A
        DRc3qFPA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXhWT-0007zT-JR; Fri, 25 Mar 2022 11:50:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH 0/8] Fixes for a recent Coverity tool run
Date:   Fri, 25 Mar 2022 11:49:55 +0100
Message-Id: <20220325105003.26621-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter (8):
  hash: Flush tables when destroying
  cache: Fix features array allocation
  Fix potential buffer overrun in snprintf() calls
  helpers: ftp: Avoid ugly casts
  read_config_yy: Drop extra argument from dlog() call
  Don't call exit() from signal handler
  Drop pointless assignments
  connntrack: Fix for memleak when parsing -j arg

 src/cache.c          |  4 ++--
 src/conntrack.c      |  2 ++
 src/hash.c           |  1 +
 src/helpers/ftp.c    | 20 +++++++++-----------
 src/helpers/ssdp.c   |  1 -
 src/main.c           |  2 +-
 src/process.c        |  2 +-
 src/queue.c          |  4 ++--
 src/read_config_yy.y |  2 +-
 src/run.c            |  2 +-
 10 files changed, 20 insertions(+), 20 deletions(-)

-- 
2.34.1

