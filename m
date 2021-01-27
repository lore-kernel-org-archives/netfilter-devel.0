Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7D7C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 13:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B38E1207B1
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 13:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238412AbhA0N3H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Jan 2021 08:29:07 -0500
Received: from mail.thelounge.net ([91.118.73.15]:40343 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238401AbhA0N02 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Jan 2021 08:26:28 -0500
X-Greylist: delayed 1059 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2021 08:26:28 EST
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4DQkRm4yN6zXRQ
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2021 14:07:59 +0100 (CET)
To:     netfilter-devel@vger.kernel.org
From:   Reindl Harald <h.reindl@thelounge.net>
Subject: https://bugzilla.kernel.org/show_bug.cgi?id=207773
Organization: the lounge interactive design
Message-ID: <9ab32341-ca2f-22e2-0cb0-7ab55198ab80@thelounge.net>
Date:   Wed, 27 Jan 2021 14:07:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

for the sake of god may someone look at this?
https://bugzilla.kernel.org/show_bug.cgi?id=207773
