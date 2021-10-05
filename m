Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05988C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 13:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD1DF6124C
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Oct 2021 13:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbhJENd6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Oct 2021 09:33:58 -0400
Received: from mail.thelounge.net ([91.118.73.15]:63485 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbhJENd4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Oct 2021 09:33:56 -0400
X-Greylist: delayed 1054 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2021 09:33:56 EDT
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4HNyjK2BjCzXj4
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Oct 2021 15:14:24 +0200 (CEST)
Message-ID: <f4ccb286-44a6-81ce-0ca7-dddf6efed79d@thelounge.net>
Date:   Tue, 5 Oct 2021 15:14:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
To:     netfilter-devel@vger.kernel.org
Content-Language: en-US
From:   Reindl Harald <h.reindl@thelounge.net>
Subject: Linux 5.14 breaks wlan-ap traffic between wlan device
Organization: the lounge interactive design
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

not exactly the correct mailing list but i guess some relevant 
maintainers are also subscribed here:

https://bugzilla.kernel.org/show_bug.cgi?id=214531
https://bugzilla.redhat.com/show_bug.cgi?id=2007974
