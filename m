Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DF7C41513
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 18:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbjHCS2I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 14:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjHCS2H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 14:28:07 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB007211D
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 11:28:06 -0700 (PDT)
Date:   Thu, 03 Aug 2023 18:27:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1691087282; x=1691346482;
        bh=XEv6+QqQCzxH3UHYqq9AsF+1LGcBnP/79ecyWepfems=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=iRFCDzTLB33j3QSvstBPy6bIMJKm+9XNskSYJqWoJRpIureC5gVr6xP45TqufUvsA
         t5HCXLY1efOEjruXjZmefnua49FA02NLU2PepcoMEwTFd9kraFqIRi/DkZXauQxwOk
         DVQmRxfkYdFvVh51qX2WJs3TVTy1dLM66NHYWgqGO/CTy17/DU76l7HsAF6KRUZVvD
         t/Z35ecFHLShM1MjZLkyMYA7Y1W/gH+69wuI4kvmGCRGfW3kTySxfkk6V0fhyO6jon
         qCYG8L+8m2qSC6I94dc/oeu5j+0NLyM+UYnnaCUeOsSpuh/h/Hp7HOnXtK/PAvF+QC
         2ZWuA6DMBm/cg==
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From:   Robert <robert.smith51@protonmail.com>
Subject: Solution Bugzilla Issue 1659 - iptables-nft v1.8.9 Error: meta sreg key not supported
Message-ID: <0TcEByvmmvSrVOL2oYdyKhBojClLwt3xHHGYkphjAaaBm2jOxRmlvXJqEykAbCkuyOKHORKJ8epnPMSPocplpWrWpczuyjoOcrOurG9jJ2k=@protonmail.com>
Feedback-ID: 10897574:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I have recently encountered the issue described in the aforementioned Bugzi=
lla issue (#1659)  as, among others, Debian 12 ships the affected iptables =
v1.8.9. This can trip up a number of other applications that rely on the ip=
tables command, including the Docker daemon, preventing it from creating co=
rrect FW rules if any nftables "meta" rules are present during startup.

After some bisecting, I was able to determine that this issue was introduce=
d by commit 66806feef085c0504966c484f687bdf7b09510e3 ("nft: Fix meta statem=
ent parsing"). Reverting the commit in question resolves the issue, and no =
further errors are produced by builds of the 1.8.9 version.
