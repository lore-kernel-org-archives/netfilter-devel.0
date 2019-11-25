Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F799C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 20:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C84A420678
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 20:54:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="RXci0Q+i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfKYUyw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 15:54:52 -0500
Received: from kadath.azazel.net ([81.187.231.250]:44678 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfKYUyw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 15:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BXLh07fLSAL4DQIRTRG8rvgb1t07U15jEF6btZlvGiM=; b=RXci0Q+ijZ4rp7HKU1AdF1d0au
        zpMISNhR0CjHTUpX0NDr7IFzlGXo/2oEbea66Nmw9C661FSui8rXudEs4UI0WDYP4MY6GEgJF1nT2
        z5RY+6yJm5PhgvHd9HXNv4GG0d6PXNXn0IY1cFFFcGb17kJdPrsEgaxBa1j6hEbXIMfhdui+0z5hH
        bswfUu+RHCE4E+wOydwPUqjyWuk6DTqSwn4mXk14zeTQXVPurwwMNt2m69GZBOp+fFZh8RSJvefzM
        gGADrbrPGqjh63h6kV8lRx9TYvCHvC4+eYQ7cTyGyBvyAInrz902LE7redxvLTYV+VQHzklJbIzJm
        P353wSGA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iZLNj-00043I-3o; Mon, 25 Nov 2019 20:54:51 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft] doc: fix inconsistency in set statement documentation.
Date:   Mon, 25 Nov 2019 20:54:50 +0000
Message-Id: <20191125205450.240041-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The description of the set statement asserts that the set must have been
created with the "dynamic" flag.  However, this is not in fact the case,
and the assertion is contradicted by the following example, in which the
set is created with just the "timeout" flag (which suffices to ensure
that the kernel will create a set which can be updated).  Remove the
assertion.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/statements.txt | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index e17068a8a04b..847656ac7601 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -669,10 +669,9 @@ SET STATEMENT
 ~~~~~~~~~~~~~
 The set statement is used to dynamically add or update elements in a set from
 the packet path. The set setname must already exist in the given table and must
-have been created with the dynamic flag. Furthermore, these sets must specify
-both a maximum set size (to prevent memory exhaustion) and a timeout (so that
-number of entries in set will not grow indefinitely). The set statement can be
-used to e.g. create dynamic blacklists.
+specify both a maximum set size (to prevent memory exhaustion) and a timeout (so
+that number of entries in set will not grow indefinitely). The set statement can
+be used to e.g. create dynamic blacklists.
 
 [verse]
 {*add* | *update*} *@*'setname' *{* 'expression' [*timeout* 'timeout'] [*comment* 'string'] *}*
-- 
2.24.0

