Return-Path: <SRS0=o+8a=XX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,HK_RANDOM_REPLYTO,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20805C4360C
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Sep 2019 12:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B8D42081B
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Sep 2019 12:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="By9L54Cs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbfI1MfT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Sep 2019 08:35:19 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:56865 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI1MfS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Sep 2019 08:35:18 -0400
Date:   Sat, 28 Sep 2019 12:35:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1569674115;
        bh=5LEokSNMu+2wsmO1u+GjCsTvNcnSx1BWIqtO+izPJtQ=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=By9L54CsLgV0jskWXWlGR/kwY7mSVFj18p6UXIIKOfroX4CdsMP8Fk2vte+kzlnHh
         W7y0gVBIIH3LVJcPUdSvWlIsg9tAXHZ8T3WHyD5gHvaT/uvZH9xYN0oFbLka0VInFY
         QI+EmQRa5oMMhCu4WTSAYn9gRSr2jR+YZfSOFtlM=
To:     Florian Westphal <fw@strlen.de>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: Please add Bridge NAT in nftables
Message-ID: <CZfZSo3aKXihivnYFG2ifcJUIEkkFuaAZcQuRT4vgBdQI4JQd6lg8LxJJjvDOlIDkCp6j4LbftdETCyZbzpnYTgAQ_gSK9wPe5G54sAuCcQ=@protonmail.com>
In-Reply-To: <20190928082358.GJ9938@breakpoint.cc>
References: <NLT8x0veXvaS6Jvm2H2CHRbzeh2NPv1MBDGtt0t6C47TmsNN6vIjIw42_v6fGXIw552q8AUllbB4Lb09HXVihl_s5cgY9rZVC6qTMIQWaSc=@protonmail.com>
 <20190928082358.GJ9938@breakpoint.cc>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Nftables already has such a feature is really great!

Please add the example to the nftables wiki, otherwise the normal user does=
 not know that nftables has the function of MAC NAT.
