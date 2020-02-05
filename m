Return-Path: <SRS0=2+fO=3Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486A6C352A2
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Feb 2020 12:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E785E21741
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Feb 2020 12:29:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="F1YnzR4F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgBEM3Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Feb 2020 07:29:25 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:20640 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgBEM3Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 07:29:25 -0500
Date:   Wed, 05 Feb 2020 12:29:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1580905763;
        bh=4Lq0OQOCdzw/Rwqg+FN4wXyMWVrBF1IwlXRtZK7rFLw=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=F1YnzR4Fj5EzhmrbWOAMunYvFbdZk84wdknbi/t5TEG8v3tY8G7PZ3xad13VWrbPC
         gCC4JeKO4MukXE1vqVZK8/KYlhlQcJpfCf8xI9wLVXDv3e5KCt2XKkiLyT22MX0eHB
         dHkgc5fydxB5TfLTcmcWcrXZ0HKGm1HYQA/t4KTc=
To:     netfilter-devel@vger.kernel.org
From:   Laurent Fasnacht <fasnacht@protonmail.ch>
Reply-To: Laurent Fasnacht <fasnacht@protonmail.ch>
Subject: [PATCH nft 0/3] scanner: improving include handling
Message-ID: <20200205122858.20575-1-fasnacht@protonmail.ch>
Feedback-ID: 67Kw-YMwrBchoIMLcnFuA64ZnJub6AgnNvfJUjsgbTTSp4dmymKgGy_PLLqmOsJ9F58iClONCeGYaqp9YPx84w==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

I'd like to submit a small patch series to improve include behaviour. It fi=
xes bug #1243 for example.

Let me know if you have any questions/remarks,

Best,
Laurent




