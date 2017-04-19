From: Oleg <lego12239@yandex.ru>
Subject: nfqueue buf size for recv()
Date: Wed, 19 Apr 2017 19:50:24 +0300
Message-ID: <20170419165024.GA28485@legohost>
Reply-To: Oleg <lego12239@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward13h.cmail.yandex.net ([87.250.230.155]:55296 "EHLO
        forward13h.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938482AbdDSQ44 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 12:56:56 -0400
Received: from smtp1o.mail.yandex.net (smtp1o.mail.yandex.net [37.140.190.26])
        by forward13h.cmail.yandex.net (Yandex) with ESMTP id 794B02280E
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 19:49:44 +0300 (MSK)
Received: from smtp1o.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by smtp1o.mail.yandex.net (Yandex) with ESMTP id 530C4130073B
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 19:49:43 +0300 (MSK)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hi, all.

Can anybody tell me how can i determine a right buf size for recv()
in libnetfilter_queue program.

http://www.netfilter.org/projects/libnetfilter_queue/doxygen/group__Queue.html#gae36aee5b74d0c88d2f8530e356f68b79

tells nothing about this.

P.S. sorry, for noob question.
P.P.S. sorry, if i chosen a wrong list for my question.

-- 
Олег Неманов (Oleg Nemanov)
