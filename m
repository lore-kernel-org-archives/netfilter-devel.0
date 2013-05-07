From: Boris Figovsky <boris.figovsky@ravellosystems.com>
Subject: [xtables-addons][PATCH 0/1] xt_DHCPMAC: correct mac setting and comparing
Date: Tue,  7 May 2013 07:21:54 +0300
Message-ID: <1367900515-13101-1-git-send-email-boris.figovsky@ravellosystems.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:46270 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932998Ab3EGE1X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 May 2013 00:27:23 -0400
Received: by mail-ea0-f182.google.com with SMTP id z16so50439ead.13
        for <netfilter-devel@vger.kernel.org>; Mon, 06 May 2013 21:27:21 -0700 (PDT)
Received: from borf.ravello.local ([207.232.28.189])
        by mx.google.com with ESMTPSA id e2sm25689888eem.16.2013.05.06.21.22.01
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 06 May 2013 21:22:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have tried to use DHCPMAC target and have noticed that it sets the mac to
00:00:00:00:00:00 - no matter what I --set-mac.
This patch fixes it.

Regards,
Boris Figovsky,
Ravello Systems.

Boris Figovsky (1):
  xt_DHCPMAC: correct mac setting and comparing

 extensions/xt_DHCPMAC.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--
1.7.9.5

