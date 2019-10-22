Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00038CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 20:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDB1520679
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 20:58:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="aEqt4ZvY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731673AbfJVU65 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 16:58:57 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44378 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730893AbfJVU65 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 16:58:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VR7YCDsbz38mtcpdRqc8MORakHTa4iOfubnC97hvoPA=; b=aEqt4ZvYouWTxYNpVOtnlpa6aI
        WENoDWJTxc9HABZ/mw2K1lOc0loPOJOloj6qu2cfWsWnndxFn0GlK8yYNO+6DcHG6Cwpiqzx2Szy8
        gN72FWuAkLcP83Fo6CUIPGodF3giLBQurz8I8bedSW90CaDKVZgQzA1lTYb4TMpYQ2M1fh0hXSwUw
        o3m5SwS8cr2e292Jd1jHCcvytiol0CJg3RfiMlBT0Q+hJn5yN6+pc/0sm6CeIpzgrto9cMCPMmkw5
        FE9sEFLWqftRh7DdnrGiwNUxL7UDzwRrrPr0uX6oq9DqkVlQLdDqJ9OLFWUFL5oCoZft4M1sSmT1B
        x+yNUFXw==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iN1F1-0002CC-7l; Tue, 22 Oct 2019 21:58:55 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 0/4] Output Flag Fixes
Date:   Tue, 22 Oct 2019 21:58:51 +0100
Message-Id: <20191022205855.22507-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A handful of output-flag fixes: some missing documentation, a missing long
option, some missing Python methods and a superfluous assigment.

Jeremy Sowden (4):
  doc: add missing output flag documentation.
  py: add missing output flags.
  main: add missing `OPT_NUMERIC_PROTO` long option.
  main: remove duplicate output flag assignment.

 doc/libnftables.adoc |  6 ++++++
 py/nftables.py       | 35 +++++++++++++++++++++++++++++++++++
 src/main.c           |  5 ++++-
 3 files changed, 45 insertions(+), 1 deletion(-)

-- 
2.23.0

