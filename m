From: Oleg <lego12239@yandex.ru>
Subject: NFQUEUE --queue-balance
Date: Sat, 26 Aug 2017 18:40:13 +0300
Message-ID: <20170826154013.GA19754@legohost>
Reply-To: Oleg <lego12239@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward104o.mail.yandex.net ([37.140.190.179]:35834 "EHLO
        forward104o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751010AbdHZPiI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Aug 2017 11:38:08 -0400
Received: from mxback3j.mail.yandex.net (mxback3j.mail.yandex.net [IPv6:2a02:6b8:0:1619::10c])
        by forward104o.mail.yandex.net (Yandex) with ESMTP id 6CDFB2C83FFA
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Aug 2017 18:38:06 +0300 (MSK)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hi, all.

--queue-balance balance packets according to connection tracking,
iiuc. Consequently queue utilization is not equal. E.g.:

    0  19465  1015 2 65531  8185     0 179789099  1
    1  19467    46 2 65531  1137     0 151301170  1
    2  19470     0 2 65531     0     0 64377446  1
    3  19473    29 2 65531     0     0 46165759  1
    4  19476     4 2 65531    60     0 113848636  1
    5  19479    56 2 65531    77     0 148584270  1

Is there queue balancer without this feature(simple round-robin)?

Thanks!

-- 
Олег Неманов (Oleg Nemanov)
