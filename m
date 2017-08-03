From: Oleg <lego12239@yandex.ru>
Subject: libnetfilter_queue & nfq_errno
Date: Thu, 3 Aug 2017 11:26:49 +0300
Message-ID: <20170803082649.GB31089@legohost>
Reply-To: Oleg <lego12239@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward17o.cmail.yandex.net ([37.9.109.214]:58259 "EHLO
        forward17o.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751087AbdHCIdC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2017 04:33:02 -0400
Received: from smtp1j.mail.yandex.net (smtp1j.mail.yandex.net [95.108.130.59])
        by forward17o.cmail.yandex.net (Yandex) with ESMTP id 1911A219E5
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2017 11:25:21 +0300 (MSK)
Received: from smtp1j.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by smtp1j.mail.yandex.net (Yandex) with ESMTP id 76A2A3C81933
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2017 11:24:58 +0300 (MSK)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hi, all.

Why do we use nfq_errno instead of errno? And if we really need nfq_errno,
why this variable is not thread-local?

Thanks!

-- 
Олег Неманов (Oleg Nemanov)
