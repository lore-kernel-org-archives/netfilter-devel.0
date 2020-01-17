Return-Path: <SRS0=kPFe=3G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA892C33C9E
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 20:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 931A72072B
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 20:58:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="vKr/+l2/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgAQU6K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 15:58:10 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55986 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729782AbgAQU6K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 15:58:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4bDh5b8PpF15ebv5LxGarvtHsmgqYk2aX9OUrDAiEWI=; b=vKr/+l2/7idBeAyLAaylH4ebR4
        mE0ScyFu3uxykMDzX/lbOOdgtaMwqxIh2Vbl039GmgbJiyqF1HFO/hidwTkO/0b6hAFMaaHkfikjI
        HtnxJn15MMlOjyuTic6lQM1rh7QTNuQGdoYvQCvEcHAVphhIdJNhH+p8C6gV8FEWCXYGzcYSVUct5
        zzec1nSRANdZ+N7e4hzRXOSidKo0yqpKAOG29gwSymRg13eSJMw+AW9PCdalQj6qRJgO9lmCXzJWi
        iwqIPG+dOkhMPW+Y6ZLVakF7ozwgeh12nHr0bCjxZpvLTekBEVVAyKPWpC5M70zuU2Sbc/6L/Msoz
        ebcCuJaQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1isYgy-0004I2-Qu
        for netfilter-devel@vger.kernel.org; Fri, 17 Jan 2020 20:58:09 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl v2 1/6] Update gitignore.
Date:   Fri, 17 Jan 2020 20:58:03 +0000
Message-Id: <20200117205808.172194-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117205808.172194-1-jeremy@azazel.net>
References: <20200117205808.172194-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add ctags and etags tag files, and Emacs back-up files.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .gitignore | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/.gitignore b/.gitignore
index 1650e5853cd0..e62f850fddf6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -29,3 +29,12 @@ examples/*
 tests/*
 !tests/*.c
 !tests/Makefile.am
+
+# Tag files for Vim and Emacs.
+TAGS
+tags
+
+# Emacs back-up files
+*~
+\#*\#
+.\#*
-- 
2.24.1

