From: "\"Oleg A. Arkhangelsky\"" <sysoleg@yandex.ru>
Subject: Interface match in POSTROUTING
Date: Sun, 09 Oct 2011 13:05:45 +0400
Message-ID: <13481318151145@web42.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward2.mail.yandex.net ([77.88.46.7]:53523 "EHLO
	forward2.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1JIJMO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Oct 2011 05:12:14 -0400
Received: from web42.yandex.ru (web42.yandex.ru [77.88.47.178])
	by forward2.mail.yandex.net (Yandex) with ESMTP id 4843612A26A0
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Oct 2011 13:05:46 +0400 (MSD)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by web42.yandex.ru (Yandex) with ESMTP id 2F36A3B005D
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Oct 2011 13:05:46 +0400 (MSK)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I have a question regarding this piece of code in iptables.c:

                if (strcmp(chain, "POSTROUTING") == 0
                    || strcmp(chain, "OUTPUT") == 0) {
                        /* -i not valid with outgoing packets */
                        if (cs.options & OPT_VIANAMEIN)
                                xtables_error(PARAMETER_PROBLEM,
                                           "Can't use -%c with %s\n",
                                           opt2char(OPT_VIANAMEIN),
                                           chain);
                }

I agree that "-i" is not valid for locally generated packets
(that is what OUTPUT chain for). But for forwarded packets
going through POSTROUTING this is not true. As far as I
understand we can match for both input and output interface
here (as in FORWARD).

So why we need this restriction?

-- 
wbr, Oleg.
