Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5C4C352A4
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 10:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 860AD2082F
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 10:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.ch header.i=@protonmail.ch header.b="tByDYw27"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgBJKR2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 05:17:28 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:58622 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727436AbgBJKR2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 05:17:28 -0500
Date:   Mon, 10 Feb 2020 10:17:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1581329846;
        bh=spG5NuHUL3mV+uXEILFWGQ78wgygMKywK1uLm8AjtQU=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=tByDYw27/JF//VDzWZcTxj7V89HMYfO4+g0KYQt2fVdljhtfU34FxfLKa/+Q/nkPA
         Faqqjnyk5Fv+64dcSpOdxOiEmtzk2BBtCb/UIBHc9vSoYW+cwmllxApzh3lW70HiCW
         t0phQ+ovu412e8VsbuU3WZhwtZtscXpCOk5Gtu/I=
To:     netfilter-devel@vger.kernel.org
From:   Laurent Fasnacht <fasnacht@protonmail.ch>
Reply-To: Laurent Fasnacht <fasnacht@protonmail.ch>
Subject: [PATCH nft include v2 0/7] Improve include behaviour
Message-ID: <20200210101709.9182-1-fasnacht@protonmail.ch>
Feedback-ID: 67Kw-YMwrBchoIMLcnFuA64ZnJub6AgnNvfJUjsgbTTSp4dmymKgGy_PLLqmOsJ9F58iClONCeGYaqp9YPx84w==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

Following Pablo's comments (thanks!), here's a new version of the patch ser=
ies that improves include behavior. It fixes bug #1243, and also errors wit=
h bug reporting.

Changes from v1:
- include the test in this patch series
- split in more commits, to improve reviewability
- clean code state after each commit
- fixes an additional bug found while refactoring the patch, where the incl=
ude chain wasn't displayed correctly while printing errors.

Overall, definitely a lot of improvement, was definitely worth spending som=
e time on it.

Cheers,
Laurent



