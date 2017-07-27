From: Oleg <lego12239@yandex.ru>
Subject: libnetfilter_queue & "dropping packets"
Date: Thu, 27 Jul 2017 11:57:04 +0300
Message-ID: <20170727085704.GA4681@legohost>
Reply-To: Oleg <lego12239@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward101j.mail.yandex.net ([5.45.198.241]:55115 "EHLO
        forward101j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750981AbdG0KQp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 06:16:45 -0400
Received: from smtp2o.mail.yandex.net (smtp2o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::26])
        by forward101j.mail.yandex.net (Yandex) with ESMTP id CC7AC124BCD3
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 11:55:18 +0300 (MSK)
Received: from smtp2o.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by smtp2o.mail.yandex.net (Yandex) with ESMTP id 98DCF5080C90
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 11:55:17 +0300 (MSK)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hi, all.

What is happen with packets which are dropped by nfqueue with the next
message:

 nf_queue: full at 1024 entries, dropping packets(s)

Are this packets disappeared from netfilter/network_stack(the same
behaviour like DROP target somewhere in the iptables rules)?

Thanks!

-- 
Олег Неманов (Oleg Nemanov)
